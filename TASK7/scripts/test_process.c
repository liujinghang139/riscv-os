#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "proc.h"
#include "spinlock.h"
#define NPROC 64
extern struct proc proc[NPROC];
// --- 辅助任务函数 (供测试使用) ---

// 1. 简单任务：什么都不做直接退出
void simple_task(void) {
    exit_process(0);
}

// 2. 计算密集型任务：占用 CPU 一段时间
void cpu_intensive_task(void) {
    // 简单的忙等待循环
    for (volatile int i = 0; i < 10000000; i++);
    exit_process(0);
}

// 3. 生产者-消费者任务 (用于同步测试)
#define BUFFER_SIZE 5
int buffer[BUFFER_SIZE];
int in = 0, out = 0, count = 0;
struct spinlock lock;

void producer_task(void) {
    for (int i = 0; i < 10; i++) {
        acquire(&lock);
        while (count == BUFFER_SIZE) {
            sleep(&in, &lock); // 缓冲区满，休眠
        }
        buffer[in] = i;
        in = (in + 1) % BUFFER_SIZE;
        count++;
        wakeup(&out); // 唤醒消费者
        release(&lock);
    }
    exit_process(0);
}

void consumer_task(void) {
    for (int i = 0; i < 10; i++) {
        acquire(&lock);
        while (count == 0) {
            sleep(&out, &lock); // 缓冲区空，休眠
        }
        // int item = buffer[out]; // 读取数据 (可选打印)
        out = (out + 1) % BUFFER_SIZE;
        count--;
        wakeup(&in); // 唤醒生产者
        release(&lock);
    }
    exit_process(0);
}

void shared_buffer_init(void) {
    initlock(&lock, "buffer_lock");
}

//核心测试函数
void test_process_creation(void) {
    printf("Testing process creation...\n");
    
    // 1. 测试基本的进程创建
    int pid = create_process(simple_task);
    assert(pid > 0);

    // 2. 测试进程表限制 (尝试创建超过 NPROC 个进程)
    //int pids[NPROC];
    int count = 0;
    
    for (int i = 0; i < NPROC + 5; i++) {
        int pid = create_process(simple_task);
        if (pid > 0) {
            //pids[count++] = pid;
            count++;
        } else {
            // 预期：当进程表满时，应该返回错误（如 0 或 -1）并跳出循环
            break; 
        }
    }
    
    printf("Created %d processes\n", count);

    // 3. 清理测试进程
    for (int i = 0; i < count; i++) {
        wait_process(NULL);
    }
}
void test_scheduler(void) {
    printf("Testing scheduler...\n");
    
    // 创建多个计算密集型进程
    for (int i = 0; i < 3; i++) {
        create_process(cpu_intensive_task);
    }

    // 观察调度行为
    uint64 start_time = get_time();
    
    // 让主进程休眠，触发调度器去运行上面的子进程
    // 注意：sleep 的参数单位取决于你的实现 (ticks 或 ms)
    //sleep(100000); 
    for (volatile int i = 0; i < 50000000; i++);
    // 等待所有子进程
    //for(int i=0; i<3; i++) wait_process(NULL);
    uint64 end_time = get_time();

    printf("Scheduler test completed in %d cycles\n", (int)(end_time - start_time));
}
void test_synchronization(void) {
    // 初始化共享缓冲区 (需要你实现 shared_buffer_init)
    shared_buffer_init();

    // 测试生产者-消费者场景
    create_process(producer_task);
    create_process(consumer_task);

    // 等待两个子进程完成
    wait_process(NULL);
    wait_process(NULL);

    printf("Synchronization test completed\n");
}
void debug_proc_table(void) {
    printf("=== Process Table ===\n");
    
    for (int i = 0; i < NPROC; i++) {
        struct proc *p = &proc[i];
        if (p->state != UNUSED) {
            // 打印 PID、状态和进程名
            // 注意：需要确保你的 struct proc 中有这些字段
            printf("PID:%d State:%d Name: %s\n", 
                   p->pid, p->state, p->name);
        }
    }
}