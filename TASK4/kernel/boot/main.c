#include "defs.h"
extern void uart_puts(const char *s);

void main() {
    printf("Hello myOS! RISC-V single core console ready.\n");
    pmm_init();
    kvminit();
    kvminithart();
    //test_physical_memory();
    //test_pagetable();
    //test_virtual_memory();
    trap_init();      // 初始化中断向量表
    timer_init();     // 初始化时钟并设置第一次中断
    printf("kernel: interrupt and timer system initialized.\n");
    
    // 开启全局中断，等待时钟中断发生
    intr_on();
    test_timer_interrupt();
    //test_exception_handling();
    //test_interrupt_overhead(); 
    //printf_color(32, -1, 1, "ALL test is ok!\n"); // 绿色加粗
    intr_off(); 
    printf("Tests finished. Interrupts disabled.\n");
    
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

