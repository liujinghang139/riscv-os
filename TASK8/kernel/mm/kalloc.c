#include"../../include/types.h"
#include"../../include/memlayout.h"
#include"../../include/riscv.h"
#include"../../include/defs.h"

extern char end[]; //Defined in kernel.ld

struct pgptr{
  struct pgptr *next;
};

struct {
  struct pgptr *header;
  struct spinlock lock;
  uint pages;       //空闲页数
} freelist;


void pmm_init(){
  init_lock(&freelist.lock, "kmem");
  freerange(end, (void *)PHYEND);
  printf("DEBUG: kinit finished. Free pages: %d\n", freelist.pages);
}


void freerange(void *pa_start, void *pa_end){
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p+=PGSIZE){
    free_page(p);
  }
}

void 
free_page(void *p){
  if((char *)p < end || (uint64)p > PHYEND || (uint64)p % PGSIZE !=0)
    panic("free_page()");

  memset(p, 0, PGSIZE);
  struct pgptr *pa = p;
  acquire(&freelist.lock);
  pa->next = freelist.header;
  freelist.header = pa;
  freelist.pages = freelist.pages + 1;
  release(&freelist.lock);
}

void *
alloc_page(){
  struct pgptr *pa;

  acquire(&freelist.lock);
  pa = freelist.header;
  //There should have a lock
  if(pa){
    freelist.header = pa->next;
    freelist.pages--;
  }
  release(&freelist.lock);
  return (void *)pa;
}

void *alloc_pages(int n){
  //空闲页列表中没有足够的页，分配失败
  if(freelist.pages < n)
    return 0;
  struct pgptr* pa = freelist.header;
  struct pgptr* p = pa;
  for(int i=0;i<n;i++){
    freelist.header = p->next;
    p = freelist.header;
    freelist.pages--;
  }
  return (void *)pa;
}