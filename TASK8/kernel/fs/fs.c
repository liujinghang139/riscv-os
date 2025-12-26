#include"../../include/types.h"
#include"../../include/param.h"
#include"../../include/defs.h"
#include"../proc/sleeplock.h"
#include"./fs.h"
#include"./bio.h"
#include"./file.h"
#include"../proc/proc.h"


struct super_block superblock;

static void 
r_superblock(uint dev){
  struct buffer *b;
  b = read_buf(dev, SUPERB_INUM);
  //将superblock的内容从cache读出来
  memmove(&superblock, b->data, BLOCK_SIZE);
  relse_buf(b);
}

//对文件系统初始化
void 
fs_init(int dev){
  r_superblock(dev);
  if(superblock.magic != FSMAGIC)
    panic("invalid file system\n");
  init_log(dev,&superblock);
  reclaim_inode(dev);
}

//以下是对block的操作-----------------------

//对一个block全部写0
static void 
clear_block(uint dev, uint blocknum){
  struct buffer *buf;
  
  buf = read_buf(dev, blocknum);
  memset(buf->data, 0, BLOCK_SIZE);
  log_write(buf);
  relse_buf(buf);
}


//分配一个已经清零的block
static uint 
alloc_block(uint dev){
  uint bmap_index;
  uint bmap_bit;
  uint flag;

  struct buffer *buf;
  for(bmap_index = 0;bmap_index < superblock.size; bmap_index += BPB){
    buf = read_buf(dev, BBLOCK(bmap_index, superblock));
    for(bmap_bit = 0;bmap_bit < BPB && bmap_bit + bmap_index < superblock.size;bmap_bit++){
      flag = 1 << (bmap_bit % 8);
      if((flag & buf->data[bmap_bit/8]) == 0){
        buf->data[bmap_bit/8] |= flag;
        log_write(buf);
        relse_buf(buf);
        clear_block(dev, bmap_bit+bmap_index);
        return bmap_bit + bmap_index;
      }
    }
    relse_buf(buf);
  }
  printf("alloc_block: out of blocks\n");
  return 0;
}

//释放一个block
static void 
free_block(uint dev, uint blocknum){
  struct buffer *buf;
  int flag, bi;

  bi = blocknum % BPB;
  buf = read_buf(dev, BBLOCK(blocknum, superblock));
  flag = 1 << (bi % 8);
  if((buf->data[bi/8] & flag) == 0)
    panic("free a freed block\n");
  buf->data[bi/8] &= ~flag;
  log_write(buf);
  relse_buf(buf);

}


//以下是对inode的操作

struct {
  struct spinlock lock;
  struct inode inode[NINODE];
} itable;


void 
itable_init(){
  int i;

  init_lock(&itable.lock, "itable_lock");
  for(i = 0;i < NINODE;i++){
    init_sleeplock(&itable.inode[i].lock, "inode");
  }
}

//找itable中的inode，没有就从disk中copy
static struct inode* 
get_inode(uint dev, uint inum){
  struct inode *ip, *empty;

  acquire(&itable.lock);

  empty = 0;
  for(ip = &itable.inode[0];ip < &itable.inode[NINODE];ip++){
    if(ip->refcnt > 0 && ip->dev == dev && ip->inode_num == inum){
      ip->refcnt++;
      release(&itable.lock);
      return ip;
    }
    if(empty == 0 && ip->refcnt == 0)
      empty = ip;
  }

  //inode不在itable中
  if(empty == 0)
    panic("get_inode:no rest inodes\n");
  ip = empty;
  ip->dev = dev;
  ip->inode_num = inum;
  ip->refcnt = 1;
  ip->valid = 0;
  release(&itable.lock);

  return ip;

};


//分配一个disk_inode,并返回itable上的inode
//找不到返回0
struct inode*
alloc_inode(uint dev, short type){
  int i;
  struct buffer *buf;
  struct disk_inode* dinode;

  for(i = 1; i < superblock.inodes_num;i++){
    buf = read_buf(dev, IBLOCK(i, superblock));
    dinode = (struct disk_inode*)buf->data + (i%IPB);
    if(dinode->file_type == 0){
      // Clear on-disk inode first, then set type to avoid zeroing it out.
      memset(dinode, 0, sizeof(*dinode));
      dinode->file_type = type;
      log_write(buf);
      relse_buf(buf);  // release buffer lock before returning
      return get_inode(dev, i);
    }
    relse_buf(buf);
  }
  printf("alloc_inode:no rest inodes\n");
  return 0;
}


//将itable中的inode更新到disk中的disk_inode中
void 
update_inode(struct inode *inode){
  struct buffer *buf;
  struct disk_inode* dinode;

  buf = read_buf(inode->dev, IBLOCK(inode->inode_num, superblock));
  
  dinode = (struct disk_inode*)buf->data + (inode->inode_num % IPB);
  dinode->file_type = inode->file_type;
  dinode->major = inode->major;
  dinode->minor = inode->minor;
  dinode->links = inode->links;
  dinode->size = inode->size;
  memmove(dinode->addrs, inode->addrs, sizeof(inode->addrs));
  log_write(buf);
  relse_buf(buf);
}

//增加对inode的引用，常用于文件复制
struct inode*
duplicate_inode(struct inode *inode){
  acquire(&itable.lock);
  inode->refcnt++;
  release(&itable.lock);
  return inode;
}

//对inode进行原子操作
void
lock_inode(struct inode *inode){
  struct buffer *buf;
  struct disk_inode *dinode;

  if(inode == 0 || inode->refcnt == 0)
    panic("lock_inode\n");

  //由于接下来进行I/O操作，使用sleeplock
  acq_sleeplock(&inode->lock);
   
  if(!inode->valid){
    buf = read_buf(inode->dev, IBLOCK(inode->inode_num, superblock));
    dinode = (struct disk_inode *)buf->data + (inode->inode_num%IPB);
    inode->file_type = dinode->file_type;
    inode->major = dinode->major;
    inode->minor = dinode->minor;
    inode->links = dinode->links;
    inode->size = dinode->size;
    memmove(inode->addrs, dinode->addrs, sizeof(inode->addrs));
    relse_buf(buf);
    inode->valid = 1;
    
    if(inode->file_type == 0){
      panic("lock_inode: no type\n");
    }
  }
}

void 
unlock_inode(struct inode *inode){
  if(inode == 0 || !holding_sleeplock(&inode->lock) || inode->refcnt == 0){
    panic("unlock_inode\n");
  }
  rel_sleeplock(&inode->lock);
}


//当进程不在对文件进行引用使得ref--
//当最后一个引用要结束时，要进行离场打扫
void 
putback_inode(struct inode *inode){
  acquire(&itable.lock);

  if(inode->refcnt == 1 && inode->links == 0 && inode->valid){

    acq_sleeplock(&inode->lock);
    release(&itable.lock);

    truncate_inode(inode);

    inode->file_type = 0;
    update_inode(inode);
    inode->valid = 0;

    rel_sleeplock(&inode->lock);

    acquire(&itable.lock);
  }

  inode->refcnt--;
  release(&itable.lock);

}

//恢复文件系统中所有的inode，并且处理孤儿inode
void 
reclaim_inode(int dev){
  for(int inum = 1; inum < superblock.inodes_num;inum++){
    struct buffer *buf;
    struct disk_inode* dinode;
    struct inode* ip = 0;

    buf  = read_buf(dev, IBLOCK(inum, superblock));
    dinode = (struct disk_inode *)buf->data + (inum % IPB);

    if(dinode->file_type != 0 && dinode->links == 0){
      //孤儿inode
      printf("ireclaim: orphaned inode %d\n", inum);
      ip = get_inode(dev, inum);
    }

    relse_buf(buf);

    if(ip){
      begin_op();
      //此处必须要先lock一遍
      //由于get_inode只是得到了itable中的inode并没有加载数据
      //而是放到了lock中加载
      lock_inode(ip);
      unlock_inode(ip);
      putback_inode(ip);
      end_op();
    }
  }
}

static uint 
bmap(struct inode *ip, uint bn){
  uint addr;
  struct buffer *buf;
  uint *array;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0){
      addr = alloc_block(ip->dev);
      //如果分配不了
      if(!addr)
        return 0;
      ip->addrs[bn] = addr;
    }
    return addr;
  }
  bn -= NDIRECT;

  //间接的addr
  if(bn < NINDIRECT){
    if((addr = ip->addrs[NDIRECT]) == 0){
      addr = alloc_block(ip->dev);
      if(addr == 0)
        return 0;
      ip->addrs[NDIRECT] = addr;
    }

    buf = read_buf(ip->dev, addr);
    array = (uint*)buf->data;
    //如果间接block的第一个addr是0，要分配block号
    // if(array[bn] == 0){
    //   addr = alloc_block(ip->dev);
    //   if(addr == 0){
    //     // 分配失败时需释放持有的缓存块锁，否则将导致后续读写死锁
    //     relse_buf(buf);
    //     return 0;
    //   }
    //   array[bn] = addr;
    //   log_write(buf);
    // }
    // relse_buf(buf);
    // return addr;


    if((addr = array[bn])==0){
      addr = alloc_block(ip->dev);
      if(addr){
        array[bn] = addr;
        log_write(buf);
      }
    }

    relse_buf(buf);
    return addr;
  }
  panic("bmap():out of range\n");
}

//将文件清空，将inode的addrs全部变0
//使用的时候已经持有了inode.lock
void
truncate_inode(struct inode *inode){
  struct buffer *buf;
  int i;
  uint *array;

  for(i = 0; i<NDIRECT; i++){
    if(inode->addrs[i]){
      free_block(inode->dev, inode->addrs[i]);
      inode->addrs[i] = 0;
    }
  }

  if(inode->addrs[NDIRECT]){
    buf = read_buf(inode->dev, inode->addrs[NDIRECT]);
    array = (uint*)buf->data;
    for(i = 0; i<NINDIRECT; i++){
      if(array[i]){
        free_block(inode->dev, array[i]);
      }
    }
    relse_buf(buf);
    free_block(inode->dev, inode->addrs[NDIRECT]);
    inode->addrs[NDIRECT] = 0;
  }
  
  inode->size = 0;
  update_inode(inode);
}

//stat_inode 稍后实现

#define min(a, b)  ((a) < (b) ?(a):(b))
int 
read_inode(struct inode *inode, int user_dst, uint64 dst, uint off, uint n){
  //tot-->已经读取的字节数 m-->每次读取的字节数
  uint tot;
  uint m;
  struct buffer *buf;
  uint blocknum;
  //首先判断offset是否出界
  if(off > inode->size || off + n < off)
    return 0;
  //判断要读取的字节数是否最终超过文件总数
  if(off + n > inode->size)
    n = inode->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    blocknum = bmap(inode, off/BLOCK_SIZE);
    if(blocknum == 0){
      break;
    }
    buf = read_buf(inode->dev, blocknum);
    m = min((BLOCK_SIZE - off%BLOCK_SIZE), (n-tot));
    if(either_copyout(user_dst, dst, buf->data + (off % BLOCK_SIZE), m) == -1){
      relse_buf(buf);
      return -1;
    }
    relse_buf(buf);
  }
  return tot;
}

int write_inode(struct inode *inode, int user_src, uint64 src, uint off , uint n){
  uint tot, m;
  struct buffer *buf;

  if(off > inode->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BLOCK_SIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    uint blocknum = bmap(inode, off/BLOCK_SIZE);
    if(blocknum == 0)
      break;
    buf = read_buf(inode->dev, blocknum);
    m = min(n - tot, BLOCK_SIZE - off%BLOCK_SIZE);
    if(either_copyin(buf->data + (off %BLOCK_SIZE), user_src, src, m) == -1){
      relse_buf(buf);
      break;
    }
    log_write(buf);
    relse_buf(buf);

  }
  //To be continued...
  if(off > inode->size)
    inode->size = off;

  update_inode(inode);
  
  return tot;
}







//以下是对Dir的操作-----------------------
int 
compare_name(const char *s, const char *t){
  return strncmp(s, t, DIRSIZ);
}


struct inode*
lookup_dir(struct inode *inode, char *name, uint *poff){
  uint off, inum;
  struct dirent de;

  //判断inode文件类型是否是DIR
  if(inode->file_type != T_DIR)
    panic("lookup_dir: type is not DIR\n");

  for(off=0; off<inode->size; off+=sizeof(de)){
    if(read_inode(inode, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
      panic("lookup_dir read\n");
    if(de.inum == 0)
      continue;
    if(compare_name(name, de.name) == 0){
      if(poff)
        *poff = off;
      inum = de.inum;
      return get_inode(inode->dev, inum);
    }
  }

  return 0;
}

//构建一个dir
int
link_dir(struct inode *inode, char *name, uint inum){
  struct inode *ip;
  struct dirent de;
  int off;
  //已经存在这个目录了
  if((ip = lookup_dir(inode, name, 0)) != 0){
    putback_inode(ip);
    return -1;
  }
  
  for(off=0; off<inode->size; off+=sizeof(de)){
    if(read_inode(inode, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
      panic("link_dir read\n");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(write_inode(inode, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    return -1;

  return 0;
}

//以下是Path的操作-----------------------------
static char*
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
    path++;
  return path;
}


//用于路径名解析
static struct inode*
namex(char *path, int nameiparent, char *name){
  struct inode *ip, *next;

  if(*path == '/')
    ip = get_inode(ROOTDEV, ROOTINO);
  else
    ip = duplicate_inode(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    lock_inode(ip);
  if(ip->file_type != T_DIR){
      unlock_inode(ip);
      putback_inode(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      unlock_inode(ip);
      return ip;
    }
    if((next = lookup_dir(ip, name, 0)) == 0){
      unlock_inode(ip);
      putback_inode(ip);
      return 0;
    }
    unlock_inode(ip);
    putback_inode(ip);
    ip = next;
  }
  if(nameiparent){
    putback_inode(ip);
    return 0;
  }
  return ip;
}


struct inode*
namei(char *path){
  char name[DIRSIZ];
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
}