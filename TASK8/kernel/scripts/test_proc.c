#include"../../include/param.h"
#include"../../include/riscv.h"
#include"../proc/proc.h"
#include"../../include/defs.h"

//获取当前时间，辅助函数
static uint64
get_time(){
  uint64 x = r_time();
  return x;
}



void test_process_creation() {
  printf("Testing process creation...\n");
  // 测试基本的进程创建
  struct proc *p = alloc_proc();
  release(&p->lock);
  printf("p:%x\n",p);
  assert(p > 0);
  // 测试进程表限制
  uint64 proc_pids[NPROC];
  int count = 0;
  for (int i = 0; i < NPROC + 5; i++) {
    struct proc *p = alloc_proc();
    if (p > 0) {
      proc_pids[count++] = p->pid;
      release(&p->lock);
      (void)proc_pids[count-1];
    } else {
      break;
    }
  }
  printf("Created %d processes\n", count);
  
  // 清理测试进程
  for (int i = 0; i < count; i++) {
    proc_wait(myproc()->state);
  }
}


void 
create_testproc(void) {
  printf("Creating test process...\n");
  // 创建多个计算密集型进程
  struct proc *p;
  for (int i = 0; i < 3; i++) {
    p = alloc_proc();
    p->state = RUNNABLE;
    p->context.ra = (uint64)test_scheduler;
    release(&p->lock);
  }
  printf("Test process created!\n");
}

extern void forkret();

void
test_scheduler(){
  printf("\n=== Testing Scheduler ===\n");
  struct proc *p = myproc();
  release(&p->lock);
   // 观察调度行为
  uint64 start_time = get_time();
  sleep_tick(10);
  uint64 end_time = get_time();
  printf("Scheduler test completed in %lu cycles\n",
  end_time - start_time);


  acquire(&p->lock);
  p->state = ZOMBIE; 

  sched();

  panic("test_scheduler returned");
  // acquire(&p->lock);
  // p->context.ra = (uint64)forkret;
  // release(&p->lock);

}

// 共享缓冲区结构
struct {
  struct spinlock lock;
  int buffer[5];      // 缓冲区大小为 5
  int count;          // 当前元素数量
  int read_idx;       // 读指针
  int write_idx;      // 写指针
} shared_buf;

void
shared_buffer_init(void)
{
  init_lock(&shared_buf.lock, "shared_buffer");
  shared_buf.count = 0;
  shared_buf.read_idx = 0;
  shared_buf.write_idx = 0;
}

// 生产者任务
void
producer_task(void)
{
  struct proc *p = myproc();
  // 【重要】调度器切换过来时持有 p->lock，必须先释放
  release(&p->lock);

  for(int i = 0; i < 10; i++) {
    acquire(&shared_buf.lock);

    // 缓冲区满，等待 (使用 while 防止虚假唤醒)
    while(shared_buf.count == 5) {
      printf("Buffer Full. Producer sleeping...\n");
      // 在 read_idx 上睡眠，等待消费者唤醒
      sleep(&shared_buf.lock, &shared_buf.read_idx);
    }

    // 生产数据
    shared_buf.buffer[shared_buf.write_idx] = i;
    shared_buf.write_idx = (shared_buf.write_idx + 1) % 5;
    shared_buf.count++;
    
    printf("Producer produced: %d (Count: %d)\n", i, shared_buf.count);

    // 唤醒消费者 (唤醒睡在 write_idx 上的进程)
    wakeup(&shared_buf.write_idx);

    release(&shared_buf.lock);
    
    // 模拟生产耗时，稍微慢一点
    for(volatile int k=0; k<1000000; k++);
  }

  printf("Producer finished.\n");
  
  // 任务结束，变为 ZOMBIE 并让出 CPU
  acquire(&p->lock);
  p->state = ZOMBIE;
  sched();
}

// 消费者任务
void
consumer_task(void)
{
  struct proc *p = myproc();
  release(&p->lock); // 释放调度器传来的锁

  for(int i = 0; i < 10; i++) {
    acquire(&shared_buf.lock);

    // 缓冲区空，等待
    while(shared_buf.count == 0) {
      printf("Buffer Empty. Consumer sleeping...\n");
      // 在 write_idx 上睡眠，等待生产者唤醒
      sleep(&shared_buf.lock, &shared_buf.write_idx);
    }

    // 消费数据
    int val = shared_buf.buffer[shared_buf.read_idx];
    shared_buf.read_idx = (shared_buf.read_idx + 1) % 5;
    shared_buf.count--;

    printf("Consumer consumed: %d (Count: %d)\n", val, shared_buf.count);

    // 唤醒生产者
    wakeup(&shared_buf.read_idx);

    release(&shared_buf.lock);
  }

  printf("Consumer finished.\n");

  acquire(&p->lock);
  p->state = ZOMBIE;
  sched();
}


// 创建一个执行特定函数的内核进程
void
create_kernel_process(char *name, void (*func)(void))
{
  struct proc *p;

  p = alloc_proc();
  if(p == 0) {
    printf("Failed to create process %s\n", name);
    return;
  }

  // 修改返回地址，使其被调度时直接跳转到 func
  p->context.ra = (uint64)func;
  
  // 设置栈指针 (alloc_proc 已经分配了 kstack)
  p->context.sp = p->kstack + PGSIZE;

  safestrcpy(p->name, name, sizeof(p->name));
  p->state = RUNNABLE;

  // alloc_proc 返回时持有锁，释放它以便调度器可以调度该进程
  release(&p->lock);
}


void test_synchronization(void) {
    printf("\n=== Testing Synchronization (Producer/Consumer) ===\n");
    
    // 1. 初始化共享锁和缓冲区
    shared_buffer_init();

    // 2. 创建生产者进程
    create_kernel_process("producer", producer_task);

    // 3. 创建消费者进程
    create_kernel_process("consumer", consumer_task);

    printf("Processes created. They will run when scheduler starts.\n");
}

