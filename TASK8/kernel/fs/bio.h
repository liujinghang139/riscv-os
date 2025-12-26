#ifndef BIO_H
#define BIO_H

struct buffer{
  int valid;  // 此BUF是否有效
  int disk;   // does disk "own" off
  uint dev;
  uint blocknum;
  struct sleeplock lock;
  uint refcnt;
  //循环列表来组织buf
  struct buffer *prev;
  struct buffer *next;
  uchar data[BLOCK_SIZE];
};

#endif