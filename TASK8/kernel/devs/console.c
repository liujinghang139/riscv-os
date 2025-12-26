#include "../../include/types.h"
#include "../../include/param.h"
#include "../proc/spinlock.h"
#include "../proc/sleeplock.h"
#include "../../include/memlayout.h"
#include "../../include/riscv.h"
#include "../../include/defs.h"
#include "../proc/proc.h"
#include "../fs/fs.h"
#include "../fs/file.h"



#define BACKSPACE 0x100
#define C(x)  ((x)-'@')  // Control-x


void cons_putc(int c){
  if(c == BACKSPACE){
    // 输出退格：回退、清除、再回退
    uart_putc('\b');
    uart_putc(' ');
    uart_putc('\b');
    return;
  }
  uart_putc((char)c);
}

struct {
  struct spinlock lock;
  
  // input
#define INPUT_BUF_SIZE 128
  char buf[INPUT_BUF_SIZE];
  uint r;  // Read index
  uint w;  // Write index
  uint e;  // Edit index
} cons;


int
console_read(int user_dst, uint64 dst, int n)
{
  uint target;
  int c;
  char cbuf;

  target = n;
  acquire(&cons.lock);
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
      if(get_killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.lock ,&cons.r);
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        cons.r--;
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
      break;

    dst++;
    --n;

    if(c == '\n'){
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);

  return target - n;
}


int
console_write(int user_src, uint64 src, int n)
{
  char buf[32];
  int i = 0;

  while(i < n){
    int nn = sizeof(buf);
    if(nn > n - i)
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
      break;
    // Write exact nn bytes; do not treat as C-string to avoid reading past buffer.
    for(int j = 0; j < nn; j++){
      if(buf[j] == '\n')
        uart_putc('\r');
      uart_putc(buf[j]);
    }
    i += nn;
  }

  return i;
}

void
console_intr(int c)
{
  acquire(&cons.lock);

  switch(c){
    break;
  case C('U'):  // Kill line.
    while(cons.e != cons.w &&
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
      cons.e--;
      cons_putc(BACKSPACE);
    }
    break;
  case C('H'): // Backspace
  case '\x7f': // Delete key
    if(cons.e != cons.w){
      cons.e--;
      cons_putc(BACKSPACE);
    }
    break;
  default:
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
      c = (c == '\r') ? '\n' : c;

      // echo back to the user.
      cons_putc(c);

      // store for consumption by consoleread().
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;

      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
        // wake up consoleread() if a whole line (or end-of-file)
        // has arrived.
        cons.w = cons.e;
        wakeup(&cons.r);
      }
    }
    break;
  }
  
  release(&cons.lock);
}



void console_init(){
  init_lock(&cons.lock, "cons");

  uart_init();

  devsw[CONSOLE].read = console_read;
  devsw[CONSOLE].write = console_write;

}





void clear_screen(){
  printf("\033[2J\033[H");
}

void go_to_xy(int x, int y){
  printf("\033[%d;%dH", x, y);
  printf("dym");
}