# 实验 3：页表与内存管理 (Memory Management)

## 1. 实验概述

本实验在 RISC-V 架构下实现了操作系统的内存管理子系统。主要包含两部分核心工作：

1.  **物理内存分配器 (Physical Memory Allocator)**：管理物理内存页的申请与释放。
2.  **虚拟内存管理 (Virtual Memory Management)**：基于 RISC-V Sv39 模式实现多级页表机制，建立内核地址空间的直接映射。

通过本实验，内核成功开启了 MMU（内存管理单元），实现了虚拟地址到物理地址的转换，为后续的进程管理打下基础。

## 2. 目录结构说明

本实验新增了内存管理相关的核心模块：

```text
.
├── Makefile             # 构建脚本
├── kernel.ld            # 链接脚本
├── include/             # [核心头文件]
│   ├── defs.h           # 内核函数声明 (新增 kalloc, vm 相关接口)
│   ├── memlayout.h      # 物理内存布局定义 (KERNBASE, PHYSTOP 等)
│   ├── riscv.h          # RISC-V 寄存器、页表项(PTE)格式、汇编宏
│   └── types.h          # 基础数据类型定义 (uint64, pte_t 等)
├── kernel/
│   ├── boot/            # [启动相关]
│   │   ├── entry.S      # 汇编入口
│   │   ├── start.c      # 机器模式初始化 (新增 kvminit 调用)
│   │   └── main.c       # 内核主函数
│   ├── mm/              # [内存管理核心] (本实验新增)
│   │   ├── kalloc.c     # 物理内存分配器 (kalloc/kfree)
│   │   └── vm.c         # 虚拟内存管理 (kvminit, mappages, walk)
│   ├── devs/            # [设备驱动]
│   │   ├── uart.c       # 串口驱动
│   │   ├── consloe.c    # 控制台处理
│   │   └── string.c     # 内存操作函数 (memset, memcpy)
│   └── lib/             # [通用库]
│       ├── printf.c     # 格式化输出
│       └── ansi.c       # ANSI 颜色控制
└── scripts/
    └── test_memory.c    # [测试代码] 物理内存与页表功能测试

```
## 3. 核心实现原理

### 3.1 物理内存管理 (kalloc.c)

- **管理策略**：采用**空闲链表法 (Free List)**。
- **内存范围**：管理从内核结束位置 (`end` 符号) 到物理内存顶端 (`PHYSTOP`) 的空间。
- **核心函数**：
  - `kinit()`: 初始化内存，将所有可用物理页通过 `kfree` 挂入空闲链表。
  - `kalloc()`: 从链表头取出一个空闲页，填充垃圾数据（如 `1`）以辅助调试，返回物理地址。
  - `kfree()`: 将物理页插入空闲链表头部。

### 3.2 虚拟内存与页表 (vm.c)

- **页表模式**：RISC-V Sv39（3 级页表，39 位虚拟地址）。
- **映射机制**：
  - `walk()`: 模拟硬件 MMU 的页表遍历过程，根据虚拟地址查找或创建对应的 PTE (Page Table Entry)。
  - `mappages()`: 建立一段虚拟地址区间到物理地址区间的映射，并设置权限（R/W/X）。
- **内核地址空间布局**： 采用了**恒等映射 (Identity Mapping)** 策略，即内核虚拟地址 = 物理地址。主要映射区域包括：
  - **UART 寄存器**: 读写权限，用于 I/O。
  - **内核代码段 (.text)**: 读/执行权限。
  - **内核数据段 (.data/.bss)**: 读/写权限。
  - **剩余物理内存**: 读/写权限，用于动态分配。

### 3.3 开启分页

在 `start.c` 中，通过以下步骤开启分页：

1. 调用 `kvminit()` 创建内核页表。
2. 调用 `kvminithart()` 将页表基地址写入 `satp` 寄存器，并执行 `sfence.vma` 刷新 TLB。

## 4. 测试与验证

### 测试脚本 (scripts/test_memory.c)

实验包含了一个综合测试模块 `test_memory.c`，主要验证点如下：

1. **物理页分配测试**: 连续申请和释放物理页，验证链表操作的正确性。
2. **地址对齐检查**: 确保分配的地址是 4KB 对齐的。
3. **读写测试**: 验证分配的内存是否可正常读写。
4. **映射验证**: 检查内核页表是否正确建立了虚拟地址到物理地址的映射。

### 编译与运行

使用以下命令编译并启动 QEMU：

```
make clean
make qemu
```

**预期输出**： 系统启动后，将依次初始化 UART、物理内存分配器和虚拟内存系统，并运行内存测试：

```
...
Starting qemu...
start() reached, hart0
Hello myOS! RISC-V single core console ready.
Before enabling paging...
After enabling paging...
ALL test is ok!
...
```

## 5. 关键数据结构

- **`struct run`**: 物理内存空闲链表的节点结构，直接存储在空闲物理页中。
- **`pagetable_t`**: 页表指针，实质上是一个 `uint64` 类型的物理地址。
- **`PTE_V, PTE_R, PTE_W, PTE_X`**: 页表项的标志位，分别代表有效、可读、可写、可执行。