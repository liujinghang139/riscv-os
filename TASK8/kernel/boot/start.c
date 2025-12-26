#include"../../include/defs.h"
#include"../../include/riscv.h"
#include"../../include/types.h"

#define NCPU 1

void main();        //Define in main.c
void timer_init();
//Define stack0 for entry.S
char stack0[NCPU*4096];
void start(){ 
  //设置mstatus寄存器，以便mret
  unsigned int x = r_mstatus();
  x &= ~MSTATUS_MPP_MASK;
  x |= MSTATUS_MPP_S;
  w_mstatus(x);

  //禁止页转换
  w_satp(0);

  //中断处理后返回的地址，pc <- mepc
  w_mepc((uint64)main);

  //Machine mode设置委托
  w_medeleg(0xffff);
  w_mideleg(0xffff);
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);

  //允许Supervisor Mode查询所有的物理内存
  w_pmpaddr0(0x3fffffffffffffffull);
  w_pmpcfg0(0xf);

  timer_init();

  asm volatile("mret");

}

//时钟中断还需要xv6学习
void timer_init(){
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);

  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63));

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);

};