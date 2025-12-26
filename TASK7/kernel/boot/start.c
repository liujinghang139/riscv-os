#include <stdint.h>
#include "types.h"
#include "../../include/riscv.h"
#include "defs.h"

extern void uart_puts(const char *s);
extern void main();

#define NCPU 1
char stack0[NCPU*4096];


void start(void){
  consoleinit();    
  printf("start() reached, hart0\n"); 
  // 1. 委托中断和异常给 S 模式
  w_mideleg(0xffff);
  // 2. 将所有异常委托给 S 模式
  w_medeleg(0xffff & ~(1L << 9));
   

  //允许 S 模式访问时钟寄存器 (sie)
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
  // 只有开启这个，S 模式才能访问 stimecmp 寄存器
  w_menvcfg(r_menvcfg() | (1L << 63));
  w_mcounteren(0xffffffff);
  //  配置 PMP 以允许 S 模式访问物理内存 (非常重要！)
  w_pmpaddr0(0x3fffffffffffffull);
  w_pmpcfg0(0xf);
  // 准备从 M 模式 切换到 S 模式
  // 设置 mstatus 寄存器：
  // MPP (Previous Mode) = Supervisor (01)
  // MPIE (Previous Interrupt Enable) = 1 (S 模式下中断开启)
  unsigned long x = r_mstatus();
  x &= ~MSTATUS_MPP_MASK;
  x |=(MSTATUS_MPP_S); 
  w_mstatus(x);
 
  //main();
  //设置 S 模式入口点
  // 当执行 mret 指令时，PC 会跳到 main 函数
  w_mepc((uint64)main);

  // 设置页表为 0 (Bare 模式)，禁用虚拟内存
  // 在 main 函数中会重新设置 satp 开启分页
  w_satp(0);

  // 切换到 S 模式并跳转到 main
  asm volatile("mret");
  //dead loop
  for(;;){
    asm volatile("wfi");
  }

}
