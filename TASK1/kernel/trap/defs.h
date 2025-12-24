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
void consoleinit(void);

// exported by your bootstrap
extern volatile int panicked;
