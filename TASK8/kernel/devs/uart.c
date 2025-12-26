#include"../../include/memlayout.h"
#include"../../include/defs.h"


#define RHR 0  //Receive hloding register (ReadMode)
#define THR 0  //Transmit holding register (WriteMode)
#define DLL 0  //Divisor latch register: Least Significant Byte (WriteMode)
#define IER 1  //Interrupt enable register (WriteMode)
#define IER_RX_ENABLE (1<<0)
#define IER_TX_ENABLE (1<<1)
#define DLM 1  //Divisor latch register: Most Significant Byte (WriteMode)
#define FCR 2  //FIFO control register
#define FCR_FIFO_ENABLE (1<<0)
#define FCR_FIFO_CLEAR (3<<1)
#define ISR 2                 // interrupt status register
#define LCR 3  //Line control register
#define LCR_BAUD_LATCH (1<<7)  //Special mode to set baud rate
#define LCR_EIGHT_BITS (3<<0)
#define LSR 5  //Line status register
#define LSR_TX_IDLE (1<<5) 
#define LSR_RX_READY (1<<0)   // input is waiting to be read from RHR


#define Reg(reg) ((volatile unsigned char*) (UART0 + reg))
//Attention: there should be unsigned because UART use 0-255
#define ReadReg(reg) (*Reg(reg))
#define WriteReg(reg, v) (*Reg(reg) = (v))


static struct spinlock tx_lock;

// static int tx_busy;           // is the UART busy sending?
// static int tx_chan;           // &tx_chan is the "wait channel"


extern volatile int panicking;
extern volatile int panicked;


void 
uart_init(){
  init_lock(&tx_lock, "uart");
  //1.Disable the interrupts
  WriteReg(IER, 0x00);
  //2.Enter the mode which sets baud rate
  WriteReg(LCR, LCR_BAUD_LATCH);
  //3.Set DLL, DLM for the baud rate
  WriteReg(DLL, 0x03); //LSB for 38.4K
  WriteReg(DLM, 0x00); //MSB for 38.4K
  //4.Leave the special mode
  //Word Length:8bit  Parity:None Why?
  WriteReg(LCR, LCR_EIGHT_BITS);
  //5.Set the FIFO
  WriteReg(FCR, (FCR_FIFO_CLEAR | FCR_FIFO_ENABLE));
  //6.Enable the interrupts
  // 只启用接收中断，发送使用轮询方式，避免空闲发送中断风暴
  WriteReg(IER, IER_RX_ENABLE); 

}


void 
uart_putc(char c){

  if(panicking == 0)
    push_off();
  if(panicked){
    while(1){
    }
  }

  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
  ;
  WriteReg(THR, (int)c);
  if(panicking == 0)
    pop_off();
}


// void
// uart_puts(const char *s)
// {
//   acquire(&tx_lock);

//   while(*s != '\0'){ // 循环直到遇到字符串结束符
//     while(tx_busy != 0){
//       // 如果 UART 发送器忙，睡眠等待中断唤醒
//       // 这里的逻辑与 uartwrite 保持完全一致
//       sleep(&tx_lock, &tx_chan);
//     }

//     WriteReg(THR, *s); // 发送当前字符
//     tx_busy = 1;       // 标记为忙碌状态
//     s++;               // 指针后移，指向下一个字符
//   }

//   release(&tx_lock);
// }

void
uart_puts(const char *s)
{
  // 发送简单轮询，保持与 uart_putc 同步特性
  acquire(&tx_lock);
  while(*s){
    if(*s == '\n')
      uart_putc('\r');
    uart_putc(*s++);
  }
  release(&tx_lock);
}


int
uartgetc(void)
{
  if(ReadReg(LSR) & LSR_RX_READY){
    // input data is ready.
    return ReadReg(RHR);
  } else {
    return -1;
  }
}


void
uart_intr(void)
{
  ReadReg(ISR); // acknowledge the interrupt

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
      break;
    console_intr(c);
  }
}