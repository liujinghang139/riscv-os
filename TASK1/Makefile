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
CFLAGS += -Ikernel/trap
LDFLAGS = -T kernel.ld -nostdlib

# QEMU 通用参数
QEMUFLAGS = -machine virt -nographic -bios none

# source files
SRCS = kernel/boot/entry.S kernel/boot/start.c kernel/devs/uart.c kernel/boot/main.c kernel/devs/consloe.c 
OBJS = kernel/boot/entry.o kernel/boot/start.o kernel/devs/uart.o kernel/boot/main.o kernel/devs/consloe.o 

.PHONY: all qemu qemu-gdb gdb dump clean

all: kernel.elf kernel.bin

# 生成 ELF
kernel.elf: $(OBJS) kernel.ld
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
	rm -f $(OBJS) kernel.elf kernel.bin



