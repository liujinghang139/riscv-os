
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "./user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	add	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	add	s0,sp,64
  for(int i = 1; i < argc; i++){
  12:	4785                	li	a5,1
  14:	06a7dd63          	bge	a5,a0,8e <main+0x8e>
  18:	00858493          	add	s1,a1,8
  1c:	3579                	addw	a0,a0,-2
  1e:	02051793          	sll	a5,a0,0x20
  22:	01d7d513          	srl	a0,a5,0x1d
  26:	00a48a33          	add	s4,s1,a0
  2a:	05c1                	add	a1,a1,16
  2c:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc)
      write(1, " ", 1);
  30:	00001a97          	auipc	s5,0x1
  34:	990a8a93          	add	s5,s5,-1648 # 9c0 <malloc+0xf4>
  38:	a819                	j	4e <main+0x4e>
  3a:	4605                	li	a2,1
  3c:	85d6                	mv	a1,s5
  3e:	4505                	li	a0,1
  40:	00000097          	auipc	ra,0x0
  44:	3ae080e7          	jalr	942(ra) # 3ee <write>
  for(int i = 1; i < argc; i++){
  48:	04a1                	add	s1,s1,8
  4a:	03348d63          	beq	s1,s3,84 <main+0x84>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	00000097          	auipc	ra,0x0
  58:	0b0080e7          	jalr	176(ra) # 104 <strlen>
  5c:	0005061b          	sext.w	a2,a0
  60:	85ca                	mv	a1,s2
  62:	4505                	li	a0,1
  64:	00000097          	auipc	ra,0x0
  68:	38a080e7          	jalr	906(ra) # 3ee <write>
    if(i + 1 < argc)
  6c:	fd4497e3          	bne	s1,s4,3a <main+0x3a>
    else
      write(1, "\n", 1);
  70:	4605                	li	a2,1
  72:	00001597          	auipc	a1,0x1
  76:	95658593          	add	a1,a1,-1706 # 9c8 <malloc+0xfc>
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	372080e7          	jalr	882(ra) # 3ee <write>
  }
  if(argc <= 1)
    write(1, "\n", 1);
  exit(0);
  84:	4501                	li	a0,0
  86:	00000097          	auipc	ra,0x0
  8a:	330080e7          	jalr	816(ra) # 3b6 <exit>
    write(1, "\n", 1);
  8e:	4605                	li	a2,1
  90:	00001597          	auipc	a1,0x1
  94:	93858593          	add	a1,a1,-1736 # 9c8 <malloc+0xfc>
  98:	4505                	li	a0,1
  9a:	00000097          	auipc	ra,0x0
  9e:	354080e7          	jalr	852(ra) # 3ee <write>
  a2:	b7cd                	j	84 <main+0x84>

00000000000000a4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  a4:	1141                	add	sp,sp,-16
  a6:	e406                	sd	ra,8(sp)
  a8:	e022                	sd	s0,0(sp)
  aa:	0800                	add	s0,sp,16
  int r;
  extern int main();
  r = main();
  ac:	00000097          	auipc	ra,0x0
  b0:	f54080e7          	jalr	-172(ra) # 0 <main>
  exit(r);
  b4:	00000097          	auipc	ra,0x0
  b8:	302080e7          	jalr	770(ra) # 3b6 <exit>

00000000000000bc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  bc:	1141                	add	sp,sp,-16
  be:	e422                	sd	s0,8(sp)
  c0:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  c2:	87aa                	mv	a5,a0
  c4:	0585                	add	a1,a1,1
  c6:	0785                	add	a5,a5,1
  c8:	fff5c703          	lbu	a4,-1(a1)
  cc:	fee78fa3          	sb	a4,-1(a5)
  d0:	fb75                	bnez	a4,c4 <strcpy+0x8>
    ;
  return os;
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	add	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d8:	1141                	add	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cb91                	beqz	a5,f6 <strcmp+0x1e>
  e4:	0005c703          	lbu	a4,0(a1)
  e8:	00f71763          	bne	a4,a5,f6 <strcmp+0x1e>
    p++, q++;
  ec:	0505                	add	a0,a0,1
  ee:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  f0:	00054783          	lbu	a5,0(a0)
  f4:	fbe5                	bnez	a5,e4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  f6:	0005c503          	lbu	a0,0(a1)
}
  fa:	40a7853b          	subw	a0,a5,a0
  fe:	6422                	ld	s0,8(sp)
 100:	0141                	add	sp,sp,16
 102:	8082                	ret

0000000000000104 <strlen>:

uint
strlen(const char *s)
{
 104:	1141                	add	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cf91                	beqz	a5,12a <strlen+0x26>
 110:	0505                	add	a0,a0,1
 112:	87aa                	mv	a5,a0
 114:	86be                	mv	a3,a5
 116:	0785                	add	a5,a5,1
 118:	fff7c703          	lbu	a4,-1(a5)
 11c:	ff65                	bnez	a4,114 <strlen+0x10>
 11e:	40a6853b          	subw	a0,a3,a0
 122:	2505                	addw	a0,a0,1
    ;
  return n;
}
 124:	6422                	ld	s0,8(sp)
 126:	0141                	add	sp,sp,16
 128:	8082                	ret
  for(n = 0; s[n]; n++)
 12a:	4501                	li	a0,0
 12c:	bfe5                	j	124 <strlen+0x20>

000000000000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	1141                	add	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 134:	ca19                	beqz	a2,14a <memset+0x1c>
 136:	87aa                	mv	a5,a0
 138:	1602                	sll	a2,a2,0x20
 13a:	9201                	srl	a2,a2,0x20
 13c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 140:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 144:	0785                	add	a5,a5,1
 146:	fee79de3          	bne	a5,a4,140 <memset+0x12>
  }
  return dst;
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	add	sp,sp,16
 14e:	8082                	ret

0000000000000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	1141                	add	sp,sp,-16
 152:	e422                	sd	s0,8(sp)
 154:	0800                	add	s0,sp,16
  for(; *s; s++)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cb99                	beqz	a5,170 <strchr+0x20>
    if(*s == c)
 15c:	00f58763          	beq	a1,a5,16a <strchr+0x1a>
  for(; *s; s++)
 160:	0505                	add	a0,a0,1
 162:	00054783          	lbu	a5,0(a0)
 166:	fbfd                	bnez	a5,15c <strchr+0xc>
      return (char*)s;
  return 0;
 168:	4501                	li	a0,0
}
 16a:	6422                	ld	s0,8(sp)
 16c:	0141                	add	sp,sp,16
 16e:	8082                	ret
  return 0;
 170:	4501                	li	a0,0
 172:	bfe5                	j	16a <strchr+0x1a>

0000000000000174 <gets>:

char*
gets(char *buf, int max)
{
 174:	711d                	add	sp,sp,-96
 176:	ec86                	sd	ra,88(sp)
 178:	e8a2                	sd	s0,80(sp)
 17a:	e4a6                	sd	s1,72(sp)
 17c:	e0ca                	sd	s2,64(sp)
 17e:	fc4e                	sd	s3,56(sp)
 180:	f852                	sd	s4,48(sp)
 182:	f456                	sd	s5,40(sp)
 184:	f05a                	sd	s6,32(sp)
 186:	ec5e                	sd	s7,24(sp)
 188:	1080                	add	s0,sp,96
 18a:	8baa                	mv	s7,a0
 18c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18e:	892a                	mv	s2,a0
 190:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 192:	4aa9                	li	s5,10
 194:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 196:	89a6                	mv	s3,s1
 198:	2485                	addw	s1,s1,1
 19a:	0344d863          	bge	s1,s4,1ca <gets+0x56>
    cc = read(0, &c, 1);
 19e:	4605                	li	a2,1
 1a0:	faf40593          	add	a1,s0,-81
 1a4:	4501                	li	a0,0
 1a6:	00000097          	auipc	ra,0x0
 1aa:	240080e7          	jalr	576(ra) # 3e6 <read>
    if(cc < 1)
 1ae:	00a05e63          	blez	a0,1ca <gets+0x56>
    buf[i++] = c;
 1b2:	faf44783          	lbu	a5,-81(s0)
 1b6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ba:	01578763          	beq	a5,s5,1c8 <gets+0x54>
 1be:	0905                	add	s2,s2,1
 1c0:	fd679be3          	bne	a5,s6,196 <gets+0x22>
  for(i=0; i+1 < max; ){
 1c4:	89a6                	mv	s3,s1
 1c6:	a011                	j	1ca <gets+0x56>
 1c8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1ca:	99de                	add	s3,s3,s7
 1cc:	00098023          	sb	zero,0(s3)
  return buf;
}
 1d0:	855e                	mv	a0,s7
 1d2:	60e6                	ld	ra,88(sp)
 1d4:	6446                	ld	s0,80(sp)
 1d6:	64a6                	ld	s1,72(sp)
 1d8:	6906                	ld	s2,64(sp)
 1da:	79e2                	ld	s3,56(sp)
 1dc:	7a42                	ld	s4,48(sp)
 1de:	7aa2                	ld	s5,40(sp)
 1e0:	7b02                	ld	s6,32(sp)
 1e2:	6be2                	ld	s7,24(sp)
 1e4:	6125                	add	sp,sp,96
 1e6:	8082                	ret

00000000000001e8 <atoi>:
//   return r;
// }

int
atoi(const char *s)
{
 1e8:	1141                	add	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ee:	00054683          	lbu	a3,0(a0)
 1f2:	fd06879b          	addw	a5,a3,-48
 1f6:	0ff7f793          	zext.b	a5,a5
 1fa:	4625                	li	a2,9
 1fc:	02f66863          	bltu	a2,a5,22c <atoi+0x44>
 200:	872a                	mv	a4,a0
  n = 0;
 202:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 204:	0705                	add	a4,a4,1
 206:	0025179b          	sllw	a5,a0,0x2
 20a:	9fa9                	addw	a5,a5,a0
 20c:	0017979b          	sllw	a5,a5,0x1
 210:	9fb5                	addw	a5,a5,a3
 212:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 216:	00074683          	lbu	a3,0(a4)
 21a:	fd06879b          	addw	a5,a3,-48
 21e:	0ff7f793          	zext.b	a5,a5
 222:	fef671e3          	bgeu	a2,a5,204 <atoi+0x1c>
  return n;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	add	sp,sp,16
 22a:	8082                	ret
  n = 0;
 22c:	4501                	li	a0,0
 22e:	bfe5                	j	226 <atoi+0x3e>

0000000000000230 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 230:	1141                	add	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 236:	02b57463          	bgeu	a0,a1,25e <memmove+0x2e>
    while(n-- > 0)
 23a:	00c05f63          	blez	a2,258 <memmove+0x28>
 23e:	1602                	sll	a2,a2,0x20
 240:	9201                	srl	a2,a2,0x20
 242:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 246:	872a                	mv	a4,a0
      *dst++ = *src++;
 248:	0585                	add	a1,a1,1
 24a:	0705                	add	a4,a4,1
 24c:	fff5c683          	lbu	a3,-1(a1)
 250:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 254:	fee79ae3          	bne	a5,a4,248 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	add	sp,sp,16
 25c:	8082                	ret
    dst += n;
 25e:	00c50733          	add	a4,a0,a2
    src += n;
 262:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 264:	fec05ae3          	blez	a2,258 <memmove+0x28>
 268:	fff6079b          	addw	a5,a2,-1
 26c:	1782                	sll	a5,a5,0x20
 26e:	9381                	srl	a5,a5,0x20
 270:	fff7c793          	not	a5,a5
 274:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 276:	15fd                	add	a1,a1,-1
 278:	177d                	add	a4,a4,-1
 27a:	0005c683          	lbu	a3,0(a1)
 27e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 282:	fee79ae3          	bne	a5,a4,276 <memmove+0x46>
 286:	bfc9                	j	258 <memmove+0x28>

0000000000000288 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 288:	1141                	add	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28e:	ca05                	beqz	a2,2be <memcmp+0x36>
 290:	fff6069b          	addw	a3,a2,-1
 294:	1682                	sll	a3,a3,0x20
 296:	9281                	srl	a3,a3,0x20
 298:	0685                	add	a3,a3,1
 29a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	0005c703          	lbu	a4,0(a1)
 2a4:	00e79863          	bne	a5,a4,2b4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2a8:	0505                	add	a0,a0,1
    p2++;
 2aa:	0585                	add	a1,a1,1
  while (n-- > 0) {
 2ac:	fed518e3          	bne	a0,a3,29c <memcmp+0x14>
  }
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	a019                	j	2b8 <memcmp+0x30>
      return *p1 - *p2;
 2b4:	40e7853b          	subw	a0,a5,a4
}
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	add	sp,sp,16
 2bc:	8082                	ret
  return 0;
 2be:	4501                	li	a0,0
 2c0:	bfe5                	j	2b8 <memcmp+0x30>

00000000000002c2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c2:	1141                	add	sp,sp,-16
 2c4:	e406                	sd	ra,8(sp)
 2c6:	e022                	sd	s0,0(sp)
 2c8:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2ca:	00000097          	auipc	ra,0x0
 2ce:	f66080e7          	jalr	-154(ra) # 230 <memmove>
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	add	sp,sp,16
 2d8:	8082                	ret

00000000000002da <sbrk>:

char *
sbrk(int n) {
 2da:	1141                	add	sp,sp,-16
 2dc:	e406                	sd	ra,8(sp)
 2de:	e022                	sd	s0,0(sp)
 2e0:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2e2:	4585                	li	a1,1
 2e4:	00000097          	auipc	ra,0x0
 2e8:	12a080e7          	jalr	298(ra) # 40e <sys_sbrk>
}
 2ec:	60a2                	ld	ra,8(sp)
 2ee:	6402                	ld	s0,0(sp)
 2f0:	0141                	add	sp,sp,16
 2f2:	8082                	ret

00000000000002f4 <get_time>:
//   return sys_sbrk(n, SBRK_LAZY);
// }


unsigned int 
get_time(void) {
 2f4:	1141                	add	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	add	s0,sp,16
    return uptime();
 2fc:	00000097          	auipc	ra,0x0
 300:	11a080e7          	jalr	282(ra) # 416 <uptime>
}
 304:	2501                	sext.w	a0,a0
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	add	sp,sp,16
 30c:	8082                	ret

000000000000030e <make_filename>:
void 
make_filename(char *buf, const char *prefix, int num) {
    // 复制前缀
    char *p = buf;
    const char *s = prefix;
    while(*s) *p++ = *s++;
 30e:	0005c783          	lbu	a5,0(a1)
 312:	cb81                	beqz	a5,322 <make_filename+0x14>
 314:	0585                	add	a1,a1,1
 316:	0505                	add	a0,a0,1
 318:	fef50fa3          	sb	a5,-1(a0)
 31c:	0005c783          	lbu	a5,0(a1)
 320:	fbf5                	bnez	a5,314 <make_filename+0x6>
    
    // 处理数字部分
    if (num == 0) {
 322:	ca3d                	beqz	a2,398 <make_filename+0x8a>
make_filename(char *buf, const char *prefix, int num) {
 324:	1101                	add	sp,sp,-32
 326:	ec22                	sd	s0,24(sp)
 328:	1000                	add	s0,sp,32
        *p++ = '0';
    } else {
        // 临时缓冲区存放数字
        char digits[16];
        int i = 0;
        while(num > 0) {
 32a:	fe040893          	add	a7,s0,-32
 32e:	87c6                	mv	a5,a7
            digits[i++] = (num % 10) + '0';
 330:	46a9                	li	a3,10
        while(num > 0) {
 332:	4825                	li	a6,9
 334:	06c05063          	blez	a2,394 <make_filename+0x86>
            digits[i++] = (num % 10) + '0';
 338:	02d6673b          	remw	a4,a2,a3
 33c:	0307071b          	addw	a4,a4,48
 340:	00e78023          	sb	a4,0(a5)
            num /= 10;
 344:	85b2                	mv	a1,a2
 346:	02d6463b          	divw	a2,a2,a3
        while(num > 0) {
 34a:	873e                	mv	a4,a5
 34c:	0785                	add	a5,a5,1
 34e:	feb845e3          	blt	a6,a1,338 <make_filename+0x2a>
 352:	4117073b          	subw	a4,a4,a7
 356:	0017069b          	addw	a3,a4,1
            digits[i++] = (num % 10) + '0';
 35a:	0006879b          	sext.w	a5,a3
        }
        // 倒序写入
        while(i > 0) *p++ = digits[--i];
 35e:	04f05663          	blez	a5,3aa <make_filename+0x9c>
 362:	fe040713          	add	a4,s0,-32
 366:	973e                	add	a4,a4,a5
 368:	02069593          	sll	a1,a3,0x20
 36c:	9181                	srl	a1,a1,0x20
 36e:	95aa                	add	a1,a1,a0
 370:	87aa                	mv	a5,a0
 372:	0785                	add	a5,a5,1
 374:	fff74603          	lbu	a2,-1(a4)
 378:	fec78fa3          	sb	a2,-1(a5)
 37c:	177d                	add	a4,a4,-1
 37e:	feb79ae3          	bne	a5,a1,372 <make_filename+0x64>
 382:	02069793          	sll	a5,a3,0x20
 386:	9381                	srl	a5,a5,0x20
 388:	97aa                	add	a5,a5,a0
    }
    *p = 0; // 字符串结束符
 38a:	00078023          	sb	zero,0(a5)
 38e:	6462                	ld	s0,24(sp)
 390:	6105                	add	sp,sp,32
 392:	8082                	ret
        while(num > 0) {
 394:	87aa                	mv	a5,a0
 396:	bfd5                	j	38a <make_filename+0x7c>
        *p++ = '0';
 398:	00150793          	add	a5,a0,1
 39c:	03000713          	li	a4,48
 3a0:	00e50023          	sb	a4,0(a0)
    *p = 0; // 字符串结束符
 3a4:	00078023          	sb	zero,0(a5)
 3a8:	8082                	ret
        while(i > 0) *p++ = digits[--i];
 3aa:	87aa                	mv	a5,a0
 3ac:	bff9                	j	38a <make_filename+0x7c>

00000000000003ae <fork>:
.globl unlink
# generated by usys.pl - do not edit
#include "../kernel/sys/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ae:	4885                	li	a7,1
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b6:	4889                	li	a7,2
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <wait>:
.global wait
wait:
 li a7, SYS_wait
 3be:	488d                	li	a7,3
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3c6:	4891                	li	a7,4
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <close>:
.global close
close:
 li a7, SYS_close
 3ce:	4899                	li	a7,6
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <open>:
.global open
open:
 li a7, SYS_open
 3d6:	489d                	li	a7,7
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <exec>:
.global exec
exec:
 li a7, SYS_exec
 3de:	4895                	li	a7,5
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <read>:
.global read
read:
 li a7, SYS_read
 3e6:	48a1                	li	a7,8
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <write>:
.global write
write:
 li a7, SYS_write
 3ee:	48a5                	li	a7,9
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f6:	48a9                	li	a7,10
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <makenode>:
.global makenode
makenode:
 li a7, SYS_makenode
 3fe:	48ad                	li	a7,11
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <duplicate>:
.global duplicate
duplicate:
 li a7, SYS_duplicate
 406:	48b1                	li	a7,12
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 40e:	48b5                	li	a7,13
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 416:	48b9                	li	a7,14
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 41e:	48bd                	li	a7,15
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 426:	48c1                	li	a7,16
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <crash_arm>:
.global crash_arm
crash_arm:
 li a7, SYS_crash_arm
 42e:	48c5                	li	a7,17
 ecall
 430:	00000073          	ecall
 434:	8082                	ret

0000000000000436 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 436:	1101                	add	sp,sp,-32
 438:	ec06                	sd	ra,24(sp)
 43a:	e822                	sd	s0,16(sp)
 43c:	1000                	add	s0,sp,32
 43e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 442:	4605                	li	a2,1
 444:	fef40593          	add	a1,s0,-17
 448:	00000097          	auipc	ra,0x0
 44c:	fa6080e7          	jalr	-90(ra) # 3ee <write>
}
 450:	60e2                	ld	ra,24(sp)
 452:	6442                	ld	s0,16(sp)
 454:	6105                	add	sp,sp,32
 456:	8082                	ret

0000000000000458 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 458:	715d                	add	sp,sp,-80
 45a:	e486                	sd	ra,72(sp)
 45c:	e0a2                	sd	s0,64(sp)
 45e:	fc26                	sd	s1,56(sp)
 460:	f84a                	sd	s2,48(sp)
 462:	f44e                	sd	s3,40(sp)
 464:	0880                	add	s0,sp,80
 466:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 468:	c299                	beqz	a3,46e <printint+0x16>
 46a:	0805c363          	bltz	a1,4f0 <printint+0x98>
  neg = 0;
 46e:	4881                	li	a7,0
 470:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 474:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 476:	00000517          	auipc	a0,0x0
 47a:	56250513          	add	a0,a0,1378 # 9d8 <digits>
 47e:	883e                	mv	a6,a5
 480:	2785                	addw	a5,a5,1
 482:	02c5f733          	remu	a4,a1,a2
 486:	972a                	add	a4,a4,a0
 488:	00074703          	lbu	a4,0(a4)
 48c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 490:	872e                	mv	a4,a1
 492:	02c5d5b3          	divu	a1,a1,a2
 496:	0685                	add	a3,a3,1
 498:	fec773e3          	bgeu	a4,a2,47e <printint+0x26>
  if(neg)
 49c:	00088b63          	beqz	a7,4b2 <printint+0x5a>
    buf[i++] = '-';
 4a0:	fd078793          	add	a5,a5,-48
 4a4:	97a2                	add	a5,a5,s0
 4a6:	02d00713          	li	a4,45
 4aa:	fee78423          	sb	a4,-24(a5)
 4ae:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 4b2:	02f05863          	blez	a5,4e2 <printint+0x8a>
 4b6:	fb840713          	add	a4,s0,-72
 4ba:	00f704b3          	add	s1,a4,a5
 4be:	fff70993          	add	s3,a4,-1
 4c2:	99be                	add	s3,s3,a5
 4c4:	37fd                	addw	a5,a5,-1
 4c6:	1782                	sll	a5,a5,0x20
 4c8:	9381                	srl	a5,a5,0x20
 4ca:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4ce:	fff4c583          	lbu	a1,-1(s1)
 4d2:	854a                	mv	a0,s2
 4d4:	00000097          	auipc	ra,0x0
 4d8:	f62080e7          	jalr	-158(ra) # 436 <putc>
  while(--i >= 0)
 4dc:	14fd                	add	s1,s1,-1
 4de:	ff3498e3          	bne	s1,s3,4ce <printint+0x76>
}
 4e2:	60a6                	ld	ra,72(sp)
 4e4:	6406                	ld	s0,64(sp)
 4e6:	74e2                	ld	s1,56(sp)
 4e8:	7942                	ld	s2,48(sp)
 4ea:	79a2                	ld	s3,40(sp)
 4ec:	6161                	add	sp,sp,80
 4ee:	8082                	ret
    x = -xx;
 4f0:	40b005b3          	neg	a1,a1
    neg = 1;
 4f4:	4885                	li	a7,1
    x = -xx;
 4f6:	bfad                	j	470 <printint+0x18>

00000000000004f8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f8:	711d                	add	sp,sp,-96
 4fa:	ec86                	sd	ra,88(sp)
 4fc:	e8a2                	sd	s0,80(sp)
 4fe:	e4a6                	sd	s1,72(sp)
 500:	e0ca                	sd	s2,64(sp)
 502:	fc4e                	sd	s3,56(sp)
 504:	f852                	sd	s4,48(sp)
 506:	f456                	sd	s5,40(sp)
 508:	f05a                	sd	s6,32(sp)
 50a:	ec5e                	sd	s7,24(sp)
 50c:	e862                	sd	s8,16(sp)
 50e:	e466                	sd	s9,8(sp)
 510:	e06a                	sd	s10,0(sp)
 512:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 514:	0005c903          	lbu	s2,0(a1)
 518:	2a090963          	beqz	s2,7ca <vprintf+0x2d2>
 51c:	8b2a                	mv	s6,a0
 51e:	8a2e                	mv	s4,a1
 520:	8bb2                	mv	s7,a2
  state = 0;
 522:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 524:	4481                	li	s1,0
 526:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 528:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 52c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 530:	06c00c93          	li	s9,108
 534:	a015                	j	558 <vprintf+0x60>
        putc(fd, c0);
 536:	85ca                	mv	a1,s2
 538:	855a                	mv	a0,s6
 53a:	00000097          	auipc	ra,0x0
 53e:	efc080e7          	jalr	-260(ra) # 436 <putc>
 542:	a019                	j	548 <vprintf+0x50>
    } else if(state == '%'){
 544:	03598263          	beq	s3,s5,568 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 548:	2485                	addw	s1,s1,1
 54a:	8726                	mv	a4,s1
 54c:	009a07b3          	add	a5,s4,s1
 550:	0007c903          	lbu	s2,0(a5)
 554:	26090b63          	beqz	s2,7ca <vprintf+0x2d2>
    c0 = fmt[i] & 0xff;
 558:	0009079b          	sext.w	a5,s2
    if(state == 0){
 55c:	fe0994e3          	bnez	s3,544 <vprintf+0x4c>
      if(c0 == '%'){
 560:	fd579be3          	bne	a5,s5,536 <vprintf+0x3e>
        state = '%';
 564:	89be                	mv	s3,a5
 566:	b7cd                	j	548 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 568:	cfc9                	beqz	a5,602 <vprintf+0x10a>
 56a:	00ea06b3          	add	a3,s4,a4
 56e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 572:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 574:	c681                	beqz	a3,57c <vprintf+0x84>
 576:	9752                	add	a4,a4,s4
 578:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 57c:	05878563          	beq	a5,s8,5c6 <vprintf+0xce>
      } else if(c0 == 'l' && c1 == 'd'){
 580:	07978163          	beq	a5,s9,5e2 <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 584:	07500713          	li	a4,117
 588:	10e78563          	beq	a5,a4,692 <vprintf+0x19a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 58c:	07800713          	li	a4,120
 590:	14e78d63          	beq	a5,a4,6ea <vprintf+0x1f2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 594:	07000713          	li	a4,112
 598:	18e78663          	beq	a5,a4,724 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 59c:	06300713          	li	a4,99
 5a0:	1ce78a63          	beq	a5,a4,774 <vprintf+0x27c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5a4:	07300713          	li	a4,115
 5a8:	1ee78263          	beq	a5,a4,78c <vprintf+0x294>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5ac:	02500713          	li	a4,37
 5b0:	04e79963          	bne	a5,a4,602 <vprintf+0x10a>
        putc(fd, '%');
 5b4:	02500593          	li	a1,37
 5b8:	855a                	mv	a0,s6
 5ba:	00000097          	auipc	ra,0x0
 5be:	e7c080e7          	jalr	-388(ra) # 436 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b751                	j	548 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 5c6:	008b8913          	add	s2,s7,8
 5ca:	4685                	li	a3,1
 5cc:	4629                	li	a2,10
 5ce:	000ba583          	lw	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	00000097          	auipc	ra,0x0
 5d8:	e84080e7          	jalr	-380(ra) # 458 <printint>
 5dc:	8bca                	mv	s7,s2
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	b7a5                	j	548 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 5e2:	06400793          	li	a5,100
 5e6:	02f68d63          	beq	a3,a5,620 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ea:	06c00793          	li	a5,108
 5ee:	04f68863          	beq	a3,a5,63e <vprintf+0x146>
      } else if(c0 == 'l' && c1 == 'u'){
 5f2:	07500793          	li	a5,117
 5f6:	0af68c63          	beq	a3,a5,6ae <vprintf+0x1b6>
      } else if(c0 == 'l' && c1 == 'x'){
 5fa:	07800793          	li	a5,120
 5fe:	10f68463          	beq	a3,a5,706 <vprintf+0x20e>
        putc(fd, '%');
 602:	02500593          	li	a1,37
 606:	855a                	mv	a0,s6
 608:	00000097          	auipc	ra,0x0
 60c:	e2e080e7          	jalr	-466(ra) # 436 <putc>
        putc(fd, c0);
 610:	85ca                	mv	a1,s2
 612:	855a                	mv	a0,s6
 614:	00000097          	auipc	ra,0x0
 618:	e22080e7          	jalr	-478(ra) # 436 <putc>
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b72d                	j	548 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 620:	008b8913          	add	s2,s7,8
 624:	4685                	li	a3,1
 626:	4629                	li	a2,10
 628:	000bb583          	ld	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	00000097          	auipc	ra,0x0
 632:	e2a080e7          	jalr	-470(ra) # 458 <printint>
        i += 1;
 636:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 638:	8bca                	mv	s7,s2
      state = 0;
 63a:	4981                	li	s3,0
        i += 1;
 63c:	b731                	j	548 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 63e:	06400793          	li	a5,100
 642:	02f60963          	beq	a2,a5,674 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 646:	07500793          	li	a5,117
 64a:	08f60163          	beq	a2,a5,6cc <vprintf+0x1d4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 64e:	07800793          	li	a5,120
 652:	faf618e3          	bne	a2,a5,602 <vprintf+0x10a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 656:	008b8913          	add	s2,s7,8
 65a:	4681                	li	a3,0
 65c:	4641                	li	a2,16
 65e:	000bb583          	ld	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	00000097          	auipc	ra,0x0
 668:	df4080e7          	jalr	-524(ra) # 458 <printint>
        i += 2;
 66c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
        i += 2;
 672:	bdd9                	j	548 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 674:	008b8913          	add	s2,s7,8
 678:	4685                	li	a3,1
 67a:	4629                	li	a2,10
 67c:	000bb583          	ld	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	00000097          	auipc	ra,0x0
 686:	dd6080e7          	jalr	-554(ra) # 458 <printint>
        i += 2;
 68a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 68c:	8bca                	mv	s7,s2
      state = 0;
 68e:	4981                	li	s3,0
        i += 2;
 690:	bd65                	j	548 <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 10, 0);
 692:	008b8913          	add	s2,s7,8
 696:	4681                	li	a3,0
 698:	4629                	li	a2,10
 69a:	000be583          	lwu	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	00000097          	auipc	ra,0x0
 6a4:	db8080e7          	jalr	-584(ra) # 458 <printint>
 6a8:	8bca                	mv	s7,s2
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bd71                	j	548 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ae:	008b8913          	add	s2,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4629                	li	a2,10
 6b6:	000bb583          	ld	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	00000097          	auipc	ra,0x0
 6c0:	d9c080e7          	jalr	-612(ra) # 458 <printint>
        i += 1;
 6c4:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c6:	8bca                	mv	s7,s2
      state = 0;
 6c8:	4981                	li	s3,0
        i += 1;
 6ca:	bdbd                	j	548 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6cc:	008b8913          	add	s2,s7,8
 6d0:	4681                	li	a3,0
 6d2:	4629                	li	a2,10
 6d4:	000bb583          	ld	a1,0(s7)
 6d8:	855a                	mv	a0,s6
 6da:	00000097          	auipc	ra,0x0
 6de:	d7e080e7          	jalr	-642(ra) # 458 <printint>
        i += 2;
 6e2:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e4:	8bca                	mv	s7,s2
      state = 0;
 6e6:	4981                	li	s3,0
        i += 2;
 6e8:	b585                	j	548 <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6ea:	008b8913          	add	s2,s7,8
 6ee:	4681                	li	a3,0
 6f0:	4641                	li	a2,16
 6f2:	000be583          	lwu	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	00000097          	auipc	ra,0x0
 6fc:	d60080e7          	jalr	-672(ra) # 458 <printint>
 700:	8bca                	mv	s7,s2
      state = 0;
 702:	4981                	li	s3,0
 704:	b591                	j	548 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 706:	008b8913          	add	s2,s7,8
 70a:	4681                	li	a3,0
 70c:	4641                	li	a2,16
 70e:	000bb583          	ld	a1,0(s7)
 712:	855a                	mv	a0,s6
 714:	00000097          	auipc	ra,0x0
 718:	d44080e7          	jalr	-700(ra) # 458 <printint>
        i += 1;
 71c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
        i += 1;
 722:	b51d                	j	548 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 724:	008b8d13          	add	s10,s7,8
 728:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 72c:	03000593          	li	a1,48
 730:	855a                	mv	a0,s6
 732:	00000097          	auipc	ra,0x0
 736:	d04080e7          	jalr	-764(ra) # 436 <putc>
  putc(fd, 'x');
 73a:	07800593          	li	a1,120
 73e:	855a                	mv	a0,s6
 740:	00000097          	auipc	ra,0x0
 744:	cf6080e7          	jalr	-778(ra) # 436 <putc>
 748:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74a:	00000b97          	auipc	s7,0x0
 74e:	28eb8b93          	add	s7,s7,654 # 9d8 <digits>
 752:	03c9d793          	srl	a5,s3,0x3c
 756:	97de                	add	a5,a5,s7
 758:	0007c583          	lbu	a1,0(a5)
 75c:	855a                	mv	a0,s6
 75e:	00000097          	auipc	ra,0x0
 762:	cd8080e7          	jalr	-808(ra) # 436 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 766:	0992                	sll	s3,s3,0x4
 768:	397d                	addw	s2,s2,-1
 76a:	fe0914e3          	bnez	s2,752 <vprintf+0x25a>
        printptr(fd, va_arg(ap, uint64));
 76e:	8bea                	mv	s7,s10
      state = 0;
 770:	4981                	li	s3,0
 772:	bbd9                	j	548 <vprintf+0x50>
        putc(fd, va_arg(ap, uint32));
 774:	008b8913          	add	s2,s7,8
 778:	000bc583          	lbu	a1,0(s7)
 77c:	855a                	mv	a0,s6
 77e:	00000097          	auipc	ra,0x0
 782:	cb8080e7          	jalr	-840(ra) # 436 <putc>
 786:	8bca                	mv	s7,s2
      state = 0;
 788:	4981                	li	s3,0
 78a:	bb7d                	j	548 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 78c:	008b8993          	add	s3,s7,8
 790:	000bb903          	ld	s2,0(s7)
 794:	02090163          	beqz	s2,7b6 <vprintf+0x2be>
        for(; *s; s++)
 798:	00094583          	lbu	a1,0(s2)
 79c:	c585                	beqz	a1,7c4 <vprintf+0x2cc>
          putc(fd, *s);
 79e:	855a                	mv	a0,s6
 7a0:	00000097          	auipc	ra,0x0
 7a4:	c96080e7          	jalr	-874(ra) # 436 <putc>
        for(; *s; s++)
 7a8:	0905                	add	s2,s2,1
 7aa:	00094583          	lbu	a1,0(s2)
 7ae:	f9e5                	bnez	a1,79e <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
 7b0:	8bce                	mv	s7,s3
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	bb51                	j	548 <vprintf+0x50>
          s = "(null)";
 7b6:	00000917          	auipc	s2,0x0
 7ba:	21a90913          	add	s2,s2,538 # 9d0 <malloc+0x104>
        for(; *s; s++)
 7be:	02800593          	li	a1,40
 7c2:	bff1                	j	79e <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
 7c4:	8bce                	mv	s7,s3
      state = 0;
 7c6:	4981                	li	s3,0
 7c8:	b341                	j	548 <vprintf+0x50>
    }
  }
}
 7ca:	60e6                	ld	ra,88(sp)
 7cc:	6446                	ld	s0,80(sp)
 7ce:	64a6                	ld	s1,72(sp)
 7d0:	6906                	ld	s2,64(sp)
 7d2:	79e2                	ld	s3,56(sp)
 7d4:	7a42                	ld	s4,48(sp)
 7d6:	7aa2                	ld	s5,40(sp)
 7d8:	7b02                	ld	s6,32(sp)
 7da:	6be2                	ld	s7,24(sp)
 7dc:	6c42                	ld	s8,16(sp)
 7de:	6ca2                	ld	s9,8(sp)
 7e0:	6d02                	ld	s10,0(sp)
 7e2:	6125                	add	sp,sp,96
 7e4:	8082                	ret

00000000000007e6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7e6:	715d                	add	sp,sp,-80
 7e8:	ec06                	sd	ra,24(sp)
 7ea:	e822                	sd	s0,16(sp)
 7ec:	1000                	add	s0,sp,32
 7ee:	e010                	sd	a2,0(s0)
 7f0:	e414                	sd	a3,8(s0)
 7f2:	e818                	sd	a4,16(s0)
 7f4:	ec1c                	sd	a5,24(s0)
 7f6:	03043023          	sd	a6,32(s0)
 7fa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7fe:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 802:	8622                	mv	a2,s0
 804:	00000097          	auipc	ra,0x0
 808:	cf4080e7          	jalr	-780(ra) # 4f8 <vprintf>
}
 80c:	60e2                	ld	ra,24(sp)
 80e:	6442                	ld	s0,16(sp)
 810:	6161                	add	sp,sp,80
 812:	8082                	ret

0000000000000814 <printf>:

void
printf(const char *fmt, ...)
{
 814:	711d                	add	sp,sp,-96
 816:	ec06                	sd	ra,24(sp)
 818:	e822                	sd	s0,16(sp)
 81a:	1000                	add	s0,sp,32
 81c:	e40c                	sd	a1,8(s0)
 81e:	e810                	sd	a2,16(s0)
 820:	ec14                	sd	a3,24(s0)
 822:	f018                	sd	a4,32(s0)
 824:	f41c                	sd	a5,40(s0)
 826:	03043823          	sd	a6,48(s0)
 82a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 82e:	00840613          	add	a2,s0,8
 832:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 836:	85aa                	mv	a1,a0
 838:	4505                	li	a0,1
 83a:	00000097          	auipc	ra,0x0
 83e:	cbe080e7          	jalr	-834(ra) # 4f8 <vprintf>
}
 842:	60e2                	ld	ra,24(sp)
 844:	6442                	ld	s0,16(sp)
 846:	6125                	add	sp,sp,96
 848:	8082                	ret

000000000000084a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84a:	1141                	add	sp,sp,-16
 84c:	e422                	sd	s0,8(sp)
 84e:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 850:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 854:	00000797          	auipc	a5,0x0
 858:	7ac7b783          	ld	a5,1964(a5) # 1000 <freep>
 85c:	a02d                	j	886 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 85e:	4618                	lw	a4,8(a2)
 860:	9f2d                	addw	a4,a4,a1
 862:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 866:	6398                	ld	a4,0(a5)
 868:	6310                	ld	a2,0(a4)
 86a:	a83d                	j	8a8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 86c:	ff852703          	lw	a4,-8(a0)
 870:	9f31                	addw	a4,a4,a2
 872:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 874:	ff053683          	ld	a3,-16(a0)
 878:	a091                	j	8bc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87a:	6398                	ld	a4,0(a5)
 87c:	00e7e463          	bltu	a5,a4,884 <free+0x3a>
 880:	00e6ea63          	bltu	a3,a4,894 <free+0x4a>
{
 884:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 886:	fed7fae3          	bgeu	a5,a3,87a <free+0x30>
 88a:	6398                	ld	a4,0(a5)
 88c:	00e6e463          	bltu	a3,a4,894 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 890:	fee7eae3          	bltu	a5,a4,884 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 894:	ff852583          	lw	a1,-8(a0)
 898:	6390                	ld	a2,0(a5)
 89a:	02059813          	sll	a6,a1,0x20
 89e:	01c85713          	srl	a4,a6,0x1c
 8a2:	9736                	add	a4,a4,a3
 8a4:	fae60de3          	beq	a2,a4,85e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8a8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ac:	4790                	lw	a2,8(a5)
 8ae:	02061593          	sll	a1,a2,0x20
 8b2:	01c5d713          	srl	a4,a1,0x1c
 8b6:	973e                	add	a4,a4,a5
 8b8:	fae68ae3          	beq	a3,a4,86c <free+0x22>
    p->s.ptr = bp->s.ptr;
 8bc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8be:	00000717          	auipc	a4,0x0
 8c2:	74f73123          	sd	a5,1858(a4) # 1000 <freep>
}
 8c6:	6422                	ld	s0,8(sp)
 8c8:	0141                	add	sp,sp,16
 8ca:	8082                	ret

00000000000008cc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8cc:	7139                	add	sp,sp,-64
 8ce:	fc06                	sd	ra,56(sp)
 8d0:	f822                	sd	s0,48(sp)
 8d2:	f426                	sd	s1,40(sp)
 8d4:	f04a                	sd	s2,32(sp)
 8d6:	ec4e                	sd	s3,24(sp)
 8d8:	e852                	sd	s4,16(sp)
 8da:	e456                	sd	s5,8(sp)
 8dc:	e05a                	sd	s6,0(sp)
 8de:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e0:	02051493          	sll	s1,a0,0x20
 8e4:	9081                	srl	s1,s1,0x20
 8e6:	04bd                	add	s1,s1,15
 8e8:	8091                	srl	s1,s1,0x4
 8ea:	0014899b          	addw	s3,s1,1
 8ee:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 8f0:	00000517          	auipc	a0,0x0
 8f4:	71053503          	ld	a0,1808(a0) # 1000 <freep>
 8f8:	c515                	beqz	a0,924 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fc:	4798                	lw	a4,8(a5)
 8fe:	02977f63          	bgeu	a4,s1,93c <malloc+0x70>
  if(nu < 4096)
 902:	8a4e                	mv	s4,s3
 904:	0009871b          	sext.w	a4,s3
 908:	6685                	lui	a3,0x1
 90a:	00d77363          	bgeu	a4,a3,910 <malloc+0x44>
 90e:	6a05                	lui	s4,0x1
 910:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 914:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 918:	00000917          	auipc	s2,0x0
 91c:	6e890913          	add	s2,s2,1768 # 1000 <freep>
  if(p == SBRK_ERROR)
 920:	5afd                	li	s5,-1
 922:	a895                	j	996 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 924:	00000797          	auipc	a5,0x0
 928:	6ec78793          	add	a5,a5,1772 # 1010 <base>
 92c:	00000717          	auipc	a4,0x0
 930:	6cf73a23          	sd	a5,1748(a4) # 1000 <freep>
 934:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 936:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 93a:	b7e1                	j	902 <malloc+0x36>
      if(p->s.size == nunits)
 93c:	02e48c63          	beq	s1,a4,974 <malloc+0xa8>
        p->s.size -= nunits;
 940:	4137073b          	subw	a4,a4,s3
 944:	c798                	sw	a4,8(a5)
        p += p->s.size;
 946:	02071693          	sll	a3,a4,0x20
 94a:	01c6d713          	srl	a4,a3,0x1c
 94e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 950:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 954:	00000717          	auipc	a4,0x0
 958:	6aa73623          	sd	a0,1708(a4) # 1000 <freep>
      return (void*)(p + 1);
 95c:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 960:	70e2                	ld	ra,56(sp)
 962:	7442                	ld	s0,48(sp)
 964:	74a2                	ld	s1,40(sp)
 966:	7902                	ld	s2,32(sp)
 968:	69e2                	ld	s3,24(sp)
 96a:	6a42                	ld	s4,16(sp)
 96c:	6aa2                	ld	s5,8(sp)
 96e:	6b02                	ld	s6,0(sp)
 970:	6121                	add	sp,sp,64
 972:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 974:	6398                	ld	a4,0(a5)
 976:	e118                	sd	a4,0(a0)
 978:	bff1                	j	954 <malloc+0x88>
  hp->s.size = nu;
 97a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 97e:	0541                	add	a0,a0,16
 980:	00000097          	auipc	ra,0x0
 984:	eca080e7          	jalr	-310(ra) # 84a <free>
  return freep;
 988:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 98c:	d971                	beqz	a0,960 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 990:	4798                	lw	a4,8(a5)
 992:	fa9775e3          	bgeu	a4,s1,93c <malloc+0x70>
    if(p == freep)
 996:	00093703          	ld	a4,0(s2)
 99a:	853e                	mv	a0,a5
 99c:	fef719e3          	bne	a4,a5,98e <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9a0:	8552                	mv	a0,s4
 9a2:	00000097          	auipc	ra,0x0
 9a6:	938080e7          	jalr	-1736(ra) # 2da <sbrk>
  if(p == SBRK_ERROR)
 9aa:	fd5518e3          	bne	a0,s5,97a <malloc+0xae>
        return 0;
 9ae:	4501                	li	a0,0
 9b0:	bf45                	j	960 <malloc+0x94>
