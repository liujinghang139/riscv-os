#include "defs.h"
#include "ansi.h"
extern void uart_puts(const char *s);
void test_printf_basic() {
    printf("Testing integer: %d\n", 42);
    printf("Testing negative: %d\n", -123);
    printf("Testing zero: %d\n", 0);
    printf("Testing hex: 0x%x\n", 0xABC);
    printf("Testing string: %s\n", "Hello");
    printf("Testing char: %c\n", 'X');
    printf("Testing percent: %%\n");
}

void test_printf_edge_cases() {
    printf("INT_MAX: %d\n", 2147483647);
    printf("INT_MIN: %d\n", -2147483648);   // 注意 RISC-V GCC 可能会警告这个常量写法
    printf("NULL string: %s\n", (char*)0);
    printf("Empty string: %s\n", "");
}
//void main() {
   // consoleinit(); // 如已在 start() 里调过可省略
    //ansi_clear_screen();
   // ansi_goto_xy(1, 1);
   // printf("Screen cleared. Hello!\n");

    //printf_color(32, -1, 1, "Green & bold line\n"); // 绿色加粗
    //printf_color(31, 47, 0, "Red on White\n");      // 红字白底

    //ansi_goto_xy(5, 1);
    //printf("This line will be cleared partially...");
    //ansi_goto_xy(5, 20);
   // ansi_clear_eol();   // 从列20清到行尾

    //ansi_goto_xy(7, 1);
   // printf("Now clear whole line:\n");
    //ansi_clear_line();

    //for(;;) { __asm__ volatile("wfi"); }
//}
void main() {
    printf("Hello myOS! RISC-V single core console ready.\n");
   // test_printf_basic();
   // test_printf_edge_cases();
   // printf("All tests done.\n");
     
    ansi_clear_screen();
    ansi_goto_xy(1, 1);
   printf("Screen cleared. Hello!\n");
    printf_color(32, -1, 1, "Green & bold line\n"); // 绿色加粗
    printf_color(31, 47, 0, "Red on White\n");      // 红字白底

    ansi_goto_xy(5, 1);
    printf("This line will be cleared partially...");
    ansi_goto_xy(5, 20);
    ansi_clear_eol();   // 从列20清到行尾

    ansi_goto_xy(7, 1);
   printf("Now clear whole line:\n");
    ansi_clear_line();
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
//void main() {
    //uart_puts("Hello myOS!\n");
    //while (1) {}
//}