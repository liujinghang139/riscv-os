#ifndef DEFS_H
#define DEFS_H

#include"types.h"
#include"riscv.h"
#include"../kernel/proc/spinlock.h"
extern int TEST_CRASH_ARMED;
//define the code of color
enum{
  RED, GREEN, YELLOW
};

// number of elements in fixed-size array
#define NELEM(x) (sizeof(x)/sizeof((x)[0]))

struct context;
struct proc;
struct spinlock;
struct buffer;
struct sleeplock;
struct inode;
struct super_block;

//console.c
void cons_putc(int c);
void console_intr(int c);
void console_init();     //Init the console to input character
void clear_screen();
void go_to_xy(int x, int y);

//printf.c
void printf(char *fmt, ...);
void printf_color(int color, char*fmt);
void panic(char*) __attribute__((noreturn));
void printf_init();

//string.c
void *memset(void *ptr, int c, uint n);
void panic(char *str);
int strlen(const char *s);
void *memmove(void *dst, const void *src, uint n);
char *safestrcpy(char *s, const char *t, int n);
void test_synchronization(void);
int  strncmp(const char*, const char*, uint);
char* strncpy(char*, const char*, int);


//uart.c
void uart_putc(char c);
void uart_puts(const char *s);
void uart_init();
void uart_intr();

//kalloc.c
void pmm_init();
void freerange(void *pa_start, void *pa_end);
void free_page(void *p);
void *alloc_page(); //Allocate one page of physical memory

//vm.c
void kvm_init();
void kvm_inithart();
pagetable_t kvmmake();
pagetable_t create_pagetable();
int map_page(pagetable_t , uint64 , uint64 , uint64 , int );
void map_region(pagetable_t pt, uint64 va, uint64 pa, int size, int perm);
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc);
pagetable_t uvm_create();
void uvm_unmap(pagetable_t pagetable, uint64 va, int npages, int dofree);
void uvm_free(pagetable_t pagetable, uint64 sz);
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max);
int copy_page(pagetable_t old_page, pagetable_t new_page, uint64 sz);
int copyout(pagetable_t, uint64, char *, uint64);
int copyin(pagetable_t, char *, uint64, uint64);
uint64 walkaddr(pagetable_t pagetable, uint64 va);
uint64 uvm_alloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm);
void uvm_clear(pagetable_t pagetable, uint64 va);
uint64 uvm_dealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz);
uint64          vmfault(pagetable_t, uint64, int);


//trap.c
void trap_init();
void trap_init_hart();
void pre_return();

//spinlock.c
int holding(struct spinlock *lk);
void push_off();
void pop_off();
void init_lock(struct spinlock *lk, char *name);
void acquire(struct spinlock *lk);
void release(struct spinlock *lk);

//sleeplock.c
void init_sleeplock(struct sleeplock *lk, char *name);
void acq_sleeplock(struct sleeplock *lk);
void rel_sleeplock(struct sleeplock *lk);
int  holding_sleeplock(struct sleeplock *lk);

//proc.c
void proc_init();
void user_init();
void proc_mapstacks(uint64 *kernel_pagetable);
pagetable_t proc_pagetable(struct proc *p);
void proc_freepagetable(pagetable_t pagetable, uint64 sz);
struct proc *alloc_proc();
void free_proc(struct proc *p);
int cpuid();
struct cpu *mycpu();
struct proc *myproc();
void scheduler();
void yield();
void sched();
int get_killed(struct proc *p);
void set_killed(struct proc *p);
void swtch(struct context*, struct context*); //  swtch.S
void sleep(struct spinlock *lk, void *chan);
void wakeup(void *chan);
void sleep_tick(uint64 n);
void proc_exit(int status);
uint64 proc_wait(uint64 addr);
int proc_fork();
void forkret();
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len);
int either_copyin(void *dst, int user_src, uint64 src, uint64 len);
int grow_proc(int n);

//exec.c
int kexec(char*, char**);

//syscall.c
void syscall();
void argint(int n, int *ip);
void argaddr(int n, uint64 *ip);
int argstr(int, char*, int);
int fetchstr(uint64 , char *, int);
int fetchaddr(uint64 , uint64 *);

struct inode* create(char *path, short type, short major, short minor);

//plic.c
int plic_claim();
void plic_compelete(int irq);
void plicinit();      // set up interrupt controller
void plicinithart();  // ask PLIC for device interrupts

// virtio_disk.c
void            virtio_disk_init(void);
void            virtio_disk_rw(struct buffer *, int);
void            virtio_disk_intr(void);

//bio.c
void bio_init();
struct buffer *read_buf(uint dev, uint block_num);
void write_buf(struct buffer *buf);
void relse_buf(struct buffer *buf);
void pin_buf(struct buffer*);
void unpin_buf(struct buffer*);

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




//file.c
struct file* filealloc(void);
void fileclose(struct file*);
struct file* filedup(struct file*);
void file_init(void);
int fileread(struct file*, uint64, int n);
// int filestat(struct file*, uint64 addr);
int filewrite(struct file*, uint64, int n);

//log.c
void init_log(int, struct super_block*);
void log_write(struct buffer*);
void begin_op(void);
void end_op(void);
void
init_log(int dev, struct super_block *sb);


/*
scripts/test文件夹下的测试函数
*/
//用于测试内核print.c
void test_printf_basic();
void test_printf_edge_cases();
//用于测试内存分配
void test_physical_memory();
void test_pagetable();
void test_virtual_memory();
//用于测试trap
void test_timer_interrupt();
//用于测试进程调度
void test_process_creation();
void test_scheduler();
void create_testproc();
//用于测试文件系统
void test_filesystem_integrity();



//用于测试系统调用
void test_syscalls();
//define assert()
#define assert(expr) ((expr)?(void)0:\
  printf("Assertion Error: %s, file %s, line %d, function %s\n", #expr, __FILE__, __LINE__, __func__))

#endif