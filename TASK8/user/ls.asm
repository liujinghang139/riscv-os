
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <ls>:
  printf("%s\n", name);
}

static void
ls(const char *path)
{
   0:	7159                	add	sp,sp,-112
   2:	f486                	sd	ra,104(sp)
   4:	f0a2                	sd	s0,96(sp)
   6:	eca6                	sd	s1,88(sp)
   8:	e8ca                	sd	s2,80(sp)
   a:	e4ce                	sd	s3,72(sp)
   c:	e0d2                	sd	s4,64(sp)
   e:	fc56                	sd	s5,56(sp)
  10:	f85a                	sd	s6,48(sp)
  12:	f45e                	sd	s7,40(sp)
  14:	f062                	sd	s8,32(sp)
  16:	1880                	add	s0,sp,112
  18:	8a2a                	mv	s4,a0
  struct dirent de;
  int fd = open(path, O_RDONLY);
  1a:	4581                	li	a1,0
  1c:	00000097          	auipc	ra,0x0
  20:	474080e7          	jalr	1140(ra) # 490 <open>
  if(fd < 0){
  24:	00054e63          	bltz	a0,40 <ls+0x40>
  28:	892a                	mv	s2,a0
  2a:	4a81                	li	s5,0
    if(de.inum == 0)
      continue;

    char name[DIRSIZ + 1];
    int i;
    for(i = 0; i < DIRSIZ && de.name[i]; i++)
  2c:	4981                	li	s3,0
  2e:	44b9                	li	s1,14
      name[i] = de.name[i];
    name[i] = '\0';

    if(name[0] == '\0')
      continue;
    if(name[0] == '.' && (name[1] == '\0' || (name[1] == '.' && name[2] == '\0')))
  30:	02e00b13          	li	s6,46
  printf("%s\n", name);
  34:	00001c17          	auipc	s8,0x1
  38:	a4cc0c13          	add	s8,s8,-1460 # a80 <malloc+0xfa>
      continue;

    emit_name(name);
    saw_dir = 1;
  3c:	4b85                	li	s7,1
  3e:	a025                	j	66 <ls+0x66>
    fprintf(2, "ls: cannot open %s\n", path);
  40:	8652                	mv	a2,s4
  42:	00001597          	auipc	a1,0x1
  46:	a2e58593          	add	a1,a1,-1490 # a70 <malloc+0xea>
  4a:	4509                	li	a0,2
  4c:	00001097          	auipc	ra,0x1
  50:	854080e7          	jalr	-1964(ra) # 8a0 <fprintf>
    return;
  54:	a051                	j	d8 <ls+0xd8>
  printf("%s\n", name);
  56:	f9040593          	add	a1,s0,-112
  5a:	8562                	mv	a0,s8
  5c:	00001097          	auipc	ra,0x1
  60:	872080e7          	jalr	-1934(ra) # 8ce <printf>
    saw_dir = 1;
  64:	8ade                	mv	s5,s7
  while(read(fd, &de, sizeof(de)) == sizeof(de)){
  66:	4641                	li	a2,16
  68:	fa040593          	add	a1,s0,-96
  6c:	854a                	mv	a0,s2
  6e:	00000097          	auipc	ra,0x0
  72:	432080e7          	jalr	1074(ra) # 4a0 <read>
  76:	47c1                	li	a5,16
  78:	04f51963          	bne	a0,a5,ca <ls+0xca>
    if(de.inum == 0)
  7c:	fa045783          	lhu	a5,-96(s0)
  80:	d3fd                	beqz	a5,66 <ls+0x66>
  82:	fa240713          	add	a4,s0,-94
  86:	f9040693          	add	a3,s0,-112
    for(i = 0; i < DIRSIZ && de.name[i]; i++)
  8a:	87ce                	mv	a5,s3
  8c:	00074603          	lbu	a2,0(a4)
  90:	ca01                	beqz	a2,a0 <ls+0xa0>
      name[i] = de.name[i];
  92:	00c68023          	sb	a2,0(a3)
    for(i = 0; i < DIRSIZ && de.name[i]; i++)
  96:	2785                	addw	a5,a5,1
  98:	0705                	add	a4,a4,1
  9a:	0685                	add	a3,a3,1
  9c:	fe9798e3          	bne	a5,s1,8c <ls+0x8c>
    name[i] = '\0';
  a0:	fb078793          	add	a5,a5,-80
  a4:	97a2                	add	a5,a5,s0
  a6:	fe078023          	sb	zero,-32(a5)
    if(name[0] == '\0')
  aa:	f9044783          	lbu	a5,-112(s0)
  ae:	dfc5                	beqz	a5,66 <ls+0x66>
    if(name[0] == '.' && (name[1] == '\0' || (name[1] == '.' && name[2] == '\0')))
  b0:	fb6793e3          	bne	a5,s6,56 <ls+0x56>
  b4:	f9144783          	lbu	a5,-111(s0)
  b8:	d7dd                	beqz	a5,66 <ls+0x66>
  ba:	02e00713          	li	a4,46
  be:	f8e79ce3          	bne	a5,a4,56 <ls+0x56>
  c2:	f9244783          	lbu	a5,-110(s0)
  c6:	fbc1                	bnez	a5,56 <ls+0x56>
  c8:	bf79                	j	66 <ls+0x66>
  }

  close(fd);
  ca:	854a                	mv	a0,s2
  cc:	00000097          	auipc	ra,0x0
  d0:	3bc080e7          	jalr	956(ra) # 488 <close>

  if(!saw_dir)
  d4:	000a8e63          	beqz	s5,f0 <ls+0xf0>
    emit_name(path);
}
  d8:	70a6                	ld	ra,104(sp)
  da:	7406                	ld	s0,96(sp)
  dc:	64e6                	ld	s1,88(sp)
  de:	6946                	ld	s2,80(sp)
  e0:	69a6                	ld	s3,72(sp)
  e2:	6a06                	ld	s4,64(sp)
  e4:	7ae2                	ld	s5,56(sp)
  e6:	7b42                	ld	s6,48(sp)
  e8:	7ba2                	ld	s7,40(sp)
  ea:	7c02                	ld	s8,32(sp)
  ec:	6165                	add	sp,sp,112
  ee:	8082                	ret
  printf("%s\n", name);
  f0:	85d2                	mv	a1,s4
  f2:	00001517          	auipc	a0,0x1
  f6:	98e50513          	add	a0,a0,-1650 # a80 <malloc+0xfa>
  fa:	00000097          	auipc	ra,0x0
  fe:	7d4080e7          	jalr	2004(ra) # 8ce <printf>
}
 102:	bfd9                	j	d8 <ls+0xd8>

0000000000000104 <main>:

int
main(int argc, char *argv[])
{
 104:	1101                	add	sp,sp,-32
 106:	ec06                	sd	ra,24(sp)
 108:	e822                	sd	s0,16(sp)
 10a:	e426                	sd	s1,8(sp)
 10c:	e04a                	sd	s2,0(sp)
 10e:	1000                	add	s0,sp,32
  if(argc <= 1){
 110:	4785                	li	a5,1
 112:	02a7d963          	bge	a5,a0,144 <main+0x40>
 116:	00858493          	add	s1,a1,8
 11a:	ffe5091b          	addw	s2,a0,-2
 11e:	02091793          	sll	a5,s2,0x20
 122:	01d7d913          	srl	s2,a5,0x1d
 126:	05c1                	add	a1,a1,16
 128:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }

  for(int i = 1; i < argc; i++)
    ls(argv[i]);
 12a:	6088                	ld	a0,0(s1)
 12c:	00000097          	auipc	ra,0x0
 130:	ed4080e7          	jalr	-300(ra) # 0 <ls>
  for(int i = 1; i < argc; i++)
 134:	04a1                	add	s1,s1,8
 136:	ff249ae3          	bne	s1,s2,12a <main+0x26>

  exit(0);
 13a:	4501                	li	a0,0
 13c:	00000097          	auipc	ra,0x0
 140:	334080e7          	jalr	820(ra) # 470 <exit>
    ls(".");
 144:	00001517          	auipc	a0,0x1
 148:	94450513          	add	a0,a0,-1724 # a88 <malloc+0x102>
 14c:	00000097          	auipc	ra,0x0
 150:	eb4080e7          	jalr	-332(ra) # 0 <ls>
    exit(0);
 154:	4501                	li	a0,0
 156:	00000097          	auipc	ra,0x0
 15a:	31a080e7          	jalr	794(ra) # 470 <exit>

000000000000015e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 15e:	1141                	add	sp,sp,-16
 160:	e406                	sd	ra,8(sp)
 162:	e022                	sd	s0,0(sp)
 164:	0800                	add	s0,sp,16
  int r;
  extern int main();
  r = main();
 166:	00000097          	auipc	ra,0x0
 16a:	f9e080e7          	jalr	-98(ra) # 104 <main>
  exit(r);
 16e:	00000097          	auipc	ra,0x0
 172:	302080e7          	jalr	770(ra) # 470 <exit>

0000000000000176 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 176:	1141                	add	sp,sp,-16
 178:	e422                	sd	s0,8(sp)
 17a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 17c:	87aa                	mv	a5,a0
 17e:	0585                	add	a1,a1,1
 180:	0785                	add	a5,a5,1
 182:	fff5c703          	lbu	a4,-1(a1)
 186:	fee78fa3          	sb	a4,-1(a5)
 18a:	fb75                	bnez	a4,17e <strcpy+0x8>
    ;
  return os;
}
 18c:	6422                	ld	s0,8(sp)
 18e:	0141                	add	sp,sp,16
 190:	8082                	ret

0000000000000192 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 192:	1141                	add	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 198:	00054783          	lbu	a5,0(a0)
 19c:	cb91                	beqz	a5,1b0 <strcmp+0x1e>
 19e:	0005c703          	lbu	a4,0(a1)
 1a2:	00f71763          	bne	a4,a5,1b0 <strcmp+0x1e>
    p++, q++;
 1a6:	0505                	add	a0,a0,1
 1a8:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	fbe5                	bnez	a5,19e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1b0:	0005c503          	lbu	a0,0(a1)
}
 1b4:	40a7853b          	subw	a0,a5,a0
 1b8:	6422                	ld	s0,8(sp)
 1ba:	0141                	add	sp,sp,16
 1bc:	8082                	ret

00000000000001be <strlen>:

uint
strlen(const char *s)
{
 1be:	1141                	add	sp,sp,-16
 1c0:	e422                	sd	s0,8(sp)
 1c2:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	cf91                	beqz	a5,1e4 <strlen+0x26>
 1ca:	0505                	add	a0,a0,1
 1cc:	87aa                	mv	a5,a0
 1ce:	86be                	mv	a3,a5
 1d0:	0785                	add	a5,a5,1
 1d2:	fff7c703          	lbu	a4,-1(a5)
 1d6:	ff65                	bnez	a4,1ce <strlen+0x10>
 1d8:	40a6853b          	subw	a0,a3,a0
 1dc:	2505                	addw	a0,a0,1
    ;
  return n;
}
 1de:	6422                	ld	s0,8(sp)
 1e0:	0141                	add	sp,sp,16
 1e2:	8082                	ret
  for(n = 0; s[n]; n++)
 1e4:	4501                	li	a0,0
 1e6:	bfe5                	j	1de <strlen+0x20>

00000000000001e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e8:	1141                	add	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ee:	ca19                	beqz	a2,204 <memset+0x1c>
 1f0:	87aa                	mv	a5,a0
 1f2:	1602                	sll	a2,a2,0x20
 1f4:	9201                	srl	a2,a2,0x20
 1f6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1fa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1fe:	0785                	add	a5,a5,1
 200:	fee79de3          	bne	a5,a4,1fa <memset+0x12>
  }
  return dst;
}
 204:	6422                	ld	s0,8(sp)
 206:	0141                	add	sp,sp,16
 208:	8082                	ret

000000000000020a <strchr>:

char*
strchr(const char *s, char c)
{
 20a:	1141                	add	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	add	s0,sp,16
  for(; *s; s++)
 210:	00054783          	lbu	a5,0(a0)
 214:	cb99                	beqz	a5,22a <strchr+0x20>
    if(*s == c)
 216:	00f58763          	beq	a1,a5,224 <strchr+0x1a>
  for(; *s; s++)
 21a:	0505                	add	a0,a0,1
 21c:	00054783          	lbu	a5,0(a0)
 220:	fbfd                	bnez	a5,216 <strchr+0xc>
      return (char*)s;
  return 0;
 222:	4501                	li	a0,0
}
 224:	6422                	ld	s0,8(sp)
 226:	0141                	add	sp,sp,16
 228:	8082                	ret
  return 0;
 22a:	4501                	li	a0,0
 22c:	bfe5                	j	224 <strchr+0x1a>

000000000000022e <gets>:

char*
gets(char *buf, int max)
{
 22e:	711d                	add	sp,sp,-96
 230:	ec86                	sd	ra,88(sp)
 232:	e8a2                	sd	s0,80(sp)
 234:	e4a6                	sd	s1,72(sp)
 236:	e0ca                	sd	s2,64(sp)
 238:	fc4e                	sd	s3,56(sp)
 23a:	f852                	sd	s4,48(sp)
 23c:	f456                	sd	s5,40(sp)
 23e:	f05a                	sd	s6,32(sp)
 240:	ec5e                	sd	s7,24(sp)
 242:	1080                	add	s0,sp,96
 244:	8baa                	mv	s7,a0
 246:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 248:	892a                	mv	s2,a0
 24a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 24c:	4aa9                	li	s5,10
 24e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 250:	89a6                	mv	s3,s1
 252:	2485                	addw	s1,s1,1
 254:	0344d863          	bge	s1,s4,284 <gets+0x56>
    cc = read(0, &c, 1);
 258:	4605                	li	a2,1
 25a:	faf40593          	add	a1,s0,-81
 25e:	4501                	li	a0,0
 260:	00000097          	auipc	ra,0x0
 264:	240080e7          	jalr	576(ra) # 4a0 <read>
    if(cc < 1)
 268:	00a05e63          	blez	a0,284 <gets+0x56>
    buf[i++] = c;
 26c:	faf44783          	lbu	a5,-81(s0)
 270:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 274:	01578763          	beq	a5,s5,282 <gets+0x54>
 278:	0905                	add	s2,s2,1
 27a:	fd679be3          	bne	a5,s6,250 <gets+0x22>
  for(i=0; i+1 < max; ){
 27e:	89a6                	mv	s3,s1
 280:	a011                	j	284 <gets+0x56>
 282:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 284:	99de                	add	s3,s3,s7
 286:	00098023          	sb	zero,0(s3)
  return buf;
}
 28a:	855e                	mv	a0,s7
 28c:	60e6                	ld	ra,88(sp)
 28e:	6446                	ld	s0,80(sp)
 290:	64a6                	ld	s1,72(sp)
 292:	6906                	ld	s2,64(sp)
 294:	79e2                	ld	s3,56(sp)
 296:	7a42                	ld	s4,48(sp)
 298:	7aa2                	ld	s5,40(sp)
 29a:	7b02                	ld	s6,32(sp)
 29c:	6be2                	ld	s7,24(sp)
 29e:	6125                	add	sp,sp,96
 2a0:	8082                	ret

00000000000002a2 <atoi>:
//   return r;
// }

int
atoi(const char *s)
{
 2a2:	1141                	add	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a8:	00054683          	lbu	a3,0(a0)
 2ac:	fd06879b          	addw	a5,a3,-48
 2b0:	0ff7f793          	zext.b	a5,a5
 2b4:	4625                	li	a2,9
 2b6:	02f66863          	bltu	a2,a5,2e6 <atoi+0x44>
 2ba:	872a                	mv	a4,a0
  n = 0;
 2bc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2be:	0705                	add	a4,a4,1
 2c0:	0025179b          	sllw	a5,a0,0x2
 2c4:	9fa9                	addw	a5,a5,a0
 2c6:	0017979b          	sllw	a5,a5,0x1
 2ca:	9fb5                	addw	a5,a5,a3
 2cc:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d0:	00074683          	lbu	a3,0(a4)
 2d4:	fd06879b          	addw	a5,a3,-48
 2d8:	0ff7f793          	zext.b	a5,a5
 2dc:	fef671e3          	bgeu	a2,a5,2be <atoi+0x1c>
  return n;
}
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	add	sp,sp,16
 2e4:	8082                	ret
  n = 0;
 2e6:	4501                	li	a0,0
 2e8:	bfe5                	j	2e0 <atoi+0x3e>

00000000000002ea <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ea:	1141                	add	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f0:	02b57463          	bgeu	a0,a1,318 <memmove+0x2e>
    while(n-- > 0)
 2f4:	00c05f63          	blez	a2,312 <memmove+0x28>
 2f8:	1602                	sll	a2,a2,0x20
 2fa:	9201                	srl	a2,a2,0x20
 2fc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 300:	872a                	mv	a4,a0
      *dst++ = *src++;
 302:	0585                	add	a1,a1,1
 304:	0705                	add	a4,a4,1
 306:	fff5c683          	lbu	a3,-1(a1)
 30a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 30e:	fee79ae3          	bne	a5,a4,302 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 312:	6422                	ld	s0,8(sp)
 314:	0141                	add	sp,sp,16
 316:	8082                	ret
    dst += n;
 318:	00c50733          	add	a4,a0,a2
    src += n;
 31c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 31e:	fec05ae3          	blez	a2,312 <memmove+0x28>
 322:	fff6079b          	addw	a5,a2,-1
 326:	1782                	sll	a5,a5,0x20
 328:	9381                	srl	a5,a5,0x20
 32a:	fff7c793          	not	a5,a5
 32e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 330:	15fd                	add	a1,a1,-1
 332:	177d                	add	a4,a4,-1
 334:	0005c683          	lbu	a3,0(a1)
 338:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 33c:	fee79ae3          	bne	a5,a4,330 <memmove+0x46>
 340:	bfc9                	j	312 <memmove+0x28>

0000000000000342 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 342:	1141                	add	sp,sp,-16
 344:	e422                	sd	s0,8(sp)
 346:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 348:	ca05                	beqz	a2,378 <memcmp+0x36>
 34a:	fff6069b          	addw	a3,a2,-1
 34e:	1682                	sll	a3,a3,0x20
 350:	9281                	srl	a3,a3,0x20
 352:	0685                	add	a3,a3,1
 354:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 356:	00054783          	lbu	a5,0(a0)
 35a:	0005c703          	lbu	a4,0(a1)
 35e:	00e79863          	bne	a5,a4,36e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 362:	0505                	add	a0,a0,1
    p2++;
 364:	0585                	add	a1,a1,1
  while (n-- > 0) {
 366:	fed518e3          	bne	a0,a3,356 <memcmp+0x14>
  }
  return 0;
 36a:	4501                	li	a0,0
 36c:	a019                	j	372 <memcmp+0x30>
      return *p1 - *p2;
 36e:	40e7853b          	subw	a0,a5,a4
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	add	sp,sp,16
 376:	8082                	ret
  return 0;
 378:	4501                	li	a0,0
 37a:	bfe5                	j	372 <memcmp+0x30>

000000000000037c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 37c:	1141                	add	sp,sp,-16
 37e:	e406                	sd	ra,8(sp)
 380:	e022                	sd	s0,0(sp)
 382:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 384:	00000097          	auipc	ra,0x0
 388:	f66080e7          	jalr	-154(ra) # 2ea <memmove>
}
 38c:	60a2                	ld	ra,8(sp)
 38e:	6402                	ld	s0,0(sp)
 390:	0141                	add	sp,sp,16
 392:	8082                	ret

0000000000000394 <sbrk>:

char *
sbrk(int n) {
 394:	1141                	add	sp,sp,-16
 396:	e406                	sd	ra,8(sp)
 398:	e022                	sd	s0,0(sp)
 39a:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 39c:	4585                	li	a1,1
 39e:	00000097          	auipc	ra,0x0
 3a2:	12a080e7          	jalr	298(ra) # 4c8 <sys_sbrk>
}
 3a6:	60a2                	ld	ra,8(sp)
 3a8:	6402                	ld	s0,0(sp)
 3aa:	0141                	add	sp,sp,16
 3ac:	8082                	ret

00000000000003ae <get_time>:
//   return sys_sbrk(n, SBRK_LAZY);
// }


unsigned int 
get_time(void) {
 3ae:	1141                	add	sp,sp,-16
 3b0:	e406                	sd	ra,8(sp)
 3b2:	e022                	sd	s0,0(sp)
 3b4:	0800                	add	s0,sp,16
    return uptime();
 3b6:	00000097          	auipc	ra,0x0
 3ba:	11a080e7          	jalr	282(ra) # 4d0 <uptime>
}
 3be:	2501                	sext.w	a0,a0
 3c0:	60a2                	ld	ra,8(sp)
 3c2:	6402                	ld	s0,0(sp)
 3c4:	0141                	add	sp,sp,16
 3c6:	8082                	ret

00000000000003c8 <make_filename>:
void 
make_filename(char *buf, const char *prefix, int num) {
    // 复制前缀
    char *p = buf;
    const char *s = prefix;
    while(*s) *p++ = *s++;
 3c8:	0005c783          	lbu	a5,0(a1)
 3cc:	cb81                	beqz	a5,3dc <make_filename+0x14>
 3ce:	0585                	add	a1,a1,1
 3d0:	0505                	add	a0,a0,1
 3d2:	fef50fa3          	sb	a5,-1(a0)
 3d6:	0005c783          	lbu	a5,0(a1)
 3da:	fbf5                	bnez	a5,3ce <make_filename+0x6>
    
    // 处理数字部分
    if (num == 0) {
 3dc:	ca3d                	beqz	a2,452 <make_filename+0x8a>
make_filename(char *buf, const char *prefix, int num) {
 3de:	1101                	add	sp,sp,-32
 3e0:	ec22                	sd	s0,24(sp)
 3e2:	1000                	add	s0,sp,32
        *p++ = '0';
    } else {
        // 临时缓冲区存放数字
        char digits[16];
        int i = 0;
        while(num > 0) {
 3e4:	fe040893          	add	a7,s0,-32
 3e8:	87c6                	mv	a5,a7
            digits[i++] = (num % 10) + '0';
 3ea:	46a9                	li	a3,10
        while(num > 0) {
 3ec:	4825                	li	a6,9
 3ee:	06c05063          	blez	a2,44e <make_filename+0x86>
            digits[i++] = (num % 10) + '0';
 3f2:	02d6673b          	remw	a4,a2,a3
 3f6:	0307071b          	addw	a4,a4,48
 3fa:	00e78023          	sb	a4,0(a5)
            num /= 10;
 3fe:	85b2                	mv	a1,a2
 400:	02d6463b          	divw	a2,a2,a3
        while(num > 0) {
 404:	873e                	mv	a4,a5
 406:	0785                	add	a5,a5,1
 408:	feb845e3          	blt	a6,a1,3f2 <make_filename+0x2a>
 40c:	4117073b          	subw	a4,a4,a7
 410:	0017069b          	addw	a3,a4,1
            digits[i++] = (num % 10) + '0';
 414:	0006879b          	sext.w	a5,a3
        }
        // 倒序写入
        while(i > 0) *p++ = digits[--i];
 418:	04f05663          	blez	a5,464 <make_filename+0x9c>
 41c:	fe040713          	add	a4,s0,-32
 420:	973e                	add	a4,a4,a5
 422:	02069593          	sll	a1,a3,0x20
 426:	9181                	srl	a1,a1,0x20
 428:	95aa                	add	a1,a1,a0
 42a:	87aa                	mv	a5,a0
 42c:	0785                	add	a5,a5,1
 42e:	fff74603          	lbu	a2,-1(a4)
 432:	fec78fa3          	sb	a2,-1(a5)
 436:	177d                	add	a4,a4,-1
 438:	feb79ae3          	bne	a5,a1,42c <make_filename+0x64>
 43c:	02069793          	sll	a5,a3,0x20
 440:	9381                	srl	a5,a5,0x20
 442:	97aa                	add	a5,a5,a0
    }
    *p = 0; // 字符串结束符
 444:	00078023          	sb	zero,0(a5)
 448:	6462                	ld	s0,24(sp)
 44a:	6105                	add	sp,sp,32
 44c:	8082                	ret
        while(num > 0) {
 44e:	87aa                	mv	a5,a0
 450:	bfd5                	j	444 <make_filename+0x7c>
        *p++ = '0';
 452:	00150793          	add	a5,a0,1
 456:	03000713          	li	a4,48
 45a:	00e50023          	sb	a4,0(a0)
    *p = 0; // 字符串结束符
 45e:	00078023          	sb	zero,0(a5)
 462:	8082                	ret
        while(i > 0) *p++ = digits[--i];
 464:	87aa                	mv	a5,a0
 466:	bff9                	j	444 <make_filename+0x7c>

0000000000000468 <fork>:
.globl unlink
# generated by usys.pl - do not edit
#include "../kernel/sys/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 468:	4885                	li	a7,1
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <exit>:
.global exit
exit:
 li a7, SYS_exit
 470:	4889                	li	a7,2
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <wait>:
.global wait
wait:
 li a7, SYS_wait
 478:	488d                	li	a7,3
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 480:	4891                	li	a7,4
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <close>:
.global close
close:
 li a7, SYS_close
 488:	4899                	li	a7,6
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <open>:
.global open
open:
 li a7, SYS_open
 490:	489d                	li	a7,7
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <exec>:
.global exec
exec:
 li a7, SYS_exec
 498:	4895                	li	a7,5
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <read>:
.global read
read:
 li a7, SYS_read
 4a0:	48a1                	li	a7,8
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <write>:
.global write
write:
 li a7, SYS_write
 4a8:	48a5                	li	a7,9
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4b0:	48a9                	li	a7,10
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <makenode>:
.global makenode
makenode:
 li a7, SYS_makenode
 4b8:	48ad                	li	a7,11
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <duplicate>:
.global duplicate
duplicate:
 li a7, SYS_duplicate
 4c0:	48b1                	li	a7,12
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4c8:	48b5                	li	a7,13
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4d0:	48b9                	li	a7,14
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d8:	48bd                	li	a7,15
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4e0:	48c1                	li	a7,16
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <crash_arm>:
.global crash_arm
crash_arm:
 li a7, SYS_crash_arm
 4e8:	48c5                	li	a7,17
 ecall
 4ea:	00000073          	ecall
 4ee:	8082                	ret

00000000000004f0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4f0:	1101                	add	sp,sp,-32
 4f2:	ec06                	sd	ra,24(sp)
 4f4:	e822                	sd	s0,16(sp)
 4f6:	1000                	add	s0,sp,32
 4f8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4fc:	4605                	li	a2,1
 4fe:	fef40593          	add	a1,s0,-17
 502:	00000097          	auipc	ra,0x0
 506:	fa6080e7          	jalr	-90(ra) # 4a8 <write>
}
 50a:	60e2                	ld	ra,24(sp)
 50c:	6442                	ld	s0,16(sp)
 50e:	6105                	add	sp,sp,32
 510:	8082                	ret

0000000000000512 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 512:	715d                	add	sp,sp,-80
 514:	e486                	sd	ra,72(sp)
 516:	e0a2                	sd	s0,64(sp)
 518:	fc26                	sd	s1,56(sp)
 51a:	f84a                	sd	s2,48(sp)
 51c:	f44e                	sd	s3,40(sp)
 51e:	0880                	add	s0,sp,80
 520:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 522:	c299                	beqz	a3,528 <printint+0x16>
 524:	0805c363          	bltz	a1,5aa <printint+0x98>
  neg = 0;
 528:	4881                	li	a7,0
 52a:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 52e:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 530:	00000517          	auipc	a0,0x0
 534:	56850513          	add	a0,a0,1384 # a98 <digits>
 538:	883e                	mv	a6,a5
 53a:	2785                	addw	a5,a5,1
 53c:	02c5f733          	remu	a4,a1,a2
 540:	972a                	add	a4,a4,a0
 542:	00074703          	lbu	a4,0(a4)
 546:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 54a:	872e                	mv	a4,a1
 54c:	02c5d5b3          	divu	a1,a1,a2
 550:	0685                	add	a3,a3,1
 552:	fec773e3          	bgeu	a4,a2,538 <printint+0x26>
  if(neg)
 556:	00088b63          	beqz	a7,56c <printint+0x5a>
    buf[i++] = '-';
 55a:	fd078793          	add	a5,a5,-48
 55e:	97a2                	add	a5,a5,s0
 560:	02d00713          	li	a4,45
 564:	fee78423          	sb	a4,-24(a5)
 568:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
 56c:	02f05863          	blez	a5,59c <printint+0x8a>
 570:	fb840713          	add	a4,s0,-72
 574:	00f704b3          	add	s1,a4,a5
 578:	fff70993          	add	s3,a4,-1
 57c:	99be                	add	s3,s3,a5
 57e:	37fd                	addw	a5,a5,-1
 580:	1782                	sll	a5,a5,0x20
 582:	9381                	srl	a5,a5,0x20
 584:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 588:	fff4c583          	lbu	a1,-1(s1)
 58c:	854a                	mv	a0,s2
 58e:	00000097          	auipc	ra,0x0
 592:	f62080e7          	jalr	-158(ra) # 4f0 <putc>
  while(--i >= 0)
 596:	14fd                	add	s1,s1,-1
 598:	ff3498e3          	bne	s1,s3,588 <printint+0x76>
}
 59c:	60a6                	ld	ra,72(sp)
 59e:	6406                	ld	s0,64(sp)
 5a0:	74e2                	ld	s1,56(sp)
 5a2:	7942                	ld	s2,48(sp)
 5a4:	79a2                	ld	s3,40(sp)
 5a6:	6161                	add	sp,sp,80
 5a8:	8082                	ret
    x = -xx;
 5aa:	40b005b3          	neg	a1,a1
    neg = 1;
 5ae:	4885                	li	a7,1
    x = -xx;
 5b0:	bfad                	j	52a <printint+0x18>

00000000000005b2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b2:	711d                	add	sp,sp,-96
 5b4:	ec86                	sd	ra,88(sp)
 5b6:	e8a2                	sd	s0,80(sp)
 5b8:	e4a6                	sd	s1,72(sp)
 5ba:	e0ca                	sd	s2,64(sp)
 5bc:	fc4e                	sd	s3,56(sp)
 5be:	f852                	sd	s4,48(sp)
 5c0:	f456                	sd	s5,40(sp)
 5c2:	f05a                	sd	s6,32(sp)
 5c4:	ec5e                	sd	s7,24(sp)
 5c6:	e862                	sd	s8,16(sp)
 5c8:	e466                	sd	s9,8(sp)
 5ca:	e06a                	sd	s10,0(sp)
 5cc:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5ce:	0005c903          	lbu	s2,0(a1)
 5d2:	2a090963          	beqz	s2,884 <vprintf+0x2d2>
 5d6:	8b2a                	mv	s6,a0
 5d8:	8a2e                	mv	s4,a1
 5da:	8bb2                	mv	s7,a2
  state = 0;
 5dc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5de:	4481                	li	s1,0
 5e0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5e2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5e6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5ea:	06c00c93          	li	s9,108
 5ee:	a015                	j	612 <vprintf+0x60>
        putc(fd, c0);
 5f0:	85ca                	mv	a1,s2
 5f2:	855a                	mv	a0,s6
 5f4:	00000097          	auipc	ra,0x0
 5f8:	efc080e7          	jalr	-260(ra) # 4f0 <putc>
 5fc:	a019                	j	602 <vprintf+0x50>
    } else if(state == '%'){
 5fe:	03598263          	beq	s3,s5,622 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
 602:	2485                	addw	s1,s1,1
 604:	8726                	mv	a4,s1
 606:	009a07b3          	add	a5,s4,s1
 60a:	0007c903          	lbu	s2,0(a5)
 60e:	26090b63          	beqz	s2,884 <vprintf+0x2d2>
    c0 = fmt[i] & 0xff;
 612:	0009079b          	sext.w	a5,s2
    if(state == 0){
 616:	fe0994e3          	bnez	s3,5fe <vprintf+0x4c>
      if(c0 == '%'){
 61a:	fd579be3          	bne	a5,s5,5f0 <vprintf+0x3e>
        state = '%';
 61e:	89be                	mv	s3,a5
 620:	b7cd                	j	602 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
 622:	cfc9                	beqz	a5,6bc <vprintf+0x10a>
 624:	00ea06b3          	add	a3,s4,a4
 628:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 62c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 62e:	c681                	beqz	a3,636 <vprintf+0x84>
 630:	9752                	add	a4,a4,s4
 632:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 636:	05878563          	beq	a5,s8,680 <vprintf+0xce>
      } else if(c0 == 'l' && c1 == 'd'){
 63a:	07978163          	beq	a5,s9,69c <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 63e:	07500713          	li	a4,117
 642:	10e78563          	beq	a5,a4,74c <vprintf+0x19a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 646:	07800713          	li	a4,120
 64a:	14e78d63          	beq	a5,a4,7a4 <vprintf+0x1f2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 64e:	07000713          	li	a4,112
 652:	18e78663          	beq	a5,a4,7de <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 656:	06300713          	li	a4,99
 65a:	1ce78a63          	beq	a5,a4,82e <vprintf+0x27c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 65e:	07300713          	li	a4,115
 662:	1ee78263          	beq	a5,a4,846 <vprintf+0x294>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 666:	02500713          	li	a4,37
 66a:	04e79963          	bne	a5,a4,6bc <vprintf+0x10a>
        putc(fd, '%');
 66e:	02500593          	li	a1,37
 672:	855a                	mv	a0,s6
 674:	00000097          	auipc	ra,0x0
 678:	e7c080e7          	jalr	-388(ra) # 4f0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 67c:	4981                	li	s3,0
 67e:	b751                	j	602 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
 680:	008b8913          	add	s2,s7,8
 684:	4685                	li	a3,1
 686:	4629                	li	a2,10
 688:	000ba583          	lw	a1,0(s7)
 68c:	855a                	mv	a0,s6
 68e:	00000097          	auipc	ra,0x0
 692:	e84080e7          	jalr	-380(ra) # 512 <printint>
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
 69a:	b7a5                	j	602 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
 69c:	06400793          	li	a5,100
 6a0:	02f68d63          	beq	a3,a5,6da <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a4:	06c00793          	li	a5,108
 6a8:	04f68863          	beq	a3,a5,6f8 <vprintf+0x146>
      } else if(c0 == 'l' && c1 == 'u'){
 6ac:	07500793          	li	a5,117
 6b0:	0af68c63          	beq	a3,a5,768 <vprintf+0x1b6>
      } else if(c0 == 'l' && c1 == 'x'){
 6b4:	07800793          	li	a5,120
 6b8:	10f68463          	beq	a3,a5,7c0 <vprintf+0x20e>
        putc(fd, '%');
 6bc:	02500593          	li	a1,37
 6c0:	855a                	mv	a0,s6
 6c2:	00000097          	auipc	ra,0x0
 6c6:	e2e080e7          	jalr	-466(ra) # 4f0 <putc>
        putc(fd, c0);
 6ca:	85ca                	mv	a1,s2
 6cc:	855a                	mv	a0,s6
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e22080e7          	jalr	-478(ra) # 4f0 <putc>
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	b72d                	j	602 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6da:	008b8913          	add	s2,s7,8
 6de:	4685                	li	a3,1
 6e0:	4629                	li	a2,10
 6e2:	000bb583          	ld	a1,0(s7)
 6e6:	855a                	mv	a0,s6
 6e8:	00000097          	auipc	ra,0x0
 6ec:	e2a080e7          	jalr	-470(ra) # 512 <printint>
        i += 1;
 6f0:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f2:	8bca                	mv	s7,s2
      state = 0;
 6f4:	4981                	li	s3,0
        i += 1;
 6f6:	b731                	j	602 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f8:	06400793          	li	a5,100
 6fc:	02f60963          	beq	a2,a5,72e <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 700:	07500793          	li	a5,117
 704:	08f60163          	beq	a2,a5,786 <vprintf+0x1d4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 708:	07800793          	li	a5,120
 70c:	faf618e3          	bne	a2,a5,6bc <vprintf+0x10a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 710:	008b8913          	add	s2,s7,8
 714:	4681                	li	a3,0
 716:	4641                	li	a2,16
 718:	000bb583          	ld	a1,0(s7)
 71c:	855a                	mv	a0,s6
 71e:	00000097          	auipc	ra,0x0
 722:	df4080e7          	jalr	-524(ra) # 512 <printint>
        i += 2;
 726:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 728:	8bca                	mv	s7,s2
      state = 0;
 72a:	4981                	li	s3,0
        i += 2;
 72c:	bdd9                	j	602 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
 72e:	008b8913          	add	s2,s7,8
 732:	4685                	li	a3,1
 734:	4629                	li	a2,10
 736:	000bb583          	ld	a1,0(s7)
 73a:	855a                	mv	a0,s6
 73c:	00000097          	auipc	ra,0x0
 740:	dd6080e7          	jalr	-554(ra) # 512 <printint>
        i += 2;
 744:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 746:	8bca                	mv	s7,s2
      state = 0;
 748:	4981                	li	s3,0
        i += 2;
 74a:	bd65                	j	602 <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 10, 0);
 74c:	008b8913          	add	s2,s7,8
 750:	4681                	li	a3,0
 752:	4629                	li	a2,10
 754:	000be583          	lwu	a1,0(s7)
 758:	855a                	mv	a0,s6
 75a:	00000097          	auipc	ra,0x0
 75e:	db8080e7          	jalr	-584(ra) # 512 <printint>
 762:	8bca                	mv	s7,s2
      state = 0;
 764:	4981                	li	s3,0
 766:	bd71                	j	602 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 768:	008b8913          	add	s2,s7,8
 76c:	4681                	li	a3,0
 76e:	4629                	li	a2,10
 770:	000bb583          	ld	a1,0(s7)
 774:	855a                	mv	a0,s6
 776:	00000097          	auipc	ra,0x0
 77a:	d9c080e7          	jalr	-612(ra) # 512 <printint>
        i += 1;
 77e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 780:	8bca                	mv	s7,s2
      state = 0;
 782:	4981                	li	s3,0
        i += 1;
 784:	bdbd                	j	602 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
 786:	008b8913          	add	s2,s7,8
 78a:	4681                	li	a3,0
 78c:	4629                	li	a2,10
 78e:	000bb583          	ld	a1,0(s7)
 792:	855a                	mv	a0,s6
 794:	00000097          	auipc	ra,0x0
 798:	d7e080e7          	jalr	-642(ra) # 512 <printint>
        i += 2;
 79c:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 79e:	8bca                	mv	s7,s2
      state = 0;
 7a0:	4981                	li	s3,0
        i += 2;
 7a2:	b585                	j	602 <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7a4:	008b8913          	add	s2,s7,8
 7a8:	4681                	li	a3,0
 7aa:	4641                	li	a2,16
 7ac:	000be583          	lwu	a1,0(s7)
 7b0:	855a                	mv	a0,s6
 7b2:	00000097          	auipc	ra,0x0
 7b6:	d60080e7          	jalr	-672(ra) # 512 <printint>
 7ba:	8bca                	mv	s7,s2
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	b591                	j	602 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c0:	008b8913          	add	s2,s7,8
 7c4:	4681                	li	a3,0
 7c6:	4641                	li	a2,16
 7c8:	000bb583          	ld	a1,0(s7)
 7cc:	855a                	mv	a0,s6
 7ce:	00000097          	auipc	ra,0x0
 7d2:	d44080e7          	jalr	-700(ra) # 512 <printint>
        i += 1;
 7d6:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d8:	8bca                	mv	s7,s2
      state = 0;
 7da:	4981                	li	s3,0
        i += 1;
 7dc:	b51d                	j	602 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
 7de:	008b8d13          	add	s10,s7,8
 7e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7e6:	03000593          	li	a1,48
 7ea:	855a                	mv	a0,s6
 7ec:	00000097          	auipc	ra,0x0
 7f0:	d04080e7          	jalr	-764(ra) # 4f0 <putc>
  putc(fd, 'x');
 7f4:	07800593          	li	a1,120
 7f8:	855a                	mv	a0,s6
 7fa:	00000097          	auipc	ra,0x0
 7fe:	cf6080e7          	jalr	-778(ra) # 4f0 <putc>
 802:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 804:	00000b97          	auipc	s7,0x0
 808:	294b8b93          	add	s7,s7,660 # a98 <digits>
 80c:	03c9d793          	srl	a5,s3,0x3c
 810:	97de                	add	a5,a5,s7
 812:	0007c583          	lbu	a1,0(a5)
 816:	855a                	mv	a0,s6
 818:	00000097          	auipc	ra,0x0
 81c:	cd8080e7          	jalr	-808(ra) # 4f0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 820:	0992                	sll	s3,s3,0x4
 822:	397d                	addw	s2,s2,-1
 824:	fe0914e3          	bnez	s2,80c <vprintf+0x25a>
        printptr(fd, va_arg(ap, uint64));
 828:	8bea                	mv	s7,s10
      state = 0;
 82a:	4981                	li	s3,0
 82c:	bbd9                	j	602 <vprintf+0x50>
        putc(fd, va_arg(ap, uint32));
 82e:	008b8913          	add	s2,s7,8
 832:	000bc583          	lbu	a1,0(s7)
 836:	855a                	mv	a0,s6
 838:	00000097          	auipc	ra,0x0
 83c:	cb8080e7          	jalr	-840(ra) # 4f0 <putc>
 840:	8bca                	mv	s7,s2
      state = 0;
 842:	4981                	li	s3,0
 844:	bb7d                	j	602 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
 846:	008b8993          	add	s3,s7,8
 84a:	000bb903          	ld	s2,0(s7)
 84e:	02090163          	beqz	s2,870 <vprintf+0x2be>
        for(; *s; s++)
 852:	00094583          	lbu	a1,0(s2)
 856:	c585                	beqz	a1,87e <vprintf+0x2cc>
          putc(fd, *s);
 858:	855a                	mv	a0,s6
 85a:	00000097          	auipc	ra,0x0
 85e:	c96080e7          	jalr	-874(ra) # 4f0 <putc>
        for(; *s; s++)
 862:	0905                	add	s2,s2,1
 864:	00094583          	lbu	a1,0(s2)
 868:	f9e5                	bnez	a1,858 <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
 86a:	8bce                	mv	s7,s3
      state = 0;
 86c:	4981                	li	s3,0
 86e:	bb51                	j	602 <vprintf+0x50>
          s = "(null)";
 870:	00000917          	auipc	s2,0x0
 874:	22090913          	add	s2,s2,544 # a90 <malloc+0x10a>
        for(; *s; s++)
 878:	02800593          	li	a1,40
 87c:	bff1                	j	858 <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
 87e:	8bce                	mv	s7,s3
      state = 0;
 880:	4981                	li	s3,0
 882:	b341                	j	602 <vprintf+0x50>
    }
  }
}
 884:	60e6                	ld	ra,88(sp)
 886:	6446                	ld	s0,80(sp)
 888:	64a6                	ld	s1,72(sp)
 88a:	6906                	ld	s2,64(sp)
 88c:	79e2                	ld	s3,56(sp)
 88e:	7a42                	ld	s4,48(sp)
 890:	7aa2                	ld	s5,40(sp)
 892:	7b02                	ld	s6,32(sp)
 894:	6be2                	ld	s7,24(sp)
 896:	6c42                	ld	s8,16(sp)
 898:	6ca2                	ld	s9,8(sp)
 89a:	6d02                	ld	s10,0(sp)
 89c:	6125                	add	sp,sp,96
 89e:	8082                	ret

00000000000008a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8a0:	715d                	add	sp,sp,-80
 8a2:	ec06                	sd	ra,24(sp)
 8a4:	e822                	sd	s0,16(sp)
 8a6:	1000                	add	s0,sp,32
 8a8:	e010                	sd	a2,0(s0)
 8aa:	e414                	sd	a3,8(s0)
 8ac:	e818                	sd	a4,16(s0)
 8ae:	ec1c                	sd	a5,24(s0)
 8b0:	03043023          	sd	a6,32(s0)
 8b4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8b8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8bc:	8622                	mv	a2,s0
 8be:	00000097          	auipc	ra,0x0
 8c2:	cf4080e7          	jalr	-780(ra) # 5b2 <vprintf>
}
 8c6:	60e2                	ld	ra,24(sp)
 8c8:	6442                	ld	s0,16(sp)
 8ca:	6161                	add	sp,sp,80
 8cc:	8082                	ret

00000000000008ce <printf>:

void
printf(const char *fmt, ...)
{
 8ce:	711d                	add	sp,sp,-96
 8d0:	ec06                	sd	ra,24(sp)
 8d2:	e822                	sd	s0,16(sp)
 8d4:	1000                	add	s0,sp,32
 8d6:	e40c                	sd	a1,8(s0)
 8d8:	e810                	sd	a2,16(s0)
 8da:	ec14                	sd	a3,24(s0)
 8dc:	f018                	sd	a4,32(s0)
 8de:	f41c                	sd	a5,40(s0)
 8e0:	03043823          	sd	a6,48(s0)
 8e4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8e8:	00840613          	add	a2,s0,8
 8ec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8f0:	85aa                	mv	a1,a0
 8f2:	4505                	li	a0,1
 8f4:	00000097          	auipc	ra,0x0
 8f8:	cbe080e7          	jalr	-834(ra) # 5b2 <vprintf>
}
 8fc:	60e2                	ld	ra,24(sp)
 8fe:	6442                	ld	s0,16(sp)
 900:	6125                	add	sp,sp,96
 902:	8082                	ret

0000000000000904 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 904:	1141                	add	sp,sp,-16
 906:	e422                	sd	s0,8(sp)
 908:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 90a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90e:	00000797          	auipc	a5,0x0
 912:	6f27b783          	ld	a5,1778(a5) # 1000 <freep>
 916:	a02d                	j	940 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 918:	4618                	lw	a4,8(a2)
 91a:	9f2d                	addw	a4,a4,a1
 91c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 920:	6398                	ld	a4,0(a5)
 922:	6310                	ld	a2,0(a4)
 924:	a83d                	j	962 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 926:	ff852703          	lw	a4,-8(a0)
 92a:	9f31                	addw	a4,a4,a2
 92c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 92e:	ff053683          	ld	a3,-16(a0)
 932:	a091                	j	976 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 934:	6398                	ld	a4,0(a5)
 936:	00e7e463          	bltu	a5,a4,93e <free+0x3a>
 93a:	00e6ea63          	bltu	a3,a4,94e <free+0x4a>
{
 93e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 940:	fed7fae3          	bgeu	a5,a3,934 <free+0x30>
 944:	6398                	ld	a4,0(a5)
 946:	00e6e463          	bltu	a3,a4,94e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94a:	fee7eae3          	bltu	a5,a4,93e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 94e:	ff852583          	lw	a1,-8(a0)
 952:	6390                	ld	a2,0(a5)
 954:	02059813          	sll	a6,a1,0x20
 958:	01c85713          	srl	a4,a6,0x1c
 95c:	9736                	add	a4,a4,a3
 95e:	fae60de3          	beq	a2,a4,918 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 962:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 966:	4790                	lw	a2,8(a5)
 968:	02061593          	sll	a1,a2,0x20
 96c:	01c5d713          	srl	a4,a1,0x1c
 970:	973e                	add	a4,a4,a5
 972:	fae68ae3          	beq	a3,a4,926 <free+0x22>
    p->s.ptr = bp->s.ptr;
 976:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 978:	00000717          	auipc	a4,0x0
 97c:	68f73423          	sd	a5,1672(a4) # 1000 <freep>
}
 980:	6422                	ld	s0,8(sp)
 982:	0141                	add	sp,sp,16
 984:	8082                	ret

0000000000000986 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 986:	7139                	add	sp,sp,-64
 988:	fc06                	sd	ra,56(sp)
 98a:	f822                	sd	s0,48(sp)
 98c:	f426                	sd	s1,40(sp)
 98e:	f04a                	sd	s2,32(sp)
 990:	ec4e                	sd	s3,24(sp)
 992:	e852                	sd	s4,16(sp)
 994:	e456                	sd	s5,8(sp)
 996:	e05a                	sd	s6,0(sp)
 998:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 99a:	02051493          	sll	s1,a0,0x20
 99e:	9081                	srl	s1,s1,0x20
 9a0:	04bd                	add	s1,s1,15
 9a2:	8091                	srl	s1,s1,0x4
 9a4:	0014899b          	addw	s3,s1,1
 9a8:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 9aa:	00000517          	auipc	a0,0x0
 9ae:	65653503          	ld	a0,1622(a0) # 1000 <freep>
 9b2:	c515                	beqz	a0,9de <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b6:	4798                	lw	a4,8(a5)
 9b8:	02977f63          	bgeu	a4,s1,9f6 <malloc+0x70>
  if(nu < 4096)
 9bc:	8a4e                	mv	s4,s3
 9be:	0009871b          	sext.w	a4,s3
 9c2:	6685                	lui	a3,0x1
 9c4:	00d77363          	bgeu	a4,a3,9ca <malloc+0x44>
 9c8:	6a05                	lui	s4,0x1
 9ca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ce:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d2:	00000917          	auipc	s2,0x0
 9d6:	62e90913          	add	s2,s2,1582 # 1000 <freep>
  if(p == SBRK_ERROR)
 9da:	5afd                	li	s5,-1
 9dc:	a895                	j	a50 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 9de:	00000797          	auipc	a5,0x0
 9e2:	63278793          	add	a5,a5,1586 # 1010 <base>
 9e6:	00000717          	auipc	a4,0x0
 9ea:	60f73d23          	sd	a5,1562(a4) # 1000 <freep>
 9ee:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9f4:	b7e1                	j	9bc <malloc+0x36>
      if(p->s.size == nunits)
 9f6:	02e48c63          	beq	s1,a4,a2e <malloc+0xa8>
        p->s.size -= nunits;
 9fa:	4137073b          	subw	a4,a4,s3
 9fe:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a00:	02071693          	sll	a3,a4,0x20
 a04:	01c6d713          	srl	a4,a3,0x1c
 a08:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a0a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a0e:	00000717          	auipc	a4,0x0
 a12:	5ea73923          	sd	a0,1522(a4) # 1000 <freep>
      return (void*)(p + 1);
 a16:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a1a:	70e2                	ld	ra,56(sp)
 a1c:	7442                	ld	s0,48(sp)
 a1e:	74a2                	ld	s1,40(sp)
 a20:	7902                	ld	s2,32(sp)
 a22:	69e2                	ld	s3,24(sp)
 a24:	6a42                	ld	s4,16(sp)
 a26:	6aa2                	ld	s5,8(sp)
 a28:	6b02                	ld	s6,0(sp)
 a2a:	6121                	add	sp,sp,64
 a2c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a2e:	6398                	ld	a4,0(a5)
 a30:	e118                	sd	a4,0(a0)
 a32:	bff1                	j	a0e <malloc+0x88>
  hp->s.size = nu;
 a34:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a38:	0541                	add	a0,a0,16
 a3a:	00000097          	auipc	ra,0x0
 a3e:	eca080e7          	jalr	-310(ra) # 904 <free>
  return freep;
 a42:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a46:	d971                	beqz	a0,a1a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a48:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a4a:	4798                	lw	a4,8(a5)
 a4c:	fa9775e3          	bgeu	a4,s1,9f6 <malloc+0x70>
    if(p == freep)
 a50:	00093703          	ld	a4,0(s2)
 a54:	853e                	mv	a0,a5
 a56:	fef719e3          	bne	a4,a5,a48 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 a5a:	8552                	mv	a0,s4
 a5c:	00000097          	auipc	ra,0x0
 a60:	938080e7          	jalr	-1736(ra) # 394 <sbrk>
  if(p == SBRK_ERROR)
 a64:	fd5518e3          	bne	a0,s5,a34 <malloc+0xae>
        return 0;
 a68:	4501                	li	a0,0
 a6a:	bf45                	j	a1a <malloc+0x94>
