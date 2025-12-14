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

    /* ======================================================== */
    /* [新增] Trampoline段配置 - 必须严格按页对齐 */
    /* ======================================================== */
    . = ALIGN(0x1000);       /* 1. 对齐到下一页边界 (4096字节) */
    _trampoline = .;         /* 2. 记录当前位置为 _trampoline */
    *(.tramp)                /* 3. 把 trampoline.S 里的代码塞进来 */
    . = ALIGN(0x1000);       /* 4. 再次对齐，确保占满整整一页 */
    
    /* 5. 确保这一段正好是一页大小，否则报错 */
    ASSERT(. - _trampoline == 0x1000, "error: trampoline larger than one page");
    
    /* 6. 导出符号 trampoline 给 C 语言用 */
    PROVIDE(trampoline = _trampoline);
    /* ======================================================== */

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