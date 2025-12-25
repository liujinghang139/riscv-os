# 实验 4：中断处理与时钟管理 (Interrupt Handling & Timer Management)

## 1. 实验概述

本实验在 RISC-V 操作系统内核中构建了完整的中断与异常处理框架。主要完成了以下核心功能：

1.  **中断向量表设置**：配置 `stvec` 寄存器，接管机器的中断与异常入口。
2.  **上下文保存与恢复**：在汇编层面实现通用寄存器的压栈保存与出栈恢复。
3.  **时钟中断驱动**：利用 SBI 接口设置硬件时钟，实现周期性的时钟中断（Timer Interrupt）。
4.  **异常分发机制**：根据 `scause` 寄存器判断中断类型（时钟中断、外部中断、软件中断或CPU异常），并分发给对应的处理函数。

通过本实验，内核具备了响应异步硬件事件的能力，为后续的进程调度（实验 5）提供了核心驱动力。

## 2. 目录结构说明

本实验新增与修改的核心模块如下：

```text
kernel/
├── trap/               # [新增] 中断处理核心模块
│   ├── trap.c          # C语言中断处理主逻辑 (kerneltrap, trapinit)
│   ├── timer.c         # 时钟中断管理 (timerinit, set_next_timeout)
│   └── defs.h          # 中断相关函数声明
├── boot/
│   ├── kernelvec.S     # [新增] 内核态中断入口汇编 (保存/恢复上下文)
│   └── start.c         # 修改：在启动流程中增加 trapinit() 和 timerinit()
└── scripts/
    └── test_trap.c     # [新增] 中断与异常功能测试代码
```

## 3. 核心实现原理

### 3.1 中断入口与上下文切换 (kernelvec.S)

- **入口 (`kernelvec`)**: 当中断发生时，硬件自动跳转到此地址。代码负责分配栈空间（`addi sp, sp, -256`），并保存所有通用寄存器（`sd ra, 0(sp)`, `sd sp, 8(sp)` ...）到内核栈中。
- **调用 C 处理函数**: 保存完上下文后，调用 `call kerneltrap` 进入 C 语言处理逻辑。
- **出口**: `kerneltrap` 返回后，恢复所有寄存器，缩减栈空间，最后执行 `sret` 指令返回中断发生点，恢复特权级和中断状态。

### 3.2 中断分发逻辑 (trap.c)

`kerneltrap()` 函数是中断处理的核心枢纽，主要流程如下：

1. **读取 `scause`**: 获取中断原因。
2. **判断类型**:
   - **时钟中断** (Scause bit 63=1, Exception Code=5): 调用 `timer_tick()` 更新系统时间，并设置下一次时钟中断。
   - **设备中断** (如 UART): 暂留接口或简单处理。
   - **CPU 异常** (如非法指令、地址未对齐): 打印错误信息并 Panic（内核态异常通常是致命的）。
3. **读取 `sepc`**: 保存异常发生时的程序计数器值，用于中断返回。

### 3.3 时钟管理 (timer.c)

- **初始化 (`timerinit`)**:
  - 开启 `sie` 寄存器的 `STIE` 位（Supervisor Timer Interrupt Enable）。
  - 调用 SBI 接口 `set_timer()` 设置第一次中断触发时间。
- **周期性触发**: 在每次时钟中断处理中，再次调用 `set_timer(r_time() + INTERVAL)`，从而形成周期性的“心跳”，这是操作系统实现时间片轮转调度的基础。

## 4. 编译与运行验证

### 编译运行

使用与之前相同的命令启动 QEMU：


```
make clean
make qemu
```

### 预期输出

系统启动后，你将看到时钟中断被触发的日志，以及 `test_trap` 的测试结果：


```

Testing timer interrupt...
Waiting for interrupt 1...
Waiting for interrupt 1...
Waiting for interrupt 1...
Waiting for interrupt 1...
Waiting for interrupt 1...
Waiting for interrupt 2...
Waiting for interrupt 2...
Waiting for interrupt 2...
Waiting for interrupt 2...
Waiting for interrupt 2...
Waiting for interrupt 3...
Waiting for interrupt 3...
Waiting for interrupt 3...
Waiting for interrupt 3...
Waiting for interrupt 3...
Waiting for interrupt 4...
Waiting for interrupt 4...
Waiting for interrupt 4...
Waiting for interrupt 4...
Waiting for interrupt 4...
Waiting for interrupt 5...
Waiting for interrupt 5...
Waiting for interrupt 5...
Waiting for interrupt 5...
Waiting for interrupt 5...
Timer test completed: 5 interrupts in 5124367 cycles

=== TEST: Exception Handling ===
Triggering supervisor ecall...
ecall handled.
Triggering illegal instruction...
Illegal instruction caught. Skipping instruction.
illegal instruction handled.
Tests finished. Interrupts disabled.
```

