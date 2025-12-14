#ifndef __RISCV_H__
#define __RISCV_H__

#include "types.h"


#define MSTATUS_MPP_MASK (3L << 11) // mask for Previous mode
#define MSTATUS_MPP_M (3L << 11)    // machine mode
#define MSTATUS_MPP_S (1L << 11)    // supervisor mode
#define MSTATUS_MPP_U (0L << 11)    // user mode
#define MSTATUS_MIE (1L << 3)       // machine-mode interrupt enable
#define SSTATUS_SIE  (1L << 1)  // Supervisor Interrupt Enable (全局中断使能)
#define SSTATUS_SPIE (1L << 5)  // Supervisor Previous Interrupt Enable (保存之前的中断状态)
#define SSTATUS_SPP  (1L << 8)  // Supervisor Previous Privilege (保存之前的特权级: User/Supervisor)
#define SIE_SSIE (1L << 1) // 软件中断
#define SIE_STIE (1L << 5) // 时钟中断
#define SIE_SEIE (1L << 9) // 外部中断
// --- Machine Mode (M模式) 专用寄存器操作 ---

// 1. Machine Interrupt Delegation (中断委托)
// 决定哪些中断交给 S 模式处理
static inline uint64 r_mideleg() {
    uint64 x;
    asm volatile("csrr %0, mideleg" : "=r" (x));
    return x;
}

static inline void w_mideleg(uint64 x) {
    asm volatile("csrw mideleg, %0" : : "r" (x));
}

// 2. Machine Exception Delegation (异常委托)
// 决定哪些异常（如缺页、非法指令）交给 S 模式处理 [cite: 789]
static inline uint64 r_medeleg() {
    uint64 x;
    asm volatile("csrr %0, medeleg" : "=r" (x));
    return x;
}

static inline void w_medeleg(uint64 x) {
    asm volatile("csrw medeleg, %0" : : "r" (x));
}

// 3. Machine Status (M模式状态寄存器)
static inline uint64 r_mstatus() {
    uint64 x;
    asm volatile("csrr %0, mstatus" : "=r" (x));
    return x;
}

static inline void w_mstatus(uint64 x) {
    asm volatile("csrw mstatus, %0" : : "r" (x));
}

// 4. Machine Exception Program Counter (M模式异常PC)
static inline void w_mepc(uint64 x) {
    asm volatile("csrw mepc, %0" : : "r" (x));
}

// 5. Machine Trap Vector (M模式中断向量基址)
static inline void w_mtvec(uint64 x) {
    asm volatile("csrw mtvec, %0" : : "r" (x));
}

// 6. Physical Memory Protection (PMP 配置 - 可选但推荐)
// 允许 S 模式访问所有内存，否则 S 模式连代码都跑不了
static inline void w_pmpaddr0(uint64 x) {
    asm volatile("csrw pmpaddr0, %0" : : "r" (x));
}
static inline void w_pmpcfg0(uint64 x) {
    asm volatile("csrw pmpcfg0, %0" : : "r" (x));
}
// Machine Counter-Enable (控制 S 模式是否能访问 time 等计数器)
static inline void w_mcounteren(uint64 x) {
    asm volatile("csrw mcounteren, %0" : : "r" (x));
}
static inline uint64 r_stimecmp(){
  uint64 x;
  asm volatile("csrr %0, stmecmp": "=r" (x));
  return x;
}

static inline uint64 r_mcounteren() {
    uint64 x;
    asm volatile("csrr %0, mcounteren" : "=r" (x));
    return x;
}
// 2. menvcfg (Machine Environment Configuration)
// M 模式用它来开启 Sstc 功能 (STCE 位)
static inline uint64 r_menvcfg() {
    uint64 x;
    asm volatile("csrr %0, menvcfg" : "=r" (x));
    return x;
}

static inline void w_menvcfg(uint64 x) {
    asm volatile("csrw menvcfg, %0" : : "r" (x));
}
//s模式
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
// 1. 中断向量基址寄存器 (Supervisor Trap Vector Base Address)
// 告诉 CPU 中断发生时跳到哪里去执行代码
static inline void w_stvec(uint64 x) {
    asm volatile("csrw stvec, %0" : : "r" (x));
}

static inline uint64 r_stvec() {
    uint64 x;
    asm volatile("csrr %0, stvec" : "=r" (x));
    return x;
}

// 2. 中断使能寄存器 (Supervisor Interrupt Enable)
// 控制是否开启具体的某类中断（如时钟中断、软件中断）
static inline uint64 r_sie() {
    uint64 x;
    asm volatile("csrr %0, sie" : "=r" (x));
    return x;
}

static inline void w_sie(uint64 x) {
    asm volatile("csrw sie, %0" : : "r" (x));
}

// 3. 异常程序计数器 (Supervisor Exception Program Counter)
// 记录发生中断/异常时，原本正在执行的那条指令地址（以便恢复）
static inline uint64 r_sepc() {
    uint64 x;
    asm volatile("csrr %0, sepc" : "=r" (x));
    return x;
}

static inline void w_sepc(uint64 x) {
    asm volatile("csrw sepc, %0" : : "r" (x));
}
// 读取 scause
// 4. 中断原因寄存器 (Supervisor Cause Register)
// 告诉我们要么发生了什么事（是时钟中断？还是缺页异常？）
static inline uint64 r_scause() {
  uint64 x;
  asm volatile("csrr %0, scause" : "=r" (x) );
  return x;
}

// 读取 stval (发生异常的地址)
// 5. 异常值寄存器 (Supervisor Trap Value)
// 比如发生缺页异常时，这里存的是那个导致缺页的虚拟地址
static inline uint64 r_stval() {
  uint64 x;
  asm volatile("csrr %0, stval" : "=r" (x) );
  return x;
}
static inline void w_stimecmp(uint64 x){
  asm volatile("csrw stimecmp, %0": :"r" (x));
}
// 开启中断
static inline void intr_on() {
  w_sstatus(r_sstatus() | SSTATUS_SIE);
}

// 关闭中断
static inline void intr_off() {
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
}
// [新增] 检查中断是否开启
// 返回 1 表示开启，0 表示关闭
static inline int intr_get() {
  uint64 x = r_sstatus();
  return (x & SSTATUS_SIE) != 0;
}




// Supervisor Address Translation and Protection (satp) register
// Sv39 mode is indicated by setting MODE to 8. [cite: 418]
#define SATP_SV39 (8L << 60)

#define MAKE_SATP(pagetable) (SATP_SV39 | (((uint64)pagetable) >> 12))
static inline uint64
r_satp(void)
{
  uint64 x;
  asm volatile("csrr %0, satp" : "=r" (x) );
  return x;
}
// supervisor address translation and protection;
// holds the address of the page table.
static inline void
w_satp(uint64 x)
{
  // csrw: Control and Status Register Write (写控制状态寄存器)
  // satp: 目标寄存器名字
  // %0:   占位符，对应后面的输入参数 x
  // "r"(x): 告诉编译器把变量 x 的值放到一个通用寄存器中传给汇编
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