// kernel/timer.c
#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "proc.h"
#include "spinlock.h"
volatile int interrupt_count = 0;
// 定义时钟间隔，约 10ms (取决于 QEMU 频率，通常是 10MHz)
#define INTERVAL 1000000 

static uint64 ticks; // 系统启动以来的滴答数

// 获取当前时间 (从 time 寄存器读取) [cite: 892]
uint64 get_time(void) {
    uint64 x;
    asm volatile("rdtime %0" : "=r" (x));
    return x;
}

// 初始化时钟
void timer_init() {
    // 设置第一次中断时间
    // 使用 stimecmp 直接设置
    w_stimecmp(get_time() + INTERVAL); 
    
    // 确保 S 模式中断开关打开了 (也可以在 trap_init 做)
    w_sie(r_sie() | SIE_STIE);
}

// 时钟中断处理函数 [cite: 898]
void timer_interrupt() {
    // 1. 设置下一次时钟中断时间，以维持周期性中断
    w_stimecmp(get_time() + INTERVAL);
    // 2. [关键] 增加测试计数器
    interrupt_count++;
    // 2. 更新系统时间计数
    ticks++;

    // 3. (可选) 打印信息证明中断正在工作 [cite: 961]
   // if((ticks % 100) == 0) {
       // printf("timer_interrupt: ticks=%d\n", ticks);
    //}
    if(myproc() != NULL && myproc()->state == RUNNING) {
        yield();
    }
    // 4. 触发任务调度 (实验5内容，此处暂时留空或仅做标记)
    // yield();
}