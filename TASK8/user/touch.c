#include "../include/fcntl.h"
#include "./user.h"

static int
create_file(const char *path)
{
  int fd = open(path, O_CREATE | O_WRONLY);
  if(fd < 0)
    return -1;
  close(fd);
  return 0;
}

int
main(int argc, char *argv[])
{
  if(argc < 2){
    fprintf(2, "Usage: touch files...\n");
    exit(1);
  }

  int status = 0;
  for(int i = 1; i < argc; i++){
    if(create_file(argv[i]) < 0){
      fprintf(2, "touch: %s failed\n", argv[i]);
      status = 1;
    }
  }

  exit(status);
}
