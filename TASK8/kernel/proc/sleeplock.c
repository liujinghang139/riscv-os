#include"../../include/types.h"
#include"../../include/riscv.h"
#include"../../include/param.h"
#include"../../include/memlayout.h"
#include"./spinlock.h"
#include"./proc.h"
#include"./sleeplock.h"
#include"../../include/defs.h"

void
init_sleeplock(struct sleeplock *lk, char *name){
  init_lock(&lk->lock, "sleep_lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
}

//通过sleeplock中的locked来进行同步
void acq_sleeplock(struct sleeplock *lk){
  acquire(&lk->lock);
  while(lk->locked){
    sleep(&lk->lock, lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lock);
}

void 
rel_sleeplock(struct sleeplock *lk){
  acquire(&lk->lock);
  if(!lk->locked)
    panic("sleeplock:\n");
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lock);
}

int 
holding_sleeplock(struct sleeplock *lk){
  int pid;
  int ans;
  pid = myproc()->pid;
  acquire(&lk->lock);
  ans = lk->locked && (lk->pid == pid);
  release(&lk->lock);
  return ans;
}