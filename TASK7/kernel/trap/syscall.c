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
extern int sys_uptime(void); // 如果还没实现可以先注释掉
extern int sys_read(void);
extern int sys_open(void);
extern int sys_crash_arm(void);
extern int sys_unlink(void);
// extern int sys_open(void);   // 如果没文件系统，可以先让它返回 -1
static int (*syscalls[])(void) = {
  [SYS_fork]    sys_fork,
  [SYS_exit]    sys_exit,
  [SYS_wait]    sys_wait,
  [SYS_getpid]  sys_getpid,
  [SYS_write]   sys_write,
  [SYS_read]    sys_read,
  [SYS_uptime]  sys_uptime,
  [SYS_open]    sys_open,
  [SYS_crash_arm] sys_crash_arm,
  [SYS_unlink]  sys_unlink,
};
int fetchstr(uint64 addr, char *buf, int max) ;
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
int
fetchaddr(uint64 addr, uint64 *ip)
{
  struct proc *p = myproc();
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    return -1;
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    return -1;
  return 0;
}
int
argstr(int n, char *buf, int max)
{
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
}
// 在 kernel/syscall.c 或 kernel/sysfile.c 中添加
//int argstr(int n, char *buf, int max) {
  //uint64 addr;
  //if(argaddr(n, &addr) < 0)
   // return -1;
 // return fetchstr(addr, buf, max);
//}

// 辅助函数 fetchstr (从用户空间拷贝字符串)
// 需要 vm.c 中的 copyin 或类似的实现
int fetchstr(uint64 addr, char *buf, int max) {
  struct proc *p = myproc();
  int err = copyin(p->pagetable, buf, addr, max);
  if(err < 0)
    return -1;
  return strlen(buf);
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