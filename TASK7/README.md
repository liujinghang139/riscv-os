# 实验 7：文件系统 (File System)

# 1.实验概述

本实验在 RISC-V 操作系统内核中实现了一个基于磁盘的、支持日志功能的简易文件系统。通过本实验，操作系统从仅支持内存任务管理进化为具备持久化存储能力的系统。

主要完成的工作包括：

1. 底层驱动：实现了 virtio_disk 驱动，使内核能够读写 QEMU 的模拟磁盘设备。
2. 缓冲区缓存 (Buffer Cache)：实现了基于 LRU (Least Recently Used) 算法的块缓存层 (bio.c)，以减少磁盘 I/O 开销。
3. 日志系统 (Logging)：实现了预写式日志 (Write-Ahead Logging) 机制 (log.c)，保证文件系统操作（如创建文件）的原子性和崩溃一致性。
4. 文件系统核心：实现了 Inode 管理、位图分配、目录操作和路径解析 (fs.c)。
5. 系统调用：新增了 open, read, write, close, mkdir, unlink 等文件操作相关的系统调用。
6. 文件系统制作工具：编写了主机端工具 mkfs，用于生成包含初始文件的磁盘镜像 fs.img。

# 2.目录结构说明

本实验重点新增了 kernel/fs 目录及相关驱动和测试代码。

```text

├── Makefile                # 构建脚本 (新增 fs.img 和 mkfs 的构建规则)
├── fs.img                  # [生成] 文件系统磁盘镜像
├── mkfs/                   # [新增] 主机端文件系统制作工具
│   └── mkfs.c              # 用于创建 fs.img 并写入初始文件 (如 README)
├── kernel/
│   ├── devs/
│   │   ├── virtio_disk.c   # [新增] VirtIO 磁盘驱动
│   │   └── plic.c          # [新增] PLIC 中断控制器 (处理磁盘中断)
│   ├── fs/                 # [新增] 文件系统核心代码
│   │   ├── bio.c           # Buffer Cache (缓存层)
│   │   ├── log.c           # 日志系统 (事务层)
│   │   ├── fs.c            # Inode、目录、位图管理
│   │   ├── file.c          # 文件描述符与文件结构层
│   │   └── exec.c          # (可选) ELF 文件加载执行
│   ├── trap/
│   │   ├── sysfile.c       # [新增] 文件系统相关系统调用实现 (sys_open, sys_write...)
│   │   └── ...
│   └── boot/main.c         # 修改：增加了文件系统各模块的初始化调用
├── scripts/
│   └── test_wenjian.c      # [新增] 文件系统综合测试程序 (用户态)
└── user/                   # 用户态库
    └── ulib.c              # 包含 open, write 等库函数封装
```
# 3.核心功能实现

## 3.1 磁盘驱动与缓存

VirtIO Disk: 使用内存映射 I/O (MMIO) 与 QEMU 的虚拟磁盘设备交互，支持扇区读写。

Buffer Cache: 维护一个双向链表，缓存最近使用的磁盘块。实现了块锁 (sleeplock)，支持多进程并发访问时的同步。

## 3.2 日志与崩溃恢复

事务机制: 文件系统操作（如 sys_write）被封装在 begin_op() 和 end_op() 之间。

Group Commit: 支持多个系统调用的修改合并提交，提高性能。

崩溃恢复: 系统启动时会自动检查日志区，回放已提交但未写入磁盘数据区的操作，确保数据完整性。

## 3.3 目录与路径

支持类似 UNIX 的层级目录结构。

实现了 namei 函数，用于解析如 /home/user/file 这样的路径字符串并定位对应的 Inode。

# 4.编译与运行

- **环境依赖**
  QEMU 模拟器 (qemu-system-riscv64)
- RISC-V 工具链 (riscv64-unknown-elf-gcc)

**编译与启动**
使用 make 命令即可自动编译内核、编译 mkfs 工具、制作 fs.img 并启动 QEMU。

# 5.测试说明

系统启动后，init 进程会自动加载并运行测试程序 test_wenjian（源文件 scripts/test_wenjian.c）。该测试包含四个阶段：

## 5.1 完整性测试 (Integrity Test)

- **内容**: 创建文件 -> 写入数据 -> 关闭 -> 重新打开 -> 读取数据 -> 校验内容 -> 删除文件。
- **预期**: 输出 Filesystem integrity test passed。

## 5.2 并发访问测试 (Concurrent Access)

- **内容**: 父进程 fork 出 4 个子进程，同时对文件系统进行频繁的创建、写入和删除操作。
- **目的**: 验证 Buffer Cache 的锁机制和日志系统的并发处理能力。
- **预期**: 输出 Concurrent access test completed。

## 5.3 性能测试 (Performance Test)

- **内容**: 批量创建并写入 100 个小文件。
- **输出**: 显示操作消耗的时钟周期数 (Files (100x4B): X ticks)。

## 5.4 崩溃恢复测试 (Crash Recovery)

这是一个两阶段测试，用于验证日志系统的可靠性：

**阶段一 (崩溃演示)**:

- 测试程序创建一个名为 crash_file 的文件。
- 调用自定义系统调用 crash_arm() 通知内核“准备崩溃”。
- 执行 write 操作。内核在日志提交后、数据写入磁盘前触发 panic (模拟断电)。
- 现象: QEMU 会突然退出或停止，这是正常现象。

**阶段二 (恢复验证)**:

- 你需要再次执行 make qemu 重启系统。
- 系统启动时，init_log 会检测到日志区有未完成的数据，并执行重放 (Replay)。
- 测试程序再次运行，检测到 crash_file 存在且内容正确。
- 预期: 输出 [PASS] Data persisted after crash!。

