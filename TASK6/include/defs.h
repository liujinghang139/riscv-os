// defs.h - tiny shared prototypes for the minimal OS
#pragma once
#include <stdint.h>
#include"types.h"
#include"riscv.h"
//#include "spinlock.h"
struct spinlock;
// uart
void uart_init(void);
void uart_putc(char c);
void uart_puts(const char *s);
int  uart_getc(void);
int  uart_getc_nonblock(void);

// console
void consputc(int c);
int  consolewrite(const char *src, int n);
int  console_getc(void);
int  console_readline(char *dst, int max);
void consoleinit(void);
//void consolewrite(char *buf, int n) ;
// printf/panic
int printf(const char *fmt, ...);
void panic(const char *s);

// exported by your bootstrap
extern volatile int panicked;

//ansi.c
void ansi_clear_screen(void);// Clear entire screen and move cursor to home (1,1)
void ansi_goto_xy(int row, int col);// Move cursor to (row, col), 1-based
void ansi_clear_eol(void);// Clear from cursor to end of line
void ansi_clear_line(void);
int printf_color(int fg, int bg, int bold, const char *fmt, ...);
void ansi_reset(void);

//string.c
void *memset(void *dst, int c, size_t n);
void *memcpy(void *dst, const void *src, size_t n);
char* safestrcpy(char *s, const char *t, int n);
void* memmove(void* dst, const void* src, uint n);
//kalloc.c
void pmm_init(void);
void *alloc_page(void);
void free_page(void *pa);
//vm.c
void kvminit();
void kvminithart();
pagetable_t kvmmake();
pagetable_t create_pagetable(void);
int map_page(pagetable_t pt, uint64 va, uint64 pa, uint64 size, int perm);
void map_region(pagetable_t pt, uint64 va, uint64 pa, uint64 size, int perm);
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc);
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) ;
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) ;
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) ;
void uvminit(pagetable_t pagetable, uchar *init, uint sz);
pagetable_t uvmcreate();
//proc.c
struct proc;
struct context; // 前置声明
void forkret(void);
void procinit(void);
struct cpu* mycpu(void);
struct proc* myproc(void);
void scheduler(void);
void yield(void);
void sched(void);
void sleep(void *chan, struct spinlock *lk);
void wakeup(void *chan);
int create_process(void (*entry)(void)) ;
void exit_process(int status);
int wait_process(int *status);
int fork(void);
void userinit(void) ;
//spinlock.c
void initlock(struct spinlock *lk, char *name);
void acquire(struct spinlock *lk) ;
void release(struct spinlock *lk) ;
int holding(struct spinlock *lk);
void push_off(void) ;
void pop_off(void);
// trap.c
// kernel/trap.c
void trap_init(void);
void kerneltrap(void);
void usertrap(void);
void usertrapret(void);
void handle_exception(uint64 cause, uint64 epc);
//syscall.c
int argint(int n, int *ip);
int argaddr(int n, uint64 *ip);
void syscall(void);
//sysproc.c

// trampoline.S
extern char trampoline[];
extern char uservec[];
extern char userret[];
// swtch.S
void swtch(struct context*, struct context*);
// timer.c
void timer_init(void);
void timer_interrupt(void);
uint64 get_time(void);
//用于测试内存分配
void test_physical_memory();
void test_pagetable();
void test_virtual_memory();
//用于测试中断
void test_timer_interrupt(void);
void test_exception_handling(void);
void test_interrupt_overhead(void); 
//用于测试进程
void test_process_creation(void);
void test_scheduler(void);
void test_synchronization(void);
//用于测试系统调用
// 基础功能测试：getpid, fork, exit, wait
void test_basic_syscalls(void);
// 参数传递测试：write, open, close 及参数检查
void test_parameter_passing(void);
// 安全性测试：无效指针、缓冲区边界
void test_security(void);
// 性能测试：测量系统调用耗时
void test_syscall_performance(void);
// 测试总入口：依次运行上述所有测试
void run_syscall_tests(void);
//define assert()
#define assert(expr) \
    do { \
        if (!(expr)) { \
            printf("Assertion Error: %s, file %s, line %d, function %s\n", \
                   #expr, __FILE__, __LINE__, __func__); \
            while (1); /* 关键修改：死循环，阻止代码继续向下执行 */ \
        } \
    } while (0)

