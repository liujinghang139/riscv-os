#include"types.h"
void *memset(void *dst, int c, size_t n) {
    char *cdst = (char *)dst;
    for (size_t i = 0; i < n; i++) {
        cdst[i] = c;
    }
    return dst;
}

void *memcpy(void *dst, const void *src, size_t n) {
    const char *s = (const char *)src;
    char *d = (char *)dst;
    for (size_t i = 0; i < n; i++) {
        d[i] = s[i];
    }
    return dst;
}
char* safestrcpy(char *s, const char *t, int n) {
  char *os = s;
  
  if(n <= 0)
    return s;
  
  // 复制字符串，直到遇到 \0 或者剩下最后一个字节的空间
  while(--n > 0 && (*s++ = *t++) != 0)
    ;
  
  // 强制把最后一个字符设为 \0
  *s = 0;
  
  return os;
}
void* memmove(void* dst, const void* src, uint n) {
  const char *s;
  char *d;

  s = src;
  d = dst;

  if(n == 0)
    return dst;

  // 情况 1: dst 在 src 后面，且有重叠 (Overlap)
  // 必须【从后往前】拷贝，防止覆盖还未读取的源数据
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } 
  // 情况 2: dst 在 src 前面，或者没有重叠
  // 可以安全地【从前往后】拷贝
  else {
    while(n-- > 0)
      *d++ = *s++;
  }

  return dst;
}