#ifndef PARAM_H
#define PARAM_H

#define NPROC 64
#define NCPU 8
#define NBUF 30
#define NINODE       50  // maximum number of active i-nodes
#define NDEV         10  // maximum major device number
#define NFILE       100  // open files per system
#define NOFILE       16  // open files per process
#define MAXOPBLOCKS  10  // max # of blocks any FS op writes
#define ROOTDEV       1  // device number of file system root disk
#define LOGBLOCKS    (MAXOPBLOCKS*3)  // max data blocks in on-disk log
#define FSSIZE       2000  // size of file system in blocks
#define MAXPATH      128   // maximum file path name
#define MAXARG       32  // max exec arguments
#define USERSTACK    1     // user stack pages

#define SBRK_EAGER 1
#define SBRK_LAZY  2

#endif