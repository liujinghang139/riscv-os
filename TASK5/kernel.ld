OUTPUT_ARCH("riscv")
ENTRY(_entry)

SECTIONS
{
  /* QEMU -kernel 默认加载到 0x80000000 */
  . = 0x80000000;

  /* --- Text/code section --- */
  .text : ALIGN(16)
  {
    *(.text.entry)        /* 如果 entry.S 放在 .text.entry */
    *(.text .text.*)
    *(.gnu.linkonce.t.*)
    *(.rodata .rodata.*)  /* 只读数据也可以放这里 */
    . = ALIGN(0x1000);
    PROVIDE(etext = .);
  } :text

  /* --- Data section --- */
  .data : ALIGN(16)
  {
    *(.data .data.*)
    *(.sdata .sdata.*)
    *(.gnu.linkonce.d.*)
    PROVIDE(edata = .);
  } :data

  /* --- BSS section --- */
  .bss (NOLOAD) : ALIGN(16)
  {
    _sbss = .;
    *(.sbss .sbss.*)
    *(.bss .bss.*)
    *(COMMON)
    _ebss = .;
  } :data

  PROVIDE(end = .);
  PROVIDE(_end = .);

  /DISCARD/ : { *(.comment) *(.note*) }
}

/* --- Program headers (control segment permissions) --- */
PHDRS
{
  text PT_LOAD FLAGS(5); /* R + X */
  data PT_LOAD FLAGS(6); /* R + W */
}
