
.text
#Define global Label: _entry, so _entry can be used in other files
.globl _entry

_entry:
      #stack0 is defined in start.c
      la sp, stack0
      li a0, 4*1024
      add sp, sp, a0

      la a0, sbss
      la a1, ebss
clear_bss:
      sb zero, 0(a0)
      addi a0, a0, 1
      bne a0, a1, clear_bss  
clear_bss_done:
      call start

spin:
      j spin