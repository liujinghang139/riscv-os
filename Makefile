K = kernel
U = user

QEMU = qemu-system-riscv64

CROSS_COMPILE = riscv64-unknown-elf-
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

CFLAGS = -Wall -Werror -O -fno-omit-frame-pointer -ggdb -MD
CFLAGS += -ffreestanding -nostdlib -mno-relax -mcmodel=medany
CFLAGS += -Ikernel/trap
LDFLAGS = -T kernel.ld -nostdlib

#source files
SRCS = kernel/boot/entry.S kernel/boot/start.c kernel/devs/uart.c kernel/boot/main.c kernel/devs/consloe.c kernel/lib/printf.c kernel/lib/ansi.c
OBJS = kernel/boot/entry.o kernel/boot/start.o kernel/devs/uart.o kernel/boot/main.o kernel/devs/consloe.o kernel/lib/printf.o kernel/lib/ansi.o

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

# 运行 QEMU
qemu: kernel.elf
	@echo "Starting qemu..."
	@qemu-system-riscv64 -machine virt -nographic -kernel kernel.elf\
		-bios none

# 调试用：查看段信息
dump: kernel.elf
	$(OBJDUMP) -D kernel.elf | less

# 清理
clean:
	rm -f $(OBJS) kernel.elf kernel.bin



