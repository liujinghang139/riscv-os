#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "spinlock.h"
#include "proc.h" // 需要 mycpu() 定义

// 初始化锁
void initlock(struct spinlock *lk, char *name) {
  lk->name = name;
  lk->locked = 0;
  lk->cpu = 0;
}

// 获取锁
void acquire(struct spinlock *lk) {
  // 1. 关闭中断以防死锁
  push_off(); 

  // 检查是否重复加锁 (调试用)
  if(holding(lk))
    panic("acquire");

  // 2. 原子操作循环：尝试将 locked 置为 1
  // __sync_lock_test_and_set 返回 locked 的旧值
  // 如果旧值是 1，说明有人在用，继续循环；如果是 0，说明抢到了，循环结束
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
      ; // 自旋等待
  }

  // 3. 内存屏障
  // 告诉 CPU：在屏障之后的读写操作，绝对不能被重排到屏障之前
  // 确保临界区的代码在锁获取之后才执行
  __sync_synchronize();

  // 记录持有者信息
  lk->cpu = mycpu();
}

// 释放锁
void release(struct spinlock *lk) {
  if(!holding(lk))
    panic("release");

  lk->cpu = 0;

  // 1. 内存屏障
  // 确保临界区的所有操作在释放锁之前都已经写入内存
  __sync_synchronize();

  // 2. 原子释放：将 locked 置为 0
  __sync_lock_release(&lk->locked);

  // 3. 恢复中断状态
  pop_off();
}

// 检查当前 CPU 是否持有该锁
int holding(struct spinlock *lk) {
  int r;
  push_off();
  r = (lk->locked && lk->cpu == mycpu());
  pop_off();
  return r;
}
// 保存并关闭中断
void push_off(void) {
  int old = intr_get(); // 获取当前中断状态 (sstatus.sie)
  
  intr_off(); // 真正的关中断操作
  
  struct cpu *c = mycpu();
  if(c->noff == 0)
    c->intena = old; // 只有在最外层才记录原来的中断状态
  c->noff += 1;      // 增加嵌套深度
}

// 恢复中断
void pop_off(void) {
  struct cpu *c = mycpu();
  
  if(intr_get()) // 如果当前中断是开着的，说明逻辑错了（还没 pop 完怎么就开了？）
    panic("pop_off - interruptible");
  
  if(c->noff < 1)
    panic("pop_off");
    
  c->noff -= 1;
  
  // 只有当嵌套深度回到 0，且原来就是开中断状态时，才真正开启中断
  if(c->noff == 0 && c->intena)
    intr_on();
}