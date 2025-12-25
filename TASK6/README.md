# 实验 6：系统调用 (System Calls)

## 1. 实验概述

本实验旨在实现操作系统中最关键的接口——系统调用。通过利用 RISC-V 的 `ecall` 指令，建立用户程序请求内核服务的机制。实验内容涵盖了：

1.  **异常处理扩展**：在 `trap` 处理逻辑中识别并处理用户态系统调用请求。
2.  **系统调用分发**：实现 `syscall()` 分发器，解析系统调用号并执行对应内核函数。
3.  **基础系统调用实现**：实现了 `write` (输出)、`getpid` (获取进程ID)、`exit` (进程退出) 等基础服务。
4.  **用户态库 (User Library)**：构建了 `ulib.c` 和 `usys.S`，为用户程序提供类似 C 标准库的封装接口。

## 2. 目录结构说明 (完整版)

本实验新增了用户态支持目录 `user/` 以及内核中处理系统调用的模块。

```text
.
├── Makefile             # 构建脚本 (新增用户程序编译规则)
├── kernel.ld            # 内核链接脚本
├── include/             # [头文件]
│   ├── syscall.h        # [新增] 系统调用号定义 (SYS_write, SYS_exit 等)
│   ├── proc.h           # 进程结构体 (需包含 trapframe 指针)
│   └── ...
├── kernel/
│   ├── trap/
│   │   ├── syscall.c    # [新增] 系统调用分发器 (syscall 函数)
│   │   ├── sysproc.c    # [新增] 具体系统调用实现 (sys_getpid, sys_exit)
│   │   ├── trap.c       # 修改：增加对 scause=8 (User Ecall) 的处理
│   │   └── trampoline.S # 用户态/内核态切换跳板
│   ├── boot/            # 启动代码
│   ├── proc/            # 进程管理
│   └── mm/              # 内存管理
├── user/                # [新增] 用户态支持库与测试程序
│   ├── user.h           # 用户态头文件 (函数声明)
│   ├── usys.S           # 系统调用汇编封装 (ecall 指令封装)
│   ├── ulib.c           # 用户态基础库 (如 printf, strcpy)
│   └── user.ld          # 用户程序链接脚本
└── scripts/
    └── test_syscall.c   # [新增] 系统调用功能测试
```

## 3. 核心实现原理

### 3.1 用户态发起请求 (user/)

- **`user.h`**: 声明了 `write`, `exit` 等用户可见的函数接口。
- **`usys.S`**: 使用汇编宏生成系统调用存根。
  - 将系统调用号加载到 `a7` 寄存器。
  - 执行 `ecall` 指令陷入内核。
  - `ecall` 返回后，`ret` 返回调用者。

### 3.2 内核捕获异常 (kernel/trap/trap.c)

- **异常识别**: 在 `usertrap()` 函数中，检查 `r_scause()` 的值。
- **`scause == 8`**: 代表 User mode environment call (用户态系统调用)。
- **处理流程**:
  1. `p->trapframe->epc += 4`: 将记录的程序计数器加 4，确保系统调用返回后执行下一条指令（而不是重新执行 `ecall`）。
  2. 调用 `intr_on()` 开启中断（系统调用通常在开中断下执行）。
  3. 调用 `syscall()` 进入分发逻辑。

### 3.3 系统调用分发 (kernel/trap/syscall.c)

- **参数获取**: 从当前进程的 `trapframe->a7` 中读取系统调用号。
- **查表分发**: 根据系统调用号，在函数指针数组 `syscalls[]` 中找到对应的处理函数（如 `sys_write`）。
- **返回值处理**: 将内核函数的返回值写入 `trapframe->a0`，这样用户程序就能在 `a0` 寄存器中收到结果。

### 3.4 具体功能实现 (sysproc.c)

- **`sys_write`**: 解析用户传入的缓冲区地址和长度，调用 `consolewrite` 输出到屏幕。
- **`sys_getpid`**: 直接返回 `myproc()->pid`。
- **`sys_exit`**: 打印退出信息，并将进程状态设为 `ZOMBIE` 或释放资源（取决于具体实现阶段）。

## 4. 编译与运行验证

### 测试脚本 (scripts/test_syscall.c)

实验包含了专门的测试模块，通过硬编码二进制数组的方式用于在内核态验证系统调用逻辑，支持加载用户二进制程序进行测试。

### 编译运行



```
make clean
make qemu
```

### 预期输出

系统启动后，将测试系统调用机制。你可能会看到类似以下的输出（取决于 `main.c` 中如何加载测试）：

```
Starting qemu...
start() reached, hart0
Hello myOS! RISC-V single core console ready.
System initialized. Starting scheduler...
Hello World
Init Loop...
============ Test Running =============
Testing basic system calls...
Current PID: 1
Child process: PID=2
Child exited with status: 42
Testing parameter passing...
1: unknown sys call 15
Open failed (expected if no FS yet), skipping file write test.
Hello, World!
�A�瀀6Testing security...
Invalid pointer write result: -1 (expected -1)
abxbb
Security tests completed
Testing syscall performance...
10000 getpid() calls took 1236729 cycles
All syscall tests passed!
```

