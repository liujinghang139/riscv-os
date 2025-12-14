#include "types.h"
#include "defs.h"
#include "riscv.h"
#include "proc.h"
#include "../../include/syscall.h"

// 外部声明具体系统调用函数
extern int sys_fork(void);
extern int sys_exit(void);
extern int sys_wait(void);
extern int sys_getpid(void);
extern int sys_write(void);
// extern int sys_uptime(void); // 如果还没实现可以先注释掉
// extern int sys_open(void);   // 如果没文件系统，可以先让它返回 -1
static int (*syscalls[])(void) = {
  [SYS_fork]    sys_fork,
  [SYS_exit]    sys_exit,
  [SYS_wait]    sys_wait,
  [SYS_getpid]  sys_getpid,
  [SYS_write]   sys_write,
};

// 获取第 n 个整型参数 (a0-a5) [cite: 1493]
int argint(int n, int *ip) {
  struct proc *p = myproc();
  struct trapframe *tf = p->trapframe;
  switch(n) {
  case 0: *ip = tf->a0; break;
  case 1: *ip = tf->a1; break;
  case 2: *ip = tf->a2; break;
  case 3: *ip = tf->a3; break;
  case 4: *ip = tf->a4; break;
  case 5: *ip = tf->a5; break;
  default: return -1;
  }
  return 0;
}
// 获取第 n 个系统调用参数，作为指针（地址）返回
// 参数:
//   n: 参数索引 (0-5)
//   ip: 用于存储获取到的地址值
// 返回值: 
//   0 表示成功, -1 表示索引无效
int argaddr(int n, uint64 *ip) {
  struct proc *p = myproc();
  struct trapframe *tf = p->trapframe;

  switch(n) {
  case 0: *ip = tf->a0; break;
  case 1: *ip = tf->a1; break;
  case 2: *ip = tf->a2; break;
  case 3: *ip = tf->a3; break;
  case 4: *ip = tf->a4; break;
  case 5: *ip = tf->a5; break;
  default:
    return -1;
  }
  return 0;
}
void syscall(void) {
  int num;
  struct proc *p = myproc();
  num = p->trapframe->a7; // 系统调用号在 a7

  if(num > 0 && num < sizeof(syscalls)/sizeof(syscalls[0]) && syscalls[num]) {
    p->trapframe->a0 = syscalls[num](); // 返回值存入 a0
  } else {
    printf("%d: unknown sys call %d\n", p->pid, num);
    p->trapframe->a0 = -1;
  }
  //p->trapframe->epc += 4;
}