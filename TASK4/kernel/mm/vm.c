#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"
/*
内核的页表
*/
pagetable_t kernel_pagetable;

extern char etext[];  // kernel.ld sets this to end of kernel code.


pagetable_t kvmmake(){
  pagetable_t kpgtbl;
  kpgtbl = create_pagetable();

  // map kernel text executable and read-only.
  map_region(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);

  // map kernel data and the physical RAM we'll make use of.
  map_region(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP -(uint64)etext, PTE_R | PTE_W);
   // uart registers
  map_region(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);

  // virtio mmio disk interface
  map_region(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);

  // PLIC
  map_region(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);

  return kpgtbl;
}

void kvminit(){
  kernel_pagetable = kvmmake();
}

//激活页表，使得硬件开始使用虚拟地址
void kvminithart(){
  // 激活内核页表
    w_satp(MAKE_SATP(kernel_pagetable));
    sfence_vma();
}

// 内部辅助：遍历页表找到 va 对应的最末级（L0）PTE 地址。
// 若 alloc=1 且中间级缺失，则按页分配并清零（依赖单核版 alloc_page）。
 pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
  if (va >= MAXVA)
    panic("walk: va >= MAXVA");

  // Sv39 三级页表：从 L2 -> L1 -> L0
  for (int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      // 有效：跳到下一级页表
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc)
        return 0;
      // 分配一个新的中间页表页并清零（单核：无需加锁）
      pagetable_t newpt = (pagetable_t)alloc_page();
      if (newpt == 0)
        return 0;
      memset(newpt, 0, PGSIZE);
      // 将当前条目指向新页表，并标记有效
      *pte = PA2PTE(newpt) | PTE_V;
      pagetable = newpt;
    }
  }
  // 返回 L0 的 PTE 地址
  return &pagetable[PX(0, va)];
}

// 仅查找 PTE，不创建
static inline pte_t *
walk_lookup(pagetable_t pagetable, uint64 va)
{
  return walk(pagetable, va, 0);
}
void map_region(pagetable_t pt, uint64 va, uint64 pa, uint64 size, int perm) {
  if (map_page(pt, va, pa, size, perm) != 0) {
    panic("map_region(): map_page failed");
  }
}
// 创建一个空的顶级页表（单核：无需并发控制）
pagetable_t
create_pagetable(void)
{
  pagetable_t pagetable = (pagetable_t)alloc_page();
  if (pagetable == 0){
    panic("create_page(): alloc_page failed!");
    return 0;
  }
  memset(pagetable, 0, PGSIZE);
  return pagetable;
}
void destroy_pagetable(pagetable_t pt){
  if (!pt) return;
  free_page(pt);
}



// 在页表中创建从 [va, va+size) 到 [pa, pa+size) 的页粒度映射
// perm: 组合自 PTE_R/PTE_W/PTE_X/等标志（会额外或上 PTE_V）
int
map_page(pagetable_t pt, uint64 va, uint64 pa, uint64 size, int perm)
{
  if (size == 0) {
    panic("map_page(): size == 0");
  }
  if (size % PGSIZE != 0) {
    panic("map_page(): size is not page-aligned");
  }
  if (va % PGSIZE != 0) {
    panic("map_page(): va is not page-aligned");
  }
  if (pa % PGSIZE != 0) {
    panic("map_page(): pa is not page-aligned");
  }

  uint64 map_end = va + size - PGSIZE; // 最后一页的起始地址
  for (;;) {
    pte_t *pte = walk(pt, va, 1);
    if (!pte) {
      // walk 在尝试分配中间页失败时返回 NULL
      return -1;
    }
    if (*pte & PTE_V) {
      // 已有映射冲突：此处视为致命错误（内核启动映射阶段通常不允许覆盖）
      panic("map_page(): PTE already valid (mapping conflict)");
    }
    *pte = PA2PTE(pa) | PTE_V | (uint64)perm;

    if (va == map_end)
      break;
    va += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
