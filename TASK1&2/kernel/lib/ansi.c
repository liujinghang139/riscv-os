// ansi.c - ANSI escape helpers for serial/console
#include <stdarg.h>
#include "defs.h"
#include "ansi.h"

static inline void putstr(const char *s) {
  while (*s) {
    if (*s == '\n') uart_putc('\r');
    uart_putc(*s++);
  }
}

// ESC as literal
#define ESC "\033"

void ansi_reset(void) {
  // reset all attributes
  putstr(ESC "[0m");
}

void ansi_clear_screen(void) {
  // ESC[2J  clear screen; ESC[H move to home
  putstr(ESC "[2J" ESC "[H");
}

void ansi_goto_xy(int row, int col) {
  // ESC[row;colH
  printf(ESC "[%d;%dH", row, col);
}

void ansi_clear_eol(void) {
  // ESC[K  clear from cursor to end of line
  putstr(ESC "[K");
}

void ansi_clear_line(void) {
  // ESC[2K clear entire line, then move to column 1 (ESC[G)
  putstr(ESC "[2K" ESC "[G");
}

// NOTE: For full variadic forwarding you'd want a vprintf variant.
// Here we support simple usage without extra format args to keep things tiny.
int printf_color(int fg, int bg, int bold, const char *fmt, ...) {
  int count = 0;
  if (bold) count += printf(ESC "[1m");
  if (fg >= 30 && fg <= 37) count += printf(ESC "[%dm", fg);
  if (bg >= 40 && bg <= 47) count += printf(ESC "[%dm", bg);

  // Basic payload: support either plain string or single %s via next arg.
  va_list ap;
  va_start(ap, fmt);
  // Detect if fmt contains one %s; for simplicity, handle two cases:
  int has_percent = 0;
  for (const char *p = fmt; *p; ++p) if (*p == '%') { has_percent = 1; break; }
  if (has_percent) {
    const char *sarg = va_arg(ap, const char*);
    count += printf(fmt, sarg);
  } else {
    count += printf("%s", fmt);
  }
  va_end(ap);

  count += printf(ESC "[0m"); // reset
  return count;
}
