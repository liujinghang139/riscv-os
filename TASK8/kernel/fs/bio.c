#include"../../include/types.h"
#include"../../include/param.h"
#include"../../include/defs.h"
#include"../proc/sleeplock.h"
#include"./fs.h"
#include"./bio.h"

struct{
  struct spinlock lock;
  struct buffer head;
  struct buffer buf[NBUF];
} bcache;


void
bio_init(){
  struct buffer *buf;

  init_lock(&bcache.lock, "bcache");
  //创建LRU链表
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;

  for(buf = bcache.buf;buf < bcache.buf + NBUF;buf++){
    buf->next = bcache.head.next;
    buf->prev = &bcache.head; 
    init_sleeplock(&buf->lock, "buffer");
    bcache.head.next->prev = buf;
    bcache.head.next = buf;
  }

}


//使用LRU算法来访问buffer
static struct buffer*
get_buf(uint dev, uint block_num){
  struct buffer *b;
  
  acquire(&bcache.lock);

  for(b = bcache.head.next;b != &bcache.head; b = b->next){
    if(b->dev == dev && b->blocknum == block_num){
      b->refcnt++;
      release(&bcache.lock);
      acq_sleeplock(&b->lock);
      return b;
    }
  }

  //没找到buffer，分配最长时间没用的buf
  for(b = bcache.head.prev;b != &bcache.head;b = b->prev){
    if(b->refcnt == 0){
      b->blocknum = block_num;
      b->dev = dev;
      b->valid = 0;
      b->refcnt = 1;
      release(&bcache.lock);
      acq_sleeplock(&b->lock);
      return b;
    }
  }
  panic("get_buf():no available buffers\n");
}

//返回存有要查找内容的buffer
//不存在就从disk中获取
struct buffer *
read_buf(uint dev, uint block_num){
  struct buffer *buf;

  buf = get_buf(dev, block_num);
  if(!buf->valid){
    virtio_disk_rw(buf, 0);
    buf->valid = 1;
  }
  return buf;
}

void 
write_buf(struct buffer *buf){
  if(!holding_sleeplock(&buf->lock)){
    panic("write_buf\n");
  }
  virtio_disk_rw(buf,1);
}

void
relse_buf(struct buffer *buf){
  if(!holding_sleeplock(&buf->lock))
    panic("relse_buf\n");

  acquire(&bcache.lock);
  rel_sleeplock(&buf->lock);

  buf->refcnt--;
  if(buf->refcnt == 0){
    buf->prev->next = buf->next;
    buf->next->prev = buf->prev;
    buf->next = bcache.head.next;
    buf->prev = &bcache.head;
    bcache.head.next->prev = buf;
    bcache.head.next = buf;  
  }
  release(&bcache.lock);
}


void
pin_buf(struct buffer *b) {
  acquire(&bcache.lock);
  b->refcnt++;
  release(&bcache.lock);
}

void
unpin_buf(struct buffer *b) {
  acquire(&bcache.lock);
  b->refcnt--;
  release(&bcache.lock);
}