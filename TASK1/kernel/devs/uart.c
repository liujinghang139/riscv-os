// uart_with_rx.c - 16550A UART for QEMU virt (TX + RX, polling)
#include <stdint.h>
#include "defs.h"

#define UART_BASE 0x10000000UL
#define UART_RHR  (UART_BASE + 0x00)  // Receive Holding Register
#define UART_THR  (UART_BASE + 0x00)  // Transmit Holding Register
#define UART_LSR  (UART_BASE + 0x05)  // Line Status Register
#define LSR_DR    0x01                // Data Ready
#define LSR_THRE  0x20                // THR Empty

static inline void outb(unsigned long addr, unsigned char val) {
  *(volatile unsigned char *)addr = val;
}
static inline unsigned char inb(unsigned long addr) {
  return *(volatile unsigned char *)addr;
}

void uart_init(void) {
  // QEMU's 16550 on virt usually comes initialized enough for polling TX/RX.
  // Keep it minimal; if you wish, add proper baud/LCR init later.
}

void uart_putc(char c) {
  while ((inb(UART_LSR) & LSR_THRE) == 0) { }
  outb(UART_THR, (unsigned char)c);
}

void uart_puts(const char *s) {
  while (*s) {
    if (*s == '\n') uart_putc('\r');
    uart_putc(*s++);
  }
}

// Non-blocking getc: returns -1 if no data available.
int uart_getc_nonblock(void) {
  if (inb(UART_LSR) & LSR_DR) {
    return (int)(unsigned char)inb(UART_RHR);
  }
  return -1;
}

// Blocking getc: spins until a byte arrives.
int uart_getc(void) {
  int v;
  while ((v = uart_getc_nonblock()) == -1) { }
  return v;
}
