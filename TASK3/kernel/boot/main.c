#include "defs.h"
extern void uart_puts(const char *s);


void main() {
    printf("Hello myOS! RISC-V single core console ready.\n");
    pmm_init();
    kvminit();
    kvminithart();
    test_physical_memory();
    test_pagetable();
    test_virtual_memory();
 
   
    printf_color(32, -1, 1, "ALL test is ok!\n"); // 绿色加粗
    
    
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

