#ifndef __SPINLOCK_H__
#define __SPINLOCK_H__

#include "types.h"

struct spinlock {
  uint locked;       // 锁的状态：0 = 空闲, 1 = 占用
  
  // 用于调试的信息
  char *name;        // 锁的名字
  struct cpu *cpu;   // 持有该锁的 CPU
};

#endif