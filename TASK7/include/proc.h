#ifndef __PROC_H__
#define __PROC_H__
#include"types.h"
#include"riscv.h"
#include "spinlock.h" // 假设你已经有了自旋锁定义，如果没有，暂时可以用空结构代替
#include"param.h"
struct inode;
// 任务1: 进程状态定义 [cite: 1095-1098]
enum procstate {
  UNUSED,
  USED,
  SLEEPING,
  RUNNABLE,
  RUNNING,
  ZOMBIE
};

// 任务4: 上下文结构体 [cite: 1169-1179]
// 仅保存被调用者保存(Callee-saved)的寄存器
struct context {
  uint64 ra;
  uint64 sp;

  // Callee-saved registers
  uint64 s0;
  uint64 s1;
  uint64 s2;
  uint64 s3;
  uint64 s4;
  uint64 s5;
  uint64 s6;
  uint64 s7;
  uint64 s8;
  uint64 s9;
  uint64 s10;
  uint64 s11;
};

//用于在用户态和内核态切换时保存寄存器
// 必须与 trampoline.S 中的偏移量保持一致
struct trapframe {
  /* 0 */ uint64 kernel_satp;   // 内核页表地址
  /* 8 */ uint64 kernel_sp;     // 进程的内核栈顶地址
  /* 16 */ uint64 kernel_trap;   // usertrap() 函数地址
  /* 24 */ uint64 epc;           // 保存的用户程序计数器 (SEPC)
  /* 32 */ uint64 kernel_hartid; // 保存的内核 TP 寄存器
  /* 40 */ uint64 ra;
  /* 48 */ uint64 sp;
  /* 56 */ uint64 gp;
  /* 64 */ uint64 tp;
  /* 72 */ uint64 t0;
  /* 80 */ uint64 t1;
  /* 88 */ uint64 t2;
  /* 96 */ uint64 s0;
  /* 104 */ uint64 s1;
  /* 112 */ uint64 a0;
  /* 120 */ uint64 a1;
  /* 128 */ uint64 a2;
  /* 136 */ uint64 a3;
  /* 144 */ uint64 a4;
  /* 152 */ uint64 a5;
  /* 160 */ uint64 a6;
  /* 168 */ uint64 a7;
  /* 176 */ uint64 s2;
  /* 184 */ uint64 s3;
  /* 192 */ uint64 s4;
  /* 200 */ uint64 s5;
  /* 208 */ uint64 s6;
  /* 216 */ uint64 s7;
  /* 224 */ uint64 s8;
  /* 232 */ uint64 s9;
  /* 240 */ uint64 s10;
  /* 248 */ uint64 s11;
  /* 256 */ uint64 t3;
  /* 264 */ uint64 t4;
  /* 272 */ uint64 t5;
  /* 280 */ uint64 t6;
};
// 任务1: 进程控制块 (PCB) [cite: 1088]
struct proc {
  struct spinlock lock;

  // p->lock must be held when using these:
  enum procstate state;        // 进程状态
  void *chan;                  // 如果非空，表示正在在该通道上休眠 [cite: 1088]
  int killed;                  // 如果非零，表示已被杀掉
  int xstate;                  // 退出状态码
  int pid;                     // 进程ID

  // proc_tree_lock must be held when using this:
  struct proc *parent;         // 父进程

  // these are private to the process, so p->lock need not be held.
  uint64 kstack;               // 内核栈虚拟地址
  uint64 sz;                   // 进程内存大小 (bytes)
  pagetable_t pagetable;       // 用户页表
  struct trapframe *trapframe; // 蹦床页的数据，用于保存用户态寄存器
  struct context context;      // swtch() 在此处切换上下文 [cite: 1088]
  char name[16];               // 进程名 (调试用)
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;     
  // [新增] 内核线程的任务函数指针
  void (*kstack_entry)(void);
};

// 简化的 CPU 结构 (假设单核)
struct cpu {
  struct proc *proc;          // 当前 CPU 运行的进程
  struct context context;     // 调度器的上下文
  int noff;                   // 嵌套锁深度
  int intena;                 // 中断使能状态
};

#endif