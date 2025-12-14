#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "proc.h"

int sys_getpid(void) {
  return myproc()->pid;
}

int sys_fork(void) {
  return fork();
}

int sys_exit(void) {
  int n;
  if(argint(0, &n) < 0)
    return -1;
  exit_process(n);
  return 0; // 不会执行到这里
}

int sys_wait(void) {
  uint64 p; // 用户态传入的指针 (int *status) 的虚拟地址
  
  // 1. 获取参数：第 0 个参数是地址，必须用 argaddr 获取
  if(argaddr(0, &p) < 0)
    return -1;
  
  // 2. 定义一个内核栈上的临时变量来接收退出状态
  int status;
  
  // 3. 调用内核的 wait_process
  // wait_process 会把子进程的退出码写入 &status (这是内核地址，安全的)
  int pid = wait_process(&status);
  
  // 如果没有子进程或被杀，直接返回 -1
  if(pid < 0)
    return -1;
  
  // 4. 如果用户提供了非空指针 (p != 0)，则将结果拷贝回用户空间
  if(p != 0 && copyout(myproc()->pagetable, p, (char*)&status, sizeof(status)) < 0)
    return -1;
    
  return pid;
}

// 核心：系统调用 write 的实现
int sys_write(void) {
  int fd;
  uint64 p; // 用户空间缓冲区的虚拟地址
  int n;    // 要写入的字节数

  // 1. 获取参数
  // fd (arg 0), pointer (arg 1), length (arg 2)
  if(argint(0, &fd) < 0 || argaddr(1, &p) < 0 || argint(2, &n) < 0)
    return -1;
  
  // 2. 检查文件描述符
  // 目前我们只支持标准输出(1) 和 标准错误(2)
  if (fd != 1 && fd != 2) {
    return -1; 
  }

  // 3. 分块从用户空间拷贝数据并输出
  // 我们使用一个内核栈上的小缓冲区，循环读取用户数据
  char buf[128]; 
  int count = 0;
   printf("DEBUG: sys_write fd=%d n=%d\n", fd, n);
  while (count < n) {
      // 计算本次需要拷贝的字节数
      int amount = n - count;
      if (amount > sizeof(buf)) 
          amount = sizeof(buf);
      
      // 使用 copyin 从用户页表将数据拷贝到内核缓冲区
      // p + count 是用户空间当前偏移的虚拟地址
      if (copyin(myproc()->pagetable, buf, p + count, amount) < 0)
          return -1; // 拷贝失败（如地址无效）
      
      // 调用控制台输出函数
      consolewrite(buf, amount);
      //for(int i = 0; i < amount; i++) {
         // printf("%c", buf[i]); // 使用内核 printf 逐字符输出
      //}
      count += amount;
  }

  return n; // 返回实际写入的字节数
}