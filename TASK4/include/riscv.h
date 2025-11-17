#ifndef __RISCV_H__
#define __RISCV_H__

#include "types.h"

//
// an inline function to write to a control and status register.
//
static inline void
w_sstatus(uint64 x)
{
  asm volatile("csrw sstatus, %0" : : "r" (x));
}

//
// an inline function to read a control and status register.
//
static inline uint64
r_sstatus(void)
{
  uint64 x;
  asm volatile("csrr %0, sstatus" : "=r" (x) );
  return x;
}

// supervisor interrupt enable register.
#define SIE_SEIE (1L << 9) // external
#define SIE_STIE (1L << 5) // timer
#define SIE_SSIE (1L << 1) // software
static inline void
w_sie(uint64 x)
{
  asm volatile("csrw sie, %0" : : "r" (x));
}

// Supervisor Address Translation and Protection (satp) register
// Sv39 mode is indicated by setting MODE to 8. [cite: 418]
#define SATP_SV39 (8L << 60)

#define MAKE_SATP(pagetable) (SATP_SV39 | (((uint64)pagetable) >> 12))

// supervisor address translation and protection;
// holds the address of the page table.
static inline void
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
}

// flush the TLB.
static inline void
sfence_vma(void)
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
}
typedef uint64 pte_t;
typedef uint64 *pagetable_t;
//
// Page table definitions for Sv39.
//
#define PGSIZE 4096 // bytes per page
#define PGSHIFT 12  // bits of offset within a page

// Aligns a size up to the nearest page boundary. [cite: 414]
#define PGROUNDUP(sz)  (((sz)+PGSIZE-1) & ~(PGSIZE-1))
// Aligns an address down to the nearest page boundary. [cite: 414]
#define PGROUNDDOWN(a) (((a)) & ~(PGSIZE-1))

// Page Table Entry (PTE) flags. 
#define PTE_V (1L << 0) // valid 
#define PTE_R (1L << 1) // read 
#define PTE_W (1L << 2) // write 
#define PTE_X (1L << 3) // execute 
#define PTE_U (1L << 4) // user can access 

// Shift for extracting physical page number (PPN) from PTE
#define PTE_SHIFT 10

// 从 PTE 中提取物理地址 (PPN << 12)
#define PTE2PA(pte) (((pte) >> PTE_SHIFT) << 12)

// 将物理地址转换为 PTE (PPN << 10)
#define PA2PTE(pa) ((((uint64)pa) >> 12) << PTE_SHIFT)

// 提取 PTE 权限位/标志位
#define PTE_FLAGS(pte) ((pte) & 0x3FF)

// Sv39 virtual address structure. [cite: 409]
// 9 bits for each level of page table index. [cite: 409]
//根据 level 和虚拟地址 va 计算页表索引（Sv39：level=2,1,0）
#define PXMASK 0x1FF // 9 bits
#define PXSHIFT(level) (PGSHIFT + (9 * (level)))
#define PX(level, va) ((((uint64) (va)) >> PXSHIFT(level)) & PXMASK)

// one beyond the highest possible virtual address.
// MAXVA is actually one bit less than the max allowed by
// Sv39, to avoid crossing into kernel space.
#define MAXVA (1L << (9 + 9 + 9 + 12 - 1))

#endif // __RISCV_H__