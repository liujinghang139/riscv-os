#include"./user.h"

void
test_syscalls(){
  printf("Testing basic system calls...\n");

  //测试getpid
  int pid = getpid();
  printf("Current PID: %d\n",pid);

  //测试fork
  int child_pid = fork();
  if(child_pid == 0){
    //子进程
    printf("Child process: PID = %d\n", getpid());
    exit(42);
  } else if(child_pid > 0){
    //父进程
    int status;
    wait(&status);
    printf("Child exited with status: %d\n", status);
  } else{
    printf("Fork failed\n");
  }
}


int
main(int argc, char *argv[])
{
  test_syscalls();

  exit(0);
}