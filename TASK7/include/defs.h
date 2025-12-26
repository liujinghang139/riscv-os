// defs.h - tiny shared prototypes for the minimal OS
#pragma once
#include <stdint.h>
#include"types.h"
#include"riscv.h"
#include"fs.h"
#define NELEM(x) (sizeof(x)/sizeof((x)[0]))
//#include "spinlock.h"
struct superblock;
struct spinlock;
struct sleeplock;
struct buffer;
struct inode;
struct file;
// uart
void uart_init(void);
void uart_putc(char c);
void uart_puts(const char *s);
int  uart_getc(void);
int  uart_getc_nonblock(void);
//exec.c
int kexec(char*, char**);
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
int strncmp(const char *p, const char *q, uint64 n); // <--- 新增
uint strlen(const char *s);                    // <--- 新增(备用)
char* strncpy(char *s, const char *t, int n);        // <--- 新增(备用)
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
uint64 uvm_alloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm);
void uvm_clear(pagetable_t pagetable, uint64 va);
uint64 walkaddr(pagetable_t pagetable, uint64 va);
pagetable_t uvmcreate();
void 
uvm_free(pagetable_t pagetable, uint64 sz);
void uvm_clear(pagetable_t pagetable, uint64 va);
void uvm_unmap(pagetable_t pagetable, uint64 va, int npages, int dofree);
uint64 uvm_dealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz);
//proc.c
struct proc;
struct context; // 前置声明
void forkret(void);
void procinit(void);
pagetable_t proc_pagetable(struct proc *p);
void 
proc_freepagetable(pagetable_t pagetable, uint64 sz);
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
void userinit(void);
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len);
int either_copyin(void *dst, int user_src, uint64 src, uint64 len);
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
int argstr(int n, char *buf, int max);
int fetchstr(uint64 addr, char *buf, int max);
int
fetchaddr(uint64 addr, uint64 *ip);
//sysproc.c
//sleeplock.c
void init_sleeplock(struct sleeplock *lk, char *name);
void acq_sleeplock(struct sleeplock *lk);
void rel_sleeplock(struct sleeplock *lk);
int  holding_sleeplock(struct sleeplock *lk);

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
//fs.c
void  fs_init(int dev);
void  itable_init();
struct inode* alloc_inode(uint dev, short type);
void update_inode(struct inode *inode);
struct inode* duplicate_inode(struct inode *inode);
void lock_inode(struct inode *inode);
void unlock_inode(struct inode *inode);
void putback_inode(struct inode *inode);
void reclaim_inode(int dev);
void truncate_inode(struct inode*);
int  compare_name(const char*, const char*);
struct inode* namei(char*);
struct inode* nameiparent(char*, char*);
int read_inode(struct inode*, int, uint64, uint, uint);
// void stat_inode(struct inode*, struct stat*);
int write_inode(struct inode*, int, uint64, uint, uint);
int link_dir(struct inode*, char*, uint);
struct inode* lookup_dir(struct inode*, char*, uint*);

// 来自 file.c
struct file* filealloc(void);
void fileclose(struct file*);
struct file* filedup(struct file*);
void file_init(void);
int fileread(struct file*, uint64, int n);
// int filestat(struct file*, uint64 addr);
int filewrite(struct file*, uint64, int n);
//int fdalloc(struct file *f); // 注意：你需要确保 file.c 中实现了这个函数，或者在这里实现
// 来自 kernel/log.c
void init_log(int, struct superblock*);
void log_write(struct buffer*);
void begin_op(void);
void end_op(void);
void init_log(int dev, struct superblock *sb);
//bio.c
void bio_init();
struct buffer *read_buf(uint dev, uint block_num);
void write_buf(struct buffer *buf);
void relse_buf(struct buffer *buf);
void pin_buf(struct buffer*);
void unpin_buf(struct buffer*);
//plic.c
void plic_init(void);
void plic_inithart(void);
int plic_claim(void);
void plic_complete(int irq);
// virtio_disk.c
void            virtio_disk_init(void);
void            virtio_disk_rw(struct buffer *, int);
void            virtio_disk_intr(void);
//
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

