#include"../../include/types.h"


void*
memset(void *ptr, int c, uint n)
{
  char *cdst = (char *) ptr;
  int i;
  for(i = 0; i < n; i++){
    cdst[i] = c;
  }
  return ptr;
}

int
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    ;
  return n;
}

//  To be continued...
void*
memmove(void *dst, const void *src, uint n)
{
  const char *s;
  char *d;

  if(n == 0)
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}

char* 
safestrcpy(char *s, const char *t, int n){
  char *os;
  os = s;
  if(n <= 0)
    return os;

  while(--n > 0 && (*s++ = *t++) != 0);
  *s = 0;
  return os;
}

//比较两个字符串的前n个字符
int strncmp(const char *s, const char *t, uint n){
  while(n > 0 && *s && *s == *t)
    n--,s++,t++;
  if(n == 0)
    return 0;
  return (uchar)*s - (uchar)*t;
}


char*
strncpy(char *s, const char *t, int n)
{
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}