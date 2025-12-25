# 实验 5：进程管理与调度 (Process Management & Scheduling)

## 1. 实验概述

本实验在 RISC-V 操作系统内核中构建了核心的进程管理子系统。实现了进程抽象（Process Control Block）、进程生命周期管理、上下文切换机制以及基于时间片轮转（Round-Robin）的 CPU 调度器。

通过本实验，内核从单一执行流进化为支持多任务并发执行的系统，能够创建、运行、挂起和销毁内核线程/进程。

## 2. 目录结构说明 (完整版)

本实验引入了进程管理模块，并更新了启动和中断流程以支持调度。

```text
.
├── Makefile             # 构建脚本
├── kernel.ld            # 链接脚本
├── include/             # [头文件]
│   ├── proc.h           # [新增] 进程结构体(struct proc)、上下文(struct context)定义
│   ├── spinlock.h       # [新增] 自旋锁定义，保护进程数据
│   ├── defs.h           # 函数声明 (新增 proc, swtch 相关接口)
│   ├── riscv.h          # 寄存器与汇编宏
│   ├── types.h          # 基础类型
│   ├── memlayout.h      # 内存布局
│   └── ...
├── kernel/
│   ├── boot/
│   │   ├── swtch.S      # [新增] 上下文切换汇编 (swtch函数)
│   │   ├── entry.S      # 异常入口
│   │   ├── start.c      # 启动流程
│   │   ├── main.c       # 内核主函数 (初始化进程子系统)
│   │   └── kernelvec.S  # 内核中断向量
│   ├── proc/            # [新增] 进程管理核心模块
│   │   ├── proc.c       # 进程创建(allocproc)、调度(scheduler)、休眠/唤醒
│   │   └── spinlock.c   # 自旋锁实现
│   ├── trap/
│   │   ├── trap.c       # 修改：时钟中断触发 yield()
│   │   └── timer.c      # 时钟驱动
│   ├── mm/              # 内存管理
│   │   ├── kalloc.c
│   │   └── vm.c
│   ├── devs/            # 设备驱动 (uart, console)
│   └── lib/             # 通用库 (printf, ansi)
└── scripts/
    └── test_process.c   # [新增] 进程调度与并发测试代码
```

## 3. 核心实现原理

### 3.1 进程抽象 (struct proc)

在 `include/proc.h` 中定义了 `struct proc`，包含以下关键字段：

- **`state`**: 进程状态 (UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE)。
- **`kstack`**: 内核栈的虚拟地址，每个进程独享一个内核栈。
- **`context`**:  调度上下文，保存了 `ra` (返回地址), `sp` (栈指针) 和 `s0-s11` (被调用者保存寄存器)。
- **`lock`**: 自旋锁，确保对进程状态修改的原子性。

### 3.2 上下文切换 (swtch.S)

实现了 `swtch(struct context *old, struct context *new)` 函数：

1. **保存旧上下文**: 将当前 CPU 寄存器（`ra`, `sp`, `s0-s11`）保存到 `old` 指向的内存结构中。
2. **加载新上下文**: 从 `new` 指向的内存结构中恢复寄存器。
3. **返回**: 执行 `ret` 指令，此时 `ra` 寄存器已被恢复为新进程上次挂起时的地址，从而“跳转”到新进程继续执行。

### 3.3 调度器 (Scheduler)

在 `kernel/proc/proc.c` 中实现了 `scheduler()` 函数：

- **策略**: 简单的轮转调度 (Round-Robin)。
- **流程**:
  1. CPU 启动后进入 `scheduler` 死循环。
  2. 遍历进程表 `proc[NPROC]`。
  3. 找到状态为 `RUNNABLE` 的进程。
  4. 将进程状态改为 `RUNNING`。
  5. 调用 `swtch(&c->context, &p->context)` 切换到该进程运行。
  6. 进程运行结束后（或被中断抢占），切回调度器线程，继续寻找下一个可运行进程。

### 3.4 抢占与让出

- **时钟中断**: 在 `kernel/trap/trap.c` 的时钟中断处理逻辑中，调用 `yield()`。
- **`yield()`**: 将当前 `RUNNING` 的进程状态改为 `RUNNABLE`，并调用 `swtch` 让出 CPU 给调度器。

## 4. 编译与运行验证

### 测试脚本 (scripts/test_process.c)

实验包含了综合测试模块，主要验证点：

1. **进程创建**: 验证 `allocproc` 能否正确分配 PCB 和内核栈。
2. **并发调度**: 创建多个计算密集型进程，观察它们是否正常调度，验证时间片轮转是否生效。
3. **锁机制**: 利用生产者-消费者场景，验证自旋锁是否能保护临界区。

### 编译运行

使用以下命令启动 QEMU：


```
make clean
make qemu
```

**预期输出**： 

```
Starting qemu...
start() reached, hart0
Hello myOS! RISC-V single core console ready.
System initialized. Starting scheduler...
--- Starting Experiment 5 Tests ---
Testing process creation...
Created 62 processes
Testing scheduler...
Scheduler test completed in 1647828 cycles
Synchronization test completed
--- All Tests Passed! ---
```

## 5. 关键数据结构

- **`NPROC`**: 系统支持的最大进程数（在 `param.h` 或 `proc.h` 中定义，通常为 64）。
- **`struct cpu`**: 记录当前 CPU 运行的进程指针及调度器上下文。