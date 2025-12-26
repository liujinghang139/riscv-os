// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"
// 外部符号，由链接脚本 kernel.ld 定义，表示内核代码的结束地址
extern char end[]; 

// 空闲页链表的节点结构
struct run {
  struct run *next;
};

// 物理内存管理器：单核场景下只需要维护空闲链表头指针
struct {
  struct run *freelist;
  uint       pages;  //空闲页数
} pmm; // Physical Memory Manager

static void freerange(void *pa_start, void *pa_end);
void free_page(void *pa);

// 初始化物理内存管理器（单核：无需锁）
void
pmm_init(void)
{
  pmm.freelist = 0;
  pmm.pages    = 0;
  // 将从内核结束到 PHYSTOP 的物理内存范围加入到空闲链表中
  freerange(end, (void*)PHYSTOP);
}

// 将一段物理地址范围 [pa_start, pa_end) 按页加入到空闲链表中
static void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  // 将起始地址向上对齐到页边界
  p = (char*)PGROUNDUP((uint64)pa_start);
  for (; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    free_page(p);
}

// 释放一个物理页
// pa: 指向要释放的物理页的起始地址
void
free_page(void *pa)
{
  struct run *r;

  // --- 基本的错误检查 ---
  // 1. 地址是否页对齐
  // 2. 地址是否在内核代码之后
  // 3. 地址是否在物理内存顶部之下
  if (((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("free_page");

  // 将要释放的页填充为特殊值，便于调试悬空指针 (dangling references)
  memset(pa, 1, PGSIZE);//毒化。

  // 将该页转换为 struct run* 类型，并加入空闲链表头部（单核：无需锁）
  r = (struct run*)pa;
  r->next = pmm.freelist;
  pmm.freelist = r;
    pmm.pages++;
}

// 分配一个 4096 字节的物理页
// 返回值: 成功则返回物理页的指针，失败则返回 0
void *
alloc_page(void)
{
  struct run *r;

  // --- 从空闲链表头部取出一个页（单核：无需锁）---
  r = pmm.freelist;
  if (r){
    pmm.freelist = r->next;
    pmm.pages--;
     // 将分配的页填充为特殊值，便于调试
    //memset((char*)r, 5, PGSIZE);
  }
  
    

  return (void*)r;
}
