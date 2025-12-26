#include"./spinlock.h"
#include"./proc.h"
#include"../../include/defs.h"


// To be continued
void init_lock(struct spinlock *lk, char *name){
  lk->name = name;
  lk->cpu = 0;
  lk->locked = 0;
}


// To be continued
void acquire(struct spinlock *lk){
  push_off();     //push_off(): 禁用中断

  //检查是否CPU已经持有该锁
  if(holding(lk))
    panic("acquire(): CPU is already holding the spinlock!");

  //自旋锁
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0);

  //内存屏障说是
  //英文注释：
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen strictly after the spinlock is acquired.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();

  lk->cpu = mycpu();

}

// To be continued
void release(struct spinlock *lk){
  if(!holding(lk))
    panic("release(): you aren't holding the spinlock, why release?");

  lk->cpu = 0;

  // Tell the C compiler and the CPU to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other CPUs before the spinlock is released,
  // and that loads in the critical section occur strictly before
  // the spinlock is released.
  // On RISC-V, this emits a fence instruction.
  __sync_synchronize();

  // Release the lock, equivalent to lk->locked = 0.
  // This code doesn't use a C assignment, since the C standard
  // implies that an assignment might be implemented with
  // multiple store instructions.
  // On RISC-V, sync_lock_release turns into an atomic swap:
  //   s1 = &lk->locked
  //   amoswap.w zero, zero, (s1)
  __sync_lock_release(&lk->locked);
  

  //开启中断
  pop_off();
}

//判断调用holding的CPU是否持有该锁
// To be continued
int holding(struct spinlock *lk){
  int r;
  r = (lk->locked)&&(lk->cpu == mycpu());
  return r;
}

//将此CPU的中断关闭
// To be continued
void push_off(){
  int old_status = intr_get();
  intr_off();
  struct cpu *c;
  c = mycpu();
  if(c->noff == 0)
    c->intena = old_status;
  c->noff += 1;
}

//将此CPU的中断打开
// To be continued
void pop_off(){
  struct cpu *c;
  c = mycpu();
  if(intr_get())
    panic("pop_off(): the interrupt is enable!\n");
  if(c->noff < 1)
    panic("pop_off(): c.noff < 1!\n");

  c->noff -= 1;
  if(c->noff == 0 && c->intena)
    intr_on();
}
