# 实验 1：RISC-V 引导与裸机启动

## 1. 实验概述

本实验旨在实现一个最小的 RISC-V 操作系统内核引导程序。通过编写汇编启动代码和链接脚本，建立 C 语言运行环境（设置栈、清零 BSS），并实现基于 UART（通用异步收发传输器）的最基础串口输出功能，最终在 QEMU 模拟器中成功运行并打印启动信息。

## 2. 目录结构说明

```text
.
├── kernel.ld           # 链接脚本：定义内存布局，代码段起始于 0x80000000
├── Makefile            # 自动化构建脚本：编译、链接及 QEMU 启动指令
├── kernel/
│   ├── boot/
│   │   ├── entry.S     # 系统入口汇编：设置栈指针，清零 BSS，跳转 C 代码
│   │   ├── start.c     # 机器模式初始化：初始化控制台，跳转 main
│   │   └── main.c      # 内核主函数 (本阶段用于测试 UART)
│   └── devs/
│       └── uart.c      # UART 16550A 驱动：底层字符输入输出实现
```

## 3. 核心实现原理

### 3.1 内存布局与链接 (kernel.ld)

- **入口点**: 指定 `_entry` 为程序入口。
- **基地址**: 代码段 (`.text`) 加载到 QEMU 默认的物理地址 `0x80000000`。
- **段对齐**: 保持 `.text`, `.data`, `.bss` 等段的 16 字节对齐。

### 3.2 启动汇编 (entry.S)

- **栈设置**: 加载 `stack0`（在 C 代码中定义的数组）的地址到 `sp` 寄存器，并加上 4KB 偏移（栈向下生长），为 C 语言函数调用提供栈空间。
- **BSS 清零**: 遍历 `_sbss` 到 `_ebss` 的内存区域并填充 0，确保未初始化的全局变量处于正确状态。
- **跳转**: 使用 `call start` 跳转到 C 语言入口。

### 3.3 串口驱动 (uart.c)

- 采用 **轮询 (Polling)** 方式实现基础 I/O。
- **uart_putc**: 检查 LSR 寄存器的 THRE 位，等待发送缓冲区为空后写入字符。
- **uart_puts**: 封装 `uart_putc` 实现字符串输出，并处理换行符 (`\n` -> `\r\n`)。

## 4. 编译与运行

### 环境要求

- 工具链: `riscv64-unknown-elf-gcc`
- 模拟器: `qemu-system-riscv64`

### 操作步骤

1. **编译内核**:

   ```
   make all
   ```

   这将生成 `kernel.elf` 和 `kernel.bin`。

2. **运行 QEMU**:

   ```
   make qemu
   ```

   预期输出：

   ```
   start() reached, hart0
   Hello myOS! RISC-V single core console ready.
   ...
   ```
   真实输出：
   ![alt text](image.png)

3. **调试模式**:

   ```
   make qemu-gdb  # 在一个终端运行 (等待连接)
   make gdb       # 在另一个终端运行 (自动连接并加载符号)
   ```

