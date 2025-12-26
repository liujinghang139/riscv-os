#include "proc.h"
#include "buf.h" 
#include "fs.h"
#include"../include/fcntl.h"
#include "file.h"   // 提供 struct inode 定义
#include "stat.h"   // 提供 T_FILE 定义// 提供 memset 定义
#include "param.h"  // 提供 ROOTDEV 等定义
#include "../user/user.h" // 包含 write, read, close, unlink 等声明


// 声明标准库函数(如果未包含头文件)
int getpid(void);
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int open(const char*, int);
int crash_arm(void);
uint strlen(const char *s) ;
void printf(const char*, ...);
uint64 get_time(void); // 对应 sys_uptime 或类似的系统调用
// 定义 assert 宏，如果条件不满足则打印错误并退出
#define assert(x) \
    do { \
        if (!(x)) { \
            printf("ASSERT FAILED: %s:%d\n", __FILE__, __LINE__); \
            exit(1); \
        } \
    } while (0)

void test_filesystem_integrity(void) {
    printf("Testing filesystem integrity…\n");
    // 创建测试文件
    int fd = open("testfile", O_CREATE | O_RDWR);

    if(fd < 0){
        printf("Error: cannot create file 'testfile'\n");
        exit(1);
    }

    // 写入数据
    char buffer[] = "Hello, filesystem!";
    int bytes = write(fd, buffer, strlen(buffer));
    int len = strlen(buffer);
    // 验证写入字节数
    if(bytes != len){
        printf("Error: write incomplete. Expected %d, wrote %d\n", len, bytes);
        close(fd);
        exit(1);
    }

    close(fd);
    // 重新打开并验证
    fd = open("testfile", O_RDONLY);
    if(fd < 0){
        printf("Error: cannot open 'testfile' for reading\n");
        exit(1);
    }
    char read_buffer[64];
    bytes = read(fd, read_buffer, 
    sizeof(read_buffer));
    read_buffer[bytes] = '\0';

    if(bytes < 0){
        printf("Error: read failed\n");
        exit(1);
    }
    close(fd);
    // 删除文件
    // 4. 删除文件 (unlink 是 xv6 中删除文件的系统调用)
    if(unlink("testfile") < 0){
        printf("Error: unlink (delete) failed\n");
        exit(1);
    }

    printf("Filesystem integrity test passed\n");
}


void test_concurrent_access(void) {
    printf("Testing concurrent file access...\n");

    // 创建 4 个子进程同时访问文件系统
    for (int i = 0; i < 4; i++) {
        int pid = fork();
        
        if(pid < 0){
            printf("fork failed\n");
            exit(1);
        }

        if (pid == 0) {
            // --- 子进程逻辑 ---
            char filename[32];
            // 手动生成文件名，例如 "test_0"
            snprintf(filename, sizeof(filename), "test_%d", i);
            //make_filename(filename, "Test_", i);

            for (int j = 0; j < 100; j++) {
                // 打开/创建文件
                int fd = open(filename, O_CREATE | O_RDWR);
                
                if (fd >= 0) {
                    // 写入数据
                    if(write(fd, &j, sizeof(j)) != sizeof(j)){
                        printf("write failed\n");
                    }
                    close(fd);
                    
                    // 删除文件
                    // 在高并发下 unlink 可能会因为文件被其他进程占用而暂时失败（但在 xv6 简单实现中通常没问题）
                    unlink(filename);
                } else {
                    // 打开失败（可能并发导致）
                    // printf("open failed for %s\n", filename);
                }
            }
            // 子进程任务完成，必须退出！
            exit(0);
        }
    }

    // 父进程：等待所有子进程完成
    // xv6 的 wait 接收一个地址来存状态，或者传 0 忽略
    for (int i = 0; i < 4; i++) {
        wait(0);
    }

    printf("Concurrent access test completed\n");
}

void test_filesystem_performance() {
  
    printf("Testing filesystem performance...\n");
    
    uint64 start_time = get_time();
    
    // --- 大量小文件测试 ---
    char filename[32];
    for (int i = 0; i < 100; i++) { // 为了不打爆xv6有限的inode，先测试100个
        // 手动生成文件名，例如 "s_0", "s_1"
        snprintf(filename, sizeof(filename), "small_%d", i);
        //make_filename(filename, "test_", i);
        
        int fd = open(filename, O_CREATE | O_RDWR);
        if(fd < 0){
            printf("Error: cannot create file %s\n", filename);
            exit(1);
        }
        write(fd, "test", 4);
        close(fd);
    }
    uint64 small_files_time = get_time() - start_time;
    
    printf("Files (100x4B): %d ticks\n", (unsigned int)small_files_time);

     //--- 大文件测试 ---
    //start_time = get_time();
    //int fd = open("large_file", O_CREATE | O_RDWR);
    // if(fd < 0){
       // printf("Error: cannot create large_file\n");
        //exit(1);
   // }
    // char large_buffer[4096];
    // 初始化一下 buffer，虽然不影响性能测试，但符合规范
    //memset(large_buffer, 'A', 4096);
    // 原代码循环体是空的，这里补上 write 操作
    // 写 1024 次 4KB = 4MB
    // for (int i = 0; i < 100; i++) { 
    //     if(write(fd, large_buffer, 4096) != 4096){
    //         printf("Error: write failed\n");
    //         exit(1);
    //     }
    //     write(fd, large_buffer, sizeof(large_buffer));
    // }
    // close(fd);
    // uint64 large_file_time = get_time() - start_time;
    
    // printf("Large file (1x4MB): %d ticks\n", (unsigned int)large_file_time);
}
void test_crash_recovery(void){
    int fd;
    char buf[10];

    printf("Starting User-Space Crash Recovery Test...\n");

    // 1. 尝试打开测试文件
    fd = open("crash_file", O_RDWR);

    if (fd >= 0) {
        // --- 恢复阶段 ---
        printf("Found crash_file! Checking content...\n");
        read(fd, buf, 5);
        if (buf[0] == 'H' && buf[4] == 'o') {
            printf("[PASS] Data persisted after crash!\n");
        } else {
            printf("[FAIL] Data corrupted or lost.\n");
        }
        close(fd);
        // 清理文件 
        unlink("crash_file");
    } else {
        // --- 崩溃阶段 ---
        printf("Phase 1: Creating file and triggering crash...\n");
        
        // 创建文件
        fd = open("crash_file", O_CREATE | O_RDWR);
        if(fd < 0){
            printf("Error: create failed\n");
            exit(1);
        }

        // 【关键】调用我们新加的系统调用，"埋雷"
        // 这会设置内核变量 TEST_CRASH_ARMED = 1
        crash_arm(); 

        // 写入数据
        // 这个 write 系统调用进入内核后，会经过日志提交(commit)
        // 在 commit 完成但数据未落盘时，内核会根据 TEST_CRASH_ARMED 触发 panic
        printf("Writing data... (System should crash now)\n");
        write(fd, "Hello", 5);

        // 如果程序跑到了这里，说明没崩溃，测试失败
        printf("[FAIL] System did not crash!\n");
    }

    exit(0);
}
// 3. 添加 main 函数作为入口
int  main(void) {
    test_filesystem_integrity();
    test_concurrent_access();
    test_filesystem_performance();
    test_crash_recovery();
    return 0;// 必须调用 exit，否则会 trap
}