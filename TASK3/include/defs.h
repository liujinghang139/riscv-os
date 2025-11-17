// defs.h - tiny shared prototypes for the minimal OS
#pragma once
#include <stdint.h>
#include"types.h"
#include"riscv.h"
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
//用于测试内存分配
void test_physical_memory();
void test_pagetable();
void test_virtual_memory();

//define assert()
#define assert(expr) \
    do { \
        if (!(expr)) { \
            printf("Assertion Error: %s, file %s, line %d, function %s\n", \
                   #expr, __FILE__, __LINE__, __func__); \
            while (1); /* 关键修改：死循环，阻止代码继续向下执行 */ \
        } \
    } while (0)

