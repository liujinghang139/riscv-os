#include"../../include/types.h"
#include"../../include/riscv.h"
#include"../../include/param.h"
#include"../../include/fcntl.h"
#include"../../include/memlayout.h"
#include"../../include/defs.h"
#include"proc.h"
#include"spinlock.h"
#include"sleeplock.h"
#include"fs.h"
#include"file.h"

static int
argfd(int n, int *pfd, struct file **pf)
{
  int fd;
  struct file *f;

  argint(n, &fd);
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}

static int
fd_alloc(struct file *file)
{
  int fd;
  struct proc *p = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd] == 0){
      p->ofile[fd] = file;
      return fd;
    }
  }
  return -1;
}



uint64
sys_read(void)
{
  struct file *f;
  int n;
  uint64 p;

  argaddr(1, &p);
  argint(2, &n);
  if(argfd(0, 0, &f) < 0)
    return -1;
  return fileread(f, p, n);
}

uint64
sys_write(void)
{
  struct file *f;
  int n;
  uint64 p;

  argaddr(1, &p);
  argint(2, &n);
  if(argfd(0, 0, &f) < 0)
    return -1;
  return filewrite(f, p, n);
}



uint64
sys_chdir(void)
{
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
  struct inode *old;
  
  begin_op();
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  lock_inode(ip);
  if(ip->type != T_DIR){
    unlock_inode(ip);
    putback_inode(ip);
    end_op();
    return -1;
  }
  unlock_inode(ip);
  end_op();
  old = p->cwd;
  p->cwd = ip;
  if(old)
    putback_inode(old);
  return 0;
}


uint64
sys_duplicate(void)
{
  struct file *file;
  int fd;

  if(argfd(0, 0, &file) < 0)
    return -1;
  if((fd=fd_alloc(file)) < 0)
    return -1;
  filedup(file);
  return fd;
}


static struct inode*
create(char *path, short type, short major, short minor)
{
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;

  lock_inode(dp);

  if((ip = lookup_dir(dp, name, 0)) != 0){
    unlock_inode(dp);
    putback_inode(dp);
    lock_inode(ip);
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
      return ip;
    unlock_inode(ip);
    putback_inode(ip);
    return 0;
  }

  if((ip = alloc_inode(dp->dev, type)) == 0){
    unlock_inode(dp);
    putback_inode(dp);
    return 0;
  }

  lock_inode(ip);
  ip->major = major;
  ip->minor = minor;
  ip->nlink = 1;
  update_inode(ip);

  if(type == T_DIR){  // Create . and .. entries.
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(link_dir(ip, ".", ip->inum) < 0 || link_dir(ip, "..", dp->inum) < 0)
      goto fail;
  }

  if(link_dir(dp, name, ip->inum) < 0)
    goto fail;

  if(type == T_DIR){
    // now that success is guaranteed:
    dp->nlink++;  // for ".."
    update_inode(dp);
  }

  unlock_inode(dp);
  putback_inode(dp);


  return ip;

 fail:
  // something went wrong. de-allocate ip.
  ip->nlink = 0;
  update_inode(ip);
  unlock_inode(ip);
  putback_inode(ip);
  unlock_inode(dp);
  putback_inode(dp);
  return 0;
}


static int
is_dir_empty(struct inode *ip)
{
  struct dirent de;

  for(uint off = 2 * sizeof(de); off < ip->size; off += sizeof(de)){
    if(read_inode(ip, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: read");
    if(de.inum != 0)
      return 0;
  }
  return 1;
}


uint64
sys_makenode(void)
{
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
  argint(1, &major);
  argint(2, &minor);
  if((argstr(0, path, MAXPATH)) < 0 ||
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    end_op();
    return -1;
  }
  unlock_inode(ip);
  putback_inode(ip);
  end_op();
  return 0;
}


uint64
sys_close(void)
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}

uint64
sys_open(void)
{
  char path[MAXPATH];
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
  if((n = argstr(0, path, MAXPATH)) < 0)
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    lock_inode(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
      unlock_inode(ip);
      putback_inode(ip);
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    unlock_inode(ip);
    putback_inode(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fd_alloc(f)) < 0){
    if(f)
      fileclose(f);
    unlock_inode(ip);
    putback_inode(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    f->off = 0;
  }
  f->ip = ip;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);

  if((omode & O_TRUNC) && ip->type == T_FILE){
    truncate_inode(ip);
  }

  unlock_inode(ip);
  end_op();

  return fd;
}


uint64
sys_mkdir(void)
{
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
  if(argstr(0, path, MAXPATH) < 0){
    end_op();
    return -1;
  }

  if((ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
    return -1;
  }

  unlock_inode(ip);
  putback_inode(ip);
  end_op();

  return 0;
}


int 
sys_unlink(void)
{
  char path[MAXPATH];
  char name[DIRSIZ];
  struct inode *dp;
  struct inode *ip;
  struct dirent de;
  uint off;

  begin_op();

  if(argstr(0, path, MAXPATH) < 0){
    end_op();
    return -1;
  }

  if((dp = nameiparent(path, name)) == 0){
    end_op();
    return -1;
  }

  lock_inode(dp);

  if(compare_name(name, ".") == 0 || compare_name(name, "..") == 0){
    unlock_inode(dp);
    putback_inode(dp);
    end_op();
    return -1;
  }

  if((ip = lookup_dir(dp, name, &off)) == 0){
    unlock_inode(dp);
    putback_inode(dp);
    end_op();
    return -1;
  }

  lock_inode(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");

  if(ip->type == T_DIR && !is_dir_empty(ip)){
    unlock_inode(ip);
    putback_inode(ip);
    unlock_inode(dp);
    putback_inode(dp);
    end_op();
    return -1;
  }

  memset(&de, 0, sizeof(de));
  if(write_inode(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: write");

  if(ip->type == T_DIR){
    dp->nlink--;
    update_inode(dp);
  }

  unlock_inode(dp);
  putback_inode(dp);

  ip->nlink--;
  update_inode(ip);
  unlock_inode(ip);
  putback_inode(ip);

  end_op();
  return 0;
}