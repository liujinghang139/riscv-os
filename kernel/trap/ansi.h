// ansi.h - ANSI escape helpers for serial console
#pragma once

// Clear entire screen and move cursor to home (1,1)
void ansi_clear_screen(void);

// Move cursor to (row, col), 1-based
void ansi_goto_xy(int row, int col);

// Clear from cursor to end of line
void ansi_clear_eol(void);

// Clear entire current line and move cursor to column 1
void ansi_clear_line(void);

// Set color then print formatted text, then reset color.
// fg/bg: -1 to leave unchanged; use 30-37 for fg, 40-47 for bg; bold 0/1.
int printf_color(int fg, int bg, int bold, const char *fmt, ...);

// Reset attributes (colors, bold, etc.)
void ansi_reset(void);