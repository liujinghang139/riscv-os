#include"../../include/defs.h"


void main(){
  console_init();
  pmm_init();
  kvm_init();
  kvm_inithart();
  proc_init();
  trap_init();
  trap_init_hart();
  // 初始化中断控制器需在设备与文件系统之前，确保外设中断可用
  plicinit();      // set up interrupt controller
  plicinithart();  // ask PLIC for device interrupts

  bio_init();
  itable_init();
  file_init();
  // 设备初始化依赖已就绪的 PLIC，否则磁盘 I/O 的睡眠将无法被中断唤醒
  virtio_disk_init();
  user_init();
  
 

  // test_printf_basic();
  // test_printf_edge_cases();

  
  // test_physical_memory();
  // test_pagetable();
  // test_virtual_memory();
  // test_timer_interrupt();
  // create_testproc();
  // test_synchronization();
  // test_syscalls();
  // test_filesystem_integrity();
  // printf_color(GREEN,"COMMON ON!\n");
  scheduler();
  
  printf("--------Dead Loop in the end of main.c---------\n");
  while(1){
    
  }
  
}
