
user/_test_file:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <my_assert>:
#include"../include/riscv.h"
#include"../include/fcntl.h"
#include"./user.h"

void my_assert(int condition, char *msg) {
    if (!condition) {
   0:	c111                	beqz	a0,4 <my_assert+0x4>
   2:	8082                	ret
void my_assert(int condition, char *msg) {
   4:	1141                	add	sp,sp,-16
   6:	e406                	sd	ra,8(sp)
   8:	e022                	sd	s0,0(sp)
   a:	0800                	add	s0,sp,16
        printf("Assertion failed: %s\n", msg);
   c:	00001517          	auipc	a0,0x1
  10:	e1450513          	add	a0,a0,-492 # e20 <malloc+0xe6>
  14:	00001097          	auipc	ra,0x1
  18:	c6e080e7          	jalr	-914(ra) # c82 <printf>
        exit(1);
  1c:	4505                	li	a0,1
  1e:	00001097          	auipc	ra,0x1
  22:	806080e7          	jalr	-2042(ra) # 824 <exit>

0000000000000026 <test_filesystem_integrity>:
    }
}


void test_filesystem_integrity(void) {
  26:	7119                	add	sp,sp,-128
  28:	fc86                	sd	ra,120(sp)
  2a:	f8a2                	sd	s0,112(sp)
  2c:	f4a6                	sd	s1,104(sp)
  2e:	f0ca                	sd	s2,96(sp)
  30:	0100                	add	s0,sp,128
    printf("Testing filesystem integrity…\n");
  32:	00001517          	auipc	a0,0x1
  36:	e0650513          	add	a0,a0,-506 # e38 <malloc+0xfe>
  3a:	00001097          	auipc	ra,0x1
  3e:	c48080e7          	jalr	-952(ra) # c82 <printf>
    // 创建测试文件
    int fd = open("testfile", O_CREATE | O_RDWR);
  42:	20200593          	li	a1,514
  46:	00001517          	auipc	a0,0x1
  4a:	e1a50513          	add	a0,a0,-486 # e60 <malloc+0x126>
  4e:	00000097          	auipc	ra,0x0
  52:	7f6080e7          	jalr	2038(ra) # 844 <open>

    if(fd < 0){
  56:	0c054b63          	bltz	a0,12c <test_filesystem_integrity+0x106>
  5a:	84aa                	mv	s1,a0
        printf("Error: cannot create file 'testfile'\n");
        exit(1);
    }

    // 写入数据
    char buffer[] = "Hello, filesystem!";
  5c:	00001797          	auipc	a5,0x1
  60:	efc78793          	add	a5,a5,-260 # f58 <malloc+0x21e>
  64:	6394                	ld	a3,0(a5)
  66:	6798                	ld	a4,8(a5)
  68:	fcd43423          	sd	a3,-56(s0)
  6c:	fce43823          	sd	a4,-48(s0)
  70:	0107d703          	lhu	a4,16(a5)
  74:	fce41c23          	sh	a4,-40(s0)
  78:	0127c783          	lbu	a5,18(a5)
  7c:	fcf40d23          	sb	a5,-38(s0)
    int bytes = write(fd, buffer, strlen(buffer));
  80:	fc840513          	add	a0,s0,-56
  84:	00000097          	auipc	ra,0x0
  88:	4ee080e7          	jalr	1262(ra) # 572 <strlen>
  8c:	0005061b          	sext.w	a2,a0
  90:	fc840593          	add	a1,s0,-56
  94:	8526                	mv	a0,s1
  96:	00000097          	auipc	ra,0x0
  9a:	7c6080e7          	jalr	1990(ra) # 85c <write>
  9e:	892a                	mv	s2,a0
    int len = strlen(buffer);
  a0:	fc840513          	add	a0,s0,-56
  a4:	00000097          	auipc	ra,0x0
  a8:	4ce080e7          	jalr	1230(ra) # 572 <strlen>
  ac:	2501                	sext.w	a0,a0
    // 验证写入字节数
    if(bytes != len){
  ae:	08a91c63          	bne	s2,a0,146 <test_filesystem_integrity+0x120>
        printf("Error: write incomplete. Expected %d, wrote %d\n", len, bytes);
        close(fd);
        exit(1);
    }

    close(fd);
  b2:	8526                	mv	a0,s1
  b4:	00000097          	auipc	ra,0x0
  b8:	788080e7          	jalr	1928(ra) # 83c <close>
    // 重新打开并验证
    fd = open("testfile", O_RDONLY);
  bc:	4581                	li	a1,0
  be:	00001517          	auipc	a0,0x1
  c2:	da250513          	add	a0,a0,-606 # e60 <malloc+0x126>
  c6:	00000097          	auipc	ra,0x0
  ca:	77e080e7          	jalr	1918(ra) # 844 <open>
  ce:	84aa                	mv	s1,a0
    if(fd < 0){
  d0:	08054f63          	bltz	a0,16e <test_filesystem_integrity+0x148>
        printf("Error: cannot open 'testfile' for reading\n");
        exit(1);
    }
    char read_buffer[64];
    bytes = read(fd, read_buffer, 
  d4:	04000613          	li	a2,64
  d8:	f8840593          	add	a1,s0,-120
  dc:	00000097          	auipc	ra,0x0
  e0:	778080e7          	jalr	1912(ra) # 854 <read>
    sizeof(read_buffer));
    read_buffer[bytes] = '\0';
  e4:	fe050793          	add	a5,a0,-32
  e8:	97a2                	add	a5,a5,s0
  ea:	fa078423          	sb	zero,-88(a5)

    if(bytes < 0){
  ee:	08054d63          	bltz	a0,188 <test_filesystem_integrity+0x162>
        printf("Error: read failed\n");
        exit(1);
    }
    close(fd);
  f2:	8526                	mv	a0,s1
  f4:	00000097          	auipc	ra,0x0
  f8:	748080e7          	jalr	1864(ra) # 83c <close>
    // 删除文件
    // 4. 删除文件 (unlink 是 xv6 中删除文件的系统调用)
    if(unlink("testfile") < 0){
  fc:	00001517          	auipc	a0,0x1
 100:	d6450513          	add	a0,a0,-668 # e60 <malloc+0x126>
 104:	00000097          	auipc	ra,0x0
 108:	790080e7          	jalr	1936(ra) # 894 <unlink>
 10c:	08054b63          	bltz	a0,1a2 <test_filesystem_integrity+0x17c>
        printf("Error: unlink (delete) failed\n");
        exit(1);
    }

    printf("Filesystem integrity test passed\n");
 110:	00001517          	auipc	a0,0x1
 114:	e2050513          	add	a0,a0,-480 # f30 <malloc+0x1f6>
 118:	00001097          	auipc	ra,0x1
 11c:	b6a080e7          	jalr	-1174(ra) # c82 <printf>
}
 120:	70e6                	ld	ra,120(sp)
 122:	7446                	ld	s0,112(sp)
 124:	74a6                	ld	s1,104(sp)
 126:	7906                	ld	s2,96(sp)
 128:	6109                	add	sp,sp,128
 12a:	8082                	ret
        printf("Error: cannot create file 'testfile'\n");
 12c:	00001517          	auipc	a0,0x1
 130:	d4450513          	add	a0,a0,-700 # e70 <malloc+0x136>
 134:	00001097          	auipc	ra,0x1
 138:	b4e080e7          	jalr	-1202(ra) # c82 <printf>
        exit(1);
 13c:	4505                	li	a0,1
 13e:	00000097          	auipc	ra,0x0
 142:	6e6080e7          	jalr	1766(ra) # 824 <exit>
        printf("Error: write incomplete. Expected %d, wrote %d\n", len, bytes);
 146:	864a                	mv	a2,s2
 148:	85aa                	mv	a1,a0
 14a:	00001517          	auipc	a0,0x1
 14e:	d4e50513          	add	a0,a0,-690 # e98 <malloc+0x15e>
 152:	00001097          	auipc	ra,0x1
 156:	b30080e7          	jalr	-1232(ra) # c82 <printf>
        close(fd);
 15a:	8526                	mv	a0,s1
 15c:	00000097          	auipc	ra,0x0
 160:	6e0080e7          	jalr	1760(ra) # 83c <close>
        exit(1);
 164:	4505                	li	a0,1
 166:	00000097          	auipc	ra,0x0
 16a:	6be080e7          	jalr	1726(ra) # 824 <exit>
        printf("Error: cannot open 'testfile' for reading\n");
 16e:	00001517          	auipc	a0,0x1
 172:	d5a50513          	add	a0,a0,-678 # ec8 <malloc+0x18e>
 176:	00001097          	auipc	ra,0x1
 17a:	b0c080e7          	jalr	-1268(ra) # c82 <printf>
        exit(1);
 17e:	4505                	li	a0,1
 180:	00000097          	auipc	ra,0x0
 184:	6a4080e7          	jalr	1700(ra) # 824 <exit>
        printf("Error: read failed\n");
 188:	00001517          	auipc	a0,0x1
 18c:	d7050513          	add	a0,a0,-656 # ef8 <malloc+0x1be>
 190:	00001097          	auipc	ra,0x1
 194:	af2080e7          	jalr	-1294(ra) # c82 <printf>
        exit(1);
 198:	4505                	li	a0,1
 19a:	00000097          	auipc	ra,0x0
 19e:	68a080e7          	jalr	1674(ra) # 824 <exit>
        printf("Error: unlink (delete) failed\n");
 1a2:	00001517          	auipc	a0,0x1
 1a6:	d6e50513          	add	a0,a0,-658 # f10 <malloc+0x1d6>
 1aa:	00001097          	auipc	ra,0x1
 1ae:	ad8080e7          	jalr	-1320(ra) # c82 <printf>
        exit(1);
 1b2:	4505                	li	a0,1
 1b4:	00000097          	auipc	ra,0x0
 1b8:	670080e7          	jalr	1648(ra) # 824 <exit>

00000000000001bc <test_concurrent_access>:


void test_concurrent_access(void) {
 1bc:	711d                	add	sp,sp,-96
 1be:	ec86                	sd	ra,88(sp)
 1c0:	e8a2                	sd	s0,80(sp)
 1c2:	e4a6                	sd	s1,72(sp)
 1c4:	e0ca                	sd	s2,64(sp)
 1c6:	fc4e                	sd	s3,56(sp)
 1c8:	1080                	add	s0,sp,96
    printf("Testing concurrent file access...\n");
 1ca:	00001517          	auipc	a0,0x1
 1ce:	da650513          	add	a0,a0,-602 # f70 <malloc+0x236>
 1d2:	00001097          	auipc	ra,0x1
 1d6:	ab0080e7          	jalr	-1360(ra) # c82 <printf>

    // 创建 4 个子进程同时访问文件系统
    for (int i = 0; i < 4; i++) {
 1da:	4481                	li	s1,0
 1dc:	4911                	li	s2,4
        int pid = fork();
 1de:	00000097          	auipc	ra,0x0
 1e2:	63e080e7          	jalr	1598(ra) # 81c <fork>
        
        if(pid < 0){
 1e6:	04054963          	bltz	a0,238 <test_concurrent_access+0x7c>
            printf("fork failed\n");
            exit(1);
        }

        if (pid == 0) {
 1ea:	c525                	beqz	a0,252 <test_concurrent_access+0x96>
    for (int i = 0; i < 4; i++) {
 1ec:	2485                	addw	s1,s1,1
 1ee:	ff2498e3          	bne	s1,s2,1de <test_concurrent_access+0x22>
    }

    // 父进程：等待所有子进程完成
    // xv6 的 wait 接收一个地址来存状态，或者传 0 忽略
    for (int i = 0; i < 4; i++) {
        wait(0);
 1f2:	4501                	li	a0,0
 1f4:	00000097          	auipc	ra,0x0
 1f8:	638080e7          	jalr	1592(ra) # 82c <wait>
 1fc:	4501                	li	a0,0
 1fe:	00000097          	auipc	ra,0x0
 202:	62e080e7          	jalr	1582(ra) # 82c <wait>
 206:	4501                	li	a0,0
 208:	00000097          	auipc	ra,0x0
 20c:	624080e7          	jalr	1572(ra) # 82c <wait>
 210:	4501                	li	a0,0
 212:	00000097          	auipc	ra,0x0
 216:	61a080e7          	jalr	1562(ra) # 82c <wait>
    }

    printf("Concurrent access test completed\n");
 21a:	00001517          	auipc	a0,0x1
 21e:	da650513          	add	a0,a0,-602 # fc0 <malloc+0x286>
 222:	00001097          	auipc	ra,0x1
 226:	a60080e7          	jalr	-1440(ra) # c82 <printf>
}
 22a:	60e6                	ld	ra,88(sp)
 22c:	6446                	ld	s0,80(sp)
 22e:	64a6                	ld	s1,72(sp)
 230:	6906                	ld	s2,64(sp)
 232:	79e2                	ld	s3,56(sp)
 234:	6125                	add	sp,sp,96
 236:	8082                	ret
            printf("fork failed\n");
 238:	00001517          	auipc	a0,0x1
 23c:	d6050513          	add	a0,a0,-672 # f98 <malloc+0x25e>
 240:	00001097          	auipc	ra,0x1
 244:	a42080e7          	jalr	-1470(ra) # c82 <printf>
            exit(1);
 248:	4505                	li	a0,1
 24a:	00000097          	auipc	ra,0x0
 24e:	5da080e7          	jalr	1498(ra) # 824 <exit>
            make_filename(filename, "Test_", i);
 252:	8626                	mv	a2,s1
 254:	00001597          	auipc	a1,0x1
 258:	d5458593          	add	a1,a1,-684 # fa8 <malloc+0x26e>
 25c:	fb040513          	add	a0,s0,-80
 260:	00000097          	auipc	ra,0x0
 264:	51c080e7          	jalr	1308(ra) # 77c <make_filename>
            for (int j = 0; j < 100; j++) {
 268:	fa042623          	sw	zero,-84(s0)
                        printf("write failed\n");
 26c:	00001997          	auipc	s3,0x1
 270:	d4498993          	add	s3,s3,-700 # fb0 <malloc+0x276>
            for (int j = 0; j < 100; j++) {
 274:	06300913          	li	s2,99
 278:	a02d                	j	2a2 <test_concurrent_access+0xe6>
                    close(fd);
 27a:	8526                	mv	a0,s1
 27c:	00000097          	auipc	ra,0x0
 280:	5c0080e7          	jalr	1472(ra) # 83c <close>
                    unlink(filename);
 284:	fb040513          	add	a0,s0,-80
 288:	00000097          	auipc	ra,0x0
 28c:	60c080e7          	jalr	1548(ra) # 894 <unlink>
            for (int j = 0; j < 100; j++) {
 290:	fac42783          	lw	a5,-84(s0)
 294:	2785                	addw	a5,a5,1
 296:	0007871b          	sext.w	a4,a5
 29a:	faf42623          	sw	a5,-84(s0)
 29e:	02e94d63          	blt	s2,a4,2d8 <test_concurrent_access+0x11c>
                int fd = open(filename, O_CREATE | O_RDWR);
 2a2:	20200593          	li	a1,514
 2a6:	fb040513          	add	a0,s0,-80
 2aa:	00000097          	auipc	ra,0x0
 2ae:	59a080e7          	jalr	1434(ra) # 844 <open>
 2b2:	84aa                	mv	s1,a0
                if (fd >= 0) {
 2b4:	fc054ee3          	bltz	a0,290 <test_concurrent_access+0xd4>
                    if(write(fd, &j, sizeof(j)) != sizeof(j)){
 2b8:	4611                	li	a2,4
 2ba:	fac40593          	add	a1,s0,-84
 2be:	00000097          	auipc	ra,0x0
 2c2:	59e080e7          	jalr	1438(ra) # 85c <write>
 2c6:	4791                	li	a5,4
 2c8:	faf509e3          	beq	a0,a5,27a <test_concurrent_access+0xbe>
                        printf("write failed\n");
 2cc:	854e                	mv	a0,s3
 2ce:	00001097          	auipc	ra,0x1
 2d2:	9b4080e7          	jalr	-1612(ra) # c82 <printf>
 2d6:	b755                	j	27a <test_concurrent_access+0xbe>
            exit(0);
 2d8:	4501                	li	a0,0
 2da:	00000097          	auipc	ra,0x0
 2de:	54a080e7          	jalr	1354(ra) # 824 <exit>

00000000000002e2 <test_filesystem_performance>:

void test_filesystem_performance() {
 2e2:	711d                	add	sp,sp,-96
 2e4:	ec86                	sd	ra,88(sp)
 2e6:	e8a2                	sd	s0,80(sp)
 2e8:	e4a6                	sd	s1,72(sp)
 2ea:	e0ca                	sd	s2,64(sp)
 2ec:	fc4e                	sd	s3,56(sp)
 2ee:	f852                	sd	s4,48(sp)
 2f0:	f456                	sd	s5,40(sp)
 2f2:	f05a                	sd	s6,32(sp)
 2f4:	1080                	add	s0,sp,96
  
    printf("Testing filesystem performance...\n");
 2f6:	00001517          	auipc	a0,0x1
 2fa:	cf250513          	add	a0,a0,-782 # fe8 <malloc+0x2ae>
 2fe:	00001097          	auipc	ra,0x1
 302:	984080e7          	jalr	-1660(ra) # c82 <printf>
    
    uint64 start_time = get_time();
 306:	00000097          	auipc	ra,0x0
 30a:	45c080e7          	jalr	1116(ra) # 762 <get_time>
 30e:	00050b1b          	sext.w	s6,a0
    
    // --- 大量小文件测试 ---
    char filename[32];
    for (int i = 0; i < 100; i++) { // 为了不打爆xv6有限的inode，先测试100个
 312:	4901                	li	s2,0
        // 手动生成文件名，例如 "s_0", "s_1"
        make_filename(filename, "test_", i);
 314:	00001997          	auipc	s3,0x1
 318:	cfc98993          	add	s3,s3,-772 # 1010 <malloc+0x2d6>
        int fd = open(filename, O_CREATE | O_RDWR);
        if(fd < 0){
            printf("Error: cannot create file %s\n", filename);
            exit(1);
        }
        write(fd, "test", 4);
 31c:	00001a97          	auipc	s5,0x1
 320:	d1ca8a93          	add	s5,s5,-740 # 1038 <malloc+0x2fe>
    for (int i = 0; i < 100; i++) { // 为了不打爆xv6有限的inode，先测试100个
 324:	06400a13          	li	s4,100
        make_filename(filename, "test_", i);
 328:	864a                	mv	a2,s2
 32a:	85ce                	mv	a1,s3
 32c:	fa040513          	add	a0,s0,-96
 330:	00000097          	auipc	ra,0x0
 334:	44c080e7          	jalr	1100(ra) # 77c <make_filename>
        int fd = open(filename, O_CREATE | O_RDWR);
 338:	20200593          	li	a1,514
 33c:	fa040513          	add	a0,s0,-96
 340:	00000097          	auipc	ra,0x0
 344:	504080e7          	jalr	1284(ra) # 844 <open>
 348:	84aa                	mv	s1,a0
        if(fd < 0){
 34a:	04054863          	bltz	a0,39a <test_filesystem_performance+0xb8>
        write(fd, "test", 4);
 34e:	4611                	li	a2,4
 350:	85d6                	mv	a1,s5
 352:	00000097          	auipc	ra,0x0
 356:	50a080e7          	jalr	1290(ra) # 85c <write>
        close(fd);
 35a:	8526                	mv	a0,s1
 35c:	00000097          	auipc	ra,0x0
 360:	4e0080e7          	jalr	1248(ra) # 83c <close>
    for (int i = 0; i < 100; i++) { // 为了不打爆xv6有限的inode，先测试100个
 364:	2905                	addw	s2,s2,1
 366:	fd4911e3          	bne	s2,s4,328 <test_filesystem_performance+0x46>
    }
    uint64 small_files_time = get_time() - start_time;
 36a:	00000097          	auipc	ra,0x0
 36e:	3f8080e7          	jalr	1016(ra) # 762 <get_time>
    
    printf("Files (100x4B): %d ticks\n", (unsigned int)small_files_time);
 372:	416505bb          	subw	a1,a0,s6
 376:	00001517          	auipc	a0,0x1
 37a:	cca50513          	add	a0,a0,-822 # 1040 <malloc+0x306>
 37e:	00001097          	auipc	ra,0x1
 382:	904080e7          	jalr	-1788(ra) # c82 <printf>
    // }
    // close(fd);
    // uint64 large_file_time = get_time() - start_time;
    
    // printf("Large file (1x4MB): %d ticks\n", (unsigned int)large_file_time);
}
 386:	60e6                	ld	ra,88(sp)
 388:	6446                	ld	s0,80(sp)
 38a:	64a6                	ld	s1,72(sp)
 38c:	6906                	ld	s2,64(sp)
 38e:	79e2                	ld	s3,56(sp)
 390:	7a42                	ld	s4,48(sp)
 392:	7aa2                	ld	s5,40(sp)
 394:	7b02                	ld	s6,32(sp)
 396:	6125                	add	sp,sp,96
 398:	8082                	ret
            printf("Error: cannot create file %s\n", filename);
 39a:	fa040593          	add	a1,s0,-96
 39e:	00001517          	auipc	a0,0x1
 3a2:	c7a50513          	add	a0,a0,-902 # 1018 <malloc+0x2de>
 3a6:	00001097          	auipc	ra,0x1
 3aa:	8dc080e7          	jalr	-1828(ra) # c82 <printf>
            exit(1);
 3ae:	4505                	li	a0,1
 3b0:	00000097          	auipc	ra,0x0
 3b4:	474080e7          	jalr	1140(ra) # 824 <exit>

00000000000003b8 <test_crash_recovery>:
void test_crash_recovery(void){
 3b8:	7179                	add	sp,sp,-48
 3ba:	f406                	sd	ra,40(sp)
 3bc:	f022                	sd	s0,32(sp)
 3be:	ec26                	sd	s1,24(sp)
 3c0:	1800                	add	s0,sp,48
    int fd;
    char buf[10];

    printf("Starting User-Space Crash Recovery Test...\n");
 3c2:	00001517          	auipc	a0,0x1
 3c6:	c9e50513          	add	a0,a0,-866 # 1060 <malloc+0x326>
 3ca:	00001097          	auipc	ra,0x1
 3ce:	8b8080e7          	jalr	-1864(ra) # c82 <printf>

    // 1. 尝试打开测试文件
    fd = open("crash_file", O_RDWR);
 3d2:	4589                	li	a1,2
 3d4:	00001517          	auipc	a0,0x1
 3d8:	cbc50513          	add	a0,a0,-836 # 1090 <malloc+0x356>
 3dc:	00000097          	auipc	ra,0x0
 3e0:	468080e7          	jalr	1128(ra) # 844 <open>

    if (fd >= 0) {
 3e4:	08054263          	bltz	a0,468 <test_crash_recovery+0xb0>
 3e8:	84aa                	mv	s1,a0
        // --- 恢复阶段 ---
        printf("Found crash_file! Checking content...\n");
 3ea:	00001517          	auipc	a0,0x1
 3ee:	cb650513          	add	a0,a0,-842 # 10a0 <malloc+0x366>
 3f2:	00001097          	auipc	ra,0x1
 3f6:	890080e7          	jalr	-1904(ra) # c82 <printf>
        read(fd, buf, 5);
 3fa:	4615                	li	a2,5
 3fc:	fd040593          	add	a1,s0,-48
 400:	8526                	mv	a0,s1
 402:	00000097          	auipc	ra,0x0
 406:	452080e7          	jalr	1106(ra) # 854 <read>
        if (buf[0] == 'H' && buf[4] == 'o') {
 40a:	fd044703          	lbu	a4,-48(s0)
 40e:	04800793          	li	a5,72
 412:	00f71863          	bne	a4,a5,422 <test_crash_recovery+0x6a>
 416:	fd444703          	lbu	a4,-44(s0)
 41a:	06f00793          	li	a5,111
 41e:	02f70c63          	beq	a4,a5,456 <test_crash_recovery+0x9e>
            printf("[PASS] Data persisted after crash!\n");
        } else {
            printf("[FAIL] Data corrupted or lost.\n");
 422:	00001517          	auipc	a0,0x1
 426:	cce50513          	add	a0,a0,-818 # 10f0 <malloc+0x3b6>
 42a:	00001097          	auipc	ra,0x1
 42e:	858080e7          	jalr	-1960(ra) # c82 <printf>
        }
        close(fd);
 432:	8526                	mv	a0,s1
 434:	00000097          	auipc	ra,0x0
 438:	408080e7          	jalr	1032(ra) # 83c <close>
        // 清理文件 
        unlink("crash_file");
 43c:	00001517          	auipc	a0,0x1
 440:	c5450513          	add	a0,a0,-940 # 1090 <malloc+0x356>
 444:	00000097          	auipc	ra,0x0
 448:	450080e7          	jalr	1104(ra) # 894 <unlink>

        // 如果程序跑到了这里，说明没崩溃，测试失败
        printf("[FAIL] System did not crash!\n");
    }

    exit(0);
 44c:	4501                	li	a0,0
 44e:	00000097          	auipc	ra,0x0
 452:	3d6080e7          	jalr	982(ra) # 824 <exit>
            printf("[PASS] Data persisted after crash!\n");
 456:	00001517          	auipc	a0,0x1
 45a:	c7250513          	add	a0,a0,-910 # 10c8 <malloc+0x38e>
 45e:	00001097          	auipc	ra,0x1
 462:	824080e7          	jalr	-2012(ra) # c82 <printf>
 466:	b7f1                	j	432 <test_crash_recovery+0x7a>
        printf("Phase 1: Creating file and triggering crash...\n");
 468:	00001517          	auipc	a0,0x1
 46c:	ca850513          	add	a0,a0,-856 # 1110 <malloc+0x3d6>
 470:	00001097          	auipc	ra,0x1
 474:	812080e7          	jalr	-2030(ra) # c82 <printf>
        fd = open("crash_file", O_CREATE | O_RDWR);
 478:	20200593          	li	a1,514
 47c:	00001517          	auipc	a0,0x1
 480:	c1450513          	add	a0,a0,-1004 # 1090 <malloc+0x356>
 484:	00000097          	auipc	ra,0x0
 488:	3c0080e7          	jalr	960(ra) # 844 <open>
 48c:	84aa                	mv	s1,a0
        if(fd < 0){
 48e:	04054163          	bltz	a0,4d0 <test_crash_recovery+0x118>
        crash_arm(); 
 492:	00000097          	auipc	ra,0x0
 496:	40a080e7          	jalr	1034(ra) # 89c <crash_arm>
        printf("Writing data... (System should crash now)\n");
 49a:	00001517          	auipc	a0,0x1
 49e:	cbe50513          	add	a0,a0,-834 # 1158 <malloc+0x41e>
 4a2:	00000097          	auipc	ra,0x0
 4a6:	7e0080e7          	jalr	2016(ra) # c82 <printf>
        write(fd, "Hello", 5);
 4aa:	4615                	li	a2,5
 4ac:	00001597          	auipc	a1,0x1
 4b0:	cdc58593          	add	a1,a1,-804 # 1188 <malloc+0x44e>
 4b4:	8526                	mv	a0,s1
 4b6:	00000097          	auipc	ra,0x0
 4ba:	3a6080e7          	jalr	934(ra) # 85c <write>
        printf("[FAIL] System did not crash!\n");
 4be:	00001517          	auipc	a0,0x1
 4c2:	cd250513          	add	a0,a0,-814 # 1190 <malloc+0x456>
 4c6:	00000097          	auipc	ra,0x0
 4ca:	7bc080e7          	jalr	1980(ra) # c82 <printf>
 4ce:	bfbd                	j	44c <test_crash_recovery+0x94>
            printf("Error: create failed\n");
 4d0:	00001517          	auipc	a0,0x1
 4d4:	c7050513          	add	a0,a0,-912 # 1140 <malloc+0x406>
 4d8:	00000097          	auipc	ra,0x0
 4dc:	7aa080e7          	jalr	1962(ra) # c82 <printf>
            exit(1);
 4e0:	4505                	li	a0,1
 4e2:	00000097          	auipc	ra,0x0
 4e6:	342080e7          	jalr	834(ra) # 824 <exit>

00000000000004ea <main>:
}
// 3. 添加 main 函数作为入口
int 
main(int argc, char *argv[]) {
 4ea:	1141                	add	sp,sp,-16
 4ec:	e406                	sd	ra,8(sp)
 4ee:	e022                	sd	s0,0(sp)
 4f0:	0800                	add	s0,sp,16
    test_filesystem_integrity();
 4f2:	00000097          	auipc	ra,0x0
 4f6:	b34080e7          	jalr	-1228(ra) # 26 <test_filesystem_integrity>
    test_concurrent_access();
 4fa:	00000097          	auipc	ra,0x0
 4fe:	cc2080e7          	jalr	-830(ra) # 1bc <test_concurrent_access>
    test_filesystem_performance();
 502:	00000097          	auipc	ra,0x0
 506:	de0080e7          	jalr	-544(ra) # 2e2 <test_filesystem_performance>
    test_crash_recovery();
 50a:	00000097          	auipc	ra,0x0
 50e:	eae080e7          	jalr	-338(ra) # 3b8 <test_crash_recovery>

0000000000000512 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 512:	1141                	add	sp,sp,-16
 514:	e406                	sd	ra,8(sp)
 516:	e022                	sd	s0,0(sp)
 518:	0800                	add	s0,sp,16
  int r;
  extern int main();
  r = main();
 51a:	00000097          	auipc	ra,0x0
 51e:	fd0080e7          	jalr	-48(ra) # 4ea <main>
  exit(r);
 522:	00000097          	auipc	ra,0x0
 526:	302080e7          	jalr	770(ra) # 824 <exit>

000000000000052a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 52a:	1141                	add	sp,sp,-16
 52c:	e422                	sd	s0,8(sp)
 52e:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 530:	87aa                	mv	a5,a0
 532:	0585                	add	a1,a1,1
 534:	0785                	add	a5,a5,1
 536:	fff5c703          	lbu	a4,-1(a1)
 53a:	fee78fa3          	sb	a4,-1(a5)
 53e:	fb75                	bnez	a4,532 <strcpy+0x8>
    ;
  return os;
}
 540:	6422                	ld	s0,8(sp)
 542:	0141                	add	sp,sp,16
 544:	8082                	ret

0000000000000546 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 546:	1141                	add	sp,sp,-16
 548:	e422                	sd	s0,8(sp)
 54a:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 54c:	00054783          	lbu	a5,0(a0)
 550:	cb91                	beqz	a5,564 <strcmp+0x1e>
 552:	0005c703          	lbu	a4,0(a1)
 556:	00f71763          	bne	a4,a5,564 <strcmp+0x1e>
    p++, q++;
 55a:	0505                	add	a0,a0,1
 55c:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 55e:	00054783          	lbu	a5,0(a0)
 562:	fbe5                	bnez	a5,552 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 564:	0005c503          	lbu	a0,0(a1)
}
 568:	40a7853b          	subw	a0,a5,a0
 56c:	6422                	ld	s0,8(sp)
 56e:	0141                	add	sp,sp,16
 570:	8082                	ret

0000000000000572 <strlen>:

uint
strlen(const char *s)
{
 572:	1141                	add	sp,sp,-16
 574:	e422                	sd	s0,8(sp)
 576:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 578:	00054783          	lbu	a5,0(a0)
 57c:	cf91                	beqz	a5,598 <strlen+0x26>
 57e:	0505                	add	a0,a0,1
 580:	87aa                	mv	a5,a0
 582:	86be                	mv	a3,a5
 584:	0785                	add	a5,a5,1
 586:	fff7c703          	lbu	a4,-1(a5)
 58a:	ff65                	bnez	a4,582 <strlen+0x10>
 58c:	40a6853b          	subw	a0,a3,a0
 590:	2505                	addw	a0,a0,1
    ;
  return n;
}
 592:	6422                	ld	s0,8(sp)
 594:	0141                	add	sp,sp,16
 596:	8082                	ret
  for(n = 0; s[n]; n++)
 598:	4501                	li	a0,0
 59a:	bfe5                	j	592 <strlen+0x20>

000000000000059c <memset>:

void*
memset(void *dst, int c, uint n)
{
 59c:	1141                	add	sp,sp,-16
 59e:	e422                	sd	s0,8(sp)
 5a0:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5a2:	ca19                	beqz	a2,5b8 <memset+0x1c>
 5a4:	87aa                	mv	a5,a0
 5a6:	1602                	sll	a2,a2,0x20
 5a8:	9201                	srl	a2,a2,0x20
 5aa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5ae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5b2:	0785                	add	a5,a5,1
 5b4:	fee79de3          	bne	a5,a4,5ae <memset+0x12>
  }
  return dst;
}
 5b8:	6422                	ld	s0,8(sp)
 5ba:	0141                	add	sp,sp,16
 5bc:	8082                	ret

00000000000005be <strchr>:

char*
strchr(const char *s, char c)
{
 5be:	1141                	add	sp,sp,-16
 5c0:	e422                	sd	s0,8(sp)
 5c2:	0800                	add	s0,sp,16
  for(; *s; s++)
 5c4:	00054783          	lbu	a5,0(a0)
 5c8:	cb99                	beqz	a5,5de <strchr+0x20>
    if(*s == c)
 5ca:	00f58763          	beq	a1,a5,5d8 <strchr+0x1a>
  for(; *s; s++)
 5ce:	0505                	add	a0,a0,1
 5d0:	00054783          	lbu	a5,0(a0)
 5d4:	fbfd                	bnez	a5,5ca <strchr+0xc>
      return (char*)s;
  return 0;
 5d6:	4501                	li	a0,0
}
 5d8:	6422                	ld	s0,8(sp)
 5da:	0141                	add	sp,sp,16
 5dc:	8082                	ret
  return 0;
 5de:	4501                	li	a0,0
 5e0:	bfe5                	j	5d8 <strchr+0x1a>

00000000000005e2 <gets>:

char*
gets(char *buf, int max)
{
 5e2:	711d                	add	sp,sp,-96
 5e4:	ec86                	sd	ra,88(sp)
 5e6:	e8a2                	sd	s0,80(sp)
 5e8:	e4a6                	sd	s1,72(sp)
 5ea:	e0ca                	sd	s2,64(sp)
 5ec:	fc4e                	sd	s3,56(sp)
 5ee:	f852                	sd	s4,48(sp)
 5f0:	f456                	sd	s5,40(sp)
 5f2:	f05a                	sd	s6,32(sp)
 5f4:	ec5e                	sd	s7,24(sp)
 5f6:	1080                	add	s0,sp,96
 5f8:	8baa                	mv	s7,a0
 5fa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5fc:	892a                	mv	s2,a0
 5fe:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 600:	4aa9                	li	s5,10
 602:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 604:	89a6                	mv	s3,s1
 606:	2485                	addw	s1,s1,1
 608:	0344d863          	bge	s1,s4,638 <gets+0x56>
    cc = read(0, &c, 1);
 60c:	4605                	li	a2,1
 60e:	faf40593          	add	a1,s0,-81
 612:	4501                	li	a0,0
 614:	00000097          	auipc	ra,0x0
 618:	240080e7          	jalr	576(ra) # 854 <read>
    if(cc < 1)
 61c:	00a05e63          	blez	a0,638 <gets+0x56>
    buf[i++] = c;
 620:	faf44783          	lbu	a5,-81(s0)
 624:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 628:	01578763          	beq	a5,s5,636 <gets+0x54>
 62c:	0905                	add	s2,s2,1
 62e:	fd679be3          	bne	a5,s6,604 <gets+0x22>
  for(i=0; i+1 < max; ){
 632:	89a6                	mv	s3,s1
 634:	a011                	j	638 <gets+0x56>
 636:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 638:	99de                	add	s3,s3,s7
 63a:	00098023          	sb	zero,0(s3)
  return buf;
}
 63e:	855e                	mv	a0,s7
 640:	60e6                	ld	ra,88(sp)
 642:	6446                	ld	s0,80(sp)
 644:	64a6                	ld	s1,72(sp)
 646:	6906                	ld	s2,64(sp)
 648:	79e2                	ld	s3,56(sp)
 64a:	7a42                	ld	s4,48(sp)
 64c:	7aa2                	ld	s5,40(sp)
 64e:	7b02                	ld	s6,32(sp)
 650:	6be2                	ld	s7,24(sp)
 652:	6125                	add	sp,sp,96
 654:	8082                	ret

0000000000000656 <atoi>:
//   return r;
// }

int
atoi(const char *s)
{
 656:	1141                	add	sp,sp,-16
 658:	e422                	sd	s0,8(sp)
 65a:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 65c:	00054683          	lbu	a3,0(a0)
 660:	fd06879b          	addw	a5,a3,-48
 664:	0ff7f793          	zext.b	a5,a5
 668:	4625                	li	a2,9
 66a:	02f66863          	bltu	a2,a5,69a <atoi+0x44>
 66e:	872a                	mv	a4,a0
  n = 0;
 670:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 672:	0705                	add	a4,a4,1
 674:	0025179b          	sllw	a5,a0,0x2
 678:	9fa9                	addw	a5,a5,a0
 67a:	0017979b          	sllw	a5,a5,0x1
 67e:	9fb5                	addw	a5,a5,a3
 680:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 684:	00074683          	lbu	a3,0(a4)
 688:	fd06879b          	addw	a5,a3,-48
 68c:	0ff7f793          	zext.b	a5,a5
 690:	fef671e3          	bgeu	a2,a5,672 <atoi+0x1c>
  return n;
}
 694:	6422                	ld	s0,8(sp)
 696:	0141                	add	sp,sp,16
 698:	8082                	ret
  n = 0;
 69a:	4501                	li	a0,0
 69c:	bfe5                	j	694 <atoi+0x3e>

000000000000069e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 69e:	1141                	add	sp,sp,-16
 6a0:	e422                	sd	s0,8(sp)
 6a2:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6a4:	02b57463          	bgeu	a0,a1,6cc <memmove+0x2e>
    while(n-- > 0)
 6a8:	00c05f63          	blez	a2,6c6 <memmove+0x28>
 6ac:	1602                	sll	a2,a2,0x20
 6ae:	9201                	srl	a2,a2,0x20
 6b0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6b4:	872a                	mv	a4,a0
      *dst++ = *src++;
 6b6:	0585                	add	a1,a1,1
 6b8:	0705                	add	a4,a4,1
 6ba:	fff5c683          	lbu	a3,-1(a1)
 6be:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6c2:	fee79ae3          	bne	a5,a4,6b6 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6c6:	6422                	ld	s0,8(sp)
 6c8:	0141                	add	sp,sp,16
 6ca:	8082                	ret
    dst += n;
 6cc:	00c50733          	add	a4,a0,a2
    src += n;
 6d0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6d2:	fec05ae3          	blez	a2,6c6 <memmove+0x28>
 6d6:	fff6079b          	addw	a5,a2,-1
 6da:	1782                	sll	a5,a5,0x20
 6dc:	9381                	srl	a5,a5,0x20
 6de:	fff7c793          	not	a5,a5
 6e2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6e4:	15fd                	add	a1,a1,-1
 6e6:	177d                	add	a4,a4,-1
 6e8:	0005c683          	lbu	a3,0(a1)
 6ec:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6f0:	fee79ae3          	bne	a5,a4,6e4 <memmove+0x46>
 6f4:	bfc9                	j	6c6 <memmove+0x28>

00000000000006f6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6f6:	1141                	add	sp,sp,-16
 6f8:	e422                	sd	s0,8(sp)
 6fa:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6fc:	ca05                	beqz	a2,72c <memcmp+0x36>
 6fe:	fff6069b          	addw	a3,a2,-1
 702:	1682                	sll	a3,a3,0x20
 704:	9281                	srl	a3,a3,0x20
 706:	0685                	add	a3,a3,1
 708:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 70a:	00054783          	lbu	a5,0(a0)
 70e:	0005c703          	lbu	a4,0(a1)
 712:	00e79863          	bne	a5,a4,722 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 716:	0505                	add	a0,a0,1
    p2++;
 718:	0585                	add	a1,a1,1
  while (n-- > 0) {
 71a:	fed518e3          	bne	a0,a3,70a <memcmp+0x14>
  }
  return 0;
 71e:	4501                	li	a0,0
 720:	a019                	j	726 <memcmp+0x30>
      return *p1 - *p2;
 722:	40e7853b          	subw	a0,a5,a4
}
 726:	6422                	ld	s0,8(sp)
 728:	0141                	add	sp,sp,16
 72a:	8082                	ret
  return 0;
 72c:	4501                	li	a0,0
 72e:	bfe5                	j	726 <memcmp+0x30>

0000000000000730 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 730:	1141                	add	sp,sp,-16
 732:	e406                	sd	ra,8(sp)
 734:	e022                	sd	s0,0(sp)
 736:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 738:	00000097          	auipc	ra,0x0
 73c:	f66080e7          	jalr	-154(ra) # 69e <memmove>
}
 740:	60a2                	ld	ra,8(sp)
 742:	6402                	ld	s0,0(sp)
 744:	0141                	add	sp,sp,16
 746:	8082                	ret

0000000000000748 <sbrk>:

char *
sbrk(int n) {
 748:	1141                	add	sp,sp,-16
 74a:	e406                	sd	ra,8(sp)
 74c:	e022                	sd	s0,0(sp)
 74e:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 750:	4585                	li	a1,1
 752:	00000097          	auipc	ra,0x0
 756:	12a080e7          	jalr	298(ra) # 87c <sys_sbrk>
}
 75a:	60a2                	ld	ra,8(sp)
 75c:	6402                	ld	s0,0(sp)
 75e:	0141                	add	sp,sp,16
 760:	8082                	ret

0000000000000762 <get_time>:
//   return sys_sbrk(n, SBRK_LAZY);
// }


unsigned int 
get_time(void) {
 762:	1141                	add	sp,sp,-16
 764:	e406                	sd	ra,8(sp)
 766:	e022                	sd	s0,0(sp)
 768:	0800                	add	s0,sp,16
    return uptime();
 76a:	00000097          	auipc	ra,0x0
 76e:	11a080e7          	jalr	282(ra) # 884 <uptime>
}
 772:	2501                	sext.w	a0,a0
 774:	60a2                	ld	ra,8(sp)
 776:	6402                	ld	s0,0(sp)
 778:	0141                	add	sp,sp,16
 77a:	8082                	ret

000000000000077c <make_filename>:
void 
make_filename(char *buf, const char *prefix, int num) {
    // 复制前缀
    char *p = buf;
    const char *s = prefix;
    while(*s) *p++ = *s++;
 77c:	0005c783          	lbu	a5,0(a1)
 780:	cb81                	beqz	a5,790 <make_filename+0x14>
 782:	0585                	add	a1,a1,1
 784:	0505                	add	a0,a0,1
 786:	fef50fa3          	sb	a5,-1(a0)
 78a:	0005c783          	lbu	a5,0(a1)
 78e:	fbf5                	bnez	a5,782 <make_filename+0x6>
    
    // 处理数字部分
    if (num == 0) {
 790:	ca3d                	beqz	a2,806 <make_filename+0x8a>
make_filename(char *buf, const char *prefix, int num) {
 792:	1101                	add	sp,sp,-32
 794:	ec22                	sd	s0,24(sp)
 796:	1000                	add	s0,sp,32
        *p++ = '0';
    } else {
        // 临时缓冲区存放数字
        char digits[16];
        int i = 0;
        while(num > 0) {
 798:	fe040893          	add	a7,s0,-32
 79c:	87c6                	mv	a5,a7
            digits[i++] = (num % 10) + '0';
 79e:	46a9                	li	a3,10
        while(num > 0) {
 7a0:	4825                	li	a6,9
 7a2:	06c05063          	blez	a2,802 <make_filename+0x86>
            digits[i++] = (num % 10) + '0';
 7a6:	02d6673b          	remw	a4,a2,a3
 7aa:	0307071b          	addw	a4,a4,48
 7ae:	00e78023          	sb	a4,0(a5)
            num /= 10;
 7b2:	85b2                	mv	a1,a2
 7b4:	02d6463b          	divw	a2,a2,a3
        while(num > 0) {
 7b8:	873e                	mv	a4,a5
 7ba:	0785                	add	a5,a5,1
 7bc:	feb845e3          	blt	a6,a1,7a6 <make_filename+0x2a>
 7c0:	4117073b          	subw	a4,a4,a7
 7c4:	0017069b          	addw	a3,a4,1
            digits[i++] = (num % 10) + '0';
 7c8:	0006879b          	sext.w	a5,a3
        }
        // 倒序写入
        while(i > 0) *p++ = digits[--i];
 7cc:	04f05663          	blez	a5,818 <make_filename+0x9c>
 7d0:	fe040713          	add	a4,s0,-32
 7d4:	973e                	add	a4,a4,a5
 7d6:	02069593          	sll	a1,a3,0x20
 7da:	9181                	srl	a1,a1,0x20
 7dc:	95aa                	add	a1,a1,a0
 7de:	87aa                	mv	a5,a0
 7e0:	0785                	add	a5,a5,1
 7e2:	fff74603          	lbu	a2,-1(a4)
 7e6:	fec78fa3          	sb	a2,-1(a5)
 7ea:	177d                	add	a4,a4,-1
 7ec:	feb79ae3          	bne	a5,a1,7e0 <make_filename+0x64>
 7f0:	02069793          	sll	a5,a3,0x20
 7f4:	9381                	srl	a5,a5,0x20
 7f6:	97aa                	add	a5,a5,a0
    }
    *p = 0; // 字符串结束符
 7f8:	00078023          	sb	zero,0(a5)
 7fc:	6462                	ld	s0,24(sp)
 7fe:	6105                	add	sp,sp,32
 800:	8082                	ret
        while(num > 0) {
 802:	87aa                	mv	a5,a0
 804:	bfd5                	j	7f8 <make_filename+0x7c>
        *p++ = '0';
 806:	00150793          	add	a5,a0,1
 80a:	03000713          	li	a4,48
 80e:	00e50023          	sb	a4,0(a0)
    *p = 0; // 字符串结束符
 812:	00078023          	sb	zero,0(a5)
 816:	8082                	ret
        while(i > 0) *p++ = digits[--i];
 818:	87aa                	mv	a5,a0
 81a:	bff9                	j	7f8 <make_filename+0x7c>

000000000000081c <fork>:
.globl unlink
# generated by usys.pl - do not edit
#include "../kernel/sys/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 81c:	4885                	li	a7,1
 ecall
 81e:	00000073          	ecall
 ret
 822:	8082                	ret

0000000000000824 <exit>:
.global exit
exit:
 li a7, SYS_exit
 824:	4889                	li	a7,2
 ecall
 826:	00000073          	ecall
 ret
 82a:	8082                	ret

000000000000082c <wait>:
.global wait
wait:
 li a7, SYS_wait
 82c:	488d                	li	a7,3
 ecall
 82e:	00000073          	ecall
 ret
 832:	8082                	ret

0000000000000834 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 834:	4891                	li	a7,4
 ecall
 836:	00000073          	ecall
 ret
 83a:	8082                	ret

000000000000083c <close>:
.global close
close:
 li a7, SYS_close
 83c:	4899                	li	a7,6
 ecall
 83e:	00000073          	ecall
 ret
 842:	8082                	ret

0000000000000844 <open>:
.global open
open:
 li a7, SYS_open
 844:	489d                	li	a7,7
 ecall
 846:	00000073          	ecall
 ret
 84a:	8082                	ret

000000000000084c <exec>:
.global exec
exec:
 li a7, SYS_exec
 84c:	4895                	li	a7,5
 ecall
 84e:	00000073          	ecall
 ret
 852:	8082                	ret

0000000000000854 <read>:
.global read
read:
 li a7, SYS_read
 854:	48a1                	li	a7,8
 ecall
 856:	00000073          	ecall
 ret
 85a:	8082                	ret

000000000000085c <write>:
.global write
write:
 li a7, SYS_write
 85c:	48a5                	li	a7,9
 ecall
 85e:	00000073          	ecall
 ret
 862:	8082                	ret

0000000000000864 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 864:	48a9                	li	a7,10
 ecall
 866:	00000073          	ecall
 ret
 86a:	8082                	ret

000000000000086c <makenode>:
.global makenode
makenode:
 li a7, SYS_makenode
 86c:	48ad                	li	a7,11
 ecall
 86e:	00000073          	ecall
 ret
 872:	8082                	ret

0000000000000874 <duplicate>:
.global duplicate
duplicate:
 li a7, SYS_duplicate
 874:	48b1                	li	a7,12
 ecall
 876:	00000073          	ecall
 ret
 87a:	8082                	ret

000000000000087c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 87c:	48b5                	li	a7,13
 ecall
 87e:	00000073          	ecall
 ret
 882:	8082                	ret

0000000000000884 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 884:	48b9                	li	a7,14
 ecall
 886:	00000073          	ecall
 ret
 88a:	8082                	ret

000000000000088c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 88c:	48bd                	li	a7,15
 ecall
 88e:	00000073          	ecall
 ret
 892:	8082                	ret

0000000000000894 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 894:	48c1                	li	a7,16
 ecall
 896:	00000073          	ecall
 ret
 89a:	8082                	ret

000000000000089c <crash_arm>:
.global crash_arm
crash_arm:
 li a7, SYS_crash_arm
 89c:	48c5                	li	a7,17
 ecall
 89e:	00000073          	ecall
 8a2:	8082                	ret

00000000000008a4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 8a4:	1101                	add	sp,sp,-32
 8a6:	ec06                	sd	ra,24(sp)
 8a8:	e822                	sd	s0,16(sp)
 8aa:	1000                	add	s0,sp,32
 8ac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 8b0:	4605                	li	a2,1
 8b2:	fef40593          	add	a1,s0,-17
 8b6:	00000097          	auipc	ra,0x0
 8ba:	fa6080e7          	jalr	-90(ra) # 85c <write>
}
 8be:	60e2                	ld	ra,24(sp)
 8c0:	6442                	ld	s0,16(sp)
 8c2:	6105                	add	sp,sp,32
 8c4:	8082                	ret

00000000000008c6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 8c6:	715d                	add	sp,sp,-80
 8c8:	e486                	sd	ra,72(sp)
 8ca:	e0a2                	sd	s0,64(sp)
 8cc:	fc26                	sd	s1,56(sp)
 8ce:	f84a                	sd	s2,48(sp)
 8d0:	f44e                	sd	s3,40(sp)
 8d2:	0880                	add	s0,sp,80
 8d4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 8d6:	c299                	beqz	a3,8dc <printint+0x16>
 8d8:	0805c363          	bltz	a1,95e <printint+0x98>
  neg = 0;
 8dc:	4881                	li	a7,0
 8de:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 8e2:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 8e4:	00001517          	auipc	a0,0x1
 8e8:	8d450513          	add	a0,a0,-1836 # 11b8 <digits>
 8ec:	883e                	mv	a6,a5
 8ee:	2785                	addw	a5,a5,1
 8f0:	02c5f733          	remu	a4,a1,a2
 8f4:	972a                	add	a4,a4,a0
 8f6:	00074703          	lbu	a4,0(a4)
 8fa:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 8fe:	872e                	mv	a4,a1
 900:	02c5d5b3          	divu	a1,a1,a2
 904:	0685                	add	a3,a3,1
 906:	fec773e3          	bgeu	a4,a2,8ec <printint+0x26>
  if(neg)
 90a:	00088b63          	beqz	a7,920 <printint+0x5a>
    buf[i++] = '-';
 90e:	fd078793          	add	a5,a5,-48
 912:	97a2                	add	a5,a5,s0
 914:	02d00713          	li	a4,45
 918:	fee78423          	sb	a4,-24(a5)
 91c:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 920:	02f05863          	blez	a5,950 <printint+0x8a>
 924:	fb840713          	add	a4,s0,-72
 928:	00f704b3          	add	s1,a4,a5
 92c:	fff70993          	add	s3,a4,-1
 930:	99be                	add	s3,s3,a5
 932:	37fd                	addw	a5,a5,-1
 934:	1782                	sll	a5,a5,0x20
 936:	9381                	srl	a5,a5,0x20
 938:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 93c:	fff4c583          	lbu	a1,-1(s1)
 940:	854a                	mv	a0,s2
 942:	00000097          	auipc	ra,0x0
 946:	f62080e7          	jalr	-158(ra) # 8a4 <putc>
  while(--i >= 0)
 94a:	14fd                	add	s1,s1,-1
 94c:	ff3498e3          	bne	s1,s3,93c <printint+0x76>
}
 950:	60a6                	ld	ra,72(sp)
 952:	6406                	ld	s0,64(sp)
 954:	74e2                	ld	s1,56(sp)
 956:	7942                	ld	s2,48(sp)
 958:	79a2                	ld	s3,40(sp)
 95a:	6161                	add	sp,sp,80
 95c:	8082                	ret
    x = -xx;
 95e:	40b005b3          	neg	a1,a1
    neg = 1;
 962:	4885                	li	a7,1
    x = -xx;
 964:	bfad                	j	8de <printint+0x18>

0000000000000966 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 966:	711d                	add	sp,sp,-96
 968:	ec86                	sd	ra,88(sp)
 96a:	e8a2                	sd	s0,80(sp)
 96c:	e4a6                	sd	s1,72(sp)
 96e:	e0ca                	sd	s2,64(sp)
 970:	fc4e                	sd	s3,56(sp)
 972:	f852                	sd	s4,48(sp)
 974:	f456                	sd	s5,40(sp)
 976:	f05a                	sd	s6,32(sp)
 978:	ec5e                	sd	s7,24(sp)
 97a:	e862                	sd	s8,16(sp)
 97c:	e466                	sd	s9,8(sp)
 97e:	e06a                	sd	s10,0(sp)
 980:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 982:	0005c903          	lbu	s2,0(a1)
 986:	2a090963          	beqz	s2,c38 <vprintf+0x2d2>
 98a:	8b2a                	mv	s6,a0
 98c:	8a2e                	mv	s4,a1
 98e:	8bb2                	mv	s7,a2
  state = 0;
 990:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 992:	4481                	li	s1,0
 994:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 996:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 99a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 99e:	06c00c93          	li	s9,108
 9a2:	a015                	j	9c6 <vprintf+0x60>
        putc(fd, c0);
 9a4:	85ca                	mv	a1,s2
 9a6:	855a                	mv	a0,s6
 9a8:	00000097          	auipc	ra,0x0
 9ac:	efc080e7          	jalr	-260(ra) # 8a4 <putc>
 9b0:	a019                	j	9b6 <vprintf+0x50>
    } else if(state == '%'){
 9b2:	03598263          	beq	s3,s5,9d6 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 9b6:	2485                	addw	s1,s1,1
 9b8:	8726                	mv	a4,s1
 9ba:	009a07b3          	add	a5,s4,s1
 9be:	0007c903          	lbu	s2,0(a5)
 9c2:	26090b63          	beqz	s2,c38 <vprintf+0x2d2>
    c0 = fmt[i] & 0xff;
 9c6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 9ca:	fe0994e3          	bnez	s3,9b2 <vprintf+0x4c>
      if(c0 == '%'){
 9ce:	fd579be3          	bne	a5,s5,9a4 <vprintf+0x3e>
        state = '%';
 9d2:	89be                	mv	s3,a5
 9d4:	b7cd                	j	9b6 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 9d6:	cfc9                	beqz	a5,a70 <vprintf+0x10a>
 9d8:	00ea06b3          	add	a3,s4,a4
 9dc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 9e0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 9e2:	c681                	beqz	a3,9ea <vprintf+0x84>
 9e4:	9752                	add	a4,a4,s4
 9e6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 9ea:	05878563          	beq	a5,s8,a34 <vprintf+0xce>
      } else if(c0 == 'l' && c1 == 'd'){
 9ee:	07978163          	beq	a5,s9,a50 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 9f2:	07500713          	li	a4,117
 9f6:	10e78563          	beq	a5,a4,b00 <vprintf+0x19a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 9fa:	07800713          	li	a4,120
 9fe:	14e78d63          	beq	a5,a4,b58 <vprintf+0x1f2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 a02:	07000713          	li	a4,112
 a06:	18e78663          	beq	a5,a4,b92 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 a0a:	06300713          	li	a4,99
 a0e:	1ce78a63          	beq	a5,a4,be2 <vprintf+0x27c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 a12:	07300713          	li	a4,115
 a16:	1ee78263          	beq	a5,a4,bfa <vprintf+0x294>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 a1a:	02500713          	li	a4,37
 a1e:	04e79963          	bne	a5,a4,a70 <vprintf+0x10a>
        putc(fd, '%');
 a22:	02500593          	li	a1,37
 a26:	855a                	mv	a0,s6
 a28:	00000097          	auipc	ra,0x0
 a2c:	e7c080e7          	jalr	-388(ra) # 8a4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 a30:	4981                	li	s3,0
 a32:	b751                	j	9b6 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 a34:	008b8913          	add	s2,s7,8
 a38:	4685                	li	a3,1
 a3a:	4629                	li	a2,10
 a3c:	000ba583          	lw	a1,0(s7)
 a40:	855a                	mv	a0,s6
 a42:	00000097          	auipc	ra,0x0
 a46:	e84080e7          	jalr	-380(ra) # 8c6 <printint>
 a4a:	8bca                	mv	s7,s2
      state = 0;
 a4c:	4981                	li	s3,0
 a4e:	b7a5                	j	9b6 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 a50:	06400793          	li	a5,100
 a54:	02f68d63          	beq	a3,a5,a8e <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a58:	06c00793          	li	a5,108
 a5c:	04f68863          	beq	a3,a5,aac <vprintf+0x146>
      } else if(c0 == 'l' && c1 == 'u'){
 a60:	07500793          	li	a5,117
 a64:	0af68c63          	beq	a3,a5,b1c <vprintf+0x1b6>
      } else if(c0 == 'l' && c1 == 'x'){
 a68:	07800793          	li	a5,120
 a6c:	10f68463          	beq	a3,a5,b74 <vprintf+0x20e>
        putc(fd, '%');
 a70:	02500593          	li	a1,37
 a74:	855a                	mv	a0,s6
 a76:	00000097          	auipc	ra,0x0
 a7a:	e2e080e7          	jalr	-466(ra) # 8a4 <putc>
        putc(fd, c0);
 a7e:	85ca                	mv	a1,s2
 a80:	855a                	mv	a0,s6
 a82:	00000097          	auipc	ra,0x0
 a86:	e22080e7          	jalr	-478(ra) # 8a4 <putc>
      state = 0;
 a8a:	4981                	li	s3,0
 a8c:	b72d                	j	9b6 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a8e:	008b8913          	add	s2,s7,8
 a92:	4685                	li	a3,1
 a94:	4629                	li	a2,10
 a96:	000bb583          	ld	a1,0(s7)
 a9a:	855a                	mv	a0,s6
 a9c:	00000097          	auipc	ra,0x0
 aa0:	e2a080e7          	jalr	-470(ra) # 8c6 <printint>
        i += 1;
 aa4:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 aa6:	8bca                	mv	s7,s2
      state = 0;
 aa8:	4981                	li	s3,0
        i += 1;
 aaa:	b731                	j	9b6 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 aac:	06400793          	li	a5,100
 ab0:	02f60963          	beq	a2,a5,ae2 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 ab4:	07500793          	li	a5,117
 ab8:	08f60163          	beq	a2,a5,b3a <vprintf+0x1d4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 abc:	07800793          	li	a5,120
 ac0:	faf618e3          	bne	a2,a5,a70 <vprintf+0x10a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 ac4:	008b8913          	add	s2,s7,8
 ac8:	4681                	li	a3,0
 aca:	4641                	li	a2,16
 acc:	000bb583          	ld	a1,0(s7)
 ad0:	855a                	mv	a0,s6
 ad2:	00000097          	auipc	ra,0x0
 ad6:	df4080e7          	jalr	-524(ra) # 8c6 <printint>
        i += 2;
 ada:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 adc:	8bca                	mv	s7,s2
      state = 0;
 ade:	4981                	li	s3,0
        i += 2;
 ae0:	bdd9                	j	9b6 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 ae2:	008b8913          	add	s2,s7,8
 ae6:	4685                	li	a3,1
 ae8:	4629                	li	a2,10
 aea:	000bb583          	ld	a1,0(s7)
 aee:	855a                	mv	a0,s6
 af0:	00000097          	auipc	ra,0x0
 af4:	dd6080e7          	jalr	-554(ra) # 8c6 <printint>
        i += 2;
 af8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 afa:	8bca                	mv	s7,s2
      state = 0;
 afc:	4981                	li	s3,0
        i += 2;
 afe:	bd65                	j	9b6 <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 10, 0);
 b00:	008b8913          	add	s2,s7,8
 b04:	4681                	li	a3,0
 b06:	4629                	li	a2,10
 b08:	000be583          	lwu	a1,0(s7)
 b0c:	855a                	mv	a0,s6
 b0e:	00000097          	auipc	ra,0x0
 b12:	db8080e7          	jalr	-584(ra) # 8c6 <printint>
 b16:	8bca                	mv	s7,s2
      state = 0;
 b18:	4981                	li	s3,0
 b1a:	bd71                	j	9b6 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b1c:	008b8913          	add	s2,s7,8
 b20:	4681                	li	a3,0
 b22:	4629                	li	a2,10
 b24:	000bb583          	ld	a1,0(s7)
 b28:	855a                	mv	a0,s6
 b2a:	00000097          	auipc	ra,0x0
 b2e:	d9c080e7          	jalr	-612(ra) # 8c6 <printint>
        i += 1;
 b32:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 b34:	8bca                	mv	s7,s2
      state = 0;
 b36:	4981                	li	s3,0
        i += 1;
 b38:	bdbd                	j	9b6 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b3a:	008b8913          	add	s2,s7,8
 b3e:	4681                	li	a3,0
 b40:	4629                	li	a2,10
 b42:	000bb583          	ld	a1,0(s7)
 b46:	855a                	mv	a0,s6
 b48:	00000097          	auipc	ra,0x0
 b4c:	d7e080e7          	jalr	-642(ra) # 8c6 <printint>
        i += 2;
 b50:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 b52:	8bca                	mv	s7,s2
      state = 0;
 b54:	4981                	li	s3,0
        i += 2;
 b56:	b585                	j	9b6 <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 16, 0);
 b58:	008b8913          	add	s2,s7,8
 b5c:	4681                	li	a3,0
 b5e:	4641                	li	a2,16
 b60:	000be583          	lwu	a1,0(s7)
 b64:	855a                	mv	a0,s6
 b66:	00000097          	auipc	ra,0x0
 b6a:	d60080e7          	jalr	-672(ra) # 8c6 <printint>
 b6e:	8bca                	mv	s7,s2
      state = 0;
 b70:	4981                	li	s3,0
 b72:	b591                	j	9b6 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 b74:	008b8913          	add	s2,s7,8
 b78:	4681                	li	a3,0
 b7a:	4641                	li	a2,16
 b7c:	000bb583          	ld	a1,0(s7)
 b80:	855a                	mv	a0,s6
 b82:	00000097          	auipc	ra,0x0
 b86:	d44080e7          	jalr	-700(ra) # 8c6 <printint>
        i += 1;
 b8a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 b8c:	8bca                	mv	s7,s2
      state = 0;
 b8e:	4981                	li	s3,0
        i += 1;
 b90:	b51d                	j	9b6 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 b92:	008b8d13          	add	s10,s7,8
 b96:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b9a:	03000593          	li	a1,48
 b9e:	855a                	mv	a0,s6
 ba0:	00000097          	auipc	ra,0x0
 ba4:	d04080e7          	jalr	-764(ra) # 8a4 <putc>
  putc(fd, 'x');
 ba8:	07800593          	li	a1,120
 bac:	855a                	mv	a0,s6
 bae:	00000097          	auipc	ra,0x0
 bb2:	cf6080e7          	jalr	-778(ra) # 8a4 <putc>
 bb6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bb8:	00000b97          	auipc	s7,0x0
 bbc:	600b8b93          	add	s7,s7,1536 # 11b8 <digits>
 bc0:	03c9d793          	srl	a5,s3,0x3c
 bc4:	97de                	add	a5,a5,s7
 bc6:	0007c583          	lbu	a1,0(a5)
 bca:	855a                	mv	a0,s6
 bcc:	00000097          	auipc	ra,0x0
 bd0:	cd8080e7          	jalr	-808(ra) # 8a4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 bd4:	0992                	sll	s3,s3,0x4
 bd6:	397d                	addw	s2,s2,-1
 bd8:	fe0914e3          	bnez	s2,bc0 <vprintf+0x25a>
        printptr(fd, va_arg(ap, uint64));
 bdc:	8bea                	mv	s7,s10
      state = 0;
 bde:	4981                	li	s3,0
 be0:	bbd9                	j	9b6 <vprintf+0x50>
        putc(fd, va_arg(ap, uint32));
 be2:	008b8913          	add	s2,s7,8
 be6:	000bc583          	lbu	a1,0(s7)
 bea:	855a                	mv	a0,s6
 bec:	00000097          	auipc	ra,0x0
 bf0:	cb8080e7          	jalr	-840(ra) # 8a4 <putc>
 bf4:	8bca                	mv	s7,s2
      state = 0;
 bf6:	4981                	li	s3,0
 bf8:	bb7d                	j	9b6 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 bfa:	008b8993          	add	s3,s7,8
 bfe:	000bb903          	ld	s2,0(s7)
 c02:	02090163          	beqz	s2,c24 <vprintf+0x2be>
        for(; *s; s++)
 c06:	00094583          	lbu	a1,0(s2)
 c0a:	c585                	beqz	a1,c32 <vprintf+0x2cc>
          putc(fd, *s);
 c0c:	855a                	mv	a0,s6
 c0e:	00000097          	auipc	ra,0x0
 c12:	c96080e7          	jalr	-874(ra) # 8a4 <putc>
        for(; *s; s++)
 c16:	0905                	add	s2,s2,1
 c18:	00094583          	lbu	a1,0(s2)
 c1c:	f9e5                	bnez	a1,c0c <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
 c1e:	8bce                	mv	s7,s3
      state = 0;
 c20:	4981                	li	s3,0
 c22:	bb51                	j	9b6 <vprintf+0x50>
          s = "(null)";
 c24:	00000917          	auipc	s2,0x0
 c28:	58c90913          	add	s2,s2,1420 # 11b0 <malloc+0x476>
        for(; *s; s++)
 c2c:	02800593          	li	a1,40
 c30:	bff1                	j	c0c <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
 c32:	8bce                	mv	s7,s3
      state = 0;
 c34:	4981                	li	s3,0
 c36:	b341                	j	9b6 <vprintf+0x50>
    }
  }
}
 c38:	60e6                	ld	ra,88(sp)
 c3a:	6446                	ld	s0,80(sp)
 c3c:	64a6                	ld	s1,72(sp)
 c3e:	6906                	ld	s2,64(sp)
 c40:	79e2                	ld	s3,56(sp)
 c42:	7a42                	ld	s4,48(sp)
 c44:	7aa2                	ld	s5,40(sp)
 c46:	7b02                	ld	s6,32(sp)
 c48:	6be2                	ld	s7,24(sp)
 c4a:	6c42                	ld	s8,16(sp)
 c4c:	6ca2                	ld	s9,8(sp)
 c4e:	6d02                	ld	s10,0(sp)
 c50:	6125                	add	sp,sp,96
 c52:	8082                	ret

0000000000000c54 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c54:	715d                	add	sp,sp,-80
 c56:	ec06                	sd	ra,24(sp)
 c58:	e822                	sd	s0,16(sp)
 c5a:	1000                	add	s0,sp,32
 c5c:	e010                	sd	a2,0(s0)
 c5e:	e414                	sd	a3,8(s0)
 c60:	e818                	sd	a4,16(s0)
 c62:	ec1c                	sd	a5,24(s0)
 c64:	03043023          	sd	a6,32(s0)
 c68:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c6c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c70:	8622                	mv	a2,s0
 c72:	00000097          	auipc	ra,0x0
 c76:	cf4080e7          	jalr	-780(ra) # 966 <vprintf>
}
 c7a:	60e2                	ld	ra,24(sp)
 c7c:	6442                	ld	s0,16(sp)
 c7e:	6161                	add	sp,sp,80
 c80:	8082                	ret

0000000000000c82 <printf>:

void
printf(const char *fmt, ...)
{
 c82:	711d                	add	sp,sp,-96
 c84:	ec06                	sd	ra,24(sp)
 c86:	e822                	sd	s0,16(sp)
 c88:	1000                	add	s0,sp,32
 c8a:	e40c                	sd	a1,8(s0)
 c8c:	e810                	sd	a2,16(s0)
 c8e:	ec14                	sd	a3,24(s0)
 c90:	f018                	sd	a4,32(s0)
 c92:	f41c                	sd	a5,40(s0)
 c94:	03043823          	sd	a6,48(s0)
 c98:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c9c:	00840613          	add	a2,s0,8
 ca0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ca4:	85aa                	mv	a1,a0
 ca6:	4505                	li	a0,1
 ca8:	00000097          	auipc	ra,0x0
 cac:	cbe080e7          	jalr	-834(ra) # 966 <vprintf>
}
 cb0:	60e2                	ld	ra,24(sp)
 cb2:	6442                	ld	s0,16(sp)
 cb4:	6125                	add	sp,sp,96
 cb6:	8082                	ret

0000000000000cb8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cb8:	1141                	add	sp,sp,-16
 cba:	e422                	sd	s0,8(sp)
 cbc:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 cbe:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cc2:	00001797          	auipc	a5,0x1
 cc6:	33e7b783          	ld	a5,830(a5) # 2000 <freep>
 cca:	a02d                	j	cf4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ccc:	4618                	lw	a4,8(a2)
 cce:	9f2d                	addw	a4,a4,a1
 cd0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 cd4:	6398                	ld	a4,0(a5)
 cd6:	6310                	ld	a2,0(a4)
 cd8:	a83d                	j	d16 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 cda:	ff852703          	lw	a4,-8(a0)
 cde:	9f31                	addw	a4,a4,a2
 ce0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ce2:	ff053683          	ld	a3,-16(a0)
 ce6:	a091                	j	d2a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ce8:	6398                	ld	a4,0(a5)
 cea:	00e7e463          	bltu	a5,a4,cf2 <free+0x3a>
 cee:	00e6ea63          	bltu	a3,a4,d02 <free+0x4a>
{
 cf2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cf4:	fed7fae3          	bgeu	a5,a3,ce8 <free+0x30>
 cf8:	6398                	ld	a4,0(a5)
 cfa:	00e6e463          	bltu	a3,a4,d02 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cfe:	fee7eae3          	bltu	a5,a4,cf2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 d02:	ff852583          	lw	a1,-8(a0)
 d06:	6390                	ld	a2,0(a5)
 d08:	02059813          	sll	a6,a1,0x20
 d0c:	01c85713          	srl	a4,a6,0x1c
 d10:	9736                	add	a4,a4,a3
 d12:	fae60de3          	beq	a2,a4,ccc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 d16:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 d1a:	4790                	lw	a2,8(a5)
 d1c:	02061593          	sll	a1,a2,0x20
 d20:	01c5d713          	srl	a4,a1,0x1c
 d24:	973e                	add	a4,a4,a5
 d26:	fae68ae3          	beq	a3,a4,cda <free+0x22>
    p->s.ptr = bp->s.ptr;
 d2a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d2c:	00001717          	auipc	a4,0x1
 d30:	2cf73a23          	sd	a5,724(a4) # 2000 <freep>
}
 d34:	6422                	ld	s0,8(sp)
 d36:	0141                	add	sp,sp,16
 d38:	8082                	ret

0000000000000d3a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d3a:	7139                	add	sp,sp,-64
 d3c:	fc06                	sd	ra,56(sp)
 d3e:	f822                	sd	s0,48(sp)
 d40:	f426                	sd	s1,40(sp)
 d42:	f04a                	sd	s2,32(sp)
 d44:	ec4e                	sd	s3,24(sp)
 d46:	e852                	sd	s4,16(sp)
 d48:	e456                	sd	s5,8(sp)
 d4a:	e05a                	sd	s6,0(sp)
 d4c:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d4e:	02051493          	sll	s1,a0,0x20
 d52:	9081                	srl	s1,s1,0x20
 d54:	04bd                	add	s1,s1,15
 d56:	8091                	srl	s1,s1,0x4
 d58:	0014899b          	addw	s3,s1,1
 d5c:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 d5e:	00001517          	auipc	a0,0x1
 d62:	2a253503          	ld	a0,674(a0) # 2000 <freep>
 d66:	c515                	beqz	a0,d92 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d68:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d6a:	4798                	lw	a4,8(a5)
 d6c:	02977f63          	bgeu	a4,s1,daa <malloc+0x70>
  if(nu < 4096)
 d70:	8a4e                	mv	s4,s3
 d72:	0009871b          	sext.w	a4,s3
 d76:	6685                	lui	a3,0x1
 d78:	00d77363          	bgeu	a4,a3,d7e <malloc+0x44>
 d7c:	6a05                	lui	s4,0x1
 d7e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d82:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d86:	00001917          	auipc	s2,0x1
 d8a:	27a90913          	add	s2,s2,634 # 2000 <freep>
  if(p == SBRK_ERROR)
 d8e:	5afd                	li	s5,-1
 d90:	a895                	j	e04 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 d92:	00001797          	auipc	a5,0x1
 d96:	27e78793          	add	a5,a5,638 # 2010 <base>
 d9a:	00001717          	auipc	a4,0x1
 d9e:	26f73323          	sd	a5,614(a4) # 2000 <freep>
 da2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 da4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 da8:	b7e1                	j	d70 <malloc+0x36>
      if(p->s.size == nunits)
 daa:	02e48c63          	beq	s1,a4,de2 <malloc+0xa8>
        p->s.size -= nunits;
 dae:	4137073b          	subw	a4,a4,s3
 db2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 db4:	02071693          	sll	a3,a4,0x20
 db8:	01c6d713          	srl	a4,a3,0x1c
 dbc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 dbe:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 dc2:	00001717          	auipc	a4,0x1
 dc6:	22a73f23          	sd	a0,574(a4) # 2000 <freep>
      return (void*)(p + 1);
 dca:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 dce:	70e2                	ld	ra,56(sp)
 dd0:	7442                	ld	s0,48(sp)
 dd2:	74a2                	ld	s1,40(sp)
 dd4:	7902                	ld	s2,32(sp)
 dd6:	69e2                	ld	s3,24(sp)
 dd8:	6a42                	ld	s4,16(sp)
 dda:	6aa2                	ld	s5,8(sp)
 ddc:	6b02                	ld	s6,0(sp)
 dde:	6121                	add	sp,sp,64
 de0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 de2:	6398                	ld	a4,0(a5)
 de4:	e118                	sd	a4,0(a0)
 de6:	bff1                	j	dc2 <malloc+0x88>
  hp->s.size = nu;
 de8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 dec:	0541                	add	a0,a0,16
 dee:	00000097          	auipc	ra,0x0
 df2:	eca080e7          	jalr	-310(ra) # cb8 <free>
  return freep;
 df6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 dfa:	d971                	beqz	a0,dce <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dfc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 dfe:	4798                	lw	a4,8(a5)
 e00:	fa9775e3          	bgeu	a4,s1,daa <malloc+0x70>
    if(p == freep)
 e04:	00093703          	ld	a4,0(s2)
 e08:	853e                	mv	a0,a5
 e0a:	fef719e3          	bne	a4,a5,dfc <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 e0e:	8552                	mv	a0,s4
 e10:	00000097          	auipc	ra,0x0
 e14:	938080e7          	jalr	-1736(ra) # 748 <sbrk>
  if(p == SBRK_ERROR)
 e18:	fd5518e3          	bne	a0,s5,de8 <malloc+0xae>
        return 0;
 e1c:	4501                	li	a0,0
 e1e:	bf45                	j	dce <malloc+0x94>
