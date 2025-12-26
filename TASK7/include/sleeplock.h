
#ifndef __SLEEPLOCK_H__
#define __SLEEPLOCK_H__

#include "spinlock.h"
struct sleeplock {
  uint locked;       
  struct spinlock lk; 
  char *name;        
  int pid;           
};
#endif