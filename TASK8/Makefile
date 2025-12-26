include ./common.mk

KERN = kernel
KERNEL_ELF = kernel.elf

U = user

ULIB = \
	$U/ulib.o \
	$U/usys.o \
	$U/printf.o \
	$U/umalloc.o

# 需要打包进文件系统镜像的用户态程序（二进制以 _ 前缀命名）
UPROGS=\
	$U/_init\
	$U/_shell\
	$U/_echo\
	$U/_ls\
	$U/_mkdir\
	$U/_rm\
	$U/_touch\
	$U/_test_file\
	$U/_test_syscall

.PHONY: $(KERN) build 

all: build 


# 调试
GDBPORT = $(shell expr `id -u` % 5000 + 25000)
QEMUGDB = $(shell if $(QEMU) -help | grep -q '^-gdb'; \
	then echo "-gdb tcp::$(GDBPORT)"; \
	else echo "-s -p $(GDBPORT)"; fi)



$(KERN): 
	$(MAKE) build --directory=$@

$U/usys.S : $U/usys.pl
	perl $U/usys.pl > $U/usys.S

# 生成用户态系统调用桩对象
$U/usys.o : $U/usys.S
	$(CC) $(CFLAGS) -I. -Iinclude -I$(U) -c -o $U/usys.o $U/usys.S

# 用户态通用库对象
$U/ulib.o: $U/ulib.c $U/user.h
	$(CC) $(CFLAGS) -I. -Iinclude -I$(U) -c -o $U/ulib.o $U/ulib.c

$U/printf.o: $U/printf.c $U/user.h
	$(CC) $(CFLAGS) -I. -Iinclude -I$(U) -c -o $U/printf.o $U/printf.c

$U/umalloc.o: $U/umalloc.c $U/user.h
	$(CC) $(CFLAGS) -I. -Iinclude -I$(U) -c -o $U/umalloc.o $U/umalloc.c


# 通用规则：将 user/*.c 构建为带前缀的可执行 _prog
# 例：user/shell.c -> user/_shell
$U/_%: $U/%.o $(ULIB) $U/user.ld
	$(LD) $(LDFLAGS) -T $U/user.ld -o $@ $U/$*.o $(ULIB)
	$(OBJDUMP) -S $@ > $U/$*.asm
	$(OBJDUMP) -t $@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $U/$*.sym

# 编译 user/*.c 为 .o
$U/%.o: $U/%.c $U/user.h
	$(CC) $(CFLAGS) -I. -Iinclude -I$(U) -c -o $@ $<

mkfs/mkfs: mkfs/mkfs.c
	gcc -Werror -Wall -I. -o mkfs/mkfs mkfs/mkfs.c

# 生成文件系统镜像，包含上面的 UPROGS 程序
fs.img: mkfs/mkfs $(UPROGS)
	mkfs/mkfs fs.img $(UPROGS)

qemu: $(KERN) $U/usys.S fs.img
	@echo "Starting the qemu!"
	$(QEMU) $(QEMU-OPTS) -kernel kernel.elf

.gdbinit: .gdbinit.tmpl-riscv
	sed "s/:1234/:$(GDBPORT)/" < $^ > $@

qemu-gdb: $(KERN) .gdbinit $U/usys.S fs.img
	$(QEMU) $(QEMU-OPTS) -S $(QEMUGDB) -kernel kernel.elf

build: $(KERN)

clean:
	$(MAKE) --directory=$(KERN) clean
	rm -f $(KERNEL_ELF) .gdbinit fs.img mkfs/mkfs \
		$(U)/*.o $(U)/*.asm $(U)/*.sym $(UPROGS) $(U)/usys.S

# 依赖文件自动包含
-include kernel/*.d user/*.d