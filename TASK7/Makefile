K = kernel
U = user

QEMU = qemu-system-riscv64

CROSS_COMPILE = riscv64-unknown-elf-
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
GDB = gdb-multiarch

CFLAGS = -Wall -Werror -O -fno-omit-frame-pointer -ggdb -MD
CFLAGS += -ffreestanding -nostdlib -mno-relax -mcmodel=medany
CFLAGS += -I include
LDFLAGS = -T kernel.ld -nostdlib
HOSTCC = gcc

# QEMU 通用参数
QEMUFLAGS = -machine virt -nographic -bios none -cpu rv64,sstc=true
QEMUFLAGS += -drive file=fs.img,if=none,format=raw,id=x0
QEMUFLAGS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0
QEMUFLAGS += -global virtio-mmio.force-legacy=false
# source files
SRCS = \
  kernel/boot/entry.S \
  kernel/boot/start.c \
  kernel/boot/main.c \
  kernel/devs/uart.c \
  kernel/devs/consloe.c \
  kernel/lib/printf.c \
  kernel/lib/ansi.c \
  kernel/mm/kalloc.c \
  kernel/mm/vm.c \
  scripts/test_memory.c \
  kernel/devs/string.c \
  kernel/devs/virtio_disk.c \
  kernel/devs/plic.c \
  kernel/trap/trap.c \
  kernel/trap/timer.c \
  kernel/boot/kernelvec.S \
  kernel/proc/proc.c \
  kernel/proc/spinlock.c \
  kernel/proc/sleeplock.c \
  kernel/trap/trampoline.S \
  kernel/trap/syscall.c \
  kernel/trap/sysproc.c \
  kernel/trap/sysfile.c \
  kernel/boot/swtch.S \
  kernel/fs/bio.c \
  kernel/fs/file.c \
  kernel/fs/fs.c \
  kernel/fs/log.c \
  scripts/test_trap.c \
  scripts/test_process.c 
  
OBJS = $(SRCS:.c=.o)
OBJS := $(OBJS:.S=.o)

# 文件系统镜像生成规则
# -----------------------------------

# 1. 目标：生成最终的磁盘镜像文件
# 依赖于 mkfs 宿主机工具
fs.img: mkfs/mkfs
	@echo "Creating fs.img..."
	# 创建一个简单的 README 文件作为文件系统内容
	@echo "Hello, RISC-V File System!" > README
	# 使用宿主机工具创建镜像
	./mkfs/mkfs fs.img README
	@echo "File system image fs.img created."
	# 清理临时的 README 文件
	rm -f README

# 2. 编译 mkfs 宿主机工具 (使用宿主机编译器 HOSTCC)
# 依赖于文件系统相关的头文件
mkfs/mkfs: mkfs/mkfs.c include/types.h include/fs.h include/stat.h
	@mkdir -p mkfs
	$(HOSTCC) -Wall -Werror -O0 -g -iquote include -std=gnu11 $< -o $@


# --- 用户程序配置 ---
# 定义用户态程序的源文件
USER_SRCS = \
  scripts/test_wenjian.c \
  user/ulib.c \
  user/usys.S

# 生成对应的 .o 文件列表
USER_OBJS = $(USER_SRCS:.c=.o)
USER_OBJS := $(USER_OBJS:.S=.o)

# 定义用户态的链接脚本
USER_LDSCRIPT = user/user.ld
.PHONY: all qemu qemu-gdb gdb dump clean mkfs/mkfs

all: kernel.elf kernel.bin user.elf fs.img

# 生成 ELF
kernel.elf: $(OBJS) kernel.ld user.elf fs.img
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS)

# 生成裸机二进制
kernel.bin: kernel.elf
	$(OBJCOPY) -O binary $< $@

# 编译 C 文件
%.o: %.c
	@$(CC) $(CFLAGS) -c -o $@ $<
	@echo "C files are compiled!"

# 编译汇编文件
%.o: %.S
	@$(CC) $(CFLAGS) -c -o $@ $<
	@echo "Assemble files are compiled!"

# 运行 QEMU（正常启动）
qemu: kernel.elf
	@echo "Starting qemu..."
	@$(QEMU) $(QEMUFLAGS) -kernel $<

# 运行 QEMU，等待 GDB 连接（-S 停在复位入口，-s 等价于 -gdb tcp::1234）
qemu-gdb: kernel.elf
	@echo "Starting qemu for gdb on tcp::1234 ..."
	@$(QEMU) $(QEMUFLAGS) -kernel $< -S -s

# 便捷 GDB（自动连到 :1234；可按需调整断点）
gdb: kernel.elf
	@echo "Starting $(GDB) and connecting to :1234 ..."
	@$(GDB) -q $< \
		-ex "target remote :1234" \
		-ex "set disassemble-next-line on" \
		-ex "b _entry"

# 调试用：查看反汇编
dump: kernel.elf
	$(OBJDUMP) -D $< | less

# 清理
clean:
	rm -f $(OBJS) $(USER_OBJS) kernel.elf kernel.bin user.elf test.bin include/test_code.h fs.img mkfs/mkfs README # 新增文件系统相关的清理

# --- 用户程序构建规则 ---

# 1. 生成 test_code.h
# 依赖于 test.bin。当 test.bin 更新时，自动重新生成头文件
include/test_code.h: test.bin
	@echo "Generating test_code.h..."
	xxd -i test.bin > include/test_code.h

# 2. 生成 test.bin (纯二进制)
# 依赖于 user.elf
test.bin: user.elf
	$(OBJCOPY) -O binary user.elf test.bin

# 3. 链接生成 user.elf
# 依赖于用户态的 .o 文件和链接脚本
user.elf: $(USER_OBJS) $(USER_LDSCRIPT)
	$(LD) -T $(USER_LDSCRIPT) -o user.elf $(USER_OBJS)

# 4. 【关键】建立内核文件对 test_code.h 的依赖
# 告诉 Make：编译 kernel/proc/proc.c 之前，必须先保证 include/test_code.h 是最新的
kernel/proc/proc.o: include/test_code.h

# --- 更新 clean 目标 ---
# (请将这部分合并到你原有的 clean 目标中，不要重复定义)

