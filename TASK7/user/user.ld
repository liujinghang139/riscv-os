/* user/user.ld */
OUTPUT_ARCH(riscv)
ENTRY(_start)

SECTIONS
{
  . = 0x0;
  
  /* 代码段 */
  .text : {
    *(.text.start)
    *(.text .text.*)
  }

  /* 只读数据段 (你的字符串就在这！) */
  .rodata : {
    . = ALIGN(16);
    *(.rodata .rodata.*)
  }

  /* 数据段 */
  .data : {
    . = ALIGN(16);
    *(.data .data.*)
  }

  /* BSS段 */
  .bss : {
    . = ALIGN(16);
    *(.bss .bss.*)
  }
}