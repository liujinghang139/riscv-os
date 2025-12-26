
user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "./user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
  if(argc < 2){
   c:	4785                	li	a5,1
   e:	02a7db63          	bge	a5,a0,44 <main+0x44>
  12:	00858493          	add	s1,a1,8
  16:	ffe5091b          	addw	s2,a0,-2
  1a:	02091793          	sll	a5,s2,0x20
  1e:	01d7d913          	srl	s2,a5,0x1d
  22:	05c1                	add	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir dirs...\n");
    exit(1);
  }

  for(int i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	3d0080e7          	jalr	976(ra) # 3f8 <mkdir>
  30:	02054863          	bltz	a0,60 <main+0x60>
  for(int i = 1; i < argc; i++){
  34:	04a1                	add	s1,s1,8
  36:	ff2498e3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
      exit(1);
    }
  }

  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	354080e7          	jalr	852(ra) # 390 <exit>
    fprintf(2, "Usage: mkdir dirs...\n");
  44:	00001597          	auipc	a1,0x1
  48:	94c58593          	add	a1,a1,-1716 # 990 <malloc+0xea>
  4c:	4509                	li	a0,2
  4e:	00000097          	auipc	ra,0x0
  52:	772080e7          	jalr	1906(ra) # 7c0 <fprintf>
    exit(1);
  56:	4505                	li	a0,1
  58:	00000097          	auipc	ra,0x0
  5c:	338080e7          	jalr	824(ra) # 390 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  60:	6090                	ld	a2,0(s1)
  62:	00001597          	auipc	a1,0x1
  66:	94658593          	add	a1,a1,-1722 # 9a8 <malloc+0x102>
  6a:	4509                	li	a0,2
  6c:	00000097          	auipc	ra,0x0
  70:	754080e7          	jalr	1876(ra) # 7c0 <fprintf>
      exit(1);
  74:	4505                	li	a0,1
  76:	00000097          	auipc	ra,0x0
  7a:	31a080e7          	jalr	794(ra) # 390 <exit>

000000000000007e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  7e:	1141                	add	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	add	s0,sp,16
  int r;
  extern int main();
  r = main();
  86:	00000097          	auipc	ra,0x0
  8a:	f7a080e7          	jalr	-134(ra) # 0 <main>
  exit(r);
  8e:	00000097          	auipc	ra,0x0
  92:	302080e7          	jalr	770(ra) # 390 <exit>

0000000000000096 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  96:	1141                	add	sp,sp,-16
  98:	e422                	sd	s0,8(sp)
  9a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9c:	87aa                	mv	a5,a0
  9e:	0585                	add	a1,a1,1
  a0:	0785                	add	a5,a5,1
  a2:	fff5c703          	lbu	a4,-1(a1)
  a6:	fee78fa3          	sb	a4,-1(a5)
  aa:	fb75                	bnez	a4,9e <strcpy+0x8>
    ;
  return os;
}
  ac:	6422                	ld	s0,8(sp)
  ae:	0141                	add	sp,sp,16
  b0:	8082                	ret

00000000000000b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b2:	1141                	add	sp,sp,-16
  b4:	e422                	sd	s0,8(sp)
  b6:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  b8:	00054783          	lbu	a5,0(a0)
  bc:	cb91                	beqz	a5,d0 <strcmp+0x1e>
  be:	0005c703          	lbu	a4,0(a1)
  c2:	00f71763          	bne	a4,a5,d0 <strcmp+0x1e>
    p++, q++;
  c6:	0505                	add	a0,a0,1
  c8:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	fbe5                	bnez	a5,be <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d0:	0005c503          	lbu	a0,0(a1)
}
  d4:	40a7853b          	subw	a0,a5,a0
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	add	sp,sp,16
  dc:	8082                	ret

00000000000000de <strlen>:

uint
strlen(const char *s)
{
  de:	1141                	add	sp,sp,-16
  e0:	e422                	sd	s0,8(sp)
  e2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	cf91                	beqz	a5,104 <strlen+0x26>
  ea:	0505                	add	a0,a0,1
  ec:	87aa                	mv	a5,a0
  ee:	86be                	mv	a3,a5
  f0:	0785                	add	a5,a5,1
  f2:	fff7c703          	lbu	a4,-1(a5)
  f6:	ff65                	bnez	a4,ee <strlen+0x10>
  f8:	40a6853b          	subw	a0,a3,a0
  fc:	2505                	addw	a0,a0,1
    ;
  return n;
}
  fe:	6422                	ld	s0,8(sp)
 100:	0141                	add	sp,sp,16
 102:	8082                	ret
  for(n = 0; s[n]; n++)
 104:	4501                	li	a0,0
 106:	bfe5                	j	fe <strlen+0x20>

0000000000000108 <memset>:

void*
memset(void *dst, int c, uint n)
{
 108:	1141                	add	sp,sp,-16
 10a:	e422                	sd	s0,8(sp)
 10c:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10e:	ca19                	beqz	a2,124 <memset+0x1c>
 110:	87aa                	mv	a5,a0
 112:	1602                	sll	a2,a2,0x20
 114:	9201                	srl	a2,a2,0x20
 116:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 11e:	0785                	add	a5,a5,1
 120:	fee79de3          	bne	a5,a4,11a <memset+0x12>
  }
  return dst;
}
 124:	6422                	ld	s0,8(sp)
 126:	0141                	add	sp,sp,16
 128:	8082                	ret

000000000000012a <strchr>:

char*
strchr(const char *s, char c)
{
 12a:	1141                	add	sp,sp,-16
 12c:	e422                	sd	s0,8(sp)
 12e:	0800                	add	s0,sp,16
  for(; *s; s++)
 130:	00054783          	lbu	a5,0(a0)
 134:	cb99                	beqz	a5,14a <strchr+0x20>
    if(*s == c)
 136:	00f58763          	beq	a1,a5,144 <strchr+0x1a>
  for(; *s; s++)
 13a:	0505                	add	a0,a0,1
 13c:	00054783          	lbu	a5,0(a0)
 140:	fbfd                	bnez	a5,136 <strchr+0xc>
      return (char*)s;
  return 0;
 142:	4501                	li	a0,0
}
 144:	6422                	ld	s0,8(sp)
 146:	0141                	add	sp,sp,16
 148:	8082                	ret
  return 0;
 14a:	4501                	li	a0,0
 14c:	bfe5                	j	144 <strchr+0x1a>

000000000000014e <gets>:

char*
gets(char *buf, int max)
{
 14e:	711d                	add	sp,sp,-96
 150:	ec86                	sd	ra,88(sp)
 152:	e8a2                	sd	s0,80(sp)
 154:	e4a6                	sd	s1,72(sp)
 156:	e0ca                	sd	s2,64(sp)
 158:	fc4e                	sd	s3,56(sp)
 15a:	f852                	sd	s4,48(sp)
 15c:	f456                	sd	s5,40(sp)
 15e:	f05a                	sd	s6,32(sp)
 160:	ec5e                	sd	s7,24(sp)
 162:	1080                	add	s0,sp,96
 164:	8baa                	mv	s7,a0
 166:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 168:	892a                	mv	s2,a0
 16a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16c:	4aa9                	li	s5,10
 16e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 170:	89a6                	mv	s3,s1
 172:	2485                	addw	s1,s1,1
 174:	0344d863          	bge	s1,s4,1a4 <gets+0x56>
    cc = read(0, &c, 1);
 178:	4605                	li	a2,1
 17a:	faf40593          	add	a1,s0,-81
 17e:	4501                	li	a0,0
 180:	00000097          	auipc	ra,0x0
 184:	240080e7          	jalr	576(ra) # 3c0 <read>
    if(cc < 1)
 188:	00a05e63          	blez	a0,1a4 <gets+0x56>
    buf[i++] = c;
 18c:	faf44783          	lbu	a5,-81(s0)
 190:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 194:	01578763          	beq	a5,s5,1a2 <gets+0x54>
 198:	0905                	add	s2,s2,1
 19a:	fd679be3          	bne	a5,s6,170 <gets+0x22>
  for(i=0; i+1 < max; ){
 19e:	89a6                	mv	s3,s1
 1a0:	a011                	j	1a4 <gets+0x56>
 1a2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a4:	99de                	add	s3,s3,s7
 1a6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1aa:	855e                	mv	a0,s7
 1ac:	60e6                	ld	ra,88(sp)
 1ae:	6446                	ld	s0,80(sp)
 1b0:	64a6                	ld	s1,72(sp)
 1b2:	6906                	ld	s2,64(sp)
 1b4:	79e2                	ld	s3,56(sp)
 1b6:	7a42                	ld	s4,48(sp)
 1b8:	7aa2                	ld	s5,40(sp)
 1ba:	7b02                	ld	s6,32(sp)
 1bc:	6be2                	ld	s7,24(sp)
 1be:	6125                	add	sp,sp,96
 1c0:	8082                	ret

00000000000001c2 <atoi>:
//   return r;
// }

int
atoi(const char *s)
{
 1c2:	1141                	add	sp,sp,-16
 1c4:	e422                	sd	s0,8(sp)
 1c6:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c8:	00054683          	lbu	a3,0(a0)
 1cc:	fd06879b          	addw	a5,a3,-48
 1d0:	0ff7f793          	zext.b	a5,a5
 1d4:	4625                	li	a2,9
 1d6:	02f66863          	bltu	a2,a5,206 <atoi+0x44>
 1da:	872a                	mv	a4,a0
  n = 0;
 1dc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1de:	0705                	add	a4,a4,1
 1e0:	0025179b          	sllw	a5,a0,0x2
 1e4:	9fa9                	addw	a5,a5,a0
 1e6:	0017979b          	sllw	a5,a5,0x1
 1ea:	9fb5                	addw	a5,a5,a3
 1ec:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f0:	00074683          	lbu	a3,0(a4)
 1f4:	fd06879b          	addw	a5,a3,-48
 1f8:	0ff7f793          	zext.b	a5,a5
 1fc:	fef671e3          	bgeu	a2,a5,1de <atoi+0x1c>
  return n;
}
 200:	6422                	ld	s0,8(sp)
 202:	0141                	add	sp,sp,16
 204:	8082                	ret
  n = 0;
 206:	4501                	li	a0,0
 208:	bfe5                	j	200 <atoi+0x3e>

000000000000020a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20a:	1141                	add	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 210:	02b57463          	bgeu	a0,a1,238 <memmove+0x2e>
    while(n-- > 0)
 214:	00c05f63          	blez	a2,232 <memmove+0x28>
 218:	1602                	sll	a2,a2,0x20
 21a:	9201                	srl	a2,a2,0x20
 21c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 220:	872a                	mv	a4,a0
      *dst++ = *src++;
 222:	0585                	add	a1,a1,1
 224:	0705                	add	a4,a4,1
 226:	fff5c683          	lbu	a3,-1(a1)
 22a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 22e:	fee79ae3          	bne	a5,a4,222 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	add	sp,sp,16
 236:	8082                	ret
    dst += n;
 238:	00c50733          	add	a4,a0,a2
    src += n;
 23c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23e:	fec05ae3          	blez	a2,232 <memmove+0x28>
 242:	fff6079b          	addw	a5,a2,-1
 246:	1782                	sll	a5,a5,0x20
 248:	9381                	srl	a5,a5,0x20
 24a:	fff7c793          	not	a5,a5
 24e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 250:	15fd                	add	a1,a1,-1
 252:	177d                	add	a4,a4,-1
 254:	0005c683          	lbu	a3,0(a1)
 258:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x46>
 260:	bfc9                	j	232 <memmove+0x28>

0000000000000262 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 262:	1141                	add	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 268:	ca05                	beqz	a2,298 <memcmp+0x36>
 26a:	fff6069b          	addw	a3,a2,-1
 26e:	1682                	sll	a3,a3,0x20
 270:	9281                	srl	a3,a3,0x20
 272:	0685                	add	a3,a3,1
 274:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 276:	00054783          	lbu	a5,0(a0)
 27a:	0005c703          	lbu	a4,0(a1)
 27e:	00e79863          	bne	a5,a4,28e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 282:	0505                	add	a0,a0,1
    p2++;
 284:	0585                	add	a1,a1,1
  while (n-- > 0) {
 286:	fed518e3          	bne	a0,a3,276 <memcmp+0x14>
  }
  return 0;
 28a:	4501                	li	a0,0
 28c:	a019                	j	292 <memcmp+0x30>
      return *p1 - *p2;
 28e:	40e7853b          	subw	a0,a5,a4
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	add	sp,sp,16
 296:	8082                	ret
  return 0;
 298:	4501                	li	a0,0
 29a:	bfe5                	j	292 <memcmp+0x30>

000000000000029c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29c:	1141                	add	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2a4:	00000097          	auipc	ra,0x0
 2a8:	f66080e7          	jalr	-154(ra) # 20a <memmove>
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	add	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <sbrk>:

char *
sbrk(int n) {
 2b4:	1141                	add	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2bc:	4585                	li	a1,1
 2be:	00000097          	auipc	ra,0x0
 2c2:	12a080e7          	jalr	298(ra) # 3e8 <sys_sbrk>
}
 2c6:	60a2                	ld	ra,8(sp)
 2c8:	6402                	ld	s0,0(sp)
 2ca:	0141                	add	sp,sp,16
 2cc:	8082                	ret

00000000000002ce <get_time>:
//   return sys_sbrk(n, SBRK_LAZY);
// }


unsigned int 
get_time(void) {
 2ce:	1141                	add	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	add	s0,sp,16
    return uptime();
 2d6:	00000097          	auipc	ra,0x0
 2da:	11a080e7          	jalr	282(ra) # 3f0 <uptime>
}
 2de:	2501                	sext.w	a0,a0
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	add	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <make_filename>:
void 
make_filename(char *buf, const char *prefix, int num) {
    // 复制前缀
    char *p = buf;
    const char *s = prefix;
    while(*s) *p++ = *s++;
 2e8:	0005c783          	lbu	a5,0(a1)
 2ec:	cb81                	beqz	a5,2fc <make_filename+0x14>
 2ee:	0585                	add	a1,a1,1
 2f0:	0505                	add	a0,a0,1
 2f2:	fef50fa3          	sb	a5,-1(a0)
 2f6:	0005c783          	lbu	a5,0(a1)
 2fa:	fbf5                	bnez	a5,2ee <make_filename+0x6>
    
    // 处理数字部分
    if (num == 0) {
 2fc:	ca3d                	beqz	a2,372 <make_filename+0x8a>
make_filename(char *buf, const char *prefix, int num) {
 2fe:	1101                	add	sp,sp,-32
 300:	ec22                	sd	s0,24(sp)
 302:	1000                	add	s0,sp,32
        *p++ = '0';
    } else {
        // 临时缓冲区存放数字
        char digits[16];
        int i = 0;
        while(num > 0) {
 304:	fe040893          	add	a7,s0,-32
 308:	87c6                	mv	a5,a7
            digits[i++] = (num % 10) + '0';
 30a:	46a9                	li	a3,10
        while(num > 0) {
 30c:	4825                	li	a6,9
 30e:	06c05063          	blez	a2,36e <make_filename+0x86>
            digits[i++] = (num % 10) + '0';
 312:	02d6673b          	remw	a4,a2,a3
 316:	0307071b          	addw	a4,a4,48
 31a:	00e78023          	sb	a4,0(a5)
            num /= 10;
 31e:	85b2                	mv	a1,a2
 320:	02d6463b          	divw	a2,a2,a3
        while(num > 0) {
 324:	873e                	mv	a4,a5
 326:	0785                	add	a5,a5,1
 328:	feb845e3          	blt	a6,a1,312 <make_filename+0x2a>
 32c:	4117073b          	subw	a4,a4,a7
 330:	0017069b          	addw	a3,a4,1
            digits[i++] = (num % 10) + '0';
 334:	0006879b          	sext.w	a5,a3
        }
        // 倒序写入
        while(i > 0) *p++ = digits[--i];
 338:	04f05663          	blez	a5,384 <make_filename+0x9c>
 33c:	fe040713          	add	a4,s0,-32
 340:	973e                	add	a4,a4,a5
 342:	02069593          	sll	a1,a3,0x20
 346:	9181                	srl	a1,a1,0x20
 348:	95aa                	add	a1,a1,a0
 34a:	87aa                	mv	a5,a0
 34c:	0785                	add	a5,a5,1
 34e:	fff74603          	lbu	a2,-1(a4)
 352:	fec78fa3          	sb	a2,-1(a5)
 356:	177d                	add	a4,a4,-1
 358:	feb79ae3          	bne	a5,a1,34c <make_filename+0x64>
 35c:	02069793          	sll	a5,a3,0x20
 360:	9381                	srl	a5,a5,0x20
 362:	97aa                	add	a5,a5,a0
    }
    *p = 0; // 字符串结束符
 364:	00078023          	sb	zero,0(a5)
 368:	6462                	ld	s0,24(sp)
 36a:	6105                	add	sp,sp,32
 36c:	8082                	ret
        while(num > 0) {
 36e:	87aa                	mv	a5,a0
 370:	bfd5                	j	364 <make_filename+0x7c>
        *p++ = '0';
 372:	00150793          	add	a5,a0,1
 376:	03000713          	li	a4,48
 37a:	00e50023          	sb	a4,0(a0)
    *p = 0; // 字符串结束符
 37e:	00078023          	sb	zero,0(a5)
 382:	8082                	ret
        while(i > 0) *p++ = digits[--i];
 384:	87aa                	mv	a5,a0
 386:	bff9                	j	364 <make_filename+0x7c>

0000000000000388 <fork>:
.globl unlink
# generated by usys.pl - do not edit
#include "../kernel/sys/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 388:	4885                	li	a7,1
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <exit>:
.global exit
exit:
 li a7, SYS_exit
 390:	4889                	li	a7,2
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <wait>:
.global wait
wait:
 li a7, SYS_wait
 398:	488d                	li	a7,3
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a0:	4891                	li	a7,4
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <close>:
.global close
close:
 li a7, SYS_close
 3a8:	4899                	li	a7,6
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <open>:
.global open
open:
 li a7, SYS_open
 3b0:	489d                	li	a7,7
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b8:	4895                	li	a7,5
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <read>:
.global read
read:
 li a7, SYS_read
 3c0:	48a1                	li	a7,8
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <write>:
.global write
write:
 li a7, SYS_write
 3c8:	48a5                	li	a7,9
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3d0:	48a9                	li	a7,10
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <makenode>:
.global makenode
makenode:
 li a7, SYS_makenode
 3d8:	48ad                	li	a7,11
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <duplicate>:
.global duplicate
duplicate:
 li a7, SYS_duplicate
 3e0:	48b1                	li	a7,12
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3e8:	48b5                	li	a7,13
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f0:	48b9                	li	a7,14
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f8:	48bd                	li	a7,15
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 400:	48c1                	li	a7,16
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <crash_arm>:
.global crash_arm
crash_arm:
 li a7, SYS_crash_arm
 408:	48c5                	li	a7,17
 ecall
 40a:	00000073          	ecall
 40e:	8082                	ret

0000000000000410 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 410:	1101                	add	sp,sp,-32
 412:	ec06                	sd	ra,24(sp)
 414:	e822                	sd	s0,16(sp)
 416:	1000                	add	s0,sp,32
 418:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41c:	4605                	li	a2,1
 41e:	fef40593          	add	a1,s0,-17
 422:	00000097          	auipc	ra,0x0
 426:	fa6080e7          	jalr	-90(ra) # 3c8 <write>
}
 42a:	60e2                	ld	ra,24(sp)
 42c:	6442                	ld	s0,16(sp)
 42e:	6105                	add	sp,sp,32
 430:	8082                	ret

0000000000000432 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 432:	715d                	add	sp,sp,-80
 434:	e486                	sd	ra,72(sp)
 436:	e0a2                	sd	s0,64(sp)
 438:	fc26                	sd	s1,56(sp)
 43a:	f84a                	sd	s2,48(sp)
 43c:	f44e                	sd	s3,40(sp)
 43e:	0880                	add	s0,sp,80
 440:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 442:	c299                	beqz	a3,448 <printint+0x16>
 444:	0805c363          	bltz	a1,4ca <printint+0x98>
  neg = 0;
 448:	4881                	li	a7,0
 44a:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 44e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 450:	00000517          	auipc	a0,0x0
 454:	58050513          	add	a0,a0,1408 # 9d0 <digits>
 458:	883e                	mv	a6,a5
 45a:	2785                	addw	a5,a5,1
 45c:	02c5f733          	remu	a4,a1,a2
 460:	972a                	add	a4,a4,a0
 462:	00074703          	lbu	a4,0(a4)
 466:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 46a:	872e                	mv	a4,a1
 46c:	02c5d5b3          	divu	a1,a1,a2
 470:	0685                	add	a3,a3,1
 472:	fec773e3          	bgeu	a4,a2,458 <printint+0x26>
  if(neg)
 476:	00088b63          	beqz	a7,48c <printint+0x5a>
    buf[i++] = '-';
 47a:	fd078793          	add	a5,a5,-48
 47e:	97a2                	add	a5,a5,s0
 480:	02d00713          	li	a4,45
 484:	fee78423          	sb	a4,-24(a5)
 488:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 48c:	02f05863          	blez	a5,4bc <printint+0x8a>
 490:	fb840713          	add	a4,s0,-72
 494:	00f704b3          	add	s1,a4,a5
 498:	fff70993          	add	s3,a4,-1
 49c:	99be                	add	s3,s3,a5
 49e:	37fd                	addw	a5,a5,-1
 4a0:	1782                	sll	a5,a5,0x20
 4a2:	9381                	srl	a5,a5,0x20
 4a4:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4a8:	fff4c583          	lbu	a1,-1(s1)
 4ac:	854a                	mv	a0,s2
 4ae:	00000097          	auipc	ra,0x0
 4b2:	f62080e7          	jalr	-158(ra) # 410 <putc>
  while(--i >= 0)
 4b6:	14fd                	add	s1,s1,-1
 4b8:	ff3498e3          	bne	s1,s3,4a8 <printint+0x76>
}
 4bc:	60a6                	ld	ra,72(sp)
 4be:	6406                	ld	s0,64(sp)
 4c0:	74e2                	ld	s1,56(sp)
 4c2:	7942                	ld	s2,48(sp)
 4c4:	79a2                	ld	s3,40(sp)
 4c6:	6161                	add	sp,sp,80
 4c8:	8082                	ret
    x = -xx;
 4ca:	40b005b3          	neg	a1,a1
    neg = 1;
 4ce:	4885                	li	a7,1
    x = -xx;
 4d0:	bfad                	j	44a <printint+0x18>

00000000000004d2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d2:	711d                	add	sp,sp,-96
 4d4:	ec86                	sd	ra,88(sp)
 4d6:	e8a2                	sd	s0,80(sp)
 4d8:	e4a6                	sd	s1,72(sp)
 4da:	e0ca                	sd	s2,64(sp)
 4dc:	fc4e                	sd	s3,56(sp)
 4de:	f852                	sd	s4,48(sp)
 4e0:	f456                	sd	s5,40(sp)
 4e2:	f05a                	sd	s6,32(sp)
 4e4:	ec5e                	sd	s7,24(sp)
 4e6:	e862                	sd	s8,16(sp)
 4e8:	e466                	sd	s9,8(sp)
 4ea:	e06a                	sd	s10,0(sp)
 4ec:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ee:	0005c903          	lbu	s2,0(a1)
 4f2:	2a090963          	beqz	s2,7a4 <vprintf+0x2d2>
 4f6:	8b2a                	mv	s6,a0
 4f8:	8a2e                	mv	s4,a1
 4fa:	8bb2                	mv	s7,a2
  state = 0;
 4fc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4fe:	4481                	li	s1,0
 500:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 502:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 506:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 50a:	06c00c93          	li	s9,108
 50e:	a015                	j	532 <vprintf+0x60>
        putc(fd, c0);
 510:	85ca                	mv	a1,s2
 512:	855a                	mv	a0,s6
 514:	00000097          	auipc	ra,0x0
 518:	efc080e7          	jalr	-260(ra) # 410 <putc>
 51c:	a019                	j	522 <vprintf+0x50>
    } else if(state == '%'){
 51e:	03598263          	beq	s3,s5,542 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 522:	2485                	addw	s1,s1,1
 524:	8726                	mv	a4,s1
 526:	009a07b3          	add	a5,s4,s1
 52a:	0007c903          	lbu	s2,0(a5)
 52e:	26090b63          	beqz	s2,7a4 <vprintf+0x2d2>
    c0 = fmt[i] & 0xff;
 532:	0009079b          	sext.w	a5,s2
    if(state == 0){
 536:	fe0994e3          	bnez	s3,51e <vprintf+0x4c>
      if(c0 == '%'){
 53a:	fd579be3          	bne	a5,s5,510 <vprintf+0x3e>
        state = '%';
 53e:	89be                	mv	s3,a5
 540:	b7cd                	j	522 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 542:	cfc9                	beqz	a5,5dc <vprintf+0x10a>
 544:	00ea06b3          	add	a3,s4,a4
 548:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 54c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 54e:	c681                	beqz	a3,556 <vprintf+0x84>
 550:	9752                	add	a4,a4,s4
 552:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 556:	05878563          	beq	a5,s8,5a0 <vprintf+0xce>
      } else if(c0 == 'l' && c1 == 'd'){
 55a:	07978163          	beq	a5,s9,5bc <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 55e:	07500713          	li	a4,117
 562:	10e78563          	beq	a5,a4,66c <vprintf+0x19a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 566:	07800713          	li	a4,120
 56a:	14e78d63          	beq	a5,a4,6c4 <vprintf+0x1f2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 56e:	07000713          	li	a4,112
 572:	18e78663          	beq	a5,a4,6fe <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 576:	06300713          	li	a4,99
 57a:	1ce78a63          	beq	a5,a4,74e <vprintf+0x27c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 57e:	07300713          	li	a4,115
 582:	1ee78263          	beq	a5,a4,766 <vprintf+0x294>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 586:	02500713          	li	a4,37
 58a:	04e79963          	bne	a5,a4,5dc <vprintf+0x10a>
        putc(fd, '%');
 58e:	02500593          	li	a1,37
 592:	855a                	mv	a0,s6
 594:	00000097          	auipc	ra,0x0
 598:	e7c080e7          	jalr	-388(ra) # 410 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 59c:	4981                	li	s3,0
 59e:	b751                	j	522 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 5a0:	008b8913          	add	s2,s7,8
 5a4:	4685                	li	a3,1
 5a6:	4629                	li	a2,10
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	00000097          	auipc	ra,0x0
 5b2:	e84080e7          	jalr	-380(ra) # 432 <printint>
 5b6:	8bca                	mv	s7,s2
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b7a5                	j	522 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 5bc:	06400793          	li	a5,100
 5c0:	02f68d63          	beq	a3,a5,5fa <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c4:	06c00793          	li	a5,108
 5c8:	04f68863          	beq	a3,a5,618 <vprintf+0x146>
      } else if(c0 == 'l' && c1 == 'u'){
 5cc:	07500793          	li	a5,117
 5d0:	0af68c63          	beq	a3,a5,688 <vprintf+0x1b6>
      } else if(c0 == 'l' && c1 == 'x'){
 5d4:	07800793          	li	a5,120
 5d8:	10f68463          	beq	a3,a5,6e0 <vprintf+0x20e>
        putc(fd, '%');
 5dc:	02500593          	li	a1,37
 5e0:	855a                	mv	a0,s6
 5e2:	00000097          	auipc	ra,0x0
 5e6:	e2e080e7          	jalr	-466(ra) # 410 <putc>
        putc(fd, c0);
 5ea:	85ca                	mv	a1,s2
 5ec:	855a                	mv	a0,s6
 5ee:	00000097          	auipc	ra,0x0
 5f2:	e22080e7          	jalr	-478(ra) # 410 <putc>
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b72d                	j	522 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fa:	008b8913          	add	s2,s7,8
 5fe:	4685                	li	a3,1
 600:	4629                	li	a2,10
 602:	000bb583          	ld	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	00000097          	auipc	ra,0x0
 60c:	e2a080e7          	jalr	-470(ra) # 432 <printint>
        i += 1;
 610:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 612:	8bca                	mv	s7,s2
      state = 0;
 614:	4981                	li	s3,0
        i += 1;
 616:	b731                	j	522 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 618:	06400793          	li	a5,100
 61c:	02f60963          	beq	a2,a5,64e <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 620:	07500793          	li	a5,117
 624:	08f60163          	beq	a2,a5,6a6 <vprintf+0x1d4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 628:	07800793          	li	a5,120
 62c:	faf618e3          	bne	a2,a5,5dc <vprintf+0x10a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 630:	008b8913          	add	s2,s7,8
 634:	4681                	li	a3,0
 636:	4641                	li	a2,16
 638:	000bb583          	ld	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	00000097          	auipc	ra,0x0
 642:	df4080e7          	jalr	-524(ra) # 432 <printint>
        i += 2;
 646:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 648:	8bca                	mv	s7,s2
      state = 0;
 64a:	4981                	li	s3,0
        i += 2;
 64c:	bdd9                	j	522 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 64e:	008b8913          	add	s2,s7,8
 652:	4685                	li	a3,1
 654:	4629                	li	a2,10
 656:	000bb583          	ld	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	00000097          	auipc	ra,0x0
 660:	dd6080e7          	jalr	-554(ra) # 432 <printint>
        i += 2;
 664:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 666:	8bca                	mv	s7,s2
      state = 0;
 668:	4981                	li	s3,0
        i += 2;
 66a:	bd65                	j	522 <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 10, 0);
 66c:	008b8913          	add	s2,s7,8
 670:	4681                	li	a3,0
 672:	4629                	li	a2,10
 674:	000be583          	lwu	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	00000097          	auipc	ra,0x0
 67e:	db8080e7          	jalr	-584(ra) # 432 <printint>
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
 686:	bd71                	j	522 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	008b8913          	add	s2,s7,8
 68c:	4681                	li	a3,0
 68e:	4629                	li	a2,10
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	00000097          	auipc	ra,0x0
 69a:	d9c080e7          	jalr	-612(ra) # 432 <printint>
        i += 1;
 69e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
        i += 1;
 6a4:	bdbd                	j	522 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a6:	008b8913          	add	s2,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4629                	li	a2,10
 6ae:	000bb583          	ld	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	00000097          	auipc	ra,0x0
 6b8:	d7e080e7          	jalr	-642(ra) # 432 <printint>
        i += 2;
 6bc:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6be:	8bca                	mv	s7,s2
      state = 0;
 6c0:	4981                	li	s3,0
        i += 2;
 6c2:	b585                	j	522 <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6c4:	008b8913          	add	s2,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4641                	li	a2,16
 6cc:	000be583          	lwu	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	00000097          	auipc	ra,0x0
 6d6:	d60080e7          	jalr	-672(ra) # 432 <printint>
 6da:	8bca                	mv	s7,s2
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	b591                	j	522 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e0:	008b8913          	add	s2,s7,8
 6e4:	4681                	li	a3,0
 6e6:	4641                	li	a2,16
 6e8:	000bb583          	ld	a1,0(s7)
 6ec:	855a                	mv	a0,s6
 6ee:	00000097          	auipc	ra,0x0
 6f2:	d44080e7          	jalr	-700(ra) # 432 <printint>
        i += 1;
 6f6:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f8:	8bca                	mv	s7,s2
      state = 0;
 6fa:	4981                	li	s3,0
        i += 1;
 6fc:	b51d                	j	522 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 6fe:	008b8d13          	add	s10,s7,8
 702:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 706:	03000593          	li	a1,48
 70a:	855a                	mv	a0,s6
 70c:	00000097          	auipc	ra,0x0
 710:	d04080e7          	jalr	-764(ra) # 410 <putc>
  putc(fd, 'x');
 714:	07800593          	li	a1,120
 718:	855a                	mv	a0,s6
 71a:	00000097          	auipc	ra,0x0
 71e:	cf6080e7          	jalr	-778(ra) # 410 <putc>
 722:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 724:	00000b97          	auipc	s7,0x0
 728:	2acb8b93          	add	s7,s7,684 # 9d0 <digits>
 72c:	03c9d793          	srl	a5,s3,0x3c
 730:	97de                	add	a5,a5,s7
 732:	0007c583          	lbu	a1,0(a5)
 736:	855a                	mv	a0,s6
 738:	00000097          	auipc	ra,0x0
 73c:	cd8080e7          	jalr	-808(ra) # 410 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 740:	0992                	sll	s3,s3,0x4
 742:	397d                	addw	s2,s2,-1
 744:	fe0914e3          	bnez	s2,72c <vprintf+0x25a>
        printptr(fd, va_arg(ap, uint64));
 748:	8bea                	mv	s7,s10
      state = 0;
 74a:	4981                	li	s3,0
 74c:	bbd9                	j	522 <vprintf+0x50>
        putc(fd, va_arg(ap, uint32));
 74e:	008b8913          	add	s2,s7,8
 752:	000bc583          	lbu	a1,0(s7)
 756:	855a                	mv	a0,s6
 758:	00000097          	auipc	ra,0x0
 75c:	cb8080e7          	jalr	-840(ra) # 410 <putc>
 760:	8bca                	mv	s7,s2
      state = 0;
 762:	4981                	li	s3,0
 764:	bb7d                	j	522 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 766:	008b8993          	add	s3,s7,8
 76a:	000bb903          	ld	s2,0(s7)
 76e:	02090163          	beqz	s2,790 <vprintf+0x2be>
        for(; *s; s++)
 772:	00094583          	lbu	a1,0(s2)
 776:	c585                	beqz	a1,79e <vprintf+0x2cc>
          putc(fd, *s);
 778:	855a                	mv	a0,s6
 77a:	00000097          	auipc	ra,0x0
 77e:	c96080e7          	jalr	-874(ra) # 410 <putc>
        for(; *s; s++)
 782:	0905                	add	s2,s2,1
 784:	00094583          	lbu	a1,0(s2)
 788:	f9e5                	bnez	a1,778 <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
 78a:	8bce                	mv	s7,s3
      state = 0;
 78c:	4981                	li	s3,0
 78e:	bb51                	j	522 <vprintf+0x50>
          s = "(null)";
 790:	00000917          	auipc	s2,0x0
 794:	23890913          	add	s2,s2,568 # 9c8 <malloc+0x122>
        for(; *s; s++)
 798:	02800593          	li	a1,40
 79c:	bff1                	j	778 <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
 79e:	8bce                	mv	s7,s3
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	b341                	j	522 <vprintf+0x50>
    }
  }
}
 7a4:	60e6                	ld	ra,88(sp)
 7a6:	6446                	ld	s0,80(sp)
 7a8:	64a6                	ld	s1,72(sp)
 7aa:	6906                	ld	s2,64(sp)
 7ac:	79e2                	ld	s3,56(sp)
 7ae:	7a42                	ld	s4,48(sp)
 7b0:	7aa2                	ld	s5,40(sp)
 7b2:	7b02                	ld	s6,32(sp)
 7b4:	6be2                	ld	s7,24(sp)
 7b6:	6c42                	ld	s8,16(sp)
 7b8:	6ca2                	ld	s9,8(sp)
 7ba:	6d02                	ld	s10,0(sp)
 7bc:	6125                	add	sp,sp,96
 7be:	8082                	ret

00000000000007c0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c0:	715d                	add	sp,sp,-80
 7c2:	ec06                	sd	ra,24(sp)
 7c4:	e822                	sd	s0,16(sp)
 7c6:	1000                	add	s0,sp,32
 7c8:	e010                	sd	a2,0(s0)
 7ca:	e414                	sd	a3,8(s0)
 7cc:	e818                	sd	a4,16(s0)
 7ce:	ec1c                	sd	a5,24(s0)
 7d0:	03043023          	sd	a6,32(s0)
 7d4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7dc:	8622                	mv	a2,s0
 7de:	00000097          	auipc	ra,0x0
 7e2:	cf4080e7          	jalr	-780(ra) # 4d2 <vprintf>
}
 7e6:	60e2                	ld	ra,24(sp)
 7e8:	6442                	ld	s0,16(sp)
 7ea:	6161                	add	sp,sp,80
 7ec:	8082                	ret

00000000000007ee <printf>:

void
printf(const char *fmt, ...)
{
 7ee:	711d                	add	sp,sp,-96
 7f0:	ec06                	sd	ra,24(sp)
 7f2:	e822                	sd	s0,16(sp)
 7f4:	1000                	add	s0,sp,32
 7f6:	e40c                	sd	a1,8(s0)
 7f8:	e810                	sd	a2,16(s0)
 7fa:	ec14                	sd	a3,24(s0)
 7fc:	f018                	sd	a4,32(s0)
 7fe:	f41c                	sd	a5,40(s0)
 800:	03043823          	sd	a6,48(s0)
 804:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 808:	00840613          	add	a2,s0,8
 80c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 810:	85aa                	mv	a1,a0
 812:	4505                	li	a0,1
 814:	00000097          	auipc	ra,0x0
 818:	cbe080e7          	jalr	-834(ra) # 4d2 <vprintf>
}
 81c:	60e2                	ld	ra,24(sp)
 81e:	6442                	ld	s0,16(sp)
 820:	6125                	add	sp,sp,96
 822:	8082                	ret

0000000000000824 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 824:	1141                	add	sp,sp,-16
 826:	e422                	sd	s0,8(sp)
 828:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 82a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82e:	00000797          	auipc	a5,0x0
 832:	7d27b783          	ld	a5,2002(a5) # 1000 <freep>
 836:	a02d                	j	860 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 838:	4618                	lw	a4,8(a2)
 83a:	9f2d                	addw	a4,a4,a1
 83c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 840:	6398                	ld	a4,0(a5)
 842:	6310                	ld	a2,0(a4)
 844:	a83d                	j	882 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 846:	ff852703          	lw	a4,-8(a0)
 84a:	9f31                	addw	a4,a4,a2
 84c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 84e:	ff053683          	ld	a3,-16(a0)
 852:	a091                	j	896 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 854:	6398                	ld	a4,0(a5)
 856:	00e7e463          	bltu	a5,a4,85e <free+0x3a>
 85a:	00e6ea63          	bltu	a3,a4,86e <free+0x4a>
{
 85e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 860:	fed7fae3          	bgeu	a5,a3,854 <free+0x30>
 864:	6398                	ld	a4,0(a5)
 866:	00e6e463          	bltu	a3,a4,86e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86a:	fee7eae3          	bltu	a5,a4,85e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 86e:	ff852583          	lw	a1,-8(a0)
 872:	6390                	ld	a2,0(a5)
 874:	02059813          	sll	a6,a1,0x20
 878:	01c85713          	srl	a4,a6,0x1c
 87c:	9736                	add	a4,a4,a3
 87e:	fae60de3          	beq	a2,a4,838 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 882:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 886:	4790                	lw	a2,8(a5)
 888:	02061593          	sll	a1,a2,0x20
 88c:	01c5d713          	srl	a4,a1,0x1c
 890:	973e                	add	a4,a4,a5
 892:	fae68ae3          	beq	a3,a4,846 <free+0x22>
    p->s.ptr = bp->s.ptr;
 896:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 898:	00000717          	auipc	a4,0x0
 89c:	76f73423          	sd	a5,1896(a4) # 1000 <freep>
}
 8a0:	6422                	ld	s0,8(sp)
 8a2:	0141                	add	sp,sp,16
 8a4:	8082                	ret

00000000000008a6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a6:	7139                	add	sp,sp,-64
 8a8:	fc06                	sd	ra,56(sp)
 8aa:	f822                	sd	s0,48(sp)
 8ac:	f426                	sd	s1,40(sp)
 8ae:	f04a                	sd	s2,32(sp)
 8b0:	ec4e                	sd	s3,24(sp)
 8b2:	e852                	sd	s4,16(sp)
 8b4:	e456                	sd	s5,8(sp)
 8b6:	e05a                	sd	s6,0(sp)
 8b8:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ba:	02051493          	sll	s1,a0,0x20
 8be:	9081                	srl	s1,s1,0x20
 8c0:	04bd                	add	s1,s1,15
 8c2:	8091                	srl	s1,s1,0x4
 8c4:	0014899b          	addw	s3,s1,1
 8c8:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 8ca:	00000517          	auipc	a0,0x0
 8ce:	73653503          	ld	a0,1846(a0) # 1000 <freep>
 8d2:	c515                	beqz	a0,8fe <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d6:	4798                	lw	a4,8(a5)
 8d8:	02977f63          	bgeu	a4,s1,916 <malloc+0x70>
  if(nu < 4096)
 8dc:	8a4e                	mv	s4,s3
 8de:	0009871b          	sext.w	a4,s3
 8e2:	6685                	lui	a3,0x1
 8e4:	00d77363          	bgeu	a4,a3,8ea <malloc+0x44>
 8e8:	6a05                	lui	s4,0x1
 8ea:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ee:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f2:	00000917          	auipc	s2,0x0
 8f6:	70e90913          	add	s2,s2,1806 # 1000 <freep>
  if(p == SBRK_ERROR)
 8fa:	5afd                	li	s5,-1
 8fc:	a895                	j	970 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8fe:	00000797          	auipc	a5,0x0
 902:	71278793          	add	a5,a5,1810 # 1010 <base>
 906:	00000717          	auipc	a4,0x0
 90a:	6ef73d23          	sd	a5,1786(a4) # 1000 <freep>
 90e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 910:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 914:	b7e1                	j	8dc <malloc+0x36>
      if(p->s.size == nunits)
 916:	02e48c63          	beq	s1,a4,94e <malloc+0xa8>
        p->s.size -= nunits;
 91a:	4137073b          	subw	a4,a4,s3
 91e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 920:	02071693          	sll	a3,a4,0x20
 924:	01c6d713          	srl	a4,a3,0x1c
 928:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 92a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92e:	00000717          	auipc	a4,0x0
 932:	6ca73923          	sd	a0,1746(a4) # 1000 <freep>
      return (void*)(p + 1);
 936:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 93a:	70e2                	ld	ra,56(sp)
 93c:	7442                	ld	s0,48(sp)
 93e:	74a2                	ld	s1,40(sp)
 940:	7902                	ld	s2,32(sp)
 942:	69e2                	ld	s3,24(sp)
 944:	6a42                	ld	s4,16(sp)
 946:	6aa2                	ld	s5,8(sp)
 948:	6b02                	ld	s6,0(sp)
 94a:	6121                	add	sp,sp,64
 94c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 94e:	6398                	ld	a4,0(a5)
 950:	e118                	sd	a4,0(a0)
 952:	bff1                	j	92e <malloc+0x88>
  hp->s.size = nu;
 954:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 958:	0541                	add	a0,a0,16
 95a:	00000097          	auipc	ra,0x0
 95e:	eca080e7          	jalr	-310(ra) # 824 <free>
  return freep;
 962:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 966:	d971                	beqz	a0,93a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 968:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 96a:	4798                	lw	a4,8(a5)
 96c:	fa9775e3          	bgeu	a4,s1,916 <malloc+0x70>
    if(p == freep)
 970:	00093703          	ld	a4,0(s2)
 974:	853e                	mv	a0,a5
 976:	fef719e3          	bne	a4,a5,968 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 97a:	8552                	mv	a0,s4
 97c:	00000097          	auipc	ra,0x0
 980:	938080e7          	jalr	-1736(ra) # 2b4 <sbrk>
  if(p == SBRK_ERROR)
 984:	fd5518e3          	bne	a0,s5,954 <malloc+0xae>
        return 0;
 988:	4501                	li	a0,0
 98a:	bf45                	j	93a <malloc+0x94>
