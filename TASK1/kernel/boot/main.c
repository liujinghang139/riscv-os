#include "defs.h"

extern void uart_puts(const char *s);
void main() {
    uart_puts("Hello myOS! RISC-V single core console ready.\n");
    
     for(;;) { __asm__ volatile("wfi"); }
    //char line[64];
    //for (;;) {
      //  printf("> ");
       // int n = console_readline(line, sizeof(line));
        //if (n == 0) {
           // printf("\nEOF (^D). Halting.\n");
           // for(;;)__asm__ volatile("wfi");
       // }
        //printf("you typed (%d): %s\n", n, line);
  //  }
}

