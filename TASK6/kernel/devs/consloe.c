// console.c - tiny console on top of UART (polling, single-core)
#include <stdint.h>
#include "defs.h"
#include "types.h"
#include "spinlock.h"
#define BACKSPACE 0x100
#define C(x) ((x)-'@')
struct {
  struct spinlock lock;
  int locking;
} cons;
void consputc(int c) {
  if (c == BACKSPACE) {
    uart_putc('\b'); uart_putc(' '); uart_putc('\b');
  } else {
    uart_putc((char)c);
  }
}

// Write n bytes from user/kernel buffer to console (no copy helper here).
int consolewrite(const char *src, int n) {
  acquire(&cons.lock);
  for (int i = 0; i < n; i++) {
    char c = src[i];
    if (c == '\n') uart_putc('\r');
    uart_putc(c);
  }
  release(&cons.lock);
  return n;
  
}

// Blocking getchar from UART; translates CR to NL; handles backspace locally.
int console_getc(void) {
  for (;;) {
    int ch = uart_getc(); // blocks until a char is available
    if (ch == '\r') return '\n';
    return ch;
  }
}

// Simple canonical line input with echo and basic editing (^H, ^U).
// Returns length (0 allowed). Buffer is always NUL-terminated.
int console_readline(char *dst, int max) {
  int n = 0;
  for (;;) {
    int c = console_getc();
    switch (c) {
      case C('H'): // ^H
      case 0x7f:   // DEL
        if (n > 0) { n--; consputc(BACKSPACE); }
        break;
      case C('U'): // kill line
        while (n > 0) { n--; consputc(BACKSPACE); }
        break;
      case C('D'): // ^D => EOF if line is empty
        if (n == 0) { dst[0] = 0; return 0; }
        break;
      default:
        if (c == '\n') {
          consputc('\n');
          dst[n] = 0;
          return n;
        }
        if (n+1 < max) { // leave space for NUL
          dst[n++] = (char)c;
          consputc(c);
        }
        break;
    }
  }
}

void consoleinit(void) {
  initlock(&cons.lock, "console");
  uart_init(); // safe to be empty if UART already works
}
