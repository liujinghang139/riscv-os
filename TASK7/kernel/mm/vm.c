#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"
/*
内核的页表
*/
pagetable_t kernel_pagetable;

extern char etext[];  // kernel.ld sets this to end of kernel code.
//extern char trampoline[];

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
  // [新增] 映射 Trampoline 到虚拟地址最高处
  // 这里的 TRAMPOLINE 宏定义在 memlayout.h，物理地址是汇编代码的地址
  map_region(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
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


// 复制父进程的页表和内存给子进程 (用于 fork) [cite: 1122]
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walk(old, i, 0)) == 0) panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0) panic("uvmcopy: page not present");
    
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);

    if((mem = alloc_page()) == 0) goto err;
    
    memcpy(mem, (char*)pa, PGSIZE); // 复制物理页内容

    if(map_page(new, i, (uint64)mem, PGSIZE, flags) != 0){
      free_page(mem);
      goto err;
    }
  }
  return 0;

 err:
  // 需实现 uvmunmap 释放已分配的页，这里简化为 panic
  panic("uvmcopy: failed");
  return -1;
}

// 从用户空间 srcva 复制 len 字节到内核 dst [cite: 1504]
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    va0 = PGROUNDDOWN(srcva);
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
      return -1;
    
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (srcva - va0);
    if(n > len) n = len;
    
    memcpy(dst, (void *)(pa0 + (srcva - va0)), n);

    len -= n;
    dst += n;
    srcva = va0 + PGSIZE;
  }
  return 0;
}
// kernel/mm/vm.c

// 将内核空间 src 开始的 len 字节数据，拷贝到用户空间 dstva
// 需要查询用户页表 pagetable 以获取对应的物理地址
// 成功返回 0，失败返回 -1
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    va0 = PGROUNDDOWN(dstva);
    pte = walk(pagetable, va0, 0); // 查找页表项
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
      return -1; // 用户地址无效或无权限
    
    pa0 = PTE2PA(*pte); // 获取物理页地址
    n = PGSIZE - (dstva - va0); // 当前页剩余可写字节数
    if(n > len)
      n = len;
    
    // 直接拷贝到物理内存
    memcpy((void *)(pa0 + (dstva - va0)), src, n);

    len -= n;
    src += n;
    dstva = va0 + PGSIZE; // 移动到下一页
  }
  return 0;
}
// 创建一个空的用户页表
// 必须映射 Trampoline，否则用户程序陷入内核时会崩溃
pagetable_t uvmcreate() {
  pagetable_t pagetable;
  
  // 1. 分配页表页
  pagetable = create_pagetable();
  if(pagetable == 0) return 0;

  // 2. 【关键】将 Trampoline 映射到用户地址空间的最高处
  // TRAMPOLINE 是虚拟地址 (定义在 memlayout.h)
  // trampoline 是物理地址 (符号地址)
  if(map_page(pagetable, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X) < 0){
    free_page(pagetable);
    return 0;
  }
  
  return pagetable;
}
// 加载 init 进程的二进制代码到用户页表
// 这里的 init 就是 test_bin 数组，sz 是长度
// kernel/mm/vm.c

void uvminit(pagetable_t pagetable, uchar *init, uint sz) {
  char *mem;
  uint64 i;

  // 循环加载：每次处理一页 (PGSIZE = 4096)
  for(i = 0; i < sz; i += PGSIZE){
    // 1. 分配一页物理内存
    mem = (char*)alloc_page(); // 或者 kalloc()
    if(mem == 0)
      panic("uvminit: out of memory");
    
    // 2. 清零
    memset(mem, 0, PGSIZE);
    
    // 3. 映射到对应的虚拟地址 (i)
    // 第一页映射到 0，第二页映射到 4096，以此类推
   if(map_page(pagetable, i, (uint64)mem, PGSIZE, PTE_W|PTE_R|PTE_X|PTE_U) < 0) {
      panic("uvminit: map_page failed");
    }
    
    // 4. 拷贝数据
    // 计算这一页要拷多少字节 (最后一页可能不满 4096)
    int n = PGSIZE;
    if(i + n > sz)
      n = sz - i;
      
    memmove(mem, init + i, n);
  }
}
void 
uvm_unmap(pagetable_t pagetable, uint64 va, int npages, int dofree){
  pte_t *pte;
  uint64 a;
  if((va % PGSIZE) != 0)
    panic("uvm_unmap(): va is not aligned!");

  for(a = va;a < (va + PGSIZE * npages);a += PGSIZE){
    //此页表项本身不存在
    if((pte = walk(pagetable, a, 0)) == 0)
      continue;
    //此页表项无效
    if((*pte & PTE_V) == 0)
      continue;

    if(dofree){
      //清除页表项所指的物理页
      uint64 pa = PTE2PA(*pte);
      free_page((void *)pa);
    }
    *pte = 0;     //清除页表项的内容

  }
}

//  清除用户页表中除了叶子页表的其他PTE
void 
freewalk(pagetable_t pagetable){
  //  一个页表 4096B, 一个PTE 64bit --> 8B
  //  算得一个页表能够装 2^9 个PTE
  for(int i=0;i < 512;i++){
    pte_t pte = pagetable[i];
    //  注意 && 和 == 的优先性
    if((pte & PTE_V) && (pte & (PTE_W|PTE_X|PTE_R)) == 0){
      // 指向下一级页表，递归释放
      pagetable_t child_page = (pagetable_t)PTE2PA(pte);
      freewalk(child_page);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    }
  }
  //  释放当前页表页，必须在遍历完所有子页表后执行一次
  free_page((void *)pagetable);
}

uint64
uvm_dealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  if(newsz >= oldsz)
    return oldsz;

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvm_unmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}

void
uvm_clear(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
  if(pte == 0)
    panic("uvmclear");
  *pte &= ~PTE_U;
}

uint64
uvm_alloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm)
{
  char *mem;
  uint64 a;

  if(newsz < oldsz)
    return oldsz;

  oldsz = PGROUNDUP(oldsz);
  for(a = oldsz; a < newsz; a += PGSIZE){
    mem = alloc_page();
    if(mem == 0){
      uvm_dealloc(pagetable, a, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(map_page(pagetable, a, (uint64)mem, PGSIZE,  PTE_R|PTE_U|xperm) != 0){
      free_page(mem);
      uvm_dealloc(pagetable, a, oldsz);
      return 0;
    }
  }
  return newsz;
}



//  先选择性的清除用户页内存
//  再清除页表中的内容
void 
uvm_free(pagetable_t pagetable, uint64 sz){
  if(sz > 0){
    //  调用uvm_unmap()将用户页的内存清除
    uvm_unmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  }
  freewalk(pagetable);
}

uint64
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    return 0;

  pte = walk(pagetable, va, 0);
  if(pte == 0)
    return 0;
  if((*pte & PTE_V) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}