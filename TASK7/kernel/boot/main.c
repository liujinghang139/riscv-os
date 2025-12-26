#include "defs.h"
#include "buf.h" 
#include "fs.h"
#include "file.h"   // 提供 struct inode 定义
#include "stat.h"   // 提供 T_FILE 定义
#include "param.h"  // 提供 ROOTDEV 等定义
extern void uart_puts(const char *s);
volatile static int started = 0;
// 根测试任务
void test_runner(void) {
    printf("--- Starting Experiment 5 Tests ---\n");
    
    test_process_creation();
    test_scheduler();
    test_synchronization();
    
    printf("--- All Tests Passed! ---\n");
    
    // 测试结束，进入死循环
    for(;;) yield();
}

void main() {
    printf("Hello myOS! RISC-V single core console ready.\n");
    pmm_init();
    kvminit();
    kvminithart();
    //test_physical_memory();
    //test_pagetable();
    //test_virtual_memory();
    trap_init();      // 初始化中断向量表
    timer_init();     // 初始化时钟并设置第一次中断
    procinit();       // [新增] 进程表初始化
    //printf("System initialized. Starting scheduler...\n");
    printf("Initializing File System...\n");
    plic_init();     // <--- 新增
    plic_inithart(); // <--- 新增
    virtio_disk_init(); // 1. 初始化磁盘驱动
    bio_init();          // 2. 初始化缓存
     itable_init();
   file_init();
    //fileinit();         // 3. 初始化文件表
    //iinit();            // 4. 初始化 Inode 表
    //struct buf *bp = bread(ROOTDEV, 1); // 读取超级块 (Block 1)
   // struct superblock sb;
    //memmove(&sb, bp->data, sizeof(sb));
    //brelse(bp);
    //initlog(ROOTDEV, &sb); // 初始化日志
    ////test_filesystem();
    
    // 开启全局中断，等待时钟中断发生
    //intr_on();
    //test_timer_interrupt();
    //test_exception_handling();
    //test_interrupt_overhead(); 
    //printf_color(32, -1, 1, "ALL test is ok!\n"); // 绿色加粗
    //intr_off(); 
    // 创建第一个进程：运行测试套件
    //create_process(test_runner);
    userinit();
    //printf("System initialized. Starting scheduler...\n");
    scheduler();
    printf("Tests finished.\n");
    
     for(;;) { __asm__ volatile("wfi"); }
    //char line[64];
    //for (;;) {
      //  printf("> ");
       // int n = console_readline(line, sizeof(line));
        //if (n == 0) {
           // printf("\nEOF (^D). Halting.\n");
           // for(;;)__asm__ volatile("wfi");
       // }
        //printf("you typed (%d): %s\n", n, line);
  //  }
}

