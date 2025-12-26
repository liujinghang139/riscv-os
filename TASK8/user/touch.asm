
user/_touch:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
  return 0;
}

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
  if(argc < 2){
  12:	4785                	li	a5,1
  14:	04a7d763          	bge	a5,a0,62 <main+0x62>
  18:	00858493          	add	s1,a1,8
  1c:	ffe5091b          	addw	s2,a0,-2
  20:	02091793          	sll	a5,s2,0x20
  24:	01d7d913          	srl	s2,a5,0x1d
  28:	05c1                	add	a1,a1,16
  2a:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: touch files...\n");
    exit(1);
  }

  int status = 0;
  2c:	4981                	li	s3,0
  for(int i = 1; i < argc; i++){
    if(create_file(argv[i]) < 0){
      fprintf(2, "touch: %s failed\n", argv[i]);
  2e:	00001a97          	auipc	s5,0x1
  32:	98aa8a93          	add	s5,s5,-1654 # 9b8 <malloc+0x100>
      status = 1;
  36:	4a05                	li	s4,1
  int fd = open(path, O_CREATE | O_WRONLY);
  38:	20100593          	li	a1,513
  3c:	6088                	ld	a0,0(s1)
  3e:	00000097          	auipc	ra,0x0
  42:	384080e7          	jalr	900(ra) # 3c2 <open>
  if(fd < 0)
  46:	02054c63          	bltz	a0,7e <main+0x7e>
  close(fd);
  4a:	00000097          	auipc	ra,0x0
  4e:	370080e7          	jalr	880(ra) # 3ba <close>
  for(int i = 1; i < argc; i++){
  52:	04a1                	add	s1,s1,8
  54:	ff2492e3          	bne	s1,s2,38 <main+0x38>
    }
  }

  exit(status);
  58:	854e                	mv	a0,s3
  5a:	00000097          	auipc	ra,0x0
  5e:	348080e7          	jalr	840(ra) # 3a2 <exit>
    fprintf(2, "Usage: touch files...\n");
  62:	00001597          	auipc	a1,0x1
  66:	93e58593          	add	a1,a1,-1730 # 9a0 <malloc+0xe8>
  6a:	4509                	li	a0,2
  6c:	00000097          	auipc	ra,0x0
  70:	766080e7          	jalr	1894(ra) # 7d2 <fprintf>
    exit(1);
  74:	4505                	li	a0,1
  76:	00000097          	auipc	ra,0x0
  7a:	32c080e7          	jalr	812(ra) # 3a2 <exit>
      fprintf(2, "touch: %s failed\n", argv[i]);
  7e:	6090                	ld	a2,0(s1)
  80:	85d6                	mv	a1,s5
  82:	4509                	li	a0,2
  84:	00000097          	auipc	ra,0x0
  88:	74e080e7          	jalr	1870(ra) # 7d2 <fprintf>
      status = 1;
  8c:	89d2                	mv	s3,s4
  8e:	b7d1                	j	52 <main+0x52>

0000000000000090 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  90:	1141                	add	sp,sp,-16
  92:	e406                	sd	ra,8(sp)
  94:	e022                	sd	s0,0(sp)
  96:	0800                	add	s0,sp,16
  int r;
  extern int main();
  r = main();
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <main>
  exit(r);
  a0:	00000097          	auipc	ra,0x0
  a4:	302080e7          	jalr	770(ra) # 3a2 <exit>

00000000000000a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a8:	1141                	add	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ae:	87aa                	mv	a5,a0
  b0:	0585                	add	a1,a1,1
  b2:	0785                	add	a5,a5,1
  b4:	fff5c703          	lbu	a4,-1(a1)
  b8:	fee78fa3          	sb	a4,-1(a5)
  bc:	fb75                	bnez	a4,b0 <strcpy+0x8>
    ;
  return os;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	add	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c4:	1141                	add	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb91                	beqz	a5,e2 <strcmp+0x1e>
  d0:	0005c703          	lbu	a4,0(a1)
  d4:	00f71763          	bne	a4,a5,e2 <strcmp+0x1e>
    p++, q++;
  d8:	0505                	add	a0,a0,1
  da:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	fbe5                	bnez	a5,d0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  e2:	0005c503          	lbu	a0,0(a1)
}
  e6:	40a7853b          	subw	a0,a5,a0
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	add	sp,sp,16
  ee:	8082                	ret

00000000000000f0 <strlen>:

uint
strlen(const char *s)
{
  f0:	1141                	add	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cf91                	beqz	a5,116 <strlen+0x26>
  fc:	0505                	add	a0,a0,1
  fe:	87aa                	mv	a5,a0
 100:	86be                	mv	a3,a5
 102:	0785                	add	a5,a5,1
 104:	fff7c703          	lbu	a4,-1(a5)
 108:	ff65                	bnez	a4,100 <strlen+0x10>
 10a:	40a6853b          	subw	a0,a3,a0
 10e:	2505                	addw	a0,a0,1
    ;
  return n;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	add	sp,sp,16
 114:	8082                	ret
  for(n = 0; s[n]; n++)
 116:	4501                	li	a0,0
 118:	bfe5                	j	110 <strlen+0x20>

000000000000011a <memset>:

void*
memset(void *dst, int c, uint n)
{
 11a:	1141                	add	sp,sp,-16
 11c:	e422                	sd	s0,8(sp)
 11e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 120:	ca19                	beqz	a2,136 <memset+0x1c>
 122:	87aa                	mv	a5,a0
 124:	1602                	sll	a2,a2,0x20
 126:	9201                	srl	a2,a2,0x20
 128:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 12c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 130:	0785                	add	a5,a5,1
 132:	fee79de3          	bne	a5,a4,12c <memset+0x12>
  }
  return dst;
}
 136:	6422                	ld	s0,8(sp)
 138:	0141                	add	sp,sp,16
 13a:	8082                	ret

000000000000013c <strchr>:

char*
strchr(const char *s, char c)
{
 13c:	1141                	add	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	add	s0,sp,16
  for(; *s; s++)
 142:	00054783          	lbu	a5,0(a0)
 146:	cb99                	beqz	a5,15c <strchr+0x20>
    if(*s == c)
 148:	00f58763          	beq	a1,a5,156 <strchr+0x1a>
  for(; *s; s++)
 14c:	0505                	add	a0,a0,1
 14e:	00054783          	lbu	a5,0(a0)
 152:	fbfd                	bnez	a5,148 <strchr+0xc>
      return (char*)s;
  return 0;
 154:	4501                	li	a0,0
}
 156:	6422                	ld	s0,8(sp)
 158:	0141                	add	sp,sp,16
 15a:	8082                	ret
  return 0;
 15c:	4501                	li	a0,0
 15e:	bfe5                	j	156 <strchr+0x1a>

0000000000000160 <gets>:

char*
gets(char *buf, int max)
{
 160:	711d                	add	sp,sp,-96
 162:	ec86                	sd	ra,88(sp)
 164:	e8a2                	sd	s0,80(sp)
 166:	e4a6                	sd	s1,72(sp)
 168:	e0ca                	sd	s2,64(sp)
 16a:	fc4e                	sd	s3,56(sp)
 16c:	f852                	sd	s4,48(sp)
 16e:	f456                	sd	s5,40(sp)
 170:	f05a                	sd	s6,32(sp)
 172:	ec5e                	sd	s7,24(sp)
 174:	1080                	add	s0,sp,96
 176:	8baa                	mv	s7,a0
 178:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17a:	892a                	mv	s2,a0
 17c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 17e:	4aa9                	li	s5,10
 180:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 182:	89a6                	mv	s3,s1
 184:	2485                	addw	s1,s1,1
 186:	0344d863          	bge	s1,s4,1b6 <gets+0x56>
    cc = read(0, &c, 1);
 18a:	4605                	li	a2,1
 18c:	faf40593          	add	a1,s0,-81
 190:	4501                	li	a0,0
 192:	00000097          	auipc	ra,0x0
 196:	240080e7          	jalr	576(ra) # 3d2 <read>
    if(cc < 1)
 19a:	00a05e63          	blez	a0,1b6 <gets+0x56>
    buf[i++] = c;
 19e:	faf44783          	lbu	a5,-81(s0)
 1a2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a6:	01578763          	beq	a5,s5,1b4 <gets+0x54>
 1aa:	0905                	add	s2,s2,1
 1ac:	fd679be3          	bne	a5,s6,182 <gets+0x22>
  for(i=0; i+1 < max; ){
 1b0:	89a6                	mv	s3,s1
 1b2:	a011                	j	1b6 <gets+0x56>
 1b4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1b6:	99de                	add	s3,s3,s7
 1b8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1bc:	855e                	mv	a0,s7
 1be:	60e6                	ld	ra,88(sp)
 1c0:	6446                	ld	s0,80(sp)
 1c2:	64a6                	ld	s1,72(sp)
 1c4:	6906                	ld	s2,64(sp)
 1c6:	79e2                	ld	s3,56(sp)
 1c8:	7a42                	ld	s4,48(sp)
 1ca:	7aa2                	ld	s5,40(sp)
 1cc:	7b02                	ld	s6,32(sp)
 1ce:	6be2                	ld	s7,24(sp)
 1d0:	6125                	add	sp,sp,96
 1d2:	8082                	ret

00000000000001d4 <atoi>:
//   return r;
// }

int
atoi(const char *s)
{
 1d4:	1141                	add	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1da:	00054683          	lbu	a3,0(a0)
 1de:	fd06879b          	addw	a5,a3,-48
 1e2:	0ff7f793          	zext.b	a5,a5
 1e6:	4625                	li	a2,9
 1e8:	02f66863          	bltu	a2,a5,218 <atoi+0x44>
 1ec:	872a                	mv	a4,a0
  n = 0;
 1ee:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f0:	0705                	add	a4,a4,1
 1f2:	0025179b          	sllw	a5,a0,0x2
 1f6:	9fa9                	addw	a5,a5,a0
 1f8:	0017979b          	sllw	a5,a5,0x1
 1fc:	9fb5                	addw	a5,a5,a3
 1fe:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 202:	00074683          	lbu	a3,0(a4)
 206:	fd06879b          	addw	a5,a3,-48
 20a:	0ff7f793          	zext.b	a5,a5
 20e:	fef671e3          	bgeu	a2,a5,1f0 <atoi+0x1c>
  return n;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	add	sp,sp,16
 216:	8082                	ret
  n = 0;
 218:	4501                	li	a0,0
 21a:	bfe5                	j	212 <atoi+0x3e>

000000000000021c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21c:	1141                	add	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 222:	02b57463          	bgeu	a0,a1,24a <memmove+0x2e>
    while(n-- > 0)
 226:	00c05f63          	blez	a2,244 <memmove+0x28>
 22a:	1602                	sll	a2,a2,0x20
 22c:	9201                	srl	a2,a2,0x20
 22e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 232:	872a                	mv	a4,a0
      *dst++ = *src++;
 234:	0585                	add	a1,a1,1
 236:	0705                	add	a4,a4,1
 238:	fff5c683          	lbu	a3,-1(a1)
 23c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 240:	fee79ae3          	bne	a5,a4,234 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	add	sp,sp,16
 248:	8082                	ret
    dst += n;
 24a:	00c50733          	add	a4,a0,a2
    src += n;
 24e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 250:	fec05ae3          	blez	a2,244 <memmove+0x28>
 254:	fff6079b          	addw	a5,a2,-1
 258:	1782                	sll	a5,a5,0x20
 25a:	9381                	srl	a5,a5,0x20
 25c:	fff7c793          	not	a5,a5
 260:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 262:	15fd                	add	a1,a1,-1
 264:	177d                	add	a4,a4,-1
 266:	0005c683          	lbu	a3,0(a1)
 26a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 26e:	fee79ae3          	bne	a5,a4,262 <memmove+0x46>
 272:	bfc9                	j	244 <memmove+0x28>

0000000000000274 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 274:	1141                	add	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 27a:	ca05                	beqz	a2,2aa <memcmp+0x36>
 27c:	fff6069b          	addw	a3,a2,-1
 280:	1682                	sll	a3,a3,0x20
 282:	9281                	srl	a3,a3,0x20
 284:	0685                	add	a3,a3,1
 286:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 288:	00054783          	lbu	a5,0(a0)
 28c:	0005c703          	lbu	a4,0(a1)
 290:	00e79863          	bne	a5,a4,2a0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 294:	0505                	add	a0,a0,1
    p2++;
 296:	0585                	add	a1,a1,1
  while (n-- > 0) {
 298:	fed518e3          	bne	a0,a3,288 <memcmp+0x14>
  }
  return 0;
 29c:	4501                	li	a0,0
 29e:	a019                	j	2a4 <memcmp+0x30>
      return *p1 - *p2;
 2a0:	40e7853b          	subw	a0,a5,a4
}
 2a4:	6422                	ld	s0,8(sp)
 2a6:	0141                	add	sp,sp,16
 2a8:	8082                	ret
  return 0;
 2aa:	4501                	li	a0,0
 2ac:	bfe5                	j	2a4 <memcmp+0x30>

00000000000002ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ae:	1141                	add	sp,sp,-16
 2b0:	e406                	sd	ra,8(sp)
 2b2:	e022                	sd	s0,0(sp)
 2b4:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2b6:	00000097          	auipc	ra,0x0
 2ba:	f66080e7          	jalr	-154(ra) # 21c <memmove>
}
 2be:	60a2                	ld	ra,8(sp)
 2c0:	6402                	ld	s0,0(sp)
 2c2:	0141                	add	sp,sp,16
 2c4:	8082                	ret

00000000000002c6 <sbrk>:

char *
sbrk(int n) {
 2c6:	1141                	add	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2ce:	4585                	li	a1,1
 2d0:	00000097          	auipc	ra,0x0
 2d4:	12a080e7          	jalr	298(ra) # 3fa <sys_sbrk>
}
 2d8:	60a2                	ld	ra,8(sp)
 2da:	6402                	ld	s0,0(sp)
 2dc:	0141                	add	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <get_time>:
//   return sys_sbrk(n, SBRK_LAZY);
// }


unsigned int 
get_time(void) {
 2e0:	1141                	add	sp,sp,-16
 2e2:	e406                	sd	ra,8(sp)
 2e4:	e022                	sd	s0,0(sp)
 2e6:	0800                	add	s0,sp,16
    return uptime();
 2e8:	00000097          	auipc	ra,0x0
 2ec:	11a080e7          	jalr	282(ra) # 402 <uptime>
}
 2f0:	2501                	sext.w	a0,a0
 2f2:	60a2                	ld	ra,8(sp)
 2f4:	6402                	ld	s0,0(sp)
 2f6:	0141                	add	sp,sp,16
 2f8:	8082                	ret

00000000000002fa <make_filename>:
void 
make_filename(char *buf, const char *prefix, int num) {
    // 复制前缀
    char *p = buf;
    const char *s = prefix;
    while(*s) *p++ = *s++;
 2fa:	0005c783          	lbu	a5,0(a1)
 2fe:	cb81                	beqz	a5,30e <make_filename+0x14>
 300:	0585                	add	a1,a1,1
 302:	0505                	add	a0,a0,1
 304:	fef50fa3          	sb	a5,-1(a0)
 308:	0005c783          	lbu	a5,0(a1)
 30c:	fbf5                	bnez	a5,300 <make_filename+0x6>
    
    // 处理数字部分
    if (num == 0) {
 30e:	ca3d                	beqz	a2,384 <make_filename+0x8a>
make_filename(char *buf, const char *prefix, int num) {
 310:	1101                	add	sp,sp,-32
 312:	ec22                	sd	s0,24(sp)
 314:	1000                	add	s0,sp,32
        *p++ = '0';
    } else {
        // 临时缓冲区存放数字
        char digits[16];
        int i = 0;
        while(num > 0) {
 316:	fe040893          	add	a7,s0,-32
 31a:	87c6                	mv	a5,a7
            digits[i++] = (num % 10) + '0';
 31c:	46a9                	li	a3,10
        while(num > 0) {
 31e:	4825                	li	a6,9
 320:	06c05063          	blez	a2,380 <make_filename+0x86>
            digits[i++] = (num % 10) + '0';
 324:	02d6673b          	remw	a4,a2,a3
 328:	0307071b          	addw	a4,a4,48
 32c:	00e78023          	sb	a4,0(a5)
            num /= 10;
 330:	85b2                	mv	a1,a2
 332:	02d6463b          	divw	a2,a2,a3
        while(num > 0) {
 336:	873e                	mv	a4,a5
 338:	0785                	add	a5,a5,1
 33a:	feb845e3          	blt	a6,a1,324 <make_filename+0x2a>
 33e:	4117073b          	subw	a4,a4,a7
 342:	0017069b          	addw	a3,a4,1
            digits[i++] = (num % 10) + '0';
 346:	0006879b          	sext.w	a5,a3
        }
        // 倒序写入
        while(i > 0) *p++ = digits[--i];
 34a:	04f05663          	blez	a5,396 <make_filename+0x9c>
 34e:	fe040713          	add	a4,s0,-32
 352:	973e                	add	a4,a4,a5
 354:	02069593          	sll	a1,a3,0x20
 358:	9181                	srl	a1,a1,0x20
 35a:	95aa                	add	a1,a1,a0
 35c:	87aa                	mv	a5,a0
 35e:	0785                	add	a5,a5,1
 360:	fff74603          	lbu	a2,-1(a4)
 364:	fec78fa3          	sb	a2,-1(a5)
 368:	177d                	add	a4,a4,-1
 36a:	feb79ae3          	bne	a5,a1,35e <make_filename+0x64>
 36e:	02069793          	sll	a5,a3,0x20
 372:	9381                	srl	a5,a5,0x20
 374:	97aa                	add	a5,a5,a0
    }
    *p = 0; // 字符串结束符
 376:	00078023          	sb	zero,0(a5)
 37a:	6462                	ld	s0,24(sp)
 37c:	6105                	add	sp,sp,32
 37e:	8082                	ret
        while(num > 0) {
 380:	87aa                	mv	a5,a0
 382:	bfd5                	j	376 <make_filename+0x7c>
        *p++ = '0';
 384:	00150793          	add	a5,a0,1
 388:	03000713          	li	a4,48
 38c:	00e50023          	sb	a4,0(a0)
    *p = 0; // 字符串结束符
 390:	00078023          	sb	zero,0(a5)
 394:	8082                	ret
        while(i > 0) *p++ = digits[--i];
 396:	87aa                	mv	a5,a0
 398:	bff9                	j	376 <make_filename+0x7c>

000000000000039a <fork>:
.globl unlink
# generated by usys.pl - do not edit
#include "../kernel/sys/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 39a:	4885                	li	a7,1
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a2:	4889                	li	a7,2
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <wait>:
.global wait
wait:
 li a7, SYS_wait
 3aa:	488d                	li	a7,3
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b2:	4891                	li	a7,4
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <close>:
.global close
close:
 li a7, SYS_close
 3ba:	4899                	li	a7,6
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <open>:
.global open
open:
 li a7, SYS_open
 3c2:	489d                	li	a7,7
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ca:	4895                	li	a7,5
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <read>:
.global read
read:
 li a7, SYS_read
 3d2:	48a1                	li	a7,8
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <write>:
.global write
write:
 li a7, SYS_write
 3da:	48a5                	li	a7,9
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3e2:	48a9                	li	a7,10
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <makenode>:
.global makenode
makenode:
 li a7, SYS_makenode
 3ea:	48ad                	li	a7,11
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <duplicate>:
.global duplicate
duplicate:
 li a7, SYS_duplicate
 3f2:	48b1                	li	a7,12
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3fa:	48b5                	li	a7,13
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 402:	48b9                	li	a7,14
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 40a:	48bd                	li	a7,15
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 412:	48c1                	li	a7,16
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <crash_arm>:
.global crash_arm
crash_arm:
 li a7, SYS_crash_arm
 41a:	48c5                	li	a7,17
 ecall
 41c:	00000073          	ecall
 420:	8082                	ret

0000000000000422 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 422:	1101                	add	sp,sp,-32
 424:	ec06                	sd	ra,24(sp)
 426:	e822                	sd	s0,16(sp)
 428:	1000                	add	s0,sp,32
 42a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 42e:	4605                	li	a2,1
 430:	fef40593          	add	a1,s0,-17
 434:	00000097          	auipc	ra,0x0
 438:	fa6080e7          	jalr	-90(ra) # 3da <write>
}
 43c:	60e2                	ld	ra,24(sp)
 43e:	6442                	ld	s0,16(sp)
 440:	6105                	add	sp,sp,32
 442:	8082                	ret

0000000000000444 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 444:	715d                	add	sp,sp,-80
 446:	e486                	sd	ra,72(sp)
 448:	e0a2                	sd	s0,64(sp)
 44a:	fc26                	sd	s1,56(sp)
 44c:	f84a                	sd	s2,48(sp)
 44e:	f44e                	sd	s3,40(sp)
 450:	0880                	add	s0,sp,80
 452:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 454:	c299                	beqz	a3,45a <printint+0x16>
 456:	0805c363          	bltz	a1,4dc <printint+0x98>
  neg = 0;
 45a:	4881                	li	a7,0
 45c:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 460:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 462:	00000517          	auipc	a0,0x0
 466:	57650513          	add	a0,a0,1398 # 9d8 <digits>
 46a:	883e                	mv	a6,a5
 46c:	2785                	addw	a5,a5,1
 46e:	02c5f733          	remu	a4,a1,a2
 472:	972a                	add	a4,a4,a0
 474:	00074703          	lbu	a4,0(a4)
 478:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 47c:	872e                	mv	a4,a1
 47e:	02c5d5b3          	divu	a1,a1,a2
 482:	0685                	add	a3,a3,1
 484:	fec773e3          	bgeu	a4,a2,46a <printint+0x26>
  if(neg)
 488:	00088b63          	beqz	a7,49e <printint+0x5a>
    buf[i++] = '-';
 48c:	fd078793          	add	a5,a5,-48
 490:	97a2                	add	a5,a5,s0
 492:	02d00713          	li	a4,45
 496:	fee78423          	sb	a4,-24(a5)
 49a:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 49e:	02f05863          	blez	a5,4ce <printint+0x8a>
 4a2:	fb840713          	add	a4,s0,-72
 4a6:	00f704b3          	add	s1,a4,a5
 4aa:	fff70993          	add	s3,a4,-1
 4ae:	99be                	add	s3,s3,a5
 4b0:	37fd                	addw	a5,a5,-1
 4b2:	1782                	sll	a5,a5,0x20
 4b4:	9381                	srl	a5,a5,0x20
 4b6:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4ba:	fff4c583          	lbu	a1,-1(s1)
 4be:	854a                	mv	a0,s2
 4c0:	00000097          	auipc	ra,0x0
 4c4:	f62080e7          	jalr	-158(ra) # 422 <putc>
  while(--i >= 0)
 4c8:	14fd                	add	s1,s1,-1
 4ca:	ff3498e3          	bne	s1,s3,4ba <printint+0x76>
}
 4ce:	60a6                	ld	ra,72(sp)
 4d0:	6406                	ld	s0,64(sp)
 4d2:	74e2                	ld	s1,56(sp)
 4d4:	7942                	ld	s2,48(sp)
 4d6:	79a2                	ld	s3,40(sp)
 4d8:	6161                	add	sp,sp,80
 4da:	8082                	ret
    x = -xx;
 4dc:	40b005b3          	neg	a1,a1
    neg = 1;
 4e0:	4885                	li	a7,1
    x = -xx;
 4e2:	bfad                	j	45c <printint+0x18>

00000000000004e4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e4:	711d                	add	sp,sp,-96
 4e6:	ec86                	sd	ra,88(sp)
 4e8:	e8a2                	sd	s0,80(sp)
 4ea:	e4a6                	sd	s1,72(sp)
 4ec:	e0ca                	sd	s2,64(sp)
 4ee:	fc4e                	sd	s3,56(sp)
 4f0:	f852                	sd	s4,48(sp)
 4f2:	f456                	sd	s5,40(sp)
 4f4:	f05a                	sd	s6,32(sp)
 4f6:	ec5e                	sd	s7,24(sp)
 4f8:	e862                	sd	s8,16(sp)
 4fa:	e466                	sd	s9,8(sp)
 4fc:	e06a                	sd	s10,0(sp)
 4fe:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 500:	0005c903          	lbu	s2,0(a1)
 504:	2a090963          	beqz	s2,7b6 <vprintf+0x2d2>
 508:	8b2a                	mv	s6,a0
 50a:	8a2e                	mv	s4,a1
 50c:	8bb2                	mv	s7,a2
  state = 0;
 50e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 510:	4481                	li	s1,0
 512:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 514:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 518:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 51c:	06c00c93          	li	s9,108
 520:	a015                	j	544 <vprintf+0x60>
        putc(fd, c0);
 522:	85ca                	mv	a1,s2
 524:	855a                	mv	a0,s6
 526:	00000097          	auipc	ra,0x0
 52a:	efc080e7          	jalr	-260(ra) # 422 <putc>
 52e:	a019                	j	534 <vprintf+0x50>
    } else if(state == '%'){
 530:	03598263          	beq	s3,s5,554 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 534:	2485                	addw	s1,s1,1
 536:	8726                	mv	a4,s1
 538:	009a07b3          	add	a5,s4,s1
 53c:	0007c903          	lbu	s2,0(a5)
 540:	26090b63          	beqz	s2,7b6 <vprintf+0x2d2>
    c0 = fmt[i] & 0xff;
 544:	0009079b          	sext.w	a5,s2
    if(state == 0){
 548:	fe0994e3          	bnez	s3,530 <vprintf+0x4c>
      if(c0 == '%'){
 54c:	fd579be3          	bne	a5,s5,522 <vprintf+0x3e>
        state = '%';
 550:	89be                	mv	s3,a5
 552:	b7cd                	j	534 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 554:	cfc9                	beqz	a5,5ee <vprintf+0x10a>
 556:	00ea06b3          	add	a3,s4,a4
 55a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 55e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 560:	c681                	beqz	a3,568 <vprintf+0x84>
 562:	9752                	add	a4,a4,s4
 564:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 568:	05878563          	beq	a5,s8,5b2 <vprintf+0xce>
      } else if(c0 == 'l' && c1 == 'd'){
 56c:	07978163          	beq	a5,s9,5ce <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 570:	07500713          	li	a4,117
 574:	10e78563          	beq	a5,a4,67e <vprintf+0x19a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 578:	07800713          	li	a4,120
 57c:	14e78d63          	beq	a5,a4,6d6 <vprintf+0x1f2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 580:	07000713          	li	a4,112
 584:	18e78663          	beq	a5,a4,710 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 588:	06300713          	li	a4,99
 58c:	1ce78a63          	beq	a5,a4,760 <vprintf+0x27c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 590:	07300713          	li	a4,115
 594:	1ee78263          	beq	a5,a4,778 <vprintf+0x294>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 598:	02500713          	li	a4,37
 59c:	04e79963          	bne	a5,a4,5ee <vprintf+0x10a>
        putc(fd, '%');
 5a0:	02500593          	li	a1,37
 5a4:	855a                	mv	a0,s6
 5a6:	00000097          	auipc	ra,0x0
 5aa:	e7c080e7          	jalr	-388(ra) # 422 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b751                	j	534 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 5b2:	008b8913          	add	s2,s7,8
 5b6:	4685                	li	a3,1
 5b8:	4629                	li	a2,10
 5ba:	000ba583          	lw	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	00000097          	auipc	ra,0x0
 5c4:	e84080e7          	jalr	-380(ra) # 444 <printint>
 5c8:	8bca                	mv	s7,s2
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b7a5                	j	534 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 5ce:	06400793          	li	a5,100
 5d2:	02f68d63          	beq	a3,a5,60c <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d6:	06c00793          	li	a5,108
 5da:	04f68863          	beq	a3,a5,62a <vprintf+0x146>
      } else if(c0 == 'l' && c1 == 'u'){
 5de:	07500793          	li	a5,117
 5e2:	0af68c63          	beq	a3,a5,69a <vprintf+0x1b6>
      } else if(c0 == 'l' && c1 == 'x'){
 5e6:	07800793          	li	a5,120
 5ea:	10f68463          	beq	a3,a5,6f2 <vprintf+0x20e>
        putc(fd, '%');
 5ee:	02500593          	li	a1,37
 5f2:	855a                	mv	a0,s6
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e2e080e7          	jalr	-466(ra) # 422 <putc>
        putc(fd, c0);
 5fc:	85ca                	mv	a1,s2
 5fe:	855a                	mv	a0,s6
 600:	00000097          	auipc	ra,0x0
 604:	e22080e7          	jalr	-478(ra) # 422 <putc>
      state = 0;
 608:	4981                	li	s3,0
 60a:	b72d                	j	534 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	008b8913          	add	s2,s7,8
 610:	4685                	li	a3,1
 612:	4629                	li	a2,10
 614:	000bb583          	ld	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	00000097          	auipc	ra,0x0
 61e:	e2a080e7          	jalr	-470(ra) # 444 <printint>
        i += 1;
 622:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
        i += 1;
 628:	b731                	j	534 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 62a:	06400793          	li	a5,100
 62e:	02f60963          	beq	a2,a5,660 <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 632:	07500793          	li	a5,117
 636:	08f60163          	beq	a2,a5,6b8 <vprintf+0x1d4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 63a:	07800793          	li	a5,120
 63e:	faf618e3          	bne	a2,a5,5ee <vprintf+0x10a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 642:	008b8913          	add	s2,s7,8
 646:	4681                	li	a3,0
 648:	4641                	li	a2,16
 64a:	000bb583          	ld	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	00000097          	auipc	ra,0x0
 654:	df4080e7          	jalr	-524(ra) # 444 <printint>
        i += 2;
 658:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 65a:	8bca                	mv	s7,s2
      state = 0;
 65c:	4981                	li	s3,0
        i += 2;
 65e:	bdd9                	j	534 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 660:	008b8913          	add	s2,s7,8
 664:	4685                	li	a3,1
 666:	4629                	li	a2,10
 668:	000bb583          	ld	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	00000097          	auipc	ra,0x0
 672:	dd6080e7          	jalr	-554(ra) # 444 <printint>
        i += 2;
 676:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 678:	8bca                	mv	s7,s2
      state = 0;
 67a:	4981                	li	s3,0
        i += 2;
 67c:	bd65                	j	534 <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 10, 0);
 67e:	008b8913          	add	s2,s7,8
 682:	4681                	li	a3,0
 684:	4629                	li	a2,10
 686:	000be583          	lwu	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	00000097          	auipc	ra,0x0
 690:	db8080e7          	jalr	-584(ra) # 444 <printint>
 694:	8bca                	mv	s7,s2
      state = 0;
 696:	4981                	li	s3,0
 698:	bd71                	j	534 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69a:	008b8913          	add	s2,s7,8
 69e:	4681                	li	a3,0
 6a0:	4629                	li	a2,10
 6a2:	000bb583          	ld	a1,0(s7)
 6a6:	855a                	mv	a0,s6
 6a8:	00000097          	auipc	ra,0x0
 6ac:	d9c080e7          	jalr	-612(ra) # 444 <printint>
        i += 1;
 6b0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b2:	8bca                	mv	s7,s2
      state = 0;
 6b4:	4981                	li	s3,0
        i += 1;
 6b6:	bdbd                	j	534 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b8:	008b8913          	add	s2,s7,8
 6bc:	4681                	li	a3,0
 6be:	4629                	li	a2,10
 6c0:	000bb583          	ld	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	00000097          	auipc	ra,0x0
 6ca:	d7e080e7          	jalr	-642(ra) # 444 <printint>
        i += 2;
 6ce:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d0:	8bca                	mv	s7,s2
      state = 0;
 6d2:	4981                	li	s3,0
        i += 2;
 6d4:	b585                	j	534 <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6d6:	008b8913          	add	s2,s7,8
 6da:	4681                	li	a3,0
 6dc:	4641                	li	a2,16
 6de:	000be583          	lwu	a1,0(s7)
 6e2:	855a                	mv	a0,s6
 6e4:	00000097          	auipc	ra,0x0
 6e8:	d60080e7          	jalr	-672(ra) # 444 <printint>
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b591                	j	534 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f2:	008b8913          	add	s2,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4641                	li	a2,16
 6fa:	000bb583          	ld	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	00000097          	auipc	ra,0x0
 704:	d44080e7          	jalr	-700(ra) # 444 <printint>
        i += 1;
 708:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 70a:	8bca                	mv	s7,s2
      state = 0;
 70c:	4981                	li	s3,0
        i += 1;
 70e:	b51d                	j	534 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 710:	008b8d13          	add	s10,s7,8
 714:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 718:	03000593          	li	a1,48
 71c:	855a                	mv	a0,s6
 71e:	00000097          	auipc	ra,0x0
 722:	d04080e7          	jalr	-764(ra) # 422 <putc>
  putc(fd, 'x');
 726:	07800593          	li	a1,120
 72a:	855a                	mv	a0,s6
 72c:	00000097          	auipc	ra,0x0
 730:	cf6080e7          	jalr	-778(ra) # 422 <putc>
 734:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 736:	00000b97          	auipc	s7,0x0
 73a:	2a2b8b93          	add	s7,s7,674 # 9d8 <digits>
 73e:	03c9d793          	srl	a5,s3,0x3c
 742:	97de                	add	a5,a5,s7
 744:	0007c583          	lbu	a1,0(a5)
 748:	855a                	mv	a0,s6
 74a:	00000097          	auipc	ra,0x0
 74e:	cd8080e7          	jalr	-808(ra) # 422 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 752:	0992                	sll	s3,s3,0x4
 754:	397d                	addw	s2,s2,-1
 756:	fe0914e3          	bnez	s2,73e <vprintf+0x25a>
        printptr(fd, va_arg(ap, uint64));
 75a:	8bea                	mv	s7,s10
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bbd9                	j	534 <vprintf+0x50>
        putc(fd, va_arg(ap, uint32));
 760:	008b8913          	add	s2,s7,8
 764:	000bc583          	lbu	a1,0(s7)
 768:	855a                	mv	a0,s6
 76a:	00000097          	auipc	ra,0x0
 76e:	cb8080e7          	jalr	-840(ra) # 422 <putc>
 772:	8bca                	mv	s7,s2
      state = 0;
 774:	4981                	li	s3,0
 776:	bb7d                	j	534 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 778:	008b8993          	add	s3,s7,8
 77c:	000bb903          	ld	s2,0(s7)
 780:	02090163          	beqz	s2,7a2 <vprintf+0x2be>
        for(; *s; s++)
 784:	00094583          	lbu	a1,0(s2)
 788:	c585                	beqz	a1,7b0 <vprintf+0x2cc>
          putc(fd, *s);
 78a:	855a                	mv	a0,s6
 78c:	00000097          	auipc	ra,0x0
 790:	c96080e7          	jalr	-874(ra) # 422 <putc>
        for(; *s; s++)
 794:	0905                	add	s2,s2,1
 796:	00094583          	lbu	a1,0(s2)
 79a:	f9e5                	bnez	a1,78a <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
 79c:	8bce                	mv	s7,s3
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	bb51                	j	534 <vprintf+0x50>
          s = "(null)";
 7a2:	00000917          	auipc	s2,0x0
 7a6:	22e90913          	add	s2,s2,558 # 9d0 <malloc+0x118>
        for(; *s; s++)
 7aa:	02800593          	li	a1,40
 7ae:	bff1                	j	78a <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
 7b0:	8bce                	mv	s7,s3
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	b341                	j	534 <vprintf+0x50>
    }
  }
}
 7b6:	60e6                	ld	ra,88(sp)
 7b8:	6446                	ld	s0,80(sp)
 7ba:	64a6                	ld	s1,72(sp)
 7bc:	6906                	ld	s2,64(sp)
 7be:	79e2                	ld	s3,56(sp)
 7c0:	7a42                	ld	s4,48(sp)
 7c2:	7aa2                	ld	s5,40(sp)
 7c4:	7b02                	ld	s6,32(sp)
 7c6:	6be2                	ld	s7,24(sp)
 7c8:	6c42                	ld	s8,16(sp)
 7ca:	6ca2                	ld	s9,8(sp)
 7cc:	6d02                	ld	s10,0(sp)
 7ce:	6125                	add	sp,sp,96
 7d0:	8082                	ret

00000000000007d2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d2:	715d                	add	sp,sp,-80
 7d4:	ec06                	sd	ra,24(sp)
 7d6:	e822                	sd	s0,16(sp)
 7d8:	1000                	add	s0,sp,32
 7da:	e010                	sd	a2,0(s0)
 7dc:	e414                	sd	a3,8(s0)
 7de:	e818                	sd	a4,16(s0)
 7e0:	ec1c                	sd	a5,24(s0)
 7e2:	03043023          	sd	a6,32(s0)
 7e6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ee:	8622                	mv	a2,s0
 7f0:	00000097          	auipc	ra,0x0
 7f4:	cf4080e7          	jalr	-780(ra) # 4e4 <vprintf>
}
 7f8:	60e2                	ld	ra,24(sp)
 7fa:	6442                	ld	s0,16(sp)
 7fc:	6161                	add	sp,sp,80
 7fe:	8082                	ret

0000000000000800 <printf>:

void
printf(const char *fmt, ...)
{
 800:	711d                	add	sp,sp,-96
 802:	ec06                	sd	ra,24(sp)
 804:	e822                	sd	s0,16(sp)
 806:	1000                	add	s0,sp,32
 808:	e40c                	sd	a1,8(s0)
 80a:	e810                	sd	a2,16(s0)
 80c:	ec14                	sd	a3,24(s0)
 80e:	f018                	sd	a4,32(s0)
 810:	f41c                	sd	a5,40(s0)
 812:	03043823          	sd	a6,48(s0)
 816:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 81a:	00840613          	add	a2,s0,8
 81e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 822:	85aa                	mv	a1,a0
 824:	4505                	li	a0,1
 826:	00000097          	auipc	ra,0x0
 82a:	cbe080e7          	jalr	-834(ra) # 4e4 <vprintf>
}
 82e:	60e2                	ld	ra,24(sp)
 830:	6442                	ld	s0,16(sp)
 832:	6125                	add	sp,sp,96
 834:	8082                	ret

0000000000000836 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 836:	1141                	add	sp,sp,-16
 838:	e422                	sd	s0,8(sp)
 83a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 83c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 840:	00000797          	auipc	a5,0x0
 844:	7c07b783          	ld	a5,1984(a5) # 1000 <freep>
 848:	a02d                	j	872 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 84a:	4618                	lw	a4,8(a2)
 84c:	9f2d                	addw	a4,a4,a1
 84e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 852:	6398                	ld	a4,0(a5)
 854:	6310                	ld	a2,0(a4)
 856:	a83d                	j	894 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 858:	ff852703          	lw	a4,-8(a0)
 85c:	9f31                	addw	a4,a4,a2
 85e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 860:	ff053683          	ld	a3,-16(a0)
 864:	a091                	j	8a8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 866:	6398                	ld	a4,0(a5)
 868:	00e7e463          	bltu	a5,a4,870 <free+0x3a>
 86c:	00e6ea63          	bltu	a3,a4,880 <free+0x4a>
{
 870:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 872:	fed7fae3          	bgeu	a5,a3,866 <free+0x30>
 876:	6398                	ld	a4,0(a5)
 878:	00e6e463          	bltu	a3,a4,880 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87c:	fee7eae3          	bltu	a5,a4,870 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 880:	ff852583          	lw	a1,-8(a0)
 884:	6390                	ld	a2,0(a5)
 886:	02059813          	sll	a6,a1,0x20
 88a:	01c85713          	srl	a4,a6,0x1c
 88e:	9736                	add	a4,a4,a3
 890:	fae60de3          	beq	a2,a4,84a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 894:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 898:	4790                	lw	a2,8(a5)
 89a:	02061593          	sll	a1,a2,0x20
 89e:	01c5d713          	srl	a4,a1,0x1c
 8a2:	973e                	add	a4,a4,a5
 8a4:	fae68ae3          	beq	a3,a4,858 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8a8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8aa:	00000717          	auipc	a4,0x0
 8ae:	74f73b23          	sd	a5,1878(a4) # 1000 <freep>
}
 8b2:	6422                	ld	s0,8(sp)
 8b4:	0141                	add	sp,sp,16
 8b6:	8082                	ret

00000000000008b8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8b8:	7139                	add	sp,sp,-64
 8ba:	fc06                	sd	ra,56(sp)
 8bc:	f822                	sd	s0,48(sp)
 8be:	f426                	sd	s1,40(sp)
 8c0:	f04a                	sd	s2,32(sp)
 8c2:	ec4e                	sd	s3,24(sp)
 8c4:	e852                	sd	s4,16(sp)
 8c6:	e456                	sd	s5,8(sp)
 8c8:	e05a                	sd	s6,0(sp)
 8ca:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8cc:	02051493          	sll	s1,a0,0x20
 8d0:	9081                	srl	s1,s1,0x20
 8d2:	04bd                	add	s1,s1,15
 8d4:	8091                	srl	s1,s1,0x4
 8d6:	0014899b          	addw	s3,s1,1
 8da:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 8dc:	00000517          	auipc	a0,0x0
 8e0:	72453503          	ld	a0,1828(a0) # 1000 <freep>
 8e4:	c515                	beqz	a0,910 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e8:	4798                	lw	a4,8(a5)
 8ea:	02977f63          	bgeu	a4,s1,928 <malloc+0x70>
  if(nu < 4096)
 8ee:	8a4e                	mv	s4,s3
 8f0:	0009871b          	sext.w	a4,s3
 8f4:	6685                	lui	a3,0x1
 8f6:	00d77363          	bgeu	a4,a3,8fc <malloc+0x44>
 8fa:	6a05                	lui	s4,0x1
 8fc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 900:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 904:	00000917          	auipc	s2,0x0
 908:	6fc90913          	add	s2,s2,1788 # 1000 <freep>
  if(p == SBRK_ERROR)
 90c:	5afd                	li	s5,-1
 90e:	a895                	j	982 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 910:	00000797          	auipc	a5,0x0
 914:	70078793          	add	a5,a5,1792 # 1010 <base>
 918:	00000717          	auipc	a4,0x0
 91c:	6ef73423          	sd	a5,1768(a4) # 1000 <freep>
 920:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 922:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 926:	b7e1                	j	8ee <malloc+0x36>
      if(p->s.size == nunits)
 928:	02e48c63          	beq	s1,a4,960 <malloc+0xa8>
        p->s.size -= nunits;
 92c:	4137073b          	subw	a4,a4,s3
 930:	c798                	sw	a4,8(a5)
        p += p->s.size;
 932:	02071693          	sll	a3,a4,0x20
 936:	01c6d713          	srl	a4,a3,0x1c
 93a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 93c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 940:	00000717          	auipc	a4,0x0
 944:	6ca73023          	sd	a0,1728(a4) # 1000 <freep>
      return (void*)(p + 1);
 948:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 94c:	70e2                	ld	ra,56(sp)
 94e:	7442                	ld	s0,48(sp)
 950:	74a2                	ld	s1,40(sp)
 952:	7902                	ld	s2,32(sp)
 954:	69e2                	ld	s3,24(sp)
 956:	6a42                	ld	s4,16(sp)
 958:	6aa2                	ld	s5,8(sp)
 95a:	6b02                	ld	s6,0(sp)
 95c:	6121                	add	sp,sp,64
 95e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 960:	6398                	ld	a4,0(a5)
 962:	e118                	sd	a4,0(a0)
 964:	bff1                	j	940 <malloc+0x88>
  hp->s.size = nu;
 966:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 96a:	0541                	add	a0,a0,16
 96c:	00000097          	auipc	ra,0x0
 970:	eca080e7          	jalr	-310(ra) # 836 <free>
  return freep;
 974:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 978:	d971                	beqz	a0,94c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 97c:	4798                	lw	a4,8(a5)
 97e:	fa9775e3          	bgeu	a4,s1,928 <malloc+0x70>
    if(p == freep)
 982:	00093703          	ld	a4,0(s2)
 986:	853e                	mv	a0,a5
 988:	fef719e3          	bne	a4,a5,97a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 98c:	8552                	mv	a0,s4
 98e:	00000097          	auipc	ra,0x0
 992:	938080e7          	jalr	-1736(ra) # 2c6 <sbrk>
  if(p == SBRK_ERROR)
 996:	fd5518e3          	bne	a0,s5,966 <malloc+0xae>
        return 0;
 99a:	4501                	li	a0,0
 99c:	bf45                	j	94c <malloc+0x94>
