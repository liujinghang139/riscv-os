#ifndef __FS_H__
#define __FS_H__

#include "types.h"

#define T_DIR     1   // Directory
#define T_FILE    2   // File
#define T_DEVICE  3   // Device
// 磁盘布局参数
#define ROOTINO 1         // 根目录 Inode 编号
#define BSIZE 1024        // 块大小
#define FSMAGIC 0x10203040 // 文件系统魔数
#define MAXOPBLOCKS 10    // 每次事务最大涉及块数
#define LOGSIZE (MAXOPBLOCKS*3) // 日志区大小
#define NBUF (MAXOPBLOCKS*3)    // 内存中的缓存块数量
#define FSSIZE 1000       // 文件系统总大小 (块数)

#define NDIRECT 12
#define NINDIRECT (BSIZE / sizeof(uint))
#define MAXFILE (NDIRECT + NINDIRECT)

// 磁盘上的超级块
struct superblock {
  uint magic;
  uint size;       // 文件系统总块数
  uint nblocks;    // 数据块数量
  uint ninodes;    // Inode 数量
  uint nlog;       // 日志块数量
  uint logstart;   // 日志区起始块号
  uint inodestart; // Inode 区起始块号
  uint bmapstart;  // 位图起始块号
};

// 磁盘上的 Inode
struct disk_inode{
  short file_type;
  short major;
  short minor;
  short links;
  uint  size;
  //前12个存储直接block,后一个存间接block的地址
  uint  addrs[NDIRECT+1];
};
//每一个block存储多少inode
#define IPB           (BSIZE / sizeof(struct disk_inode))

//寻找第i个inode在第几个block中
#define IBLOCK(i, sb)     ((i) / IPB + sb.inodestart)

//bmap位图一页有多少标志位
#define BPB           (BSIZE*8)

#define BBLOCK(b, sb) ((b)/BPB + sb.bmapstart)

// Directory is a file containing a sequence of dirent structures.
#define DIRSIZ 14
// 目录项
#define DIRSIZ 14
struct dirent {
  ushort inum;
  char name[DIRSIZ];
};

#endif