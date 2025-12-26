#ifndef SPINLOCK_H
#define SPINLOCK_H

struct spinlock{
  unsigned int locked;

  //调试所用
  char *name;
  struct cpu *cpu;
};

#endif