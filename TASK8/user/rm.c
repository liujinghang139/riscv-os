#include "./user.h"

int
main(int argc, char *argv[])
{
  if(argc < 2){
    fprintf(2, "Usage: rm targets...\n");
    exit(1);
  }

  for(int i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
      exit(1);
    }
  }

  exit(0);
}
