#ifndef SLEEPLOCK_H
#define SLEEPLOCK_H

#include"./spinlock.h"


struct sleeplock{
  int locked;
  struct spinlock lock;
  int pid;
  char *name;
};

#endif