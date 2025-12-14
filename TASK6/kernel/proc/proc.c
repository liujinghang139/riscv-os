// kernel/proc.c
#include "types.h"
#include "riscv.h"
#include"memlayout.h"
#include "defs.h"
#include "../../include/proc.h"
#include "spinlock.h"
#include"syscall.h"
#include "test_code.h"
#define NPROC 64
struct cpu cpus[1]; // 单核 CPU
struct proc proc[NPROC]; // 进程表数组 [cite: 1151]

struct proc *initproc;
int nextpid = 1;
struct spinlock pid_lock;
struct spinlock wait_lock;


// 进程第一次运行时的入口
void forkret(void) {
  static int first = 1;
  // 释放调度器在 sched() 中持有的锁
  release(&myproc()->lock);

  if (first) {
    // 文件系统初始化等...
    first = 0;
  }
  // 2. 如果是内核线程，跳转到指定的入口函数
  if (myproc()->kstack_entry) {
      myproc()->kstack_entry();
      return;
  }
  // 对于内核线程，这里应该调用线程函数
  // 对于用户进程，这里应该返回用户空间 (usertrapret)
  // 这会设置寄存器、切换页表，最后执行 sret 指令
  usertrapret();
}
// 外部定义
extern void forkret(void); 
extern void swtch(struct context*, struct context*);

// 初始化进程表
void procinit(void) {
  struct proc *p;
  initlock(&pid_lock, "nextpid");
  initlock(&wait_lock, "wait_lock");
  for(p = proc; p < &proc[NPROC]; p++) {
      initlock(&p->lock, "proc");
      p->state = UNUSED;
      // 这里需要分配内核栈，假设 kalloc 已实现 (实验3)
    //p->kstack = (uint64)alloc_page();
  }
}

// 获取当前 CPU 指针
struct cpu* mycpu(void) {
  return &cpus[0];
}

// 获取当前进程指针
struct proc* myproc(void) {
  push_off(); // 关中断防止切换
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
  pop_off();
  return p;
}
// [新增] 为进程创建一个用户页表，并映射必要的系统页
pagetable_t proc_pagetable(struct proc *p) {
  pagetable_t pagetable;

  // 1. 创建一个空的根页表
  pagetable = create_pagetable();
  if(pagetable == 0)
    return 0;

  // 2. 映射 Trampoline (必须与内核页表完全一致)
  // 权限：读 + 执行 (R|X)
  if(map_page(pagetable, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X) != 0){
    // 失败处理：释放页表 (这里简化处理，实际应释放 pagetable 占用的页)
    return 0;
  }

  // 3. 映射 Trapframe (进程独有)
  // 虚拟地址是 TRAPFRAME，物理地址是 p->trapframe
  // 权限：读 + 写 (R|W)，因为 trampoline 代码需要保存寄存器到这里
  if(map_page(pagetable, TRAPFRAME, (uint64)p->trapframe, PGSIZE, PTE_R | PTE_W) != 0){
    // 失败处理
    return 0;
  }

  return pagetable;
}
// 任务2: 分配进程 (allocproc) [cite: 1107]
// 在进程表中寻找 UNUSED 状态的进程
static struct proc* allocproc(void) {
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state == UNUSED) {
      goto found;
    } else {
      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = nextpid++; // 简化版 PID 分配
  p->state = USED;

  // 分配 trapframe (实验6需要，此处先预留)
  if((p->trapframe = (struct trapframe *)alloc_page()) == 0){
    release(&p->lock);
    return 0;
  }
  // [新增] 2. 创建用户页表并建立映射
  p->pagetable = proc_pagetable(p);
  if(p->pagetable == 0){
    free_page((void*)p->trapframe); // 如果失败，清理 trapframe
    release(&p->lock);
    return 0;
  }
  // 3. [你的需求] 分配内核栈页面
  // 内核栈大小为 1 页 (4096字节)
  if((p->kstack = (uint64)alloc_page()) == 0){
    // 如果栈分配失败，必须把之前分配的 trapframe 释放掉，避免内存泄漏
    free_page((void*)p->trapframe);
    release(&p->lock);
    return 0;
  }
  // 初始化上下文 context
  // 关键：ra 设置为 forkret，这样第一次调度到该进程时会跳转到 forkret
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret; 
  p->context.sp = p->kstack + PGSIZE; // 栈顶

  return p;
}
static void freeproc(struct proc *p) {
  if(p->trapframe)
    free_page((void*)p->trapframe);
  p->trapframe = 0;

  // [新增] 释放内核栈
  if(p->kstack)
    free_page((void*)p->kstack);
  p->kstack = 0;

  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
}
// 创建新进程 (fork) [cite: 1120]
int fork(void) {
  int  pid;
  struct proc *np;
  struct proc *p = myproc();

  // 1. 分配新进程块
  if((np = allocproc()) == 0) return -1;

  // 2. 复制用户内存
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;

  // 3. 复制 Trapframe (复制寄存器现场)
  *(np->trapframe) = *(p->trapframe);

  // 4. 子进程返回值为 0
  np->trapframe->a0 = 0;

  // 5. 继承父进程属性
  np->parent = p;
  
  pid = np->pid;
  np->state = RUNNABLE;
  release(&np->lock);

  return pid; // 父进程返回子进程 PID
}

// 任务5: 调度器 (scheduler) [cite: 1203]
// 每个 CPU 运行一个调度器循环
void scheduler(void) {
  struct proc *p;
  struct cpu *c = mycpu();
  
  c->proc = 0;
   // printf("Scheduler: starting loop\n"); // 打印一次证明进来了
  for(;;) {
    // 开启中断，避免死锁
    intr_on();

    int found = 0;
    for(p = proc; p < &proc[NPROC]; p++) {
      acquire(&p->lock);
      if(p->state == RUNNABLE) {
        // 找到可运行进程，切换过去 [cite: 1236-1241]
        // printf("Scheduler: switching to pid %d\n", p->pid);
        p->state = RUNNING;
        c->proc = p;
        
        // 执行上下文切换：保存调度器上下文 -> 恢复进程上下文
        swtch(&c->context, &p->context);
         // printf("Scheduler: pid %d yielded/slept\n", p->pid);
        // 进程 yield 或 sleep 后返回这里
        c->proc = 0;
        found = 1;
      }
      release(&p->lock);
    }
    
    // 如果没有进程运行，可以休眠 CPU 节省能源 (wfi)
    if(found == 0) {
      printf("Scheduler: no runnable proc\n");
      intr_on();
      asm volatile("wfi");
    }
  }
}
void userinit(void) {
  struct proc *p;

  p = allocproc();
  initproc = p;
  
  // 1. 加载二进制代码 (现在 uvminit 支持多页了)
  uvminit(p->pagetable, test_bin, test_bin_len);
  
  // 2. 计算代码占用的空间 (向上对齐到页边界)
  // 例如：代码长 5000 字节 -> code_size = 8192 (2页)
  uint64 code_size = PGROUNDUP(test_bin_len);
  
  // 3. 【关键】额外分配一页专门做栈
  // 如果不这样做，SP 可能会设在代码中间，压栈时会覆盖代码
  char *stack_page = (char*)alloc_page(); // 或者 kalloc()
  if(stack_page == 0)
    panic("userinit: alloc stack failed");
  
  memset(stack_page, 0, PGSIZE);
  
  // 将这页栈映射到代码段的后面
  // 虚拟地址范围：[0 ... code_size] 是代码
  //             [code_size ... code_size+PGSIZE] 是栈
  if(map_page(p->pagetable, code_size, (uint64)stack_page, PGSIZE, PTE_R|PTE_W|PTE_U) < 0)
    panic("userinit: map stack failed");

  // 4. 更新进程大小和 Trapframe
  p->sz = code_size + PGSIZE; // 总大小 = 代码页 + 1页栈
  
  p->trapframe->epc = 0;      // 程序入口地址 (代码开始处)
  p->trapframe->sp = p->sz;   // 栈指针设在内存最高处 (向下增长)

  // 5. 设置进程名和状态
  safestrcpy(p->name, "test_syscall", sizeof(p->name));
  p->state = RUNNABLE;

  release(&p->lock);
}
// 任务5: 主动让出 CPU (yield) [cite: 1200]
void yield(void) {
  struct proc *p = myproc();
  acquire(&p->lock);
  p->state = RUNNABLE;
  sched();
  release(&p->lock);
}

// 切换回调度器
void sched(void) {
  int intena;
  struct proc *p = myproc();

  if(!holding(&p->lock))
    panic("sched p->lock");
  if(mycpu()->noff != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  // 保存当前进程上下文 -> 恢复调度器上下文
  swtch(&p->context, &mycpu()->context);
  mycpu()->intena = intena;
}

// 任务6: 睡眠 (sleep) [cite: 1263]
void sleep(void *chan, struct spinlock *lk) {
  struct proc *p = myproc();
  
  // 必须持有 p->lock 才能修改状态
  if(lk != &p->lock){
    acquire(&p->lock);
    release(lk);
  }

  // 修改状态并记录休眠通道
  p->chan = chan;
  p->state = SLEEPING;

  sched(); // 调度出去

  // 唤醒后清理
  p->chan = 0;

  // 重新持有原锁
  if(lk != &p->lock){
    release(&p->lock);
    acquire(lk);
  }
}

// 任务6: 唤醒 (wakeup) [cite: 1267]
void wakeup(void *chan) {
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++) {
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
        p->state = RUNNABLE;
      }
      release(&p->lock);
    }
  }
}


// 创建一个新的进程/线程来运行 entry 函数
int create_process(void (*entry)(void)) {
  struct proc *p;

  // 1. 调用 allocproc 分配进程控制块
  if((p = allocproc()) == 0){
    return -1;
  }

  // 2. 设置上下文 (Context)
  // 注意：allocproc 已经把 ra 设置为了 forkret
  //p->context.ra = (uint64)entry;
  p->context.sp = p->kstack + PGSIZE; // 栈顶
  p->parent = myproc();
  
  p->kstack_entry = entry;
  // 3. 设置状态为 RUNNABLE，允许调度器调度它
  p->state = RUNNABLE;

  // 4. 释放 allocproc 获取的锁
  release(&p->lock);

  return p->pid;
}


// 退出当前进程
void exit_process(int status) {
  struct proc *p = myproc();

  if(p == initproc)
    panic("init exiting");

  // 关闭所有打开的文件... (实验五暂时不需要)

  acquire(&wait_lock);
  struct proc *np;
  // 将子进程托管给 initproc (实验五简化版可省略)
  for(np = proc; np < &proc[NPROC]; np++){
    if(np->parent == p){
      np->parent = initproc; // 将子进程过继给 init
      wakeup(initproc);      // 唤醒 init，因为它可能正在等待僵尸子进程
    }
  }
  // 唤醒父进程 (如果父进程在 wait)
  wakeup(p->parent);
  
  acquire(&p->lock);

  p->xstate = status;
  p->state = ZOMBIE; // 变为僵尸状态，等待父进程回收

  release(&wait_lock);

  // 跳转到调度器，不再返回
  sched();
  panic("zombie exit");
}
// kernel/proc/proc.c

// kernel/proc/proc.c

// 等待子进程退出
int wait_process(int *status) {
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();

  // 持有 wait_lock 以防止我们在检查过程中错过 wakeup
  acquire(&wait_lock);

  for(;;){
    // 扫描进程表，寻找我的子进程
    havekids = 0;
    for(np = proc; np < &proc[NPROC]; np++){
      // 【关键修正 1】只关心我自己的子进程
      if(np->parent != p)
        continue;

      havekids = 1; // 确认至少有一个子进程

      if(np->state == ZOMBIE){
        // 找到了僵尸子进程
        
        // 获取子进程锁以进行清理操作
        acquire(&np->lock);
        
        pid = np->pid;
        // 将退出状态写入提供的内核地址（前提：调用者保证 status 是内核地址）
        if(status != 0) *status = np->xstate;
        
        // 回收进程资源
        freeproc(np); 
        
        // 释放锁
        release(&np->lock);
        release(&wait_lock);
        return pid;
      }
    }

    // 如果没有子进程，或者进程被杀，立即返回
    if(!havekids || p->killed){
      release(&wait_lock);
      return -1;
    }
    
    // 有子进程但都没变成 ZOMBIE，休眠等待
    // 当有子进程 exit() 时，它会调用 wakeup(p->parent) 唤醒我们
    sleep(p, &wait_lock); 
  }
}