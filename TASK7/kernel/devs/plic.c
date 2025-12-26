#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "../../include/memlayout.h"

void plic_init(void) {
  // 设置需要的优先级（这里是 Virtio IRQ = 1）
   *(uint32*)(PLIC + UART0_IRQ*4) = 1;
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
}

void plic_inithart(void) {
  int hart = 0; // 单核
  // 开启 S 模式下的 IRQ 1 (Virtio) 和 IRQ 10 (UART)
  *(uint32*)PLIC_SENABLE(hart) = (1 << 1) | (1 << 10);
  // 设置 S 模式的优先级阈值
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
}

// 询问 PLIC 哪个中断发生了
int plic_claim(void) {
  int hart = 0;
  int irq = *(uint32*)PLIC_SCLAIM(hart);
  return irq;
}

// 告诉 PLIC 中断处理完毕
void plic_complete(int irq) {
  
  *(uint32*)PLIC_SCLAIM(0) = irq;
}