#include "syscall.h"
.section .text.start
.global _start
_start:
    # 1. 【关键修复】初始化 gp (Global Pointer) 为 0
    # 防止编译器生成的指令使用未初始化的 gp 计算地址，导致访问非法内存 (比如 -799)
    li gp, 0
    
    # 2. 调用 C 语言的 main 函数
    call main
    
    # 3. main 函数返回后，调用 exit 系统调用
    # main 的返回值放在 a0 寄存器中，正好作为 exit 的参数
    li a7, SYS_exit
    ecall
    
    # 如果 exit 竟然返回了（不可能发生），就死循环
    loop:
        j loop
# 定义一个宏，避免重复写代码
#define SYSCALL(name) \
  .global name; \
  name: \
    li a7, SYS_ ## name; \
    ecall; \
    ret

# 批量生成汇编代码
SYSCALL(fork)
SYSCALL(exit)
SYSCALL(wait)
SYSCALL(pipe)
SYSCALL(read)
SYSCALL(write)
SYSCALL(close)
SYSCALL(kill)
SYSCALL(exec)
SYSCALL(open)
SYSCALL(mknod)
SYSCALL(unlink)
SYSCALL(fstat)
SYSCALL(link)
SYSCALL(mkdir)
SYSCALL(chdir)
SYSCALL(dup)
SYSCALL(getpid)
SYSCALL(sbrk)
SYSCALL(sleep)
SYSCALL(uptime)