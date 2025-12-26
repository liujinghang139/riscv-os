// uart_with_rx.c - 16550A UART for QEMU virt (TX + RX, polling)
#include <stdint.h>
#include "defs.h"

#define UART_BASE 0x10000000UL    // UART 基地址（QEMU virt 平台）
// 寄存器偏移定义
#define UART_RHR    (UART_BASE + 0x00) // Receive Holding Register (read)
#define UART_THR    (UART_BASE + 0x00) // Transmit Holding Register (write)
#define UART_IER    (UART_BASE + 0x01) // Interrupt Enable Register
#define UART_IIR    (UART_BASE + 0x02) // Interrupt Identification Register (read)
#define UART_FCR    (UART_BASE + 0x02) // FIFO Control Register (write)
#define UART_LCR    (UART_BASE + 0x03) // Line Control Register
#define UART_MCR    (UART_BASE + 0x04) // Modem Control Register
#define UART_LSR    (UART_BASE + 0x05) // Line Status Register
#define UART_MSR    (UART_BASE + 0x06) // Modem Status Register
#define UART_SCR    (UART_BASE + 0x07) // Scratch Register
#define UART_DLL    (UART_BASE + 0x00) // Divisor Latch Low Byte
#define UART_DLM    (UART_BASE + 0x01) // Divisor Latch High Byte
// LSR 位定义（Line Status Register）
#define LSR_DR      0x01   // Data Ready
#define LSR_OE      0x02   // Overrun Error
#define LSR_PE      0x04   // Parity Error
#define LSR_FE      0x08   // Framing Error
#define LSR_THRE    0x20   // Transmitter Holding Register Empty
#define LSR_TEMT    0x40   // Transmitter Empty
// 基础 MMIO 访问函数
static inline void outb(unsigned long addr, unsigned char val) {
  *(volatile unsigned char *)addr = val;
}
static inline unsigned char inb(unsigned long addr) {
  return *(volatile unsigned char *)addr;
}

void uart_init(void) {
  // QEMU's 16550 on virt usually comes initialized enough for polling TX/RX.
  // Keep it minimal; if you wish, add proper baud/LCR init later.
   // 禁止中断
    outb(UART_IER, 0x00);

    // 设置 DLAB = 1 以访问波特率除数寄存器
    outb(UART_LCR, 0x80);

    // 波特率除数：115200 = 1.8432MHz / 16 / 1 → 除数 = 1
    // 若主频不同，可按公式 baud_div = input_clk / (16 * baud)
    outb(UART_DLL, 0x01);
    outb(UART_DLM, 0x00);

    // 配置数据格式：8 位数据，无校验，1 位停止位 (8N1)
    outb(UART_LCR, 0x03);

    // 启用 FIFO，清空发送与接收队列
    outb(UART_FCR, 0x07);

    // Modem 控制：无流控模式
    outb(UART_MCR, 0x00);
}

void uart_putc(char c) {
  while ((inb(UART_LSR) & LSR_THRE) == 0) { }
  outb(UART_THR, (unsigned char)c);
}

void uart_puts(const char *s) {
  while (*s) {
    if (*s == '\n') uart_putc('\r');
    uart_putc(*s++);
  }
}

// Non-blocking getc: returns -1 if no data available.
 //UART 非阻塞接收（无数据时返回 -1）
int uart_getc_nonblock(void) {
  if (inb(UART_LSR) & LSR_DR) {
    return (int)(unsigned char)inb(UART_RHR);
  }
  return -1;
}

// Blocking getc: spins until a byte arrives.
// UART 阻塞接收（等待直到收到数据）
int uart_getc(void) {
  int v;
  while ((v = uart_getc_nonblock()) == -1) { }
  return v;
}
