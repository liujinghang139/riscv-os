#include "types.h"
#include "riscv.h"
#include "user.h" // 包含 write 等系统调用的声明

// --- 字符串与内存操作 ---

char* strcpy(char *s, const char *t) {
  char *os;
  os = s;
  while((*s++ = *t++) != 0)
    ;
  return os;
}

int strcmp(const char *p, const char *q) {
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
}

uint strlen(const char *s) {
  int n;
  for(n = 0; s[n]; n++)
    ;
  return n;
}

void* memset(void *dst, int c, uint n) {
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    cdst[i] = c;
  }
  return dst;
}

char* strchr(const char *s, char c) {
  for(; *s; s++)
    if(*s == c)
      return (char*)s;
  return 0;
}

int atoi(const char *s) {
  int n;
  n = 0;
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}

// --- Printf 实现 (核心部分) ---

// 辅助函数：输出一个字符
// 注意：这里调用了系统调用 write，文件描述符 1 代表 stdout
static void putc(int fd, char c) {
  write(fd, &c, 1);
}

// 辅助函数：打印整数
static void printint(int fd, int xx, int base, int sgn) {
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);

  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    putc(fd, buf[i]);
}

// 辅助函数：打印指针
static void printptr(int fd, uint64 x) {
  int i;
  putc(fd, '0');
  putc(fd, 'x');
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    putc(fd, "0123456789abcdef"[x >> (sizeof(uint64) * 8 - 4)]);
}

// 用户态 printf 主函数
void printf(const char *fmt, ...) {
  // 使用 GCC 内置的 va_list 机制
  __builtin_va_list ap;
  __builtin_va_start(ap, fmt);

  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(1, c); // 默认输出到 stdout (fd=1)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(1, __builtin_va_arg(ap, int), 10, 1);
      } else if(c == 'x') {
        printint(1, __builtin_va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
        printptr(1, __builtin_va_arg(ap, uint64));
      } else if(c == 's'){
        if((s = __builtin_va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(1, *s);
      } else if(c == 'c'){
        putc(1, __builtin_va_arg(ap, int));
      } else if(c == '%'){
        putc(1, '%');
      } else {
        // 未知的 % 序列
        putc(1, '%');
        putc(1, c);
      }
      state = 0;
    }
  }
  __builtin_va_end(ap);
}
// 实现 get_time，内部直接调用 uptime
uint64 get_time(void) {
  return (uint64)uptime();
}

// 辅助函数：将整数格式化到缓冲区
static void sprintint(char **buf, char *end, int xx, int base, int sgn) {
  static char digits[] = "0123456789ABCDEF";
  char temp[16];
  int i = 0, neg = 0;
  unsigned int x;

  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
  }

  do {
    temp[i++] = digits[x % base];
  } while((x /= base) != 0);

  if(neg)
    temp[i++] = '-';

  while(--i >= 0 && *buf < end - 1)
    *(*buf)++ = temp[i];
}

int snprintf(char *buf, int size, const char *fmt, ...) {
  char *end = buf + size;
  char *out = buf;
  char *s;
  int c, i, state = 0;
  
  // 使用 GCC 内置的 va_list
  __builtin_va_list ap;
  __builtin_va_start(ap, fmt);

  for(i = 0; fmt[i] && out < end - 1; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        *out++ = c;
      }
    } else if(state == '%'){
      if(c == 'd'){
        sprintint(&out, end, __builtin_va_arg(ap, int), 10, 1);
      } else if(c == 'x'){
        sprintint(&out, end, __builtin_va_arg(ap, int), 16, 0);
      } else if(c == 's'){
        s = __builtin_va_arg(ap, char*);
        if(s == 0) s = "(null)";
        while(*s && out < end - 1) *out++ = *s++;
      } else if(c == '%'){
        *out++ = '%';
      } else {
        // 未知格式，原样输出
        *out++ = '%';
        if(out < end - 1) *out++ = c;
      }
      state = 0;
    }
  }
  *out = 0; // 确保字符串以 null 结尾
  __builtin_va_end(ap);
  return out - buf;
}