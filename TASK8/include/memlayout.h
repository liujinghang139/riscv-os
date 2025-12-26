#ifndef MEMLAYOUT_H
#define MEMLAYOUT_H

#include"riscv.h"

// Physical memory layout

// qemu -machine virt is set up like this,
// based on qemu's hw/riscv/virt.c:
//
// 00001000 -- boot ROM, provided by qemu
// 02000000 -- CLINT
// 0C000000 -- PLIC
// 10000000 -- uart0 
// 10001000 -- virtio disk 
// 80000000 -- qemu's boot ROM loads the kernel here,
//             then jumps here.
// unused RAM after 80000000.

// the kernel uses physical memory thus:
// 80000000 -- entry.S, then kernel text and data
// end -- start of kernel page allocation area
// PHYSTOP -- end RAM used by the kernel

// qemu puts UART registers here in physical memory.
#define UART0 0x10000000L
#define UART0_IRQ 10

// virtio mmio interface
#define VIRTIO0 0x10001000L
#define VIRTIO0_IRQ 1

// qemu puts platform-level interrupt controller (PLIC) here.
#define PLIC 0x0c000000L              //查看qemu设备树得到
#define PLIC_PRIORITY (PLIC + 0x0)    //To be continued
#define PLIC_PENDING (PLIC + 0x1000)
#define PLIC_SENABLE(hart) (PLIC + 0x2080 + (hart)*0x100)
#define PLIC_SPRIORITY(hart) (PLIC + 0x201000 + (hart)*0x2000)
#define PLIC_SCLAIM(hart) (PLIC + 0x201004 + (hart)*0x2000)

#define KERNBASE 0x80000000L
#define PHYEND (KERNBASE + 128 * 1024 * 1024)

// map the trampoline page to the highest address,
// in both user and kernel space.
#define TRAMPOLINE (MAXVA - PGSIZE)

//  trampoline页存放在物理内存最大地址处
//  紧接着就是不同进程的kernelstack
//  为了kernelstack 溢出考虑，设置安全页--guard pages, 大小 1*PGSIZE
//  并且trampoline page 与 kernel stack 之间也有
#define KSTACK(i) (TRAMPOLINE - (i + 1)*2*PGSIZE)

#define TRAPFRAME (TRAMPOLINE - PGSIZE)
#endif