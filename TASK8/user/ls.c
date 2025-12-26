#include "../include/types.h"
#include "../include/fcntl.h"
#include "./user.h"

#define DIRSIZ 14

struct dirent {
  ushort inum;
  char name[DIRSIZ];
};

static void
emit_name(const char *name)
{
  printf("%s\n", name);
}

static void
ls(const char *path)
{
  struct dirent de;
  int fd = open(path, O_RDONLY);
  if(fd < 0){
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  int saw_dir = 0;
  while(read(fd, &de, sizeof(de)) == sizeof(de)){
    if(de.inum == 0)
      continue;

    char name[DIRSIZ + 1];
    int i;
    for(i = 0; i < DIRSIZ && de.name[i]; i++)
      name[i] = de.name[i];
    name[i] = '\0';

    if(name[0] == '\0')
      continue;
    if(name[0] == '.' && (name[1] == '\0' || (name[1] == '.' && name[2] == '\0')))
      continue;

    emit_name(name);
    saw_dir = 1;
  }

  close(fd);

  if(!saw_dir)
    emit_name(path);
}

int
main(int argc, char *argv[])
{
  if(argc <= 1){
    ls(".");
    exit(0);
  }

  for(int i = 1; i < argc; i++)
    ls(argv[i]);

  exit(0);
}
