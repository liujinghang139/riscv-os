#include"../../include/types.h"
#include"../../include/param.h"
#include"../../include/riscv.h"
#include"../../include/defs.h"
#include "../proc/spinlock.h"
#include "../proc/sleeplock.h"
#include "./fs.h"
#include "./bio.h"

int TEST_CRASH_ARMED = 0;

// Contents of the header block, used for both the on-disk header block
// and to keep track in memory of logged block# before commit.
struct logheader {
  int n;
  int block[LOGBLOCKS];
};

struct log {
  struct spinlock lock;
  int start;
  int outstanding; // how many FS sys calls are executing.
  int committing;  // in commit(), please wait.
  int dev;
  struct logheader lh;
};

struct log mylog;

static void recover_from_log(void);
static void commit();

void
init_log(int dev, struct super_block *sb)
{
  if (sizeof(struct logheader) >= BLOCK_SIZE)
    panic("initlog: too big logheader");

  init_lock(&mylog.lock, "log");
  mylog.start = sb->log_start;
  mylog.dev = dev;
  recover_from_log();
}

// Copy committed blocks from log to their home location
static void
install_trans(int recovering)
{
  int tail;

  for (tail = 0; tail < mylog.lh.n; tail++) {
    if(recovering) {
      printf("recovering tail %d dst %d\n", tail, mylog.lh.block[tail]);
    }
    struct buffer *lbuf = read_buf(mylog.dev, mylog.start+tail+1); // read log block
    struct buffer *dbuf = read_buf(mylog.dev, mylog.lh.block[tail]); // read dst
    memmove(dbuf->data, lbuf->data, BLOCK_SIZE);  // copy block to dst
    write_buf(dbuf);  // write dst to disk
    if(recovering == 0)
      unpin_buf(dbuf);
    relse_buf(lbuf);
    relse_buf(dbuf);
  }
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buffer *buf = read_buf(mylog.dev, mylog.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  mylog.lh.n = lh->n;
  for (i = 0; i < mylog.lh.n; i++) {
    mylog.lh.block[i] = lh->block[i];
  }
  relse_buf(buf);
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buffer *buf = read_buf(mylog.dev, mylog.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = mylog.lh.n;
  for (i = 0; i < mylog.lh.n; i++) {
    hb->block[i] = mylog.lh.block[i];
  }
  write_buf(buf);
  relse_buf(buf);
}

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
  mylog.lh.n = 0;
  write_head(); // clear the log
}

// called at the start of each FS system call.
void
begin_op(void)
{
  acquire(&mylog.lock);
  while(1){
    if(mylog.committing){
      sleep(&mylog.lock, &mylog);
    } else if(mylog.lh.n + (mylog.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
      // this op might exhaust log space; wait for commit.
      sleep(&mylog.lock, &mylog);
    } else {
      mylog.outstanding += 1;
      release(&mylog.lock);
      break;
    }
  }
}

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
  int do_commit = 0;

  acquire(&mylog.lock);
  mylog.outstanding -= 1;
  if(mylog.committing)
    panic("log.committing");
  if(mylog.outstanding == 0){
    do_commit = 1;
    mylog.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&mylog);
  }
  release(&mylog.lock);

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&mylog.lock);
    mylog.committing = 0;
    wakeup(&mylog);
    release(&mylog.lock);
  }
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < mylog.lh.n; tail++) {
    struct buffer *to = read_buf(mylog.dev, mylog.start+tail+1); // log block
    struct buffer *from = read_buf(mylog.dev, mylog.lh.block[tail]); // cache block
    memmove(to->data, from->data, BLOCK_SIZE);
    write_buf(to);  // write the log
    relse_buf(from);
    relse_buf(to);
  }
}

static void
commit()
{
  if (mylog.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    // [新增] 故障注入点：在提交之后，应用之前，模拟系统崩溃
    if(TEST_CRASH_ARMED){
        TEST_CRASH_ARMED = 0; // 防止重启后死循环（虽然内存会清空，但习惯上复位）
        printf("!!! TEST_CRASH: Simulating crash after log commit !!!\n");
        panic("simulated crash"); 
        // 此时 QEMU 会退出或卡住。
        // 期望结果：数据在 Log 中，但不在实际文件块中。
        // 重启后，recover_from_log 应该能恢复这些数据。
    }
    install_trans(0); // Nozw install writes to home locations
    mylog.lh.n = 0;
    write_head();    // Erase the transaction from the log
  }
}

// Caller has modified b->data and is done with the buffer.
// Record the block number and pin in the cache by increasing refcnt.
// commit()/write_log() will do the disk write.
//
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buffer *b)
{
  int i;

  acquire(&mylog.lock);
  if (mylog.lh.n >= LOGBLOCKS)
    panic("too big a transaction");
  if (mylog.outstanding < 1)
    panic("log_write outside of trans");

  for (i = 0; i < mylog.lh.n; i++) {
    if (mylog.lh.block[i] == b->blocknum)   // log absorption
      break;
  }
  mylog.lh.block[i] = b->blocknum;
  if (i == mylog.lh.n) {  // Add new block to log?
    pin_buf(b);
    mylog.lh.n++;
  }
  release(&mylog.lock);
}

