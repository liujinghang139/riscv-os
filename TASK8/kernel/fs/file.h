#ifndef FILE_H
#define FILE_H

#include"../../include/types.h"
#include"./fs.h"
#include"../proc/sleeplock.h"

struct file {
  enum { FD_NONE, FD_PIPE, FD_INODE, FD_DEVICE } type;
  int ref; // reference count
  char readable;
  char writable;
  struct pipe *pipe; // FD_PIPE
  struct inode *ip;  // FD_INODE and FD_DEVICE
  uint off;          // FD_INODE
  short major;       // FD_DEVICE
};


#define major(dev)  ((dev) >> 16 & 0xFFFF)
#define minor(dev)  ((dev) & 0xFFFF)
#define	mkdev(m,n)  ((uint)((m)<<16| (n)))


struct inode {
  uint dev;           // Device number
  uint inode_num;          // Inode number
  int refcnt;            // Reference count
  struct sleeplock lock; // protects everything below here
  int valid;          // inode has been read from disk?

  short file_type;         // copy of disk inode
  short major;
  short minor;
  short links;
  uint size;
  uint addrs[NDIRECT+1];
};


// map major device number to device functions.
struct devsw {
  int (*read)(int, uint64, int);
  int (*write)(int, uint64, int);
};

extern struct devsw devsw[];

#define CONSOLE 1

#endif