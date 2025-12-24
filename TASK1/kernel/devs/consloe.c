// console.c - tiny console on top of UART (polling, single-core)
#include <stdint.h>
#include "defs.h"

#define BACKSPACE 0x100
#define C(x) ((x)-'@')

void consputc(int c) {
  if (c == BACKSPACE) {
    uart_putc('\b'); uart_putc(' '); uart_putc('\b');
  } else {
    uart_putc((char)c);
  }
}

void consoleinit(void) {
  uart_init(); // safe to be empty if UART already works
}
