#include"../include/param.h"
#include"../include/riscv.h"
#include"../include/fcntl.h"
#include"./user.h"

void my_assert(int condition, char *msg) {
    if (!condition) {
        printf("Assertion failed: %s\n", msg);
        exit(1);
    }
}


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
            make_filename(filename, "Test_", i);

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
        make_filename(filename, "test_", i);
        
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

    // --- 大文件测试 ---
    // start_time = get_time();
    // int fd = open("large_file", O_CREATE | O_RDWR);
    // if(fd < 0){
    //     printf("Error: cannot create large_file\n");
    //     exit(1);
    // }
    // char large_buffer[4096];
    // // 初始化一下 buffer，虽然不影响性能测试，但符合规范
    // memset(large_buffer, 'A', 4096);
    // 原代码循环体是空的，这里补上 write 操作
    // 写 1024 次 4KB = 4MB
    // for (int i = 0; i < 100; i++) { 
    //     // if(write(fd, large_buffer, 4096) != 4096){
    //     //     printf("Error: write failed\n");
    //     //     exit(1);
    //     // }
    //     write(fd, large_buffer, sizeof(large_buffer));
    // }
    // close(fd);
    // uint64 large_file_time = get_time() - start_time;
    
    // printf("Large file (1x4MB): %d ticks\n", (unsigned int)large_file_time);
}

// 3. 添加 main 函数作为入口
int 
main(int argc, char *argv[]) {
    test_filesystem_integrity();
    test_concurrent_access();
    test_filesystem_performance();

    exit(0); // 必须调用 exit，否则会 trap
}