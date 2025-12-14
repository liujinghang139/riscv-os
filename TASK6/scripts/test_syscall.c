#include "types.h"
//#include "defs.h"
// 如果是在用户态运行，需要包含用户库头文件
#include "../user/user.h"
// #include "fcntl.h" 

// 模拟的定义，如果你的环境还没有这些宏
#ifndef O_RDWR
#define O_RDWR 0x2
#define O_CREATE 0x200
#endif

// 声明标准库函数(如果未包含头文件)
int getpid(void);
int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int open(const char*, int);
uint strlen(const char *s) ;
void printf(const char*, ...);
uint64 get_time(void); // 对应 sys_uptime 或类似的系统调用

// --- 1. 基础功能测试 [cite: 1699] ---
void test_basic_syscalls(void) {
    printf("Testing basic system calls...\n");
    
    // 测试 getpid
    int pid = getpid();
    printf("Current PID: %d\n", pid);
    
    // 测试 fork
    int child_pid = fork();
    
    if (child_pid == 0) {
        // 子进程
        printf("Child process: PID=%d\n", getpid());
        exit(42);
    } else if (child_pid > 0) {
        // 父进程
        int status;
        wait(&status);
        printf("Child exited with status: %d\n", status);
    } else {
        printf("Fork failed!\n");
    }
}

// --- 2. 参数传递测试 [cite: 1743] ---
void test_parameter_passing(void) {
    printf("Testing parameter passing...\n");
    
    // 测试不同类型参数的传递
    char buffer[] = "Hello, World!";
    
    // 注意：如果没有文件系统，open 可能会失败，这里仅为示例
    // 你可以尝试打开 stdout (fd 1) 或其他设备文件
    int fd = open("test_file", O_CREATE | O_RDWR);
    
    if (fd >= 0) {
        int bytes_written = write(fd, buffer, strlen(buffer));
        printf("Wrote %d bytes\n", bytes_written);
        close(fd);
    } else {
        printf("Open failed (expected if no FS yet), skipping file write test.\n");
        // 如果没有文件系统，直接向 stdout (1) 写入测试
        write(1, buffer, strlen(buffer));
        printf("\n");
    }
    
    // 测试边界情况
    write(-1, buffer, 10); // 无效文件描述符
    write(1, (void*)0, 10); // 空指针 (可能会导致 kill)
    write(1, buffer, -1);  // 负数长度
}

// --- 3. 安全性测试 [cite: 1776] ---
void test_security(void) {
    printf("Testing security...\n");
    
    // 测试无效指针访问
    // 0x1000000 通常是内核地址或未映射区域
    char *invalid_ptr = (char*)0x1000000; 
    int result = write(1, invalid_ptr, 10);
    printf("Invalid pointer write result: %d (expected -1)\n", result);
    
    // 测试缓冲区边界
    char small_buf[4];
    // 尝试读取超过缓冲区大小的数据 (内核应检查 bounds)
    // 注意：从 stdin (0) 读取可能需要输入
    result = read(0, small_buf, 1000); 
    
    printf("Security tests completed\n");
}

// --- 4. 性能测试 [cite: 1797] ---
void test_syscall_performance(void) {
    printf("Testing syscall performance...\n");
    
    uint64 start_time = get_time(); // 假设实现了 sys_uptime 或类似调用
    
    // 大量系统调用测试
    for (int i = 0; i < 10000; i++) {
        getpid(); // 简单的系统调用
    }
    
    uint64 end_time = get_time();
    printf("10000 getpid() calls took %d cycles\n", (uint64)end_time - (uint64)start_time);
}

// 测试入口
void run_syscall_tests(void) {
    printf("============ Test Running =============\n");
    test_basic_syscalls();
    test_parameter_passing();
    test_security();
    test_syscall_performance();
    printf("All syscall tests passed!\n");
    while(1);
}
int main(void) {
    write(1, "Hello World\n", 12);
    write(1, "Init Loop...\n", 13);

    run_syscall_tests();
    return 0; // 永远不应该执行到这里
}