#include "../include/types.h"
#include "../kernel/fs/stat.h"
#include "../include/param.h"
#include"../include/fcntl.h"
#include "./user.h"


char *argv[] = { "shell", 0 };

int
main(void)
{
  int pid, wpid;

  
  // 1. 初始化文件描述符：确保 0, 1, 2 都指向控制台
  // 尝试打开控制台设备
  if(open("console", O_RDWR) < 0){
    // 如果打开失败，尝试创建一个名为 console 的设备节点
    // (主设备号 1, 次设备号 1 通常对应 console，具体取决于你的内核定义)
    makenode("console", 1, 1);
    open("console", O_RDWR); // 此时 fd = 0 (stdin)
    
  }
  
  // 复制 fd 0 到 fd 1 (stdout)
  duplicate(0); 
  // 复制 fd 0 到 fd 2 (stderr)
  duplicate(0);

  

  // 2. 进入死循环：负责启动 Shell 并监控它
  for(;;){
    printf("init: starting shell\n");
    
    pid = fork();
    if(pid < 0){
      printf("init: fork failed\n");
      exit(1);
    }
    
    if(pid == 0){
      // --- 子进程逻辑 ---
      // 执行 shell 程序
      exec("shell", argv);
      
      // 如果 exec 返回了，说明出错了（比如找不到 shell 文件）
      printf("init: exec shell failed\n");
      exit(1);
    }

    // --- 父进程 (init) 逻辑 ---
    // 等待子进程退出。
    // 注意：init 还有一个职责是回收所有"孤儿进程"（父进程先退出的进程）。
    for(;;){
      // wait 返回退出的子进程 PID
      wpid = wait((int *) 0);
      
      if(wpid == pid){
        // 如果退出的正是我们启动的 shell，
        // 那么跳出内层循环，回到外层循环重新启动一个新的 shell
        break; 
      }
      
      if(wpid < 0){
        printf("init: wait returned an error\n");
        exit(1);
      }
      
      // 如果 wpid != pid，说明这是别的孤儿进程退出了，
      // init 负责收尸（wait 已经回收了），然后继续等 shell。
    }
  }
}