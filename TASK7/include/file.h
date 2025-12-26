#ifndef __FILE_H__
#define __FILE_H__

#include "types.h"
#include "fs.h"
#include "sleeplock.h"

struct file {
  enum { FD_NONE, FD_PIPE, FD_INODE, FD_DEVICE } type;
  int ref; // 引用计数
  char readable;
  char writable;
  struct pipe *pipe; // 管道 (暂未实现)
  struct inode *ip;  // FD_INODE 和 FD_DEVICE
  uint off;          // 读写偏移
  short major;       // FD_DEVICE
};

// 内存中的 Inode (带有锁和引用计数)
struct inode {
  uint dev;           // 设备号
  uint inum;          // Inode 号
  int ref;            // 引用计数
  struct sleeplock lock; // 睡眠锁
  int valid;          // 是否已从磁盘读取数据

  short type;         // 以下是 dinode 的副本
  short major;
  short minor;
  short nlink;
  uint size;
  uint addrs[NDIRECT+1];
};

// 设备表接口
struct devsw {
  int (*read)(int, uint64, int);
  int (*write)(int, uint64, int);
};

extern struct devsw devsw[];

#define CONSOLE 1
#endif