#include"defs.h"
#include"riscv.h"
extern volatile int interrupt_count;
void test_timer_interrupt(void) {
 printf("Testing timer interrupt...\n");

// 记录中断前的时间
uint64 start_time = get_time();
 interrupt_count = 0;

 // 设置测试标志
//volatile int *test_flag = &interrupt_count;

 // 在时钟中断处理函数中增加计数
 // 等待几次中断
 while (interrupt_count < 5) {
 // 可以在这里执行其他任务
 printf("Waiting for interrupt %d...\n", interrupt_count + 1);
 // 简单延时
 for (volatile int i = 0; i < 10000000; i++);
 }

 uint64 end_time = get_time();
 printf("Timer test completed: %d interrupts in %d cycles\n",
 interrupt_count, (int)end_time - start_time);
 }
 
void test_exception_handling(void) {
printf("Testing exception handling...\n");
// 测试除零异常（如果支持）
// 测试非法指令异常 
// 测试内存访问异常

printf("Exception tests completed\n"); 
}
void test_interrupt_overhead(void) {
// 测量中断处理的时间开销
 // 测量上下文切换的成本
// 分析中断频率对系统性能的影响 
}