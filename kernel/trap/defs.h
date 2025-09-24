// defs.h - tiny shared prototypes for the minimal OS
#pragma once
#include <stdint.h>

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
