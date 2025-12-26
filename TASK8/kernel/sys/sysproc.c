#include"../../include/types.h"
#include"../../include/defs.h"
#include"../proc/proc.h"


extern int TEST_CRASH_ARMED;
uint64 sys_crash_arm(void) {
    TEST_CRASH_ARMED = 1;
    return 0;
}
uint64
sys_exit(){
  int n;
  argint(0, &n);
  proc_exit(n);
  return 0;  // not reached
}

uint64
sys_wait(){
  uint64 p;
  argaddr(0, &p);
  return proc_wait(p);
}

uint64 
sys_fork(){
  return proc_fork();
}

uint64 
sys_getpid(){
  return myproc()->pid;
}

uint64
sys_sbrk(void)
{
  uint64 address;
  int t;
  int n;

  argint(0, &n);
  argint(1, &t);
  address = myproc()->sz;

  if(t == SBRK_EAGER || n < 0) {
    if(grow_proc(n) < 0) {
      return -1;
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(address + n < address)
      return -1;
    myproc()->sz += n;
  }
  return address;
}

extern unsigned int ticks;
extern struct spinlock clock_lock;

uint64
sys_uptime(void)
{
  unsigned int xticks;
  acquire(&clock_lock);
  xticks = ticks;
  release(&clock_lock);
  return xticks;
}