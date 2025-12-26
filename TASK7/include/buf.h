#ifndef __BUF_H__
#define __BUF_H__

#include "sleeplock.h"
#include "fs.h"

struct buffer {
  int valid;   // 数据是否有效
  int disk;    // 是否已被修改(脏位)
  uint dev;
  uint blocknum;
  struct sleeplock lock;
  uint refcnt;
  struct buffer *prev; // LRU 链表
  struct buffer *next;
  uchar data[BSIZE];
};

#endif