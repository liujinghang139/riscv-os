//To deal with mutable args
#include<stdarg.h>
#include "../../include/types.h"
#include "../../include/defs.h"

static char digit[] = "0123456789abcedf";

volatile int panicking = 0; // printing a panic message
volatile int panicked = 0; // spinning forever at end of a panic


//  xv6中这样定义这个锁，没明白为什么
static struct {
  struct spinlock lock;
} pr;

void 
printf_init(){
  init_lock(&pr.lock, "printf_lock");
}

static void print_int(long long x, int base, int sign){
  char buf[20];
  unsigned long long xx;
  if(sign && (sign = x < 0)){
    xx = -x;
  }
  else 
    xx = x;
  int i = 0;
  do{
    buf[i++] = digit[xx % base];
  } 
  while ((xx /= base) != 0);

  if(sign){
    cons_putc('-');
  }
  while(--i >= 0){
    cons_putc(buf[i]);
  }
}

static void print_ptr(uint64 p){
  //Print 0x before the operation
  cons_putc('0');
  cons_putc('x');

  while(p != 0){
    int x = (p>>60);
    cons_putc(digit[x]);
    p <<= 4;
  }
}

void printf(char *fmt, ...){
  va_list ap;
  char c0, c1, c2;
  char *s;

  //  当恐慌已经发生，那么必须将panic的内容打印
  //  所以可以不获取锁，代价是可能panic的内容与正常的内容有混杂
  if(panicking == 0)
    acquire(&pr.lock);

  va_start(ap, fmt);

  for(int i=0; (fmt[i] & 0xff) ; i++){
    if(fmt[i] != '%'){
      cons_putc(fmt[i]);
      continue;
    }
    i++;
    c0 = fmt[i] & 0xff;
    c1 = c2 =0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if('d' == c0){
      print_int(va_arg(ap, int), 10, 1);
    } else if('l' == c0 && 'd' == c1){
      print_int(va_arg(ap, uint64), 10, 1);
      i+=1;
    } else if('l' == c0 && 'l' == c1 && 'd' == c2){
      print_int(va_arg(ap, uint64), 10, 1);
      i+=2;
    } else if('u' == c0){
      print_int(va_arg(ap, uint), 10, 0);
    } else if('l' == c0 && 'u' == c1){
      print_int(va_arg(ap, uint64), 10, 0);
      i+=1;
    } else if('l' == c0 && 'l' == c1 && 'u' == c2){
      print_int(va_arg(ap, uint64), 10, 0);
      i+=2;
    } else if('x' == c0){
      print_int(va_arg(ap, uint32), 16, 0);
    } else if('l' == c0 && 'x' == c1){
      print_int(va_arg(ap, uint64), 16, 0);
      i+=1;
    } else if('l' == c0 && 'l' == c1 && 'x' == c2){
      print_int(va_arg(ap, uint64), 16, 0);
      i+=2;
    } else if('c' == c0){
      cons_putc(va_arg(ap, uint));
    } else if('s' == c0){
      if(!(s = va_arg(ap, char*))){
        s = "(null)";
      }
      for(; *s; s++){
        cons_putc(*s);
      }
    } else if('p' == c0){
      print_ptr(va_arg(ap, uint64));
    } else if('%' == c0){
      cons_putc('%');
    } else if (0 == c0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      cons_putc('%');
      cons_putc(c0);
    }

  }
  va_end(ap);

  //  如果已经发生恐慌，那么就不能释放锁，不能让之后的prinf再次获得锁
  if(panicking == 0)
    release(&pr.lock);
}

void printf_color(int color, char *fmt){
  int color_code = color + 31;
  printf("\033[%dm%s\033[0m", color_code, fmt);
}

// To be continued
void
panic(char *s)
{
  panicking = 1;
  printf("panic: ");
  printf("%s\n", s);
  panicked = 1; // freeze uart output from other CPUs
  for(;;);
}