#Define common options
include ../common.mk


KERNEL_ELF = ../kernel.elf
KERNEL_LD = kernel.ld
#select all the *.o files
# MODULES = $(shell ls -d */)
MODULES = ./boot ./devs ./lib ./scripts ./mm ./proc ./trap ./fs ./sys
OBJS = $(shell ls -d ./*/*.o)

.PHONY: build clean $(MODULES)
#Compile all the .c and .S files in modules
$(MODULES): 
	$(MAKE) build --directory=$@

#Generate .elf file
$(KERNEL_ELF): $(KERNEL_LD) $(MODULES)
	$(LD) $(LDFLAGS) -T $(KERNEL_LD) -o $@ $(OBJS)
	

build: $(MODULES) $(KERNEL_ELF)

clean:
	for d in $(MODULES); \
		do \
			$(MAKE) clean --directory=$$d; \
		done
	rm -f ${KERNEL_ELF}