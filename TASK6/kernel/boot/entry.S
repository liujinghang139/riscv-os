        #qemu -kernel loads the kernel at 0x80000000
        #and causes one hart (single CPU) to jump here
        #kernel.ld causes the code below to be replaced at x80000000
.section .text
.global _entry
_entry:    
        la sp, stack0
        #stack size is 4096
        li a0, 4*1024
        add sp, sp, a0
        #clear the bss
        la a0, _sbss
        la a1, _ebss
bss_clear:
        beq a0, a1, bss_done
        sb zero, 0(a0)
        add a0, a0, 1
        j bss_clear
bss_done:
        #jump to start() in start.c
        call start
spin:
        j spin