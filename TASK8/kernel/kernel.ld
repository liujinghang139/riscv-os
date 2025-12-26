OUTPUT_ARCH("riscv")
ENTRY(_entry)

SECTIONS {
  . = 0x80000000;

  .text :{
    ./boot/entry.o(_entry)
    *(.text .text.*)
    . = ALIGN(0x1000);
    _trampoline = .;
    *(trampsec)
    . = ALIGN(0x1000);
    ASSERT(. - _trampoline == 0x1000, "error: trampoline larger than one page");
    PROVIDE(etext = .);
  }

  .rodata :{
    *(.rodata);
  }

  .data :{
    *(.data);
  }

  .bss :{
    /* Define sbss, ebss as label to realize clear_bss in entry.S*/
    sbss = .;
    *(.bss);
    ebss = .;
  }

  PROVIDE(end = .);
}