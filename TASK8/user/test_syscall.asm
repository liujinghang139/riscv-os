
user/_test_syscall:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test_syscalls>:
#include"./user.h"

void
test_syscalls(){
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	add	s0,sp,32
  printf("Testing basic system calls...\n");
   8:	00001517          	auipc	a0,0x1
   c:	9c850513          	add	a0,a0,-1592 # 9d0 <malloc+0xee>
  10:	00001097          	auipc	ra,0x1
  14:	81a080e7          	jalr	-2022(ra) # 82a <printf>

  //测试getpid
  int pid = getpid();
  18:	00000097          	auipc	ra,0x0
  1c:	3c4080e7          	jalr	964(ra) # 3dc <getpid>
  20:	85aa                	mv	a1,a0
  printf("Current PID: %d\n",pid);
  22:	00001517          	auipc	a0,0x1
  26:	9ce50513          	add	a0,a0,-1586 # 9f0 <malloc+0x10e>
  2a:	00001097          	auipc	ra,0x1
  2e:	800080e7          	jalr	-2048(ra) # 82a <printf>

  //测试fork
  int child_pid = fork();
  32:	00000097          	auipc	ra,0x0
  36:	392080e7          	jalr	914(ra) # 3c4 <fork>
  if(child_pid == 0){
  3a:	c51d                	beqz	a0,68 <test_syscalls+0x68>
    //子进程
    printf("Child process: PID = %d\n", getpid());
    exit(42);
  } else if(child_pid > 0){
  3c:	04a05963          	blez	a0,8e <test_syscalls+0x8e>
    //父进程
    int status;
    wait(&status);
  40:	fec40513          	add	a0,s0,-20
  44:	00000097          	auipc	ra,0x0
  48:	390080e7          	jalr	912(ra) # 3d4 <wait>
    printf("Child exited with status: %d\n", status);
  4c:	fec42583          	lw	a1,-20(s0)
  50:	00001517          	auipc	a0,0x1
  54:	9d850513          	add	a0,a0,-1576 # a28 <malloc+0x146>
  58:	00000097          	auipc	ra,0x0
  5c:	7d2080e7          	jalr	2002(ra) # 82a <printf>
  } else{
    printf("Fork failed\n");
  }
}
  60:	60e2                	ld	ra,24(sp)
  62:	6442                	ld	s0,16(sp)
  64:	6105                	add	sp,sp,32
  66:	8082                	ret
    printf("Child process: PID = %d\n", getpid());
  68:	00000097          	auipc	ra,0x0
  6c:	374080e7          	jalr	884(ra) # 3dc <getpid>
  70:	85aa                	mv	a1,a0
  72:	00001517          	auipc	a0,0x1
  76:	99650513          	add	a0,a0,-1642 # a08 <malloc+0x126>
  7a:	00000097          	auipc	ra,0x0
  7e:	7b0080e7          	jalr	1968(ra) # 82a <printf>
    exit(42);
  82:	02a00513          	li	a0,42
  86:	00000097          	auipc	ra,0x0
  8a:	346080e7          	jalr	838(ra) # 3cc <exit>
    printf("Fork failed\n");
  8e:	00001517          	auipc	a0,0x1
  92:	9ba50513          	add	a0,a0,-1606 # a48 <malloc+0x166>
  96:	00000097          	auipc	ra,0x0
  9a:	794080e7          	jalr	1940(ra) # 82a <printf>
}
  9e:	b7c9                	j	60 <test_syscalls+0x60>

00000000000000a0 <main>:


int
main(int argc, char *argv[])
{
  a0:	1141                	add	sp,sp,-16
  a2:	e406                	sd	ra,8(sp)
  a4:	e022                	sd	s0,0(sp)
  a6:	0800                	add	s0,sp,16
  test_syscalls();
  a8:	00000097          	auipc	ra,0x0
  ac:	f58080e7          	jalr	-168(ra) # 0 <test_syscalls>

  exit(0);
  b0:	4501                	li	a0,0
  b2:	00000097          	auipc	ra,0x0
  b6:	31a080e7          	jalr	794(ra) # 3cc <exit>

00000000000000ba <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  ba:	1141                	add	sp,sp,-16
  bc:	e406                	sd	ra,8(sp)
  be:	e022                	sd	s0,0(sp)
  c0:	0800                	add	s0,sp,16
  int r;
  extern int main();
  r = main();
  c2:	00000097          	auipc	ra,0x0
  c6:	fde080e7          	jalr	-34(ra) # a0 <main>
  exit(r);
  ca:	00000097          	auipc	ra,0x0
  ce:	302080e7          	jalr	770(ra) # 3cc <exit>

00000000000000d2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d2:	1141                	add	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d8:	87aa                	mv	a5,a0
  da:	0585                	add	a1,a1,1
  dc:	0785                	add	a5,a5,1
  de:	fff5c703          	lbu	a4,-1(a1)
  e2:	fee78fa3          	sb	a4,-1(a5)
  e6:	fb75                	bnez	a4,da <strcpy+0x8>
    ;
  return os;
}
  e8:	6422                	ld	s0,8(sp)
  ea:	0141                	add	sp,sp,16
  ec:	8082                	ret

00000000000000ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ee:	1141                	add	sp,sp,-16
  f0:	e422                	sd	s0,8(sp)
  f2:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cb91                	beqz	a5,10c <strcmp+0x1e>
  fa:	0005c703          	lbu	a4,0(a1)
  fe:	00f71763          	bne	a4,a5,10c <strcmp+0x1e>
    p++, q++;
 102:	0505                	add	a0,a0,1
 104:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbe5                	bnez	a5,fa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 10c:	0005c503          	lbu	a0,0(a1)
}
 110:	40a7853b          	subw	a0,a5,a0
 114:	6422                	ld	s0,8(sp)
 116:	0141                	add	sp,sp,16
 118:	8082                	ret

000000000000011a <strlen>:

uint
strlen(const char *s)
{
 11a:	1141                	add	sp,sp,-16
 11c:	e422                	sd	s0,8(sp)
 11e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 120:	00054783          	lbu	a5,0(a0)
 124:	cf91                	beqz	a5,140 <strlen+0x26>
 126:	0505                	add	a0,a0,1
 128:	87aa                	mv	a5,a0
 12a:	86be                	mv	a3,a5
 12c:	0785                	add	a5,a5,1
 12e:	fff7c703          	lbu	a4,-1(a5)
 132:	ff65                	bnez	a4,12a <strlen+0x10>
 134:	40a6853b          	subw	a0,a3,a0
 138:	2505                	addw	a0,a0,1
    ;
  return n;
}
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	add	sp,sp,16
 13e:	8082                	ret
  for(n = 0; s[n]; n++)
 140:	4501                	li	a0,0
 142:	bfe5                	j	13a <strlen+0x20>

0000000000000144 <memset>:

void*
memset(void *dst, int c, uint n)
{
 144:	1141                	add	sp,sp,-16
 146:	e422                	sd	s0,8(sp)
 148:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 14a:	ca19                	beqz	a2,160 <memset+0x1c>
 14c:	87aa                	mv	a5,a0
 14e:	1602                	sll	a2,a2,0x20
 150:	9201                	srl	a2,a2,0x20
 152:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 156:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 15a:	0785                	add	a5,a5,1
 15c:	fee79de3          	bne	a5,a4,156 <memset+0x12>
  }
  return dst;
}
 160:	6422                	ld	s0,8(sp)
 162:	0141                	add	sp,sp,16
 164:	8082                	ret

0000000000000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	1141                	add	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	add	s0,sp,16
  for(; *s; s++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cb99                	beqz	a5,186 <strchr+0x20>
    if(*s == c)
 172:	00f58763          	beq	a1,a5,180 <strchr+0x1a>
  for(; *s; s++)
 176:	0505                	add	a0,a0,1
 178:	00054783          	lbu	a5,0(a0)
 17c:	fbfd                	bnez	a5,172 <strchr+0xc>
      return (char*)s;
  return 0;
 17e:	4501                	li	a0,0
}
 180:	6422                	ld	s0,8(sp)
 182:	0141                	add	sp,sp,16
 184:	8082                	ret
  return 0;
 186:	4501                	li	a0,0
 188:	bfe5                	j	180 <strchr+0x1a>

000000000000018a <gets>:

char*
gets(char *buf, int max)
{
 18a:	711d                	add	sp,sp,-96
 18c:	ec86                	sd	ra,88(sp)
 18e:	e8a2                	sd	s0,80(sp)
 190:	e4a6                	sd	s1,72(sp)
 192:	e0ca                	sd	s2,64(sp)
 194:	fc4e                	sd	s3,56(sp)
 196:	f852                	sd	s4,48(sp)
 198:	f456                	sd	s5,40(sp)
 19a:	f05a                	sd	s6,32(sp)
 19c:	ec5e                	sd	s7,24(sp)
 19e:	1080                	add	s0,sp,96
 1a0:	8baa                	mv	s7,a0
 1a2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a4:	892a                	mv	s2,a0
 1a6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1a8:	4aa9                	li	s5,10
 1aa:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ac:	89a6                	mv	s3,s1
 1ae:	2485                	addw	s1,s1,1
 1b0:	0344d863          	bge	s1,s4,1e0 <gets+0x56>
    cc = read(0, &c, 1);
 1b4:	4605                	li	a2,1
 1b6:	faf40593          	add	a1,s0,-81
 1ba:	4501                	li	a0,0
 1bc:	00000097          	auipc	ra,0x0
 1c0:	240080e7          	jalr	576(ra) # 3fc <read>
    if(cc < 1)
 1c4:	00a05e63          	blez	a0,1e0 <gets+0x56>
    buf[i++] = c;
 1c8:	faf44783          	lbu	a5,-81(s0)
 1cc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1d0:	01578763          	beq	a5,s5,1de <gets+0x54>
 1d4:	0905                	add	s2,s2,1
 1d6:	fd679be3          	bne	a5,s6,1ac <gets+0x22>
  for(i=0; i+1 < max; ){
 1da:	89a6                	mv	s3,s1
 1dc:	a011                	j	1e0 <gets+0x56>
 1de:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1e0:	99de                	add	s3,s3,s7
 1e2:	00098023          	sb	zero,0(s3)
  return buf;
}
 1e6:	855e                	mv	a0,s7
 1e8:	60e6                	ld	ra,88(sp)
 1ea:	6446                	ld	s0,80(sp)
 1ec:	64a6                	ld	s1,72(sp)
 1ee:	6906                	ld	s2,64(sp)
 1f0:	79e2                	ld	s3,56(sp)
 1f2:	7a42                	ld	s4,48(sp)
 1f4:	7aa2                	ld	s5,40(sp)
 1f6:	7b02                	ld	s6,32(sp)
 1f8:	6be2                	ld	s7,24(sp)
 1fa:	6125                	add	sp,sp,96
 1fc:	8082                	ret

00000000000001fe <atoi>:
//   return r;
// }

int
atoi(const char *s)
{
 1fe:	1141                	add	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 204:	00054683          	lbu	a3,0(a0)
 208:	fd06879b          	addw	a5,a3,-48
 20c:	0ff7f793          	zext.b	a5,a5
 210:	4625                	li	a2,9
 212:	02f66863          	bltu	a2,a5,242 <atoi+0x44>
 216:	872a                	mv	a4,a0
  n = 0;
 218:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 21a:	0705                	add	a4,a4,1
 21c:	0025179b          	sllw	a5,a0,0x2
 220:	9fa9                	addw	a5,a5,a0
 222:	0017979b          	sllw	a5,a5,0x1
 226:	9fb5                	addw	a5,a5,a3
 228:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22c:	00074683          	lbu	a3,0(a4)
 230:	fd06879b          	addw	a5,a3,-48
 234:	0ff7f793          	zext.b	a5,a5
 238:	fef671e3          	bgeu	a2,a5,21a <atoi+0x1c>
  return n;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	add	sp,sp,16
 240:	8082                	ret
  n = 0;
 242:	4501                	li	a0,0
 244:	bfe5                	j	23c <atoi+0x3e>

0000000000000246 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 246:	1141                	add	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24c:	02b57463          	bgeu	a0,a1,274 <memmove+0x2e>
    while(n-- > 0)
 250:	00c05f63          	blez	a2,26e <memmove+0x28>
 254:	1602                	sll	a2,a2,0x20
 256:	9201                	srl	a2,a2,0x20
 258:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25c:	872a                	mv	a4,a0
      *dst++ = *src++;
 25e:	0585                	add	a1,a1,1
 260:	0705                	add	a4,a4,1
 262:	fff5c683          	lbu	a3,-1(a1)
 266:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 26a:	fee79ae3          	bne	a5,a4,25e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	add	sp,sp,16
 272:	8082                	ret
    dst += n;
 274:	00c50733          	add	a4,a0,a2
    src += n;
 278:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 27a:	fec05ae3          	blez	a2,26e <memmove+0x28>
 27e:	fff6079b          	addw	a5,a2,-1
 282:	1782                	sll	a5,a5,0x20
 284:	9381                	srl	a5,a5,0x20
 286:	fff7c793          	not	a5,a5
 28a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28c:	15fd                	add	a1,a1,-1
 28e:	177d                	add	a4,a4,-1
 290:	0005c683          	lbu	a3,0(a1)
 294:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 298:	fee79ae3          	bne	a5,a4,28c <memmove+0x46>
 29c:	bfc9                	j	26e <memmove+0x28>

000000000000029e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29e:	1141                	add	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a4:	ca05                	beqz	a2,2d4 <memcmp+0x36>
 2a6:	fff6069b          	addw	a3,a2,-1
 2aa:	1682                	sll	a3,a3,0x20
 2ac:	9281                	srl	a3,a3,0x20
 2ae:	0685                	add	a3,a3,1
 2b0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	0005c703          	lbu	a4,0(a1)
 2ba:	00e79863          	bne	a5,a4,2ca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2be:	0505                	add	a0,a0,1
    p2++;
 2c0:	0585                	add	a1,a1,1
  while (n-- > 0) {
 2c2:	fed518e3          	bne	a0,a3,2b2 <memcmp+0x14>
  }
  return 0;
 2c6:	4501                	li	a0,0
 2c8:	a019                	j	2ce <memcmp+0x30>
      return *p1 - *p2;
 2ca:	40e7853b          	subw	a0,a5,a4
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	add	sp,sp,16
 2d2:	8082                	ret
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	bfe5                	j	2ce <memcmp+0x30>

00000000000002d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d8:	1141                	add	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2e0:	00000097          	auipc	ra,0x0
 2e4:	f66080e7          	jalr	-154(ra) # 246 <memmove>
}
 2e8:	60a2                	ld	ra,8(sp)
 2ea:	6402                	ld	s0,0(sp)
 2ec:	0141                	add	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <sbrk>:

char *
sbrk(int n) {
 2f0:	1141                	add	sp,sp,-16
 2f2:	e406                	sd	ra,8(sp)
 2f4:	e022                	sd	s0,0(sp)
 2f6:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f8:	4585                	li	a1,1
 2fa:	00000097          	auipc	ra,0x0
 2fe:	12a080e7          	jalr	298(ra) # 424 <sys_sbrk>
}
 302:	60a2                	ld	ra,8(sp)
 304:	6402                	ld	s0,0(sp)
 306:	0141                	add	sp,sp,16
 308:	8082                	ret

000000000000030a <get_time>:
//   return sys_sbrk(n, SBRK_LAZY);
// }


unsigned int 
get_time(void) {
 30a:	1141                	add	sp,sp,-16
 30c:	e406                	sd	ra,8(sp)
 30e:	e022                	sd	s0,0(sp)
 310:	0800                	add	s0,sp,16
    return uptime();
 312:	00000097          	auipc	ra,0x0
 316:	11a080e7          	jalr	282(ra) # 42c <uptime>
}
 31a:	2501                	sext.w	a0,a0
 31c:	60a2                	ld	ra,8(sp)
 31e:	6402                	ld	s0,0(sp)
 320:	0141                	add	sp,sp,16
 322:	8082                	ret

0000000000000324 <make_filename>:
void 
make_filename(char *buf, const char *prefix, int num) {
    // 复制前缀
    char *p = buf;
    const char *s = prefix;
    while(*s) *p++ = *s++;
 324:	0005c783          	lbu	a5,0(a1)
 328:	cb81                	beqz	a5,338 <make_filename+0x14>
 32a:	0585                	add	a1,a1,1
 32c:	0505                	add	a0,a0,1
 32e:	fef50fa3          	sb	a5,-1(a0)
 332:	0005c783          	lbu	a5,0(a1)
 336:	fbf5                	bnez	a5,32a <make_filename+0x6>
    
    // 处理数字部分
    if (num == 0) {
 338:	ca3d                	beqz	a2,3ae <make_filename+0x8a>
make_filename(char *buf, const char *prefix, int num) {
 33a:	1101                	add	sp,sp,-32
 33c:	ec22                	sd	s0,24(sp)
 33e:	1000                	add	s0,sp,32
        *p++ = '0';
    } else {
        // 临时缓冲区存放数字
        char digits[16];
        int i = 0;
        while(num > 0) {
 340:	fe040893          	add	a7,s0,-32
 344:	87c6                	mv	a5,a7
            digits[i++] = (num % 10) + '0';
 346:	46a9                	li	a3,10
        while(num > 0) {
 348:	4825                	li	a6,9
 34a:	06c05063          	blez	a2,3aa <make_filename+0x86>
            digits[i++] = (num % 10) + '0';
 34e:	02d6673b          	remw	a4,a2,a3
 352:	0307071b          	addw	a4,a4,48
 356:	00e78023          	sb	a4,0(a5)
            num /= 10;
 35a:	85b2                	mv	a1,a2
 35c:	02d6463b          	divw	a2,a2,a3
        while(num > 0) {
 360:	873e                	mv	a4,a5
 362:	0785                	add	a5,a5,1
 364:	feb845e3          	blt	a6,a1,34e <make_filename+0x2a>
 368:	4117073b          	subw	a4,a4,a7
 36c:	0017069b          	addw	a3,a4,1
            digits[i++] = (num % 10) + '0';
 370:	0006879b          	sext.w	a5,a3
        }
        // 倒序写入
        while(i > 0) *p++ = digits[--i];
 374:	04f05663          	blez	a5,3c0 <make_filename+0x9c>
 378:	fe040713          	add	a4,s0,-32
 37c:	973e                	add	a4,a4,a5
 37e:	02069593          	sll	a1,a3,0x20
 382:	9181                	srl	a1,a1,0x20
 384:	95aa                	add	a1,a1,a0
 386:	87aa                	mv	a5,a0
 388:	0785                	add	a5,a5,1
 38a:	fff74603          	lbu	a2,-1(a4)
 38e:	fec78fa3          	sb	a2,-1(a5)
 392:	177d                	add	a4,a4,-1
 394:	feb79ae3          	bne	a5,a1,388 <make_filename+0x64>
 398:	02069793          	sll	a5,a3,0x20
 39c:	9381                	srl	a5,a5,0x20
 39e:	97aa                	add	a5,a5,a0
    }
    *p = 0; // 字符串结束符
 3a0:	00078023          	sb	zero,0(a5)
 3a4:	6462                	ld	s0,24(sp)
 3a6:	6105                	add	sp,sp,32
 3a8:	8082                	ret
        while(num > 0) {
 3aa:	87aa                	mv	a5,a0
 3ac:	bfd5                	j	3a0 <make_filename+0x7c>
        *p++ = '0';
 3ae:	00150793          	add	a5,a0,1
 3b2:	03000713          	li	a4,48
 3b6:	00e50023          	sb	a4,0(a0)
    *p = 0; // 字符串结束符
 3ba:	00078023          	sb	zero,0(a5)
 3be:	8082                	ret
        while(i > 0) *p++ = digits[--i];
 3c0:	87aa                	mv	a5,a0
 3c2:	bff9                	j	3a0 <make_filename+0x7c>

00000000000003c4 <fork>:
.globl unlink
# generated by usys.pl - do not edit
#include "../kernel/sys/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c4:	4885                	li	a7,1
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <exit>:
.global exit
exit:
 li a7, SYS_exit
 3cc:	4889                	li	a7,2
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d4:	488d                	li	a7,3
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3dc:	4891                	li	a7,4
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <close>:
.global close
close:
 li a7, SYS_close
 3e4:	4899                	li	a7,6
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <open>:
.global open
open:
 li a7, SYS_open
 3ec:	489d                	li	a7,7
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f4:	4895                	li	a7,5
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <read>:
.global read
read:
 li a7, SYS_read
 3fc:	48a1                	li	a7,8
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <write>:
.global write
write:
 li a7, SYS_write
 404:	48a5                	li	a7,9
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 40c:	48a9                	li	a7,10
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <makenode>:
.global makenode
makenode:
 li a7, SYS_makenode
 414:	48ad                	li	a7,11
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <duplicate>:
.global duplicate
duplicate:
 li a7, SYS_duplicate
 41c:	48b1                	li	a7,12
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 424:	48b5                	li	a7,13
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42c:	48b9                	li	a7,14
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 434:	48bd                	li	a7,15
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 43c:	48c1                	li	a7,16
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <crash_arm>:
.global crash_arm
crash_arm:
 li a7, SYS_crash_arm
 444:	48c5                	li	a7,17
 ecall
 446:	00000073          	ecall
 44a:	8082                	ret

000000000000044c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 44c:	1101                	add	sp,sp,-32
 44e:	ec06                	sd	ra,24(sp)
 450:	e822                	sd	s0,16(sp)
 452:	1000                	add	s0,sp,32
 454:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 458:	4605                	li	a2,1
 45a:	fef40593          	add	a1,s0,-17
 45e:	00000097          	auipc	ra,0x0
 462:	fa6080e7          	jalr	-90(ra) # 404 <write>
}
 466:	60e2                	ld	ra,24(sp)
 468:	6442                	ld	s0,16(sp)
 46a:	6105                	add	sp,sp,32
 46c:	8082                	ret

000000000000046e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 46e:	715d                	add	sp,sp,-80
 470:	e486                	sd	ra,72(sp)
 472:	e0a2                	sd	s0,64(sp)
 474:	fc26                	sd	s1,56(sp)
 476:	f84a                	sd	s2,48(sp)
 478:	f44e                	sd	s3,40(sp)
 47a:	0880                	add	s0,sp,80
 47c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 47e:	c299                	beqz	a3,484 <printint+0x16>
 480:	0805c363          	bltz	a1,506 <printint+0x98>
  neg = 0;
 484:	4881                	li	a7,0
 486:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 48a:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 48c:	00000517          	auipc	a0,0x0
 490:	5d450513          	add	a0,a0,1492 # a60 <digits>
 494:	883e                	mv	a6,a5
 496:	2785                	addw	a5,a5,1
 498:	02c5f733          	remu	a4,a1,a2
 49c:	972a                	add	a4,a4,a0
 49e:	00074703          	lbu	a4,0(a4)
 4a2:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4a6:	872e                	mv	a4,a1
 4a8:	02c5d5b3          	divu	a1,a1,a2
 4ac:	0685                	add	a3,a3,1
 4ae:	fec773e3          	bgeu	a4,a2,494 <printint+0x26>
  if(neg)
 4b2:	00088b63          	beqz	a7,4c8 <printint+0x5a>
    buf[i++] = '-';
 4b6:	fd078793          	add	a5,a5,-48
 4ba:	97a2                	add	a5,a5,s0
 4bc:	02d00713          	li	a4,45
 4c0:	fee78423          	sb	a4,-24(a5)
 4c4:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 4c8:	02f05863          	blez	a5,4f8 <printint+0x8a>
 4cc:	fb840713          	add	a4,s0,-72
 4d0:	00f704b3          	add	s1,a4,a5
 4d4:	fff70993          	add	s3,a4,-1
 4d8:	99be                	add	s3,s3,a5
 4da:	37fd                	addw	a5,a5,-1
 4dc:	1782                	sll	a5,a5,0x20
 4de:	9381                	srl	a5,a5,0x20
 4e0:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4e4:	fff4c583          	lbu	a1,-1(s1)
 4e8:	854a                	mv	a0,s2
 4ea:	00000097          	auipc	ra,0x0
 4ee:	f62080e7          	jalr	-158(ra) # 44c <putc>
  while(--i >= 0)
 4f2:	14fd                	add	s1,s1,-1
 4f4:	ff3498e3          	bne	s1,s3,4e4 <printint+0x76>
}
 4f8:	60a6                	ld	ra,72(sp)
 4fa:	6406                	ld	s0,64(sp)
 4fc:	74e2                	ld	s1,56(sp)
 4fe:	7942                	ld	s2,48(sp)
 500:	79a2                	ld	s3,40(sp)
 502:	6161                	add	sp,sp,80
 504:	8082                	ret
    x = -xx;
 506:	40b005b3          	neg	a1,a1
    neg = 1;
 50a:	4885                	li	a7,1
    x = -xx;
 50c:	bfad                	j	486 <printint+0x18>

000000000000050e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 50e:	711d                	add	sp,sp,-96
 510:	ec86                	sd	ra,88(sp)
 512:	e8a2                	sd	s0,80(sp)
 514:	e4a6                	sd	s1,72(sp)
 516:	e0ca                	sd	s2,64(sp)
 518:	fc4e                	sd	s3,56(sp)
 51a:	f852                	sd	s4,48(sp)
 51c:	f456                	sd	s5,40(sp)
 51e:	f05a                	sd	s6,32(sp)
 520:	ec5e                	sd	s7,24(sp)
 522:	e862                	sd	s8,16(sp)
 524:	e466                	sd	s9,8(sp)
 526:	e06a                	sd	s10,0(sp)
 528:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52a:	0005c903          	lbu	s2,0(a1)
 52e:	2a090963          	beqz	s2,7e0 <vprintf+0x2d2>
 532:	8b2a                	mv	s6,a0
 534:	8a2e                	mv	s4,a1
 536:	8bb2                	mv	s7,a2
  state = 0;
 538:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 53a:	4481                	li	s1,0
 53c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 53e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 542:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 546:	06c00c93          	li	s9,108
 54a:	a015                	j	56e <vprintf+0x60>
        putc(fd, c0);
 54c:	85ca                	mv	a1,s2
 54e:	855a                	mv	a0,s6
 550:	00000097          	auipc	ra,0x0
 554:	efc080e7          	jalr	-260(ra) # 44c <putc>
 558:	a019                	j	55e <vprintf+0x50>
    } else if(state == '%'){
 55a:	03598263          	beq	s3,s5,57e <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 55e:	2485                	addw	s1,s1,1
 560:	8726                	mv	a4,s1
 562:	009a07b3          	add	a5,s4,s1
 566:	0007c903          	lbu	s2,0(a5)
 56a:	26090b63          	beqz	s2,7e0 <vprintf+0x2d2>
    c0 = fmt[i] & 0xff;
 56e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 572:	fe0994e3          	bnez	s3,55a <vprintf+0x4c>
      if(c0 == '%'){
 576:	fd579be3          	bne	a5,s5,54c <vprintf+0x3e>
        state = '%';
 57a:	89be                	mv	s3,a5
 57c:	b7cd                	j	55e <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 57e:	cfc9                	beqz	a5,618 <vprintf+0x10a>
 580:	00ea06b3          	add	a3,s4,a4
 584:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 588:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 58a:	c681                	beqz	a3,592 <vprintf+0x84>
 58c:	9752                	add	a4,a4,s4
 58e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 592:	05878563          	beq	a5,s8,5dc <vprintf+0xce>
      } else if(c0 == 'l' && c1 == 'd'){
 596:	07978163          	beq	a5,s9,5f8 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 59a:	07500713          	li	a4,117
 59e:	10e78563          	beq	a5,a4,6a8 <vprintf+0x19a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5a2:	07800713          	li	a4,120
 5a6:	14e78d63          	beq	a5,a4,700 <vprintf+0x1f2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5aa:	07000713          	li	a4,112
 5ae:	18e78663          	beq	a5,a4,73a <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5b2:	06300713          	li	a4,99
 5b6:	1ce78a63          	beq	a5,a4,78a <vprintf+0x27c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5ba:	07300713          	li	a4,115
 5be:	1ee78263          	beq	a5,a4,7a2 <vprintf+0x294>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5c2:	02500713          	li	a4,37
 5c6:	04e79963          	bne	a5,a4,618 <vprintf+0x10a>
        putc(fd, '%');
 5ca:	02500593          	li	a1,37
 5ce:	855a                	mv	a0,s6
 5d0:	00000097          	auipc	ra,0x0
 5d4:	e7c080e7          	jalr	-388(ra) # 44c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b751                	j	55e <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 5dc:	008b8913          	add	s2,s7,8
 5e0:	4685                	li	a3,1
 5e2:	4629                	li	a2,10
 5e4:	000ba583          	lw	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	00000097          	auipc	ra,0x0
 5ee:	e84080e7          	jalr	-380(ra) # 46e <printint>
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b7a5                	j	55e <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 5f8:	06400793          	li	a5,100
 5fc:	02f68d63          	beq	a3,a5,636 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 600:	06c00793          	li	a5,108
 604:	04f68863          	beq	a3,a5,654 <vprintf+0x146>
      } else if(c0 == 'l' && c1 == 'u'){
 608:	07500793          	li	a5,117
 60c:	0af68c63          	beq	a3,a5,6c4 <vprintf+0x1b6>
      } else if(c0 == 'l' && c1 == 'x'){
 610:	07800793          	li	a5,120
 614:	10f68463          	beq	a3,a5,71c <vprintf+0x20e>
        putc(fd, '%');
 618:	02500593          	li	a1,37
 61c:	855a                	mv	a0,s6
 61e:	00000097          	auipc	ra,0x0
 622:	e2e080e7          	jalr	-466(ra) # 44c <putc>
        putc(fd, c0);
 626:	85ca                	mv	a1,s2
 628:	855a                	mv	a0,s6
 62a:	00000097          	auipc	ra,0x0
 62e:	e22080e7          	jalr	-478(ra) # 44c <putc>
      state = 0;
 632:	4981                	li	s3,0
 634:	b72d                	j	55e <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 636:	008b8913          	add	s2,s7,8
 63a:	4685                	li	a3,1
 63c:	4629                	li	a2,10
 63e:	000bb583          	ld	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	00000097          	auipc	ra,0x0
 648:	e2a080e7          	jalr	-470(ra) # 46e <printint>
        i += 1;
 64c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
        i += 1;
 652:	b731                	j	55e <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 654:	06400793          	li	a5,100
 658:	02f60963          	beq	a2,a5,68a <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 65c:	07500793          	li	a5,117
 660:	08f60163          	beq	a2,a5,6e2 <vprintf+0x1d4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 664:	07800793          	li	a5,120
 668:	faf618e3          	bne	a2,a5,618 <vprintf+0x10a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66c:	008b8913          	add	s2,s7,8
 670:	4681                	li	a3,0
 672:	4641                	li	a2,16
 674:	000bb583          	ld	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	00000097          	auipc	ra,0x0
 67e:	df4080e7          	jalr	-524(ra) # 46e <printint>
        i += 2;
 682:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
        i += 2;
 688:	bdd9                	j	55e <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 68a:	008b8913          	add	s2,s7,8
 68e:	4685                	li	a3,1
 690:	4629                	li	a2,10
 692:	000bb583          	ld	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	00000097          	auipc	ra,0x0
 69c:	dd6080e7          	jalr	-554(ra) # 46e <printint>
        i += 2;
 6a0:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a2:	8bca                	mv	s7,s2
      state = 0;
 6a4:	4981                	li	s3,0
        i += 2;
 6a6:	bd65                	j	55e <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6a8:	008b8913          	add	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4629                	li	a2,10
 6b0:	000be583          	lwu	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	00000097          	auipc	ra,0x0
 6ba:	db8080e7          	jalr	-584(ra) # 46e <printint>
 6be:	8bca                	mv	s7,s2
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	bd71                	j	55e <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c4:	008b8913          	add	s2,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4629                	li	a2,10
 6cc:	000bb583          	ld	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	00000097          	auipc	ra,0x0
 6d6:	d9c080e7          	jalr	-612(ra) # 46e <printint>
        i += 1;
 6da:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6dc:	8bca                	mv	s7,s2
      state = 0;
 6de:	4981                	li	s3,0
        i += 1;
 6e0:	bdbd                	j	55e <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e2:	008b8913          	add	s2,s7,8
 6e6:	4681                	li	a3,0
 6e8:	4629                	li	a2,10
 6ea:	000bb583          	ld	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	00000097          	auipc	ra,0x0
 6f4:	d7e080e7          	jalr	-642(ra) # 46e <printint>
        i += 2;
 6f8:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
        i += 2;
 6fe:	b585                	j	55e <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 16, 0);
 700:	008b8913          	add	s2,s7,8
 704:	4681                	li	a3,0
 706:	4641                	li	a2,16
 708:	000be583          	lwu	a1,0(s7)
 70c:	855a                	mv	a0,s6
 70e:	00000097          	auipc	ra,0x0
 712:	d60080e7          	jalr	-672(ra) # 46e <printint>
 716:	8bca                	mv	s7,s2
      state = 0;
 718:	4981                	li	s3,0
 71a:	b591                	j	55e <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 71c:	008b8913          	add	s2,s7,8
 720:	4681                	li	a3,0
 722:	4641                	li	a2,16
 724:	000bb583          	ld	a1,0(s7)
 728:	855a                	mv	a0,s6
 72a:	00000097          	auipc	ra,0x0
 72e:	d44080e7          	jalr	-700(ra) # 46e <printint>
        i += 1;
 732:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 734:	8bca                	mv	s7,s2
      state = 0;
 736:	4981                	li	s3,0
        i += 1;
 738:	b51d                	j	55e <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 73a:	008b8d13          	add	s10,s7,8
 73e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 742:	03000593          	li	a1,48
 746:	855a                	mv	a0,s6
 748:	00000097          	auipc	ra,0x0
 74c:	d04080e7          	jalr	-764(ra) # 44c <putc>
  putc(fd, 'x');
 750:	07800593          	li	a1,120
 754:	855a                	mv	a0,s6
 756:	00000097          	auipc	ra,0x0
 75a:	cf6080e7          	jalr	-778(ra) # 44c <putc>
 75e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 760:	00000b97          	auipc	s7,0x0
 764:	300b8b93          	add	s7,s7,768 # a60 <digits>
 768:	03c9d793          	srl	a5,s3,0x3c
 76c:	97de                	add	a5,a5,s7
 76e:	0007c583          	lbu	a1,0(a5)
 772:	855a                	mv	a0,s6
 774:	00000097          	auipc	ra,0x0
 778:	cd8080e7          	jalr	-808(ra) # 44c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 77c:	0992                	sll	s3,s3,0x4
 77e:	397d                	addw	s2,s2,-1
 780:	fe0914e3          	bnez	s2,768 <vprintf+0x25a>
        printptr(fd, va_arg(ap, uint64));
 784:	8bea                	mv	s7,s10
      state = 0;
 786:	4981                	li	s3,0
 788:	bbd9                	j	55e <vprintf+0x50>
        putc(fd, va_arg(ap, uint32));
 78a:	008b8913          	add	s2,s7,8
 78e:	000bc583          	lbu	a1,0(s7)
 792:	855a                	mv	a0,s6
 794:	00000097          	auipc	ra,0x0
 798:	cb8080e7          	jalr	-840(ra) # 44c <putc>
 79c:	8bca                	mv	s7,s2
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bb7d                	j	55e <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 7a2:	008b8993          	add	s3,s7,8
 7a6:	000bb903          	ld	s2,0(s7)
 7aa:	02090163          	beqz	s2,7cc <vprintf+0x2be>
        for(; *s; s++)
 7ae:	00094583          	lbu	a1,0(s2)
 7b2:	c585                	beqz	a1,7da <vprintf+0x2cc>
          putc(fd, *s);
 7b4:	855a                	mv	a0,s6
 7b6:	00000097          	auipc	ra,0x0
 7ba:	c96080e7          	jalr	-874(ra) # 44c <putc>
        for(; *s; s++)
 7be:	0905                	add	s2,s2,1
 7c0:	00094583          	lbu	a1,0(s2)
 7c4:	f9e5                	bnez	a1,7b4 <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
 7c6:	8bce                	mv	s7,s3
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	bb51                	j	55e <vprintf+0x50>
          s = "(null)";
 7cc:	00000917          	auipc	s2,0x0
 7d0:	28c90913          	add	s2,s2,652 # a58 <malloc+0x176>
        for(; *s; s++)
 7d4:	02800593          	li	a1,40
 7d8:	bff1                	j	7b4 <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
 7da:	8bce                	mv	s7,s3
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b341                	j	55e <vprintf+0x50>
    }
  }
}
 7e0:	60e6                	ld	ra,88(sp)
 7e2:	6446                	ld	s0,80(sp)
 7e4:	64a6                	ld	s1,72(sp)
 7e6:	6906                	ld	s2,64(sp)
 7e8:	79e2                	ld	s3,56(sp)
 7ea:	7a42                	ld	s4,48(sp)
 7ec:	7aa2                	ld	s5,40(sp)
 7ee:	7b02                	ld	s6,32(sp)
 7f0:	6be2                	ld	s7,24(sp)
 7f2:	6c42                	ld	s8,16(sp)
 7f4:	6ca2                	ld	s9,8(sp)
 7f6:	6d02                	ld	s10,0(sp)
 7f8:	6125                	add	sp,sp,96
 7fa:	8082                	ret

00000000000007fc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7fc:	715d                	add	sp,sp,-80
 7fe:	ec06                	sd	ra,24(sp)
 800:	e822                	sd	s0,16(sp)
 802:	1000                	add	s0,sp,32
 804:	e010                	sd	a2,0(s0)
 806:	e414                	sd	a3,8(s0)
 808:	e818                	sd	a4,16(s0)
 80a:	ec1c                	sd	a5,24(s0)
 80c:	03043023          	sd	a6,32(s0)
 810:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 814:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 818:	8622                	mv	a2,s0
 81a:	00000097          	auipc	ra,0x0
 81e:	cf4080e7          	jalr	-780(ra) # 50e <vprintf>
}
 822:	60e2                	ld	ra,24(sp)
 824:	6442                	ld	s0,16(sp)
 826:	6161                	add	sp,sp,80
 828:	8082                	ret

000000000000082a <printf>:

void
printf(const char *fmt, ...)
{
 82a:	711d                	add	sp,sp,-96
 82c:	ec06                	sd	ra,24(sp)
 82e:	e822                	sd	s0,16(sp)
 830:	1000                	add	s0,sp,32
 832:	e40c                	sd	a1,8(s0)
 834:	e810                	sd	a2,16(s0)
 836:	ec14                	sd	a3,24(s0)
 838:	f018                	sd	a4,32(s0)
 83a:	f41c                	sd	a5,40(s0)
 83c:	03043823          	sd	a6,48(s0)
 840:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 844:	00840613          	add	a2,s0,8
 848:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 84c:	85aa                	mv	a1,a0
 84e:	4505                	li	a0,1
 850:	00000097          	auipc	ra,0x0
 854:	cbe080e7          	jalr	-834(ra) # 50e <vprintf>
}
 858:	60e2                	ld	ra,24(sp)
 85a:	6442                	ld	s0,16(sp)
 85c:	6125                	add	sp,sp,96
 85e:	8082                	ret

0000000000000860 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 860:	1141                	add	sp,sp,-16
 862:	e422                	sd	s0,8(sp)
 864:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 866:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86a:	00000797          	auipc	a5,0x0
 86e:	7967b783          	ld	a5,1942(a5) # 1000 <freep>
 872:	a02d                	j	89c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 874:	4618                	lw	a4,8(a2)
 876:	9f2d                	addw	a4,a4,a1
 878:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 87c:	6398                	ld	a4,0(a5)
 87e:	6310                	ld	a2,0(a4)
 880:	a83d                	j	8be <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 882:	ff852703          	lw	a4,-8(a0)
 886:	9f31                	addw	a4,a4,a2
 888:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 88a:	ff053683          	ld	a3,-16(a0)
 88e:	a091                	j	8d2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 890:	6398                	ld	a4,0(a5)
 892:	00e7e463          	bltu	a5,a4,89a <free+0x3a>
 896:	00e6ea63          	bltu	a3,a4,8aa <free+0x4a>
{
 89a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89c:	fed7fae3          	bgeu	a5,a3,890 <free+0x30>
 8a0:	6398                	ld	a4,0(a5)
 8a2:	00e6e463          	bltu	a3,a4,8aa <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a6:	fee7eae3          	bltu	a5,a4,89a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8aa:	ff852583          	lw	a1,-8(a0)
 8ae:	6390                	ld	a2,0(a5)
 8b0:	02059813          	sll	a6,a1,0x20
 8b4:	01c85713          	srl	a4,a6,0x1c
 8b8:	9736                	add	a4,a4,a3
 8ba:	fae60de3          	beq	a2,a4,874 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8be:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8c2:	4790                	lw	a2,8(a5)
 8c4:	02061593          	sll	a1,a2,0x20
 8c8:	01c5d713          	srl	a4,a1,0x1c
 8cc:	973e                	add	a4,a4,a5
 8ce:	fae68ae3          	beq	a3,a4,882 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8d2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8d4:	00000717          	auipc	a4,0x0
 8d8:	72f73623          	sd	a5,1836(a4) # 1000 <freep>
}
 8dc:	6422                	ld	s0,8(sp)
 8de:	0141                	add	sp,sp,16
 8e0:	8082                	ret

00000000000008e2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e2:	7139                	add	sp,sp,-64
 8e4:	fc06                	sd	ra,56(sp)
 8e6:	f822                	sd	s0,48(sp)
 8e8:	f426                	sd	s1,40(sp)
 8ea:	f04a                	sd	s2,32(sp)
 8ec:	ec4e                	sd	s3,24(sp)
 8ee:	e852                	sd	s4,16(sp)
 8f0:	e456                	sd	s5,8(sp)
 8f2:	e05a                	sd	s6,0(sp)
 8f4:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f6:	02051493          	sll	s1,a0,0x20
 8fa:	9081                	srl	s1,s1,0x20
 8fc:	04bd                	add	s1,s1,15
 8fe:	8091                	srl	s1,s1,0x4
 900:	0014899b          	addw	s3,s1,1
 904:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 906:	00000517          	auipc	a0,0x0
 90a:	6fa53503          	ld	a0,1786(a0) # 1000 <freep>
 90e:	c515                	beqz	a0,93a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 910:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 912:	4798                	lw	a4,8(a5)
 914:	02977f63          	bgeu	a4,s1,952 <malloc+0x70>
  if(nu < 4096)
 918:	8a4e                	mv	s4,s3
 91a:	0009871b          	sext.w	a4,s3
 91e:	6685                	lui	a3,0x1
 920:	00d77363          	bgeu	a4,a3,926 <malloc+0x44>
 924:	6a05                	lui	s4,0x1
 926:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 92a:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 92e:	00000917          	auipc	s2,0x0
 932:	6d290913          	add	s2,s2,1746 # 1000 <freep>
  if(p == SBRK_ERROR)
 936:	5afd                	li	s5,-1
 938:	a895                	j	9ac <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 93a:	00000797          	auipc	a5,0x0
 93e:	6d678793          	add	a5,a5,1750 # 1010 <base>
 942:	00000717          	auipc	a4,0x0
 946:	6af73f23          	sd	a5,1726(a4) # 1000 <freep>
 94a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 94c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 950:	b7e1                	j	918 <malloc+0x36>
      if(p->s.size == nunits)
 952:	02e48c63          	beq	s1,a4,98a <malloc+0xa8>
        p->s.size -= nunits;
 956:	4137073b          	subw	a4,a4,s3
 95a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 95c:	02071693          	sll	a3,a4,0x20
 960:	01c6d713          	srl	a4,a3,0x1c
 964:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 966:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 96a:	00000717          	auipc	a4,0x0
 96e:	68a73b23          	sd	a0,1686(a4) # 1000 <freep>
      return (void*)(p + 1);
 972:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 976:	70e2                	ld	ra,56(sp)
 978:	7442                	ld	s0,48(sp)
 97a:	74a2                	ld	s1,40(sp)
 97c:	7902                	ld	s2,32(sp)
 97e:	69e2                	ld	s3,24(sp)
 980:	6a42                	ld	s4,16(sp)
 982:	6aa2                	ld	s5,8(sp)
 984:	6b02                	ld	s6,0(sp)
 986:	6121                	add	sp,sp,64
 988:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 98a:	6398                	ld	a4,0(a5)
 98c:	e118                	sd	a4,0(a0)
 98e:	bff1                	j	96a <malloc+0x88>
  hp->s.size = nu;
 990:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 994:	0541                	add	a0,a0,16
 996:	00000097          	auipc	ra,0x0
 99a:	eca080e7          	jalr	-310(ra) # 860 <free>
  return freep;
 99e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9a2:	d971                	beqz	a0,976 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a6:	4798                	lw	a4,8(a5)
 9a8:	fa9775e3          	bgeu	a4,s1,952 <malloc+0x70>
    if(p == freep)
 9ac:	00093703          	ld	a4,0(s2)
 9b0:	853e                	mv	a0,a5
 9b2:	fef719e3          	bne	a4,a5,9a4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9b6:	8552                	mv	a0,s4
 9b8:	00000097          	auipc	ra,0x0
 9bc:	938080e7          	jalr	-1736(ra) # 2f0 <sbrk>
  if(p == SBRK_ERROR)
 9c0:	fd5518e3          	bne	a0,s5,990 <malloc+0xae>
        return 0;
 9c4:	4501                	li	a0,0
 9c6:	bf45                	j	976 <malloc+0x94>
