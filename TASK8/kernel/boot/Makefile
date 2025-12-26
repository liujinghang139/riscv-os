#define common options
include ../../common.mk

INCLUDE := ../../include

target = $(shell ls *.c *.S 2>/dev/null | awk '{gsub(/\.c|\.S/, ".o"); print $0}')

.PHONY: clean
#Compile C files
%.o: %.c
	$(CC) $(CFLAGS) -I $(INCLUDE) -c $< -o $@
	
#Compile assemble files
%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

build: $(target)

clean:
	rm -f *.o *.d