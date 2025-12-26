
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "shell", 0 };

int
main(void)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
  int pid, wpid;

  
  // 1. 初始化文件描述符：确保 0, 1, 2 都指向控制台
  // 尝试打开控制台设备
  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	a0250513          	add	a0,a0,-1534 # a10 <malloc+0xf0>
  16:	00000097          	auipc	ra,0x0
  1a:	414080e7          	jalr	1044(ra) # 42a <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    open("console", O_RDWR); // 此时 fd = 0 (stdin)
    
  }
  
  // 复制 fd 0 到 fd 1 (stdout)
  duplicate(0); 
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	436080e7          	jalr	1078(ra) # 45a <duplicate>
  // 复制 fd 0 到 fd 2 (stderr)
  duplicate(0);
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	42c080e7          	jalr	1068(ra) # 45a <duplicate>

  

  // 2. 进入死循环：负责启动 Shell 并监控它
  for(;;){
    printf("init: starting shell\n");
  36:	00001917          	auipc	s2,0x1
  3a:	9e290913          	add	s2,s2,-1566 # a18 <malloc+0xf8>
  3e:	854a                	mv	a0,s2
  40:	00001097          	auipc	ra,0x1
  44:	828080e7          	jalr	-2008(ra) # 868 <printf>
    
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	3ba080e7          	jalr	954(ra) # 402 <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>
    // --- 父进程 (init) 逻辑 ---
    // 等待子进程退出。
    // 注意：init 还有一个职责是回收所有"孤儿进程"（父进程先退出的进程）。
    for(;;){
      // wait 返回退出的子进程 PID
      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	3b8080e7          	jalr	952(ra) # 412 <wait>
      
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // 如果退出的正是我们启动的 shell，
        // 那么跳出内层循环，回到外层循环重新启动一个新的 shell
        break; 
      }
      
      if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	a0650513          	add	a0,a0,-1530 # a70 <malloc+0x150>
  72:	00000097          	auipc	ra,0x0
  76:	7f6080e7          	jalr	2038(ra) # 868 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	38e080e7          	jalr	910(ra) # 40a <exit>
    makenode("console", 1, 1);
  84:	4605                	li	a2,1
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	98850513          	add	a0,a0,-1656 # a10 <malloc+0xf0>
  90:	00000097          	auipc	ra,0x0
  94:	3c2080e7          	jalr	962(ra) # 452 <makenode>
    open("console", O_RDWR); // 此时 fd = 0 (stdin)
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	97650513          	add	a0,a0,-1674 # a10 <malloc+0xf0>
  a2:	00000097          	auipc	ra,0x0
  a6:	388080e7          	jalr	904(ra) # 42a <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	98450513          	add	a0,a0,-1660 # a30 <malloc+0x110>
  b4:	00000097          	auipc	ra,0x0
  b8:	7b4080e7          	jalr	1972(ra) # 868 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	34c080e7          	jalr	844(ra) # 40a <exit>
      exec("shell", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	f3a58593          	add	a1,a1,-198 # 1000 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	97a50513          	add	a0,a0,-1670 # a48 <malloc+0x128>
  d6:	00000097          	auipc	ra,0x0
  da:	35c080e7          	jalr	860(ra) # 432 <exec>
      printf("init: exec shell failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	97250513          	add	a0,a0,-1678 # a50 <malloc+0x130>
  e6:	00000097          	auipc	ra,0x0
  ea:	782080e7          	jalr	1922(ra) # 868 <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	31a080e7          	jalr	794(ra) # 40a <exit>

00000000000000f8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  f8:	1141                	add	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	add	s0,sp,16
  int r;
  extern int main();
  r = main();
 100:	00000097          	auipc	ra,0x0
 104:	f00080e7          	jalr	-256(ra) # 0 <main>
  exit(r);
 108:	00000097          	auipc	ra,0x0
 10c:	302080e7          	jalr	770(ra) # 40a <exit>

0000000000000110 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 110:	1141                	add	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 116:	87aa                	mv	a5,a0
 118:	0585                	add	a1,a1,1
 11a:	0785                	add	a5,a5,1
 11c:	fff5c703          	lbu	a4,-1(a1)
 120:	fee78fa3          	sb	a4,-1(a5)
 124:	fb75                	bnez	a4,118 <strcpy+0x8>
    ;
  return os;
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	add	sp,sp,16
 12a:	8082                	ret

000000000000012c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12c:	1141                	add	sp,sp,-16
 12e:	e422                	sd	s0,8(sp)
 130:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	cb91                	beqz	a5,14a <strcmp+0x1e>
 138:	0005c703          	lbu	a4,0(a1)
 13c:	00f71763          	bne	a4,a5,14a <strcmp+0x1e>
    p++, q++;
 140:	0505                	add	a0,a0,1
 142:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 144:	00054783          	lbu	a5,0(a0)
 148:	fbe5                	bnez	a5,138 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14a:	0005c503          	lbu	a0,0(a1)
}
 14e:	40a7853b          	subw	a0,a5,a0
 152:	6422                	ld	s0,8(sp)
 154:	0141                	add	sp,sp,16
 156:	8082                	ret

0000000000000158 <strlen>:

uint
strlen(const char *s)
{
 158:	1141                	add	sp,sp,-16
 15a:	e422                	sd	s0,8(sp)
 15c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cf91                	beqz	a5,17e <strlen+0x26>
 164:	0505                	add	a0,a0,1
 166:	87aa                	mv	a5,a0
 168:	86be                	mv	a3,a5
 16a:	0785                	add	a5,a5,1
 16c:	fff7c703          	lbu	a4,-1(a5)
 170:	ff65                	bnez	a4,168 <strlen+0x10>
 172:	40a6853b          	subw	a0,a3,a0
 176:	2505                	addw	a0,a0,1
    ;
  return n;
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	add	sp,sp,16
 17c:	8082                	ret
  for(n = 0; s[n]; n++)
 17e:	4501                	li	a0,0
 180:	bfe5                	j	178 <strlen+0x20>

0000000000000182 <memset>:

void*
memset(void *dst, int c, uint n)
{
 182:	1141                	add	sp,sp,-16
 184:	e422                	sd	s0,8(sp)
 186:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 188:	ca19                	beqz	a2,19e <memset+0x1c>
 18a:	87aa                	mv	a5,a0
 18c:	1602                	sll	a2,a2,0x20
 18e:	9201                	srl	a2,a2,0x20
 190:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 194:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 198:	0785                	add	a5,a5,1
 19a:	fee79de3          	bne	a5,a4,194 <memset+0x12>
  }
  return dst;
}
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	add	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strchr>:

char*
strchr(const char *s, char c)
{
 1a4:	1141                	add	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	add	s0,sp,16
  for(; *s; s++)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cb99                	beqz	a5,1c4 <strchr+0x20>
    if(*s == c)
 1b0:	00f58763          	beq	a1,a5,1be <strchr+0x1a>
  for(; *s; s++)
 1b4:	0505                	add	a0,a0,1
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	fbfd                	bnez	a5,1b0 <strchr+0xc>
      return (char*)s;
  return 0;
 1bc:	4501                	li	a0,0
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	add	sp,sp,16
 1c2:	8082                	ret
  return 0;
 1c4:	4501                	li	a0,0
 1c6:	bfe5                	j	1be <strchr+0x1a>

00000000000001c8 <gets>:

char*
gets(char *buf, int max)
{
 1c8:	711d                	add	sp,sp,-96
 1ca:	ec86                	sd	ra,88(sp)
 1cc:	e8a2                	sd	s0,80(sp)
 1ce:	e4a6                	sd	s1,72(sp)
 1d0:	e0ca                	sd	s2,64(sp)
 1d2:	fc4e                	sd	s3,56(sp)
 1d4:	f852                	sd	s4,48(sp)
 1d6:	f456                	sd	s5,40(sp)
 1d8:	f05a                	sd	s6,32(sp)
 1da:	ec5e                	sd	s7,24(sp)
 1dc:	1080                	add	s0,sp,96
 1de:	8baa                	mv	s7,a0
 1e0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e2:	892a                	mv	s2,a0
 1e4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e6:	4aa9                	li	s5,10
 1e8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ea:	89a6                	mv	s3,s1
 1ec:	2485                	addw	s1,s1,1
 1ee:	0344d863          	bge	s1,s4,21e <gets+0x56>
    cc = read(0, &c, 1);
 1f2:	4605                	li	a2,1
 1f4:	faf40593          	add	a1,s0,-81
 1f8:	4501                	li	a0,0
 1fa:	00000097          	auipc	ra,0x0
 1fe:	240080e7          	jalr	576(ra) # 43a <read>
    if(cc < 1)
 202:	00a05e63          	blez	a0,21e <gets+0x56>
    buf[i++] = c;
 206:	faf44783          	lbu	a5,-81(s0)
 20a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20e:	01578763          	beq	a5,s5,21c <gets+0x54>
 212:	0905                	add	s2,s2,1
 214:	fd679be3          	bne	a5,s6,1ea <gets+0x22>
  for(i=0; i+1 < max; ){
 218:	89a6                	mv	s3,s1
 21a:	a011                	j	21e <gets+0x56>
 21c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 21e:	99de                	add	s3,s3,s7
 220:	00098023          	sb	zero,0(s3)
  return buf;
}
 224:	855e                	mv	a0,s7
 226:	60e6                	ld	ra,88(sp)
 228:	6446                	ld	s0,80(sp)
 22a:	64a6                	ld	s1,72(sp)
 22c:	6906                	ld	s2,64(sp)
 22e:	79e2                	ld	s3,56(sp)
 230:	7a42                	ld	s4,48(sp)
 232:	7aa2                	ld	s5,40(sp)
 234:	7b02                	ld	s6,32(sp)
 236:	6be2                	ld	s7,24(sp)
 238:	6125                	add	sp,sp,96
 23a:	8082                	ret

000000000000023c <atoi>:
//   return r;
// }

int
atoi(const char *s)
{
 23c:	1141                	add	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 242:	00054683          	lbu	a3,0(a0)
 246:	fd06879b          	addw	a5,a3,-48
 24a:	0ff7f793          	zext.b	a5,a5
 24e:	4625                	li	a2,9
 250:	02f66863          	bltu	a2,a5,280 <atoi+0x44>
 254:	872a                	mv	a4,a0
  n = 0;
 256:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 258:	0705                	add	a4,a4,1
 25a:	0025179b          	sllw	a5,a0,0x2
 25e:	9fa9                	addw	a5,a5,a0
 260:	0017979b          	sllw	a5,a5,0x1
 264:	9fb5                	addw	a5,a5,a3
 266:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 26a:	00074683          	lbu	a3,0(a4)
 26e:	fd06879b          	addw	a5,a3,-48
 272:	0ff7f793          	zext.b	a5,a5
 276:	fef671e3          	bgeu	a2,a5,258 <atoi+0x1c>
  return n;
}
 27a:	6422                	ld	s0,8(sp)
 27c:	0141                	add	sp,sp,16
 27e:	8082                	ret
  n = 0;
 280:	4501                	li	a0,0
 282:	bfe5                	j	27a <atoi+0x3e>

0000000000000284 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 284:	1141                	add	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 28a:	02b57463          	bgeu	a0,a1,2b2 <memmove+0x2e>
    while(n-- > 0)
 28e:	00c05f63          	blez	a2,2ac <memmove+0x28>
 292:	1602                	sll	a2,a2,0x20
 294:	9201                	srl	a2,a2,0x20
 296:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 29a:	872a                	mv	a4,a0
      *dst++ = *src++;
 29c:	0585                	add	a1,a1,1
 29e:	0705                	add	a4,a4,1
 2a0:	fff5c683          	lbu	a3,-1(a1)
 2a4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2a8:	fee79ae3          	bne	a5,a4,29c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	add	sp,sp,16
 2b0:	8082                	ret
    dst += n;
 2b2:	00c50733          	add	a4,a0,a2
    src += n;
 2b6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2b8:	fec05ae3          	blez	a2,2ac <memmove+0x28>
 2bc:	fff6079b          	addw	a5,a2,-1
 2c0:	1782                	sll	a5,a5,0x20
 2c2:	9381                	srl	a5,a5,0x20
 2c4:	fff7c793          	not	a5,a5
 2c8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ca:	15fd                	add	a1,a1,-1
 2cc:	177d                	add	a4,a4,-1
 2ce:	0005c683          	lbu	a3,0(a1)
 2d2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2d6:	fee79ae3          	bne	a5,a4,2ca <memmove+0x46>
 2da:	bfc9                	j	2ac <memmove+0x28>

00000000000002dc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2dc:	1141                	add	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2e2:	ca05                	beqz	a2,312 <memcmp+0x36>
 2e4:	fff6069b          	addw	a3,a2,-1
 2e8:	1682                	sll	a3,a3,0x20
 2ea:	9281                	srl	a3,a3,0x20
 2ec:	0685                	add	a3,a3,1
 2ee:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2f0:	00054783          	lbu	a5,0(a0)
 2f4:	0005c703          	lbu	a4,0(a1)
 2f8:	00e79863          	bne	a5,a4,308 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2fc:	0505                	add	a0,a0,1
    p2++;
 2fe:	0585                	add	a1,a1,1
  while (n-- > 0) {
 300:	fed518e3          	bne	a0,a3,2f0 <memcmp+0x14>
  }
  return 0;
 304:	4501                	li	a0,0
 306:	a019                	j	30c <memcmp+0x30>
      return *p1 - *p2;
 308:	40e7853b          	subw	a0,a5,a4
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	add	sp,sp,16
 310:	8082                	ret
  return 0;
 312:	4501                	li	a0,0
 314:	bfe5                	j	30c <memcmp+0x30>

0000000000000316 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 316:	1141                	add	sp,sp,-16
 318:	e406                	sd	ra,8(sp)
 31a:	e022                	sd	s0,0(sp)
 31c:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 31e:	00000097          	auipc	ra,0x0
 322:	f66080e7          	jalr	-154(ra) # 284 <memmove>
}
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	add	sp,sp,16
 32c:	8082                	ret

000000000000032e <sbrk>:

char *
sbrk(int n) {
 32e:	1141                	add	sp,sp,-16
 330:	e406                	sd	ra,8(sp)
 332:	e022                	sd	s0,0(sp)
 334:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 336:	4585                	li	a1,1
 338:	00000097          	auipc	ra,0x0
 33c:	12a080e7          	jalr	298(ra) # 462 <sys_sbrk>
}
 340:	60a2                	ld	ra,8(sp)
 342:	6402                	ld	s0,0(sp)
 344:	0141                	add	sp,sp,16
 346:	8082                	ret

0000000000000348 <get_time>:
//   return sys_sbrk(n, SBRK_LAZY);
// }


unsigned int 
get_time(void) {
 348:	1141                	add	sp,sp,-16
 34a:	e406                	sd	ra,8(sp)
 34c:	e022                	sd	s0,0(sp)
 34e:	0800                	add	s0,sp,16
    return uptime();
 350:	00000097          	auipc	ra,0x0
 354:	11a080e7          	jalr	282(ra) # 46a <uptime>
}
 358:	2501                	sext.w	a0,a0
 35a:	60a2                	ld	ra,8(sp)
 35c:	6402                	ld	s0,0(sp)
 35e:	0141                	add	sp,sp,16
 360:	8082                	ret

0000000000000362 <make_filename>:
void 
make_filename(char *buf, const char *prefix, int num) {
    // 复制前缀
    char *p = buf;
    const char *s = prefix;
    while(*s) *p++ = *s++;
 362:	0005c783          	lbu	a5,0(a1)
 366:	cb81                	beqz	a5,376 <make_filename+0x14>
 368:	0585                	add	a1,a1,1
 36a:	0505                	add	a0,a0,1
 36c:	fef50fa3          	sb	a5,-1(a0)
 370:	0005c783          	lbu	a5,0(a1)
 374:	fbf5                	bnez	a5,368 <make_filename+0x6>
    
    // 处理数字部分
    if (num == 0) {
 376:	ca3d                	beqz	a2,3ec <make_filename+0x8a>
make_filename(char *buf, const char *prefix, int num) {
 378:	1101                	add	sp,sp,-32
 37a:	ec22                	sd	s0,24(sp)
 37c:	1000                	add	s0,sp,32
        *p++ = '0';
    } else {
        // 临时缓冲区存放数字
        char digits[16];
        int i = 0;
        while(num > 0) {
 37e:	fe040893          	add	a7,s0,-32
 382:	87c6                	mv	a5,a7
            digits[i++] = (num % 10) + '0';
 384:	46a9                	li	a3,10
        while(num > 0) {
 386:	4825                	li	a6,9
 388:	06c05063          	blez	a2,3e8 <make_filename+0x86>
            digits[i++] = (num % 10) + '0';
 38c:	02d6673b          	remw	a4,a2,a3
 390:	0307071b          	addw	a4,a4,48
 394:	00e78023          	sb	a4,0(a5)
            num /= 10;
 398:	85b2                	mv	a1,a2
 39a:	02d6463b          	divw	a2,a2,a3
        while(num > 0) {
 39e:	873e                	mv	a4,a5
 3a0:	0785                	add	a5,a5,1
 3a2:	feb845e3          	blt	a6,a1,38c <make_filename+0x2a>
 3a6:	4117073b          	subw	a4,a4,a7
 3aa:	0017069b          	addw	a3,a4,1
            digits[i++] = (num % 10) + '0';
 3ae:	0006879b          	sext.w	a5,a3
        }
        // 倒序写入
        while(i > 0) *p++ = digits[--i];
 3b2:	04f05663          	blez	a5,3fe <make_filename+0x9c>
 3b6:	fe040713          	add	a4,s0,-32
 3ba:	973e                	add	a4,a4,a5
 3bc:	02069593          	sll	a1,a3,0x20
 3c0:	9181                	srl	a1,a1,0x20
 3c2:	95aa                	add	a1,a1,a0
 3c4:	87aa                	mv	a5,a0
 3c6:	0785                	add	a5,a5,1
 3c8:	fff74603          	lbu	a2,-1(a4)
 3cc:	fec78fa3          	sb	a2,-1(a5)
 3d0:	177d                	add	a4,a4,-1
 3d2:	feb79ae3          	bne	a5,a1,3c6 <make_filename+0x64>
 3d6:	02069793          	sll	a5,a3,0x20
 3da:	9381                	srl	a5,a5,0x20
 3dc:	97aa                	add	a5,a5,a0
    }
    *p = 0; // 字符串结束符
 3de:	00078023          	sb	zero,0(a5)
 3e2:	6462                	ld	s0,24(sp)
 3e4:	6105                	add	sp,sp,32
 3e6:	8082                	ret
        while(num > 0) {
 3e8:	87aa                	mv	a5,a0
 3ea:	bfd5                	j	3de <make_filename+0x7c>
        *p++ = '0';
 3ec:	00150793          	add	a5,a0,1
 3f0:	03000713          	li	a4,48
 3f4:	00e50023          	sb	a4,0(a0)
    *p = 0; // 字符串结束符
 3f8:	00078023          	sb	zero,0(a5)
 3fc:	8082                	ret
        while(i > 0) *p++ = digits[--i];
 3fe:	87aa                	mv	a5,a0
 400:	bff9                	j	3de <make_filename+0x7c>

0000000000000402 <fork>:
.globl unlink
# generated by usys.pl - do not edit
#include "../kernel/sys/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 402:	4885                	li	a7,1
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <exit>:
.global exit
exit:
 li a7, SYS_exit
 40a:	4889                	li	a7,2
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <wait>:
.global wait
wait:
 li a7, SYS_wait
 412:	488d                	li	a7,3
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 41a:	4891                	li	a7,4
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <close>:
.global close
close:
 li a7, SYS_close
 422:	4899                	li	a7,6
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <open>:
.global open
open:
 li a7, SYS_open
 42a:	489d                	li	a7,7
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <exec>:
.global exec
exec:
 li a7, SYS_exec
 432:	4895                	li	a7,5
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <read>:
.global read
read:
 li a7, SYS_read
 43a:	48a1                	li	a7,8
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <write>:
.global write
write:
 li a7, SYS_write
 442:	48a5                	li	a7,9
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 44a:	48a9                	li	a7,10
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <makenode>:
.global makenode
makenode:
 li a7, SYS_makenode
 452:	48ad                	li	a7,11
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <duplicate>:
.global duplicate
duplicate:
 li a7, SYS_duplicate
 45a:	48b1                	li	a7,12
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 462:	48b5                	li	a7,13
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 46a:	48b9                	li	a7,14
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 472:	48bd                	li	a7,15
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 47a:	48c1                	li	a7,16
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <crash_arm>:
.global crash_arm
crash_arm:
 li a7, SYS_crash_arm
 482:	48c5                	li	a7,17
 ecall
 484:	00000073          	ecall
 488:	8082                	ret

000000000000048a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 48a:	1101                	add	sp,sp,-32
 48c:	ec06                	sd	ra,24(sp)
 48e:	e822                	sd	s0,16(sp)
 490:	1000                	add	s0,sp,32
 492:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 496:	4605                	li	a2,1
 498:	fef40593          	add	a1,s0,-17
 49c:	00000097          	auipc	ra,0x0
 4a0:	fa6080e7          	jalr	-90(ra) # 442 <write>
}
 4a4:	60e2                	ld	ra,24(sp)
 4a6:	6442                	ld	s0,16(sp)
 4a8:	6105                	add	sp,sp,32
 4aa:	8082                	ret

00000000000004ac <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4ac:	715d                	add	sp,sp,-80
 4ae:	e486                	sd	ra,72(sp)
 4b0:	e0a2                	sd	s0,64(sp)
 4b2:	fc26                	sd	s1,56(sp)
 4b4:	f84a                	sd	s2,48(sp)
 4b6:	f44e                	sd	s3,40(sp)
 4b8:	0880                	add	s0,sp,80
 4ba:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4bc:	c299                	beqz	a3,4c2 <printint+0x16>
 4be:	0805c363          	bltz	a1,544 <printint+0x98>
  neg = 0;
 4c2:	4881                	li	a7,0
 4c4:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4c8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4ca:	00000517          	auipc	a0,0x0
 4ce:	5ce50513          	add	a0,a0,1486 # a98 <digits>
 4d2:	883e                	mv	a6,a5
 4d4:	2785                	addw	a5,a5,1
 4d6:	02c5f733          	remu	a4,a1,a2
 4da:	972a                	add	a4,a4,a0
 4dc:	00074703          	lbu	a4,0(a4)
 4e0:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4e4:	872e                	mv	a4,a1
 4e6:	02c5d5b3          	divu	a1,a1,a2
 4ea:	0685                	add	a3,a3,1
 4ec:	fec773e3          	bgeu	a4,a2,4d2 <printint+0x26>
  if(neg)
 4f0:	00088b63          	beqz	a7,506 <printint+0x5a>
    buf[i++] = '-';
 4f4:	fd078793          	add	a5,a5,-48
 4f8:	97a2                	add	a5,a5,s0
 4fa:	02d00713          	li	a4,45
 4fe:	fee78423          	sb	a4,-24(a5)
 502:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 506:	02f05863          	blez	a5,536 <printint+0x8a>
 50a:	fb840713          	add	a4,s0,-72
 50e:	00f704b3          	add	s1,a4,a5
 512:	fff70993          	add	s3,a4,-1
 516:	99be                	add	s3,s3,a5
 518:	37fd                	addw	a5,a5,-1
 51a:	1782                	sll	a5,a5,0x20
 51c:	9381                	srl	a5,a5,0x20
 51e:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 522:	fff4c583          	lbu	a1,-1(s1)
 526:	854a                	mv	a0,s2
 528:	00000097          	auipc	ra,0x0
 52c:	f62080e7          	jalr	-158(ra) # 48a <putc>
  while(--i >= 0)
 530:	14fd                	add	s1,s1,-1
 532:	ff3498e3          	bne	s1,s3,522 <printint+0x76>
}
 536:	60a6                	ld	ra,72(sp)
 538:	6406                	ld	s0,64(sp)
 53a:	74e2                	ld	s1,56(sp)
 53c:	7942                	ld	s2,48(sp)
 53e:	79a2                	ld	s3,40(sp)
 540:	6161                	add	sp,sp,80
 542:	8082                	ret
    x = -xx;
 544:	40b005b3          	neg	a1,a1
    neg = 1;
 548:	4885                	li	a7,1
    x = -xx;
 54a:	bfad                	j	4c4 <printint+0x18>

000000000000054c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 54c:	711d                	add	sp,sp,-96
 54e:	ec86                	sd	ra,88(sp)
 550:	e8a2                	sd	s0,80(sp)
 552:	e4a6                	sd	s1,72(sp)
 554:	e0ca                	sd	s2,64(sp)
 556:	fc4e                	sd	s3,56(sp)
 558:	f852                	sd	s4,48(sp)
 55a:	f456                	sd	s5,40(sp)
 55c:	f05a                	sd	s6,32(sp)
 55e:	ec5e                	sd	s7,24(sp)
 560:	e862                	sd	s8,16(sp)
 562:	e466                	sd	s9,8(sp)
 564:	e06a                	sd	s10,0(sp)
 566:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 568:	0005c903          	lbu	s2,0(a1)
 56c:	2a090963          	beqz	s2,81e <vprintf+0x2d2>
 570:	8b2a                	mv	s6,a0
 572:	8a2e                	mv	s4,a1
 574:	8bb2                	mv	s7,a2
  state = 0;
 576:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 578:	4481                	li	s1,0
 57a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 57c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 580:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 584:	06c00c93          	li	s9,108
 588:	a015                	j	5ac <vprintf+0x60>
        putc(fd, c0);
 58a:	85ca                	mv	a1,s2
 58c:	855a                	mv	a0,s6
 58e:	00000097          	auipc	ra,0x0
 592:	efc080e7          	jalr	-260(ra) # 48a <putc>
 596:	a019                	j	59c <vprintf+0x50>
    } else if(state == '%'){
 598:	03598263          	beq	s3,s5,5bc <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 59c:	2485                	addw	s1,s1,1
 59e:	8726                	mv	a4,s1
 5a0:	009a07b3          	add	a5,s4,s1
 5a4:	0007c903          	lbu	s2,0(a5)
 5a8:	26090b63          	beqz	s2,81e <vprintf+0x2d2>
    c0 = fmt[i] & 0xff;
 5ac:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5b0:	fe0994e3          	bnez	s3,598 <vprintf+0x4c>
      if(c0 == '%'){
 5b4:	fd579be3          	bne	a5,s5,58a <vprintf+0x3e>
        state = '%';
 5b8:	89be                	mv	s3,a5
 5ba:	b7cd                	j	59c <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 5bc:	cfc9                	beqz	a5,656 <vprintf+0x10a>
 5be:	00ea06b3          	add	a3,s4,a4
 5c2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5c6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5c8:	c681                	beqz	a3,5d0 <vprintf+0x84>
 5ca:	9752                	add	a4,a4,s4
 5cc:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5d0:	05878563          	beq	a5,s8,61a <vprintf+0xce>
      } else if(c0 == 'l' && c1 == 'd'){
 5d4:	07978163          	beq	a5,s9,636 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5d8:	07500713          	li	a4,117
 5dc:	10e78563          	beq	a5,a4,6e6 <vprintf+0x19a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5e0:	07800713          	li	a4,120
 5e4:	14e78d63          	beq	a5,a4,73e <vprintf+0x1f2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5e8:	07000713          	li	a4,112
 5ec:	18e78663          	beq	a5,a4,778 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5f0:	06300713          	li	a4,99
 5f4:	1ce78a63          	beq	a5,a4,7c8 <vprintf+0x27c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5f8:	07300713          	li	a4,115
 5fc:	1ee78263          	beq	a5,a4,7e0 <vprintf+0x294>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 600:	02500713          	li	a4,37
 604:	04e79963          	bne	a5,a4,656 <vprintf+0x10a>
        putc(fd, '%');
 608:	02500593          	li	a1,37
 60c:	855a                	mv	a0,s6
 60e:	00000097          	auipc	ra,0x0
 612:	e7c080e7          	jalr	-388(ra) # 48a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 616:	4981                	li	s3,0
 618:	b751                	j	59c <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 61a:	008b8913          	add	s2,s7,8
 61e:	4685                	li	a3,1
 620:	4629                	li	a2,10
 622:	000ba583          	lw	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	00000097          	auipc	ra,0x0
 62c:	e84080e7          	jalr	-380(ra) # 4ac <printint>
 630:	8bca                	mv	s7,s2
      state = 0;
 632:	4981                	li	s3,0
 634:	b7a5                	j	59c <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 636:	06400793          	li	a5,100
 63a:	02f68d63          	beq	a3,a5,674 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 63e:	06c00793          	li	a5,108
 642:	04f68863          	beq	a3,a5,692 <vprintf+0x146>
      } else if(c0 == 'l' && c1 == 'u'){
 646:	07500793          	li	a5,117
 64a:	0af68c63          	beq	a3,a5,702 <vprintf+0x1b6>
      } else if(c0 == 'l' && c1 == 'x'){
 64e:	07800793          	li	a5,120
 652:	10f68463          	beq	a3,a5,75a <vprintf+0x20e>
        putc(fd, '%');
 656:	02500593          	li	a1,37
 65a:	855a                	mv	a0,s6
 65c:	00000097          	auipc	ra,0x0
 660:	e2e080e7          	jalr	-466(ra) # 48a <putc>
        putc(fd, c0);
 664:	85ca                	mv	a1,s2
 666:	855a                	mv	a0,s6
 668:	00000097          	auipc	ra,0x0
 66c:	e22080e7          	jalr	-478(ra) # 48a <putc>
      state = 0;
 670:	4981                	li	s3,0
 672:	b72d                	j	59c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 674:	008b8913          	add	s2,s7,8
 678:	4685                	li	a3,1
 67a:	4629                	li	a2,10
 67c:	000bb583          	ld	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	00000097          	auipc	ra,0x0
 686:	e2a080e7          	jalr	-470(ra) # 4ac <printint>
        i += 1;
 68a:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 68c:	8bca                	mv	s7,s2
      state = 0;
 68e:	4981                	li	s3,0
        i += 1;
 690:	b731                	j	59c <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 692:	06400793          	li	a5,100
 696:	02f60963          	beq	a2,a5,6c8 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 69a:	07500793          	li	a5,117
 69e:	08f60163          	beq	a2,a5,720 <vprintf+0x1d4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6a2:	07800793          	li	a5,120
 6a6:	faf618e3          	bne	a2,a5,656 <vprintf+0x10a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6aa:	008b8913          	add	s2,s7,8
 6ae:	4681                	li	a3,0
 6b0:	4641                	li	a2,16
 6b2:	000bb583          	ld	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	00000097          	auipc	ra,0x0
 6bc:	df4080e7          	jalr	-524(ra) # 4ac <printint>
        i += 2;
 6c0:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c2:	8bca                	mv	s7,s2
      state = 0;
 6c4:	4981                	li	s3,0
        i += 2;
 6c6:	bdd9                	j	59c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c8:	008b8913          	add	s2,s7,8
 6cc:	4685                	li	a3,1
 6ce:	4629                	li	a2,10
 6d0:	000bb583          	ld	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	00000097          	auipc	ra,0x0
 6da:	dd6080e7          	jalr	-554(ra) # 4ac <printint>
        i += 2;
 6de:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e0:	8bca                	mv	s7,s2
      state = 0;
 6e2:	4981                	li	s3,0
        i += 2;
 6e4:	bd65                	j	59c <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6e6:	008b8913          	add	s2,s7,8
 6ea:	4681                	li	a3,0
 6ec:	4629                	li	a2,10
 6ee:	000be583          	lwu	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	00000097          	auipc	ra,0x0
 6f8:	db8080e7          	jalr	-584(ra) # 4ac <printint>
 6fc:	8bca                	mv	s7,s2
      state = 0;
 6fe:	4981                	li	s3,0
 700:	bd71                	j	59c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 702:	008b8913          	add	s2,s7,8
 706:	4681                	li	a3,0
 708:	4629                	li	a2,10
 70a:	000bb583          	ld	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	00000097          	auipc	ra,0x0
 714:	d9c080e7          	jalr	-612(ra) # 4ac <printint>
        i += 1;
 718:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 71a:	8bca                	mv	s7,s2
      state = 0;
 71c:	4981                	li	s3,0
        i += 1;
 71e:	bdbd                	j	59c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 720:	008b8913          	add	s2,s7,8
 724:	4681                	li	a3,0
 726:	4629                	li	a2,10
 728:	000bb583          	ld	a1,0(s7)
 72c:	855a                	mv	a0,s6
 72e:	00000097          	auipc	ra,0x0
 732:	d7e080e7          	jalr	-642(ra) # 4ac <printint>
        i += 2;
 736:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
        i += 2;
 73c:	b585                	j	59c <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 16, 0);
 73e:	008b8913          	add	s2,s7,8
 742:	4681                	li	a3,0
 744:	4641                	li	a2,16
 746:	000be583          	lwu	a1,0(s7)
 74a:	855a                	mv	a0,s6
 74c:	00000097          	auipc	ra,0x0
 750:	d60080e7          	jalr	-672(ra) # 4ac <printint>
 754:	8bca                	mv	s7,s2
      state = 0;
 756:	4981                	li	s3,0
 758:	b591                	j	59c <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 75a:	008b8913          	add	s2,s7,8
 75e:	4681                	li	a3,0
 760:	4641                	li	a2,16
 762:	000bb583          	ld	a1,0(s7)
 766:	855a                	mv	a0,s6
 768:	00000097          	auipc	ra,0x0
 76c:	d44080e7          	jalr	-700(ra) # 4ac <printint>
        i += 1;
 770:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 772:	8bca                	mv	s7,s2
      state = 0;
 774:	4981                	li	s3,0
        i += 1;
 776:	b51d                	j	59c <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 778:	008b8d13          	add	s10,s7,8
 77c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 780:	03000593          	li	a1,48
 784:	855a                	mv	a0,s6
 786:	00000097          	auipc	ra,0x0
 78a:	d04080e7          	jalr	-764(ra) # 48a <putc>
  putc(fd, 'x');
 78e:	07800593          	li	a1,120
 792:	855a                	mv	a0,s6
 794:	00000097          	auipc	ra,0x0
 798:	cf6080e7          	jalr	-778(ra) # 48a <putc>
 79c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 79e:	00000b97          	auipc	s7,0x0
 7a2:	2fab8b93          	add	s7,s7,762 # a98 <digits>
 7a6:	03c9d793          	srl	a5,s3,0x3c
 7aa:	97de                	add	a5,a5,s7
 7ac:	0007c583          	lbu	a1,0(a5)
 7b0:	855a                	mv	a0,s6
 7b2:	00000097          	auipc	ra,0x0
 7b6:	cd8080e7          	jalr	-808(ra) # 48a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ba:	0992                	sll	s3,s3,0x4
 7bc:	397d                	addw	s2,s2,-1
 7be:	fe0914e3          	bnez	s2,7a6 <vprintf+0x25a>
        printptr(fd, va_arg(ap, uint64));
 7c2:	8bea                	mv	s7,s10
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	bbd9                	j	59c <vprintf+0x50>
        putc(fd, va_arg(ap, uint32));
 7c8:	008b8913          	add	s2,s7,8
 7cc:	000bc583          	lbu	a1,0(s7)
 7d0:	855a                	mv	a0,s6
 7d2:	00000097          	auipc	ra,0x0
 7d6:	cb8080e7          	jalr	-840(ra) # 48a <putc>
 7da:	8bca                	mv	s7,s2
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	bb7d                	j	59c <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 7e0:	008b8993          	add	s3,s7,8
 7e4:	000bb903          	ld	s2,0(s7)
 7e8:	02090163          	beqz	s2,80a <vprintf+0x2be>
        for(; *s; s++)
 7ec:	00094583          	lbu	a1,0(s2)
 7f0:	c585                	beqz	a1,818 <vprintf+0x2cc>
          putc(fd, *s);
 7f2:	855a                	mv	a0,s6
 7f4:	00000097          	auipc	ra,0x0
 7f8:	c96080e7          	jalr	-874(ra) # 48a <putc>
        for(; *s; s++)
 7fc:	0905                	add	s2,s2,1
 7fe:	00094583          	lbu	a1,0(s2)
 802:	f9e5                	bnez	a1,7f2 <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
 804:	8bce                	mv	s7,s3
      state = 0;
 806:	4981                	li	s3,0
 808:	bb51                	j	59c <vprintf+0x50>
          s = "(null)";
 80a:	00000917          	auipc	s2,0x0
 80e:	28690913          	add	s2,s2,646 # a90 <malloc+0x170>
        for(; *s; s++)
 812:	02800593          	li	a1,40
 816:	bff1                	j	7f2 <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
 818:	8bce                	mv	s7,s3
      state = 0;
 81a:	4981                	li	s3,0
 81c:	b341                	j	59c <vprintf+0x50>
    }
  }
}
 81e:	60e6                	ld	ra,88(sp)
 820:	6446                	ld	s0,80(sp)
 822:	64a6                	ld	s1,72(sp)
 824:	6906                	ld	s2,64(sp)
 826:	79e2                	ld	s3,56(sp)
 828:	7a42                	ld	s4,48(sp)
 82a:	7aa2                	ld	s5,40(sp)
 82c:	7b02                	ld	s6,32(sp)
 82e:	6be2                	ld	s7,24(sp)
 830:	6c42                	ld	s8,16(sp)
 832:	6ca2                	ld	s9,8(sp)
 834:	6d02                	ld	s10,0(sp)
 836:	6125                	add	sp,sp,96
 838:	8082                	ret

000000000000083a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 83a:	715d                	add	sp,sp,-80
 83c:	ec06                	sd	ra,24(sp)
 83e:	e822                	sd	s0,16(sp)
 840:	1000                	add	s0,sp,32
 842:	e010                	sd	a2,0(s0)
 844:	e414                	sd	a3,8(s0)
 846:	e818                	sd	a4,16(s0)
 848:	ec1c                	sd	a5,24(s0)
 84a:	03043023          	sd	a6,32(s0)
 84e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 852:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 856:	8622                	mv	a2,s0
 858:	00000097          	auipc	ra,0x0
 85c:	cf4080e7          	jalr	-780(ra) # 54c <vprintf>
}
 860:	60e2                	ld	ra,24(sp)
 862:	6442                	ld	s0,16(sp)
 864:	6161                	add	sp,sp,80
 866:	8082                	ret

0000000000000868 <printf>:

void
printf(const char *fmt, ...)
{
 868:	711d                	add	sp,sp,-96
 86a:	ec06                	sd	ra,24(sp)
 86c:	e822                	sd	s0,16(sp)
 86e:	1000                	add	s0,sp,32
 870:	e40c                	sd	a1,8(s0)
 872:	e810                	sd	a2,16(s0)
 874:	ec14                	sd	a3,24(s0)
 876:	f018                	sd	a4,32(s0)
 878:	f41c                	sd	a5,40(s0)
 87a:	03043823          	sd	a6,48(s0)
 87e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 882:	00840613          	add	a2,s0,8
 886:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 88a:	85aa                	mv	a1,a0
 88c:	4505                	li	a0,1
 88e:	00000097          	auipc	ra,0x0
 892:	cbe080e7          	jalr	-834(ra) # 54c <vprintf>
}
 896:	60e2                	ld	ra,24(sp)
 898:	6442                	ld	s0,16(sp)
 89a:	6125                	add	sp,sp,96
 89c:	8082                	ret

000000000000089e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 89e:	1141                	add	sp,sp,-16
 8a0:	e422                	sd	s0,8(sp)
 8a2:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a4:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a8:	00000797          	auipc	a5,0x0
 8ac:	7687b783          	ld	a5,1896(a5) # 1010 <freep>
 8b0:	a02d                	j	8da <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8b2:	4618                	lw	a4,8(a2)
 8b4:	9f2d                	addw	a4,a4,a1
 8b6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ba:	6398                	ld	a4,0(a5)
 8bc:	6310                	ld	a2,0(a4)
 8be:	a83d                	j	8fc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8c0:	ff852703          	lw	a4,-8(a0)
 8c4:	9f31                	addw	a4,a4,a2
 8c6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8c8:	ff053683          	ld	a3,-16(a0)
 8cc:	a091                	j	910 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ce:	6398                	ld	a4,0(a5)
 8d0:	00e7e463          	bltu	a5,a4,8d8 <free+0x3a>
 8d4:	00e6ea63          	bltu	a3,a4,8e8 <free+0x4a>
{
 8d8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8da:	fed7fae3          	bgeu	a5,a3,8ce <free+0x30>
 8de:	6398                	ld	a4,0(a5)
 8e0:	00e6e463          	bltu	a3,a4,8e8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e4:	fee7eae3          	bltu	a5,a4,8d8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8e8:	ff852583          	lw	a1,-8(a0)
 8ec:	6390                	ld	a2,0(a5)
 8ee:	02059813          	sll	a6,a1,0x20
 8f2:	01c85713          	srl	a4,a6,0x1c
 8f6:	9736                	add	a4,a4,a3
 8f8:	fae60de3          	beq	a2,a4,8b2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8fc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 900:	4790                	lw	a2,8(a5)
 902:	02061593          	sll	a1,a2,0x20
 906:	01c5d713          	srl	a4,a1,0x1c
 90a:	973e                	add	a4,a4,a5
 90c:	fae68ae3          	beq	a3,a4,8c0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 910:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 912:	00000717          	auipc	a4,0x0
 916:	6ef73f23          	sd	a5,1790(a4) # 1010 <freep>
}
 91a:	6422                	ld	s0,8(sp)
 91c:	0141                	add	sp,sp,16
 91e:	8082                	ret

0000000000000920 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 920:	7139                	add	sp,sp,-64
 922:	fc06                	sd	ra,56(sp)
 924:	f822                	sd	s0,48(sp)
 926:	f426                	sd	s1,40(sp)
 928:	f04a                	sd	s2,32(sp)
 92a:	ec4e                	sd	s3,24(sp)
 92c:	e852                	sd	s4,16(sp)
 92e:	e456                	sd	s5,8(sp)
 930:	e05a                	sd	s6,0(sp)
 932:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 934:	02051493          	sll	s1,a0,0x20
 938:	9081                	srl	s1,s1,0x20
 93a:	04bd                	add	s1,s1,15
 93c:	8091                	srl	s1,s1,0x4
 93e:	0014899b          	addw	s3,s1,1
 942:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 944:	00000517          	auipc	a0,0x0
 948:	6cc53503          	ld	a0,1740(a0) # 1010 <freep>
 94c:	c515                	beqz	a0,978 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 950:	4798                	lw	a4,8(a5)
 952:	02977f63          	bgeu	a4,s1,990 <malloc+0x70>
  if(nu < 4096)
 956:	8a4e                	mv	s4,s3
 958:	0009871b          	sext.w	a4,s3
 95c:	6685                	lui	a3,0x1
 95e:	00d77363          	bgeu	a4,a3,964 <malloc+0x44>
 962:	6a05                	lui	s4,0x1
 964:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 968:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 96c:	00000917          	auipc	s2,0x0
 970:	6a490913          	add	s2,s2,1700 # 1010 <freep>
  if(p == SBRK_ERROR)
 974:	5afd                	li	s5,-1
 976:	a895                	j	9ea <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 978:	00000797          	auipc	a5,0x0
 97c:	6a878793          	add	a5,a5,1704 # 1020 <base>
 980:	00000717          	auipc	a4,0x0
 984:	68f73823          	sd	a5,1680(a4) # 1010 <freep>
 988:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 98a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 98e:	b7e1                	j	956 <malloc+0x36>
      if(p->s.size == nunits)
 990:	02e48c63          	beq	s1,a4,9c8 <malloc+0xa8>
        p->s.size -= nunits;
 994:	4137073b          	subw	a4,a4,s3
 998:	c798                	sw	a4,8(a5)
        p += p->s.size;
 99a:	02071693          	sll	a3,a4,0x20
 99e:	01c6d713          	srl	a4,a3,0x1c
 9a2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9a4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a8:	00000717          	auipc	a4,0x0
 9ac:	66a73423          	sd	a0,1640(a4) # 1010 <freep>
      return (void*)(p + 1);
 9b0:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9b4:	70e2                	ld	ra,56(sp)
 9b6:	7442                	ld	s0,48(sp)
 9b8:	74a2                	ld	s1,40(sp)
 9ba:	7902                	ld	s2,32(sp)
 9bc:	69e2                	ld	s3,24(sp)
 9be:	6a42                	ld	s4,16(sp)
 9c0:	6aa2                	ld	s5,8(sp)
 9c2:	6b02                	ld	s6,0(sp)
 9c4:	6121                	add	sp,sp,64
 9c6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9c8:	6398                	ld	a4,0(a5)
 9ca:	e118                	sd	a4,0(a0)
 9cc:	bff1                	j	9a8 <malloc+0x88>
  hp->s.size = nu;
 9ce:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9d2:	0541                	add	a0,a0,16
 9d4:	00000097          	auipc	ra,0x0
 9d8:	eca080e7          	jalr	-310(ra) # 89e <free>
  return freep;
 9dc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9e0:	d971                	beqz	a0,9b4 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e4:	4798                	lw	a4,8(a5)
 9e6:	fa9775e3          	bgeu	a4,s1,990 <malloc+0x70>
    if(p == freep)
 9ea:	00093703          	ld	a4,0(s2)
 9ee:	853e                	mv	a0,a5
 9f0:	fef719e3          	bne	a4,a5,9e2 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9f4:	8552                	mv	a0,s4
 9f6:	00000097          	auipc	ra,0x0
 9fa:	938080e7          	jalr	-1736(ra) # 32e <sbrk>
  if(p == SBRK_ERROR)
 9fe:	fd5518e3          	bne	a0,s5,9ce <malloc+0xae>
        return 0;
 a02:	4501                	li	a0,0
 a04:	bf45                	j	9b4 <malloc+0x94>
