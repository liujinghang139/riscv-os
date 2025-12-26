#include"../../include/types.h"
#include"../../include/riscv.h"
#include"../../include/memlayout.h"
#include"../proc/proc.h"
#include"../../include/defs.h"

unsigned int ticks;     //用于时钟中断计数

struct spinlock clock_lock;
extern char uservec[], trampoline[];

int interrupt_count;  //for test_trap.c

void kernelvec();   //定义在kernelvec.c中，用汇编写的

int dev_intr();


void 
trap_init(){
  init_lock(&clock_lock, "time");
}

void trap_init_hart(){
  w_stvec((uint64)kernelvec);
}


uint64
usertrap(){

  //  SPP位表示进入trap之前的privilege level
  //  SIE位表示当前是否开启中断
  //  SPIE表示在trap into S mode之前是否开启中断
  if(r_sstatus() & SSTATUS_SPP){
    panic("The trap is not occured in User Mode.\n");
  }
  int which_intr = 0;

  struct proc *p = myproc();
  //  sepc很快会被破坏，需要尽快保存
  p->trapframe->epc = r_sepc();
  
  //  如果在usertrap()的过程中出现trap,那么理应进入kerneltrap()
  w_stvec((uint64)kernelvec);

  //  scause值为8，表明trap的原因是syscall
  if(r_scause() == 8){

    if(get_killed(p))
      proc_exit(-1);
    
    //  如果是因为ecall指令的话，那么返回地址必定要跳过ecall才行
    p->trapframe->epc += 4;

    //  进行syscall()的过程比较漫长，需要将之前等待的interrupts先解决
    intr_on();
    syscall();
    
  } else if((which_intr = dev_intr()) != 0){
    //  interrupts在dev_intr()中解决了
  } else if((r_scause() == 15 || r_scause() == 13) &&
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    // page fault on lazily-allocated page
  } else if(r_scause() == 12 &&
            vmfault(p->pagetable, r_stval(), 1) != 0) {
    // instruction page fault: lazily allocate and map the page, then continue
  } else {
    // extra diagnostics to understand why fault couldn't be handled
    uint64 va = r_stval();
    pte_t *pte = walk(p->pagetable, PGROUNDDOWN(va), 0);
    if(pte && (*pte & PTE_V)){
      printf("Trap not recognized: scause=0x%lx stval=0x%lx epc=0x%lx flags=0x%lx\n",
             r_scause(), va, p->trapframe->epc, PTE_FLAGS(*pte));
    } else {
      printf("Trap not recognized: scause=0x%lx stval=0x%lx epc=0x%lx (pte invalid)\n",
             r_scause(), va, p->trapframe->epc);
    }
    set_killed(p);
    printf("pid %d died\n", p->pid);
  }

  if(get_killed(p))
    proc_exit(-1);

  if(which_intr == 1)
    yield();

  pre_return();

  uint64 satp = MAKE_SATP(p->pagetable);

  // return to trampoline.S; satp value in a0.
  return satp;
}



void 
pre_return(){
  struct proc *p = myproc();

  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
  p->trapframe->kernel_trap = (uint64)usertrap;
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()

  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
  x |= SSTATUS_SPIE; // enable interrupts in user mode
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
}


/*
  kerneltrap()只处理中断而不处理异常
  因为内核态下如果出现异常那么代码写的有问题
*/
// To be continued
void kerneltrap(){
  uint which_intr = 0;
  uint64 sepc = r_sepc();
  uint64 sstatus = r_sstatus();

  if((sstatus & SSTATUS_SPP) == 0)
    panic("kerneltrap(): not from supervisor mode!");
  // 此时要检查SIE中断是否没被机器清零，要不然在解决中断的时候又会被中断
  if(intr_get() != 0)
    panic("kerneltrap(): supervisor mode is enabled!");
  if((which_intr = dev_intr()) == 0){
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", r_scause(), r_sepc(), r_stval());
    panic("kerneltrap(): trap not recognized!"); 
  }
  
  //  如果是timer_interrupt，说明当前proc的时间片用完
  //  让度CPU, yield() -> sched() -> scheduler()
  if(which_intr == 1 && myproc() != 0)
    yield();

  w_sepc(sepc);
  w_sstatus(sstatus);

}

extern int *test_flag;  // For debug

//  在dev_intr()函数中识别到是timer_interrupt就调用clock_intr()  
//  此时获取锁并让ticks增加，并且将睡眠中的进程该唤醒的给唤醒
//  并且设置下一次timer_interrupt的时间
void 
timer_intr(){
  if(cpuid() == 0){
    acquire(&clock_lock);
    interrupt_count++;
    ticks++;
    wakeup(&ticks);
    release(&clock_lock);
    w_stimecmp(r_time() + 1000000);
  }
}

/*
  判断中断是什么类型的，external interrupt or timer interrupt
  在xv6中似乎没有处理 software interrupt
  external --> return 2
  timer --> return 1
  not recognized --> return 0
*/
int dev_intr(){
  uint64 scause = r_scause();
  // 最高位 = 1 --> interrupt, 0 --> exception
  if(scause == 0x8000000000000009L){ 
    //从PLIC处获得信息判断是哪一个外设发起中断
    int irq = plic_claim();
    if(irq == VIRTIO0_IRQ){
      virtio_disk_intr();
    } else if(irq == UART0_IRQ){
      uart_intr();
    } else{
      printf("dev_intr(): Unexpected interrupt, irq:%d", irq);
    }
    if(irq)
      plic_compelete(irq);

    return 2;
  } else if(scause == 0x8000000000000005L){
    // Supervisor mode timer interrupt
    timer_intr();
    return 1;
  } else{
    return 0;
  }
}
