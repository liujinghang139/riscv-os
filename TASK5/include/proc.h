// kernel/proc.h
#ifndef __PROC_H__
#define __PROC_H__
#include"types.h"
#include"riscv.h"
#include "spinlock.h" // 假设你已经有了自旋锁定义，如果没有，暂时可以用空结构代替

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