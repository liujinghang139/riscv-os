#ifndef FS_H 
#define FS_H

#include"../../include/types.h"

#define T_DIR     1   // Directory
#define T_FILE    2   // File
#define T_DEVICE  3   // Device

#define BLOCK_SIZE 1024  //一个block中data的大小 
#define SUPERB_INUM 1
#define ROOTINO 1   //root i-number
#define LOG_START 2 //日志起始位置
#define LOG_SIZE  30  //日志区大小

// Disk layout:
// [ boot block | super block | log | inode blocks |
//                                          free bit map | data blocks]
//
// mkfs computes the super block and builds an initial file system. The
// super block describes the disk layout:


struct super_block{
  uint magic;
  uint size;
  uint blocks_num;
  uint inodes_num;
  uint log_num;
  uint log_start;
  uint inode_start;
  uint bmap_start;
};

#define FSMAGIC 0x10203040

#define NDIRECT 12
#define NINDIRECT (BLOCK_SIZE / sizeof(uint))
#define MAXFILE (NDIRECT + NINDIRECT)

//硬盘上的inode
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
#define IPB           (BLOCK_SIZE / sizeof(struct disk_inode))

//寻找第i个inode在第几个block中
#define IBLOCK(i, sb)     ((i) / IPB + sb.inode_start)

//bmap位图一页有多少标志位
#define BPB           (BLOCK_SIZE*8)

#define BBLOCK(b, sb) ((b)/BPB + sb.bmap_start)

// Directory is a file containing a sequence of dirent structures.
#define DIRSIZ 14

// The name field may have DIRSIZ characters and not end in a NUL
// character.
struct dirent {
  ushort inum;
  char name[DIRSIZ] __attribute__((nonstring));
};

#endif