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

int strncmp(const char *p, const char *q, uint n) {
  for(; n > 0 && *p && *p == *q; n--, p++, q++);
  if (n == 0 || *p == *q) // 达到 n 或都指向 '\0'
    return 0;
  return (unsigned char)*p - (unsigned char)*q;
}

// 实现 strncpy: 复制字符串 t 到 s，最多复制 n 个字符
// 如果 t 的长度小于 n，剩余部分用 '\0' 填充
char* strncpy(char *s, const char *t, int n) {
  char *os = s;
  
  // 复制 t 的内容，直到达到 n 或遇到 '\0'
  while (n-- > 0 && (*s++ = *t++) != 0)
    ;
  
  // 如果 n 还有剩余，用 '\0' 填充剩余部分
  while (n-- > 0)
    *s++ = 0;
    
  return os;
}
uint strlen(const char *s) {
  int n;
  for(n = 0; s[n]; n++)
    ;
  return n;
}
