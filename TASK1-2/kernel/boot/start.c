#include <stdint.h>
#include "defs.h"
extern void uart_puts(const char *s);
extern void main();

#define NCPU 1
char stack0[NCPU*4096];



void start(void){
  consoleinit();    
  printf("start() reached, hart0\n"); 
  //Print simple words
  //uart_puts define in uart.c
  //uart_puts("start() reached\n");
  main();
  //dead loop
  for(;;){
    asm volatile("wfi");
  }

}
