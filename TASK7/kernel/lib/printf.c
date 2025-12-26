// printf.c - minimal kernel printf & panic (single-core)
#include <stdarg.h>
#include <limits.h>
#include <stdint.h>
#include "defs.h"

volatile int panicked = 0;

static const char digits[] = "0123456789abcdef";
static int putc_count; // 统计输出字节数

static inline void putc_wrap(int ch){ consputc(ch); putc_count++; }

static void print_number(int num, int base, int sign)
{
  char buf[32];
  int i = 0;
  unsigned int x;
  int neg = 0;

  if (base < 2 || base > 16) {
    // 不支持的进制，直接回退成十进制
    base = 10;
  }

  // 关键：把负数转换为无符号，避免 INT_MIN 取反溢出
  // 用“先转 unsigned 再求负”的方式，在无符号域里是良定义的（模 2^N）
  if (sign && num < 0) {
    neg = 1;
    x = (unsigned int)(-(unsigned int)num);
  } else {
    x = (unsigned int)num;
  }

  // x==0 也要输出 '0'
  do {
    buf[i++] = digits[x % (unsigned)base];
    x /= (unsigned)base;
  } while (x != 0);

  if (neg)
    buf[i++] = '-';

  // 逆序输出
  while (--i >= 0)
    consputc(buf[i]);
}


static int printptr(uint64_t x) {
  int n = 0;
  putc_wrap('0'); n++;
  putc_wrap('x'); n++;
  for (int i = (int)(sizeof(uint64_t)*2)-1; i >= 0; --i) {
    int nibble = (x >> (i*4)) & 0xF;
    putc_wrap(digits[nibble]); n++;
  }
  return n;
}

// 支持 %d, %x, %p, %s, %c, %% ，返回输出的字符数
int printf(const char *fmt, ...) {
  if (!fmt) { panic("null fmt"); }
  va_list ap;
  va_start(ap, fmt);
  putc_count = 0;

  for (int i = 0; fmt[i]; i++) {
    int c = fmt[i] & 0xff;
    if (c != '%') { putc_wrap(c); continue; }

    c = fmt[++i] & 0xff;
    if (c == 0) break;

    switch (c) {
      case 'd': print_number(va_arg(ap, int), 10, 1); break;//有符号十进制
      case 'x': print_number((long)va_arg(ap, unsigned int), 16, 0); break;//无符号十六进制
      case 'p': printptr(va_arg(ap, uint64_t)); break;
      case 's': {
        const char *s = va_arg(ap, const char*);
        if (!s) s = "(null)";
        while (*s) putc_wrap(*s++);
        break;
      }
      case 'c': {
        int ch = va_arg(ap, int);   // char 会被提升为 int
        putc_wrap(ch);
        break;
      }
      case '%': putc_wrap('%'); break;
      default:  // 未知格式：按 xv6 习惯输出 "%<char>"
        putc_wrap('%'); putc_wrap(c);
        break;
    }
  }

  va_end(ap);
  return putc_count;
}

void panic(const char *s) {
  //intr_off();
  panicked = 1;
  printf("panic: %s\n", s);
  for(;;){ __asm__ volatile("wfi"); }
}

// 若你需要打印 64 位指针，继续保留（或使用）这个版本：
//static void printptr_u64(uint64_t v)
//{
 // consputc('0'); consputc('x');
  //for (int i = (int)(sizeof(uint64_t) * 2) - 1; i >= 0; --i) {
   // consputc(digits[(v >> (i * 4)) & 0xF]);
 // }
//}

//static int printint(long xx, int base, int sign) {
// char buf[32];
  //unsigned long x;
 // int i = 0, n = 0;

  //if (sign && xx < 0) { x = (unsigned long)(-xx); sign = 1; }
  //else { x = (unsigned long)xx; sign = 0; }

  //do { buf[i++] = digits[x % base]; x /= base; } while (x);

 // if (sign) buf[i++] = '-';
  //while (--i >= 0) { putc_wrap(buf[i]); n++; }
  //return n;
//}
