PREVIOUS = riscv64-unknown-elf-
CC = $(PREVIOUS)gcc
LD = $(PREVIOUS)ld
OBJDUMP = $(PREVIOUS)objdump
OBJCOPY = $(PREVIOUS)objcopy

CFLAGS = -Wall -Werror -O -ggdb -MD -fno-omit-frame-pointer
CFLAGS += -ffreestanding -nostdlib -mno-relax -mcmodel=medany
# Ensure integer mul/div and atomics available in user/kernel
CFLAGS += -march=rv64gc -mabi=lp64
LDFLAGS = -nostdlib

QEMU = qemu-system-riscv64
QEMU-OPTS= -machine virt -bios none -nographic 
QEMU-OPTS += -drive file=fs.img,if=none,format=raw,id=x0
QEMU-OPTS += -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0
QEMU-OPTS += -global virtio-mmio.force-legacy=false

