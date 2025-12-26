
user/_shell:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	add	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	add	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	40e58593          	add	a1,a1,1038 # 1420 <malloc+0xec>
      1a:	4509                	li	a0,2
      1c:	00001097          	auipc	ra,0x1
      20:	e3a080e7          	jalr	-454(ra) # e56 <write>
  memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	b6c080e7          	jalr	-1172(ra) # b96 <memset>
  gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	ba6080e7          	jalr	-1114(ra) # bdc <gets>
  if(buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      46:	40a00533          	neg	a0,a0
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	64a2                	ld	s1,8(sp)
      50:	6902                	ld	s2,0(sp)
      52:	6105                	add	sp,sp,32
      54:	8082                	ret

0000000000000056 <panic>:
  exit(0);
}

void
panic(char *s)
{
      56:	1141                	add	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	add	s0,sp,16
      5e:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      60:	00001597          	auipc	a1,0x1
      64:	3c858593          	add	a1,a1,968 # 1428 <malloc+0xf4>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	1e4080e7          	jalr	484(ra) # 124e <fprintf>
  exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	daa080e7          	jalr	-598(ra) # e1e <exit>

000000000000007c <fork1>:
}

int
fork1(void)
{
      7c:	1141                	add	sp,sp,-16
      7e:	e406                	sd	ra,8(sp)
      80:	e022                	sd	s0,0(sp)
      82:	0800                	add	s0,sp,16
  int pid;

  pid = fork();
      84:	00001097          	auipc	ra,0x1
      88:	d92080e7          	jalr	-622(ra) # e16 <fork>
  if(pid == -1)
      8c:	57fd                	li	a5,-1
      8e:	00f50663          	beq	a0,a5,9a <fork1+0x1e>
    panic("fork");
  return pid;
}
      92:	60a2                	ld	ra,8(sp)
      94:	6402                	ld	s0,0(sp)
      96:	0141                	add	sp,sp,16
      98:	8082                	ret
    panic("fork");
      9a:	00001517          	auipc	a0,0x1
      9e:	39650513          	add	a0,a0,918 # 1430 <malloc+0xfc>
      a2:	00000097          	auipc	ra,0x0
      a6:	fb4080e7          	jalr	-76(ra) # 56 <panic>

00000000000000aa <runcmd>:
{
      aa:	1101                	add	sp,sp,-32
      ac:	ec06                	sd	ra,24(sp)
      ae:	e822                	sd	s0,16(sp)
      b0:	e426                	sd	s1,8(sp)
      b2:	1000                	add	s0,sp,32
  if(cmd == 0)
      b4:	c121                	beqz	a0,f4 <runcmd+0x4a>
      b6:	84aa                	mv	s1,a0
  switch(cmd->type){
      b8:	411c                	lw	a5,0(a0)
      ba:	4711                	li	a4,4
      bc:	0ce78163          	beq	a5,a4,17e <runcmd+0xd4>
      c0:	02f74f63          	blt	a4,a5,fe <runcmd+0x54>
      c4:	4705                	li	a4,1
      c6:	06e78163          	beq	a5,a4,128 <runcmd+0x7e>
      ca:	4709                	li	a4,2
      cc:	04e79663          	bne	a5,a4,118 <runcmd+0x6e>
    close(rcmd->fd);
      d0:	5148                	lw	a0,36(a0)
      d2:	00001097          	auipc	ra,0x1
      d6:	d64080e7          	jalr	-668(ra) # e36 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      da:	508c                	lw	a1,32(s1)
      dc:	6888                	ld	a0,16(s1)
      de:	00001097          	auipc	ra,0x1
      e2:	d60080e7          	jalr	-672(ra) # e3e <open>
      e6:	06054d63          	bltz	a0,160 <runcmd+0xb6>
    runcmd(rcmd->cmd);
      ea:	6488                	ld	a0,8(s1)
      ec:	00000097          	auipc	ra,0x0
      f0:	fbe080e7          	jalr	-66(ra) # aa <runcmd>
    exit(1);
      f4:	4505                	li	a0,1
      f6:	00001097          	auipc	ra,0x1
      fa:	d28080e7          	jalr	-728(ra) # e1e <exit>
  switch(cmd->type){
      fe:	4715                	li	a4,5
     100:	00e79c63          	bne	a5,a4,118 <runcmd+0x6e>
    if(fork1() == 0)
     104:	00000097          	auipc	ra,0x0
     108:	f78080e7          	jalr	-136(ra) # 7c <fork1>
     10c:	e121                	bnez	a0,14c <runcmd+0xa2>
      runcmd(bcmd->cmd);
     10e:	6488                	ld	a0,8(s1)
     110:	00000097          	auipc	ra,0x0
     114:	f9a080e7          	jalr	-102(ra) # aa <runcmd>
    panic("runcmd");
     118:	00001517          	auipc	a0,0x1
     11c:	32050513          	add	a0,a0,800 # 1438 <malloc+0x104>
     120:	00000097          	auipc	ra,0x0
     124:	f36080e7          	jalr	-202(ra) # 56 <panic>
    if(ecmd->argv[0] == 0)
     128:	6508                	ld	a0,8(a0)
     12a:	c515                	beqz	a0,156 <runcmd+0xac>
    exec(ecmd->argv[0], ecmd->argv);
     12c:	00848593          	add	a1,s1,8
     130:	00001097          	auipc	ra,0x1
     134:	d16080e7          	jalr	-746(ra) # e46 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     138:	6490                	ld	a2,8(s1)
     13a:	00001597          	auipc	a1,0x1
     13e:	30658593          	add	a1,a1,774 # 1440 <malloc+0x10c>
     142:	4509                	li	a0,2
     144:	00001097          	auipc	ra,0x1
     148:	10a080e7          	jalr	266(ra) # 124e <fprintf>
  exit(0);
     14c:	4501                	li	a0,0
     14e:	00001097          	auipc	ra,0x1
     152:	cd0080e7          	jalr	-816(ra) # e1e <exit>
      exit(1);
     156:	4505                	li	a0,1
     158:	00001097          	auipc	ra,0x1
     15c:	cc6080e7          	jalr	-826(ra) # e1e <exit>
      fprintf(2, "open %s failed\n", rcmd->file);
     160:	6890                	ld	a2,16(s1)
     162:	00001597          	auipc	a1,0x1
     166:	2ee58593          	add	a1,a1,750 # 1450 <malloc+0x11c>
     16a:	4509                	li	a0,2
     16c:	00001097          	auipc	ra,0x1
     170:	0e2080e7          	jalr	226(ra) # 124e <fprintf>
      exit(1);
     174:	4505                	li	a0,1
     176:	00001097          	auipc	ra,0x1
     17a:	ca8080e7          	jalr	-856(ra) # e1e <exit>
    if(fork1() == 0)
     17e:	00000097          	auipc	ra,0x0
     182:	efe080e7          	jalr	-258(ra) # 7c <fork1>
     186:	e511                	bnez	a0,192 <runcmd+0xe8>
      runcmd(lcmd->left);
     188:	6488                	ld	a0,8(s1)
     18a:	00000097          	auipc	ra,0x0
     18e:	f20080e7          	jalr	-224(ra) # aa <runcmd>
    wait(0);
     192:	4501                	li	a0,0
     194:	00001097          	auipc	ra,0x1
     198:	c92080e7          	jalr	-878(ra) # e26 <wait>
    runcmd(lcmd->right);
     19c:	6888                	ld	a0,16(s1)
     19e:	00000097          	auipc	ra,0x0
     1a2:	f0c080e7          	jalr	-244(ra) # aa <runcmd>

00000000000001a6 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1a6:	1101                	add	sp,sp,-32
     1a8:	ec06                	sd	ra,24(sp)
     1aa:	e822                	sd	s0,16(sp)
     1ac:	e426                	sd	s1,8(sp)
     1ae:	1000                	add	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1b0:	0a800513          	li	a0,168
     1b4:	00001097          	auipc	ra,0x1
     1b8:	180080e7          	jalr	384(ra) # 1334 <malloc>
     1bc:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1be:	0a800613          	li	a2,168
     1c2:	4581                	li	a1,0
     1c4:	00001097          	auipc	ra,0x1
     1c8:	9d2080e7          	jalr	-1582(ra) # b96 <memset>
  cmd->type = EXEC;
     1cc:	4785                	li	a5,1
     1ce:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1d0:	8526                	mv	a0,s1
     1d2:	60e2                	ld	ra,24(sp)
     1d4:	6442                	ld	s0,16(sp)
     1d6:	64a2                	ld	s1,8(sp)
     1d8:	6105                	add	sp,sp,32
     1da:	8082                	ret

00000000000001dc <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     1dc:	7139                	add	sp,sp,-64
     1de:	fc06                	sd	ra,56(sp)
     1e0:	f822                	sd	s0,48(sp)
     1e2:	f426                	sd	s1,40(sp)
     1e4:	f04a                	sd	s2,32(sp)
     1e6:	ec4e                	sd	s3,24(sp)
     1e8:	e852                	sd	s4,16(sp)
     1ea:	e456                	sd	s5,8(sp)
     1ec:	e05a                	sd	s6,0(sp)
     1ee:	0080                	add	s0,sp,64
     1f0:	8b2a                	mv	s6,a0
     1f2:	8aae                	mv	s5,a1
     1f4:	8a32                	mv	s4,a2
     1f6:	89b6                	mv	s3,a3
     1f8:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1fa:	02800513          	li	a0,40
     1fe:	00001097          	auipc	ra,0x1
     202:	136080e7          	jalr	310(ra) # 1334 <malloc>
     206:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     208:	02800613          	li	a2,40
     20c:	4581                	li	a1,0
     20e:	00001097          	auipc	ra,0x1
     212:	988080e7          	jalr	-1656(ra) # b96 <memset>
  cmd->type = REDIR;
     216:	4789                	li	a5,2
     218:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     21a:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     21e:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     222:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     226:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     22a:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     22e:	8526                	mv	a0,s1
     230:	70e2                	ld	ra,56(sp)
     232:	7442                	ld	s0,48(sp)
     234:	74a2                	ld	s1,40(sp)
     236:	7902                	ld	s2,32(sp)
     238:	69e2                	ld	s3,24(sp)
     23a:	6a42                	ld	s4,16(sp)
     23c:	6aa2                	ld	s5,8(sp)
     23e:	6b02                	ld	s6,0(sp)
     240:	6121                	add	sp,sp,64
     242:	8082                	ret

0000000000000244 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     244:	7179                	add	sp,sp,-48
     246:	f406                	sd	ra,40(sp)
     248:	f022                	sd	s0,32(sp)
     24a:	ec26                	sd	s1,24(sp)
     24c:	e84a                	sd	s2,16(sp)
     24e:	e44e                	sd	s3,8(sp)
     250:	1800                	add	s0,sp,48
     252:	89aa                	mv	s3,a0
     254:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     256:	4561                	li	a0,24
     258:	00001097          	auipc	ra,0x1
     25c:	0dc080e7          	jalr	220(ra) # 1334 <malloc>
     260:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     262:	4661                	li	a2,24
     264:	4581                	li	a1,0
     266:	00001097          	auipc	ra,0x1
     26a:	930080e7          	jalr	-1744(ra) # b96 <memset>
  cmd->type = PIPE;
     26e:	478d                	li	a5,3
     270:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     272:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     276:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     27a:	8526                	mv	a0,s1
     27c:	70a2                	ld	ra,40(sp)
     27e:	7402                	ld	s0,32(sp)
     280:	64e2                	ld	s1,24(sp)
     282:	6942                	ld	s2,16(sp)
     284:	69a2                	ld	s3,8(sp)
     286:	6145                	add	sp,sp,48
     288:	8082                	ret

000000000000028a <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     28a:	7179                	add	sp,sp,-48
     28c:	f406                	sd	ra,40(sp)
     28e:	f022                	sd	s0,32(sp)
     290:	ec26                	sd	s1,24(sp)
     292:	e84a                	sd	s2,16(sp)
     294:	e44e                	sd	s3,8(sp)
     296:	1800                	add	s0,sp,48
     298:	89aa                	mv	s3,a0
     29a:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     29c:	4561                	li	a0,24
     29e:	00001097          	auipc	ra,0x1
     2a2:	096080e7          	jalr	150(ra) # 1334 <malloc>
     2a6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2a8:	4661                	li	a2,24
     2aa:	4581                	li	a1,0
     2ac:	00001097          	auipc	ra,0x1
     2b0:	8ea080e7          	jalr	-1814(ra) # b96 <memset>
  cmd->type = LIST;
     2b4:	4791                	li	a5,4
     2b6:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2b8:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     2bc:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     2c0:	8526                	mv	a0,s1
     2c2:	70a2                	ld	ra,40(sp)
     2c4:	7402                	ld	s0,32(sp)
     2c6:	64e2                	ld	s1,24(sp)
     2c8:	6942                	ld	s2,16(sp)
     2ca:	69a2                	ld	s3,8(sp)
     2cc:	6145                	add	sp,sp,48
     2ce:	8082                	ret

00000000000002d0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2d0:	1101                	add	sp,sp,-32
     2d2:	ec06                	sd	ra,24(sp)
     2d4:	e822                	sd	s0,16(sp)
     2d6:	e426                	sd	s1,8(sp)
     2d8:	e04a                	sd	s2,0(sp)
     2da:	1000                	add	s0,sp,32
     2dc:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2de:	4541                	li	a0,16
     2e0:	00001097          	auipc	ra,0x1
     2e4:	054080e7          	jalr	84(ra) # 1334 <malloc>
     2e8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2ea:	4641                	li	a2,16
     2ec:	4581                	li	a1,0
     2ee:	00001097          	auipc	ra,0x1
     2f2:	8a8080e7          	jalr	-1880(ra) # b96 <memset>
  cmd->type = BACK;
     2f6:	4795                	li	a5,5
     2f8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fa:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     2fe:	8526                	mv	a0,s1
     300:	60e2                	ld	ra,24(sp)
     302:	6442                	ld	s0,16(sp)
     304:	64a2                	ld	s1,8(sp)
     306:	6902                	ld	s2,0(sp)
     308:	6105                	add	sp,sp,32
     30a:	8082                	ret

000000000000030c <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     30c:	7139                	add	sp,sp,-64
     30e:	fc06                	sd	ra,56(sp)
     310:	f822                	sd	s0,48(sp)
     312:	f426                	sd	s1,40(sp)
     314:	f04a                	sd	s2,32(sp)
     316:	ec4e                	sd	s3,24(sp)
     318:	e852                	sd	s4,16(sp)
     31a:	e456                	sd	s5,8(sp)
     31c:	e05a                	sd	s6,0(sp)
     31e:	0080                	add	s0,sp,64
     320:	8a2a                	mv	s4,a0
     322:	892e                	mv	s2,a1
     324:	8ab2                	mv	s5,a2
     326:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     328:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32a:	00002997          	auipc	s3,0x2
     32e:	cde98993          	add	s3,s3,-802 # 2008 <whitespace>
     332:	00b4fe63          	bgeu	s1,a1,34e <gettoken+0x42>
     336:	0004c583          	lbu	a1,0(s1)
     33a:	854e                	mv	a0,s3
     33c:	00001097          	auipc	ra,0x1
     340:	87c080e7          	jalr	-1924(ra) # bb8 <strchr>
     344:	c509                	beqz	a0,34e <gettoken+0x42>
    s++;
     346:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     348:	fe9917e3          	bne	s2,s1,336 <gettoken+0x2a>
    s++;
     34c:	84ca                	mv	s1,s2
  if(q)
     34e:	000a8463          	beqz	s5,356 <gettoken+0x4a>
    *q = s;
     352:	009ab023          	sd	s1,0(s5)
  ret = *s;
     356:	0004c783          	lbu	a5,0(s1)
     35a:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35e:	03c00713          	li	a4,60
     362:	06f76663          	bltu	a4,a5,3ce <gettoken+0xc2>
     366:	03a00713          	li	a4,58
     36a:	00f76e63          	bltu	a4,a5,386 <gettoken+0x7a>
     36e:	cf89                	beqz	a5,388 <gettoken+0x7c>
     370:	02600713          	li	a4,38
     374:	00e78963          	beq	a5,a4,386 <gettoken+0x7a>
     378:	fd87879b          	addw	a5,a5,-40
     37c:	0ff7f793          	zext.b	a5,a5
     380:	4705                	li	a4,1
     382:	06f76d63          	bltu	a4,a5,3fc <gettoken+0xf0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     386:	0485                	add	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     388:	000b0463          	beqz	s6,390 <gettoken+0x84>
    *eq = s;
     38c:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     390:	00002997          	auipc	s3,0x2
     394:	c7898993          	add	s3,s3,-904 # 2008 <whitespace>
     398:	0124fe63          	bgeu	s1,s2,3b4 <gettoken+0xa8>
     39c:	0004c583          	lbu	a1,0(s1)
     3a0:	854e                	mv	a0,s3
     3a2:	00001097          	auipc	ra,0x1
     3a6:	816080e7          	jalr	-2026(ra) # bb8 <strchr>
     3aa:	c509                	beqz	a0,3b4 <gettoken+0xa8>
    s++;
     3ac:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3ae:	fe9917e3          	bne	s2,s1,39c <gettoken+0x90>
    s++;
     3b2:	84ca                	mv	s1,s2
  *ps = s;
     3b4:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3b8:	8556                	mv	a0,s5
     3ba:	70e2                	ld	ra,56(sp)
     3bc:	7442                	ld	s0,48(sp)
     3be:	74a2                	ld	s1,40(sp)
     3c0:	7902                	ld	s2,32(sp)
     3c2:	69e2                	ld	s3,24(sp)
     3c4:	6a42                	ld	s4,16(sp)
     3c6:	6aa2                	ld	s5,8(sp)
     3c8:	6b02                	ld	s6,0(sp)
     3ca:	6121                	add	sp,sp,64
     3cc:	8082                	ret
  switch(*s){
     3ce:	03e00713          	li	a4,62
     3d2:	02e79163          	bne	a5,a4,3f4 <gettoken+0xe8>
    s++;
     3d6:	00148693          	add	a3,s1,1
    if(*s == '>'){
     3da:	0014c703          	lbu	a4,1(s1)
     3de:	03e00793          	li	a5,62
      s++;
     3e2:	0489                	add	s1,s1,2
      ret = '+';
     3e4:	02b00a93          	li	s5,43
    if(*s == '>'){
     3e8:	faf700e3          	beq	a4,a5,388 <gettoken+0x7c>
    s++;
     3ec:	84b6                	mv	s1,a3
  ret = *s;
     3ee:	03e00a93          	li	s5,62
     3f2:	bf59                	j	388 <gettoken+0x7c>
  switch(*s){
     3f4:	07c00713          	li	a4,124
     3f8:	f8e787e3          	beq	a5,a4,386 <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3fc:	00002997          	auipc	s3,0x2
     400:	c0c98993          	add	s3,s3,-1012 # 2008 <whitespace>
     404:	00002a97          	auipc	s5,0x2
     408:	bfca8a93          	add	s5,s5,-1028 # 2000 <symbols>
     40c:	0524f163          	bgeu	s1,s2,44e <gettoken+0x142>
     410:	0004c583          	lbu	a1,0(s1)
     414:	854e                	mv	a0,s3
     416:	00000097          	auipc	ra,0x0
     41a:	7a2080e7          	jalr	1954(ra) # bb8 <strchr>
     41e:	e50d                	bnez	a0,448 <gettoken+0x13c>
     420:	0004c583          	lbu	a1,0(s1)
     424:	8556                	mv	a0,s5
     426:	00000097          	auipc	ra,0x0
     42a:	792080e7          	jalr	1938(ra) # bb8 <strchr>
     42e:	e911                	bnez	a0,442 <gettoken+0x136>
      s++;
     430:	0485                	add	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     432:	fc991fe3          	bne	s2,s1,410 <gettoken+0x104>
      s++;
     436:	84ca                	mv	s1,s2
    ret = 'a';
     438:	06100a93          	li	s5,97
  if(eq)
     43c:	f40b18e3          	bnez	s6,38c <gettoken+0x80>
     440:	bf95                	j	3b4 <gettoken+0xa8>
    ret = 'a';
     442:	06100a93          	li	s5,97
     446:	b789                	j	388 <gettoken+0x7c>
     448:	06100a93          	li	s5,97
     44c:	bf35                	j	388 <gettoken+0x7c>
     44e:	06100a93          	li	s5,97
  if(eq)
     452:	f20b1de3          	bnez	s6,38c <gettoken+0x80>
     456:	bfb9                	j	3b4 <gettoken+0xa8>

0000000000000458 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     458:	7139                	add	sp,sp,-64
     45a:	fc06                	sd	ra,56(sp)
     45c:	f822                	sd	s0,48(sp)
     45e:	f426                	sd	s1,40(sp)
     460:	f04a                	sd	s2,32(sp)
     462:	ec4e                	sd	s3,24(sp)
     464:	e852                	sd	s4,16(sp)
     466:	e456                	sd	s5,8(sp)
     468:	0080                	add	s0,sp,64
     46a:	8a2a                	mv	s4,a0
     46c:	892e                	mv	s2,a1
     46e:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     470:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     472:	00002997          	auipc	s3,0x2
     476:	b9698993          	add	s3,s3,-1130 # 2008 <whitespace>
     47a:	00b4fe63          	bgeu	s1,a1,496 <peek+0x3e>
     47e:	0004c583          	lbu	a1,0(s1)
     482:	854e                	mv	a0,s3
     484:	00000097          	auipc	ra,0x0
     488:	734080e7          	jalr	1844(ra) # bb8 <strchr>
     48c:	c509                	beqz	a0,496 <peek+0x3e>
    s++;
     48e:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     490:	fe9917e3          	bne	s2,s1,47e <peek+0x26>
    s++;
     494:	84ca                	mv	s1,s2
  *ps = s;
     496:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     49a:	0004c583          	lbu	a1,0(s1)
     49e:	4501                	li	a0,0
     4a0:	e991                	bnez	a1,4b4 <peek+0x5c>
}
     4a2:	70e2                	ld	ra,56(sp)
     4a4:	7442                	ld	s0,48(sp)
     4a6:	74a2                	ld	s1,40(sp)
     4a8:	7902                	ld	s2,32(sp)
     4aa:	69e2                	ld	s3,24(sp)
     4ac:	6a42                	ld	s4,16(sp)
     4ae:	6aa2                	ld	s5,8(sp)
     4b0:	6121                	add	sp,sp,64
     4b2:	8082                	ret
  return *s && strchr(toks, *s);
     4b4:	8556                	mv	a0,s5
     4b6:	00000097          	auipc	ra,0x0
     4ba:	702080e7          	jalr	1794(ra) # bb8 <strchr>
     4be:	00a03533          	snez	a0,a0
     4c2:	b7c5                	j	4a2 <peek+0x4a>

00000000000004c4 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4c4:	7159                	add	sp,sp,-112
     4c6:	f486                	sd	ra,104(sp)
     4c8:	f0a2                	sd	s0,96(sp)
     4ca:	eca6                	sd	s1,88(sp)
     4cc:	e8ca                	sd	s2,80(sp)
     4ce:	e4ce                	sd	s3,72(sp)
     4d0:	e0d2                	sd	s4,64(sp)
     4d2:	fc56                	sd	s5,56(sp)
     4d4:	f85a                	sd	s6,48(sp)
     4d6:	f45e                	sd	s7,40(sp)
     4d8:	f062                	sd	s8,32(sp)
     4da:	ec66                	sd	s9,24(sp)
     4dc:	1880                	add	s0,sp,112
     4de:	8a2a                	mv	s4,a0
     4e0:	89ae                	mv	s3,a1
     4e2:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4e4:	00001b97          	auipc	s7,0x1
     4e8:	f9cb8b93          	add	s7,s7,-100 # 1480 <malloc+0x14c>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4ec:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     4f0:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     4f4:	a02d                	j	51e <parseredirs+0x5a>
      panic("missing file for redirection");
     4f6:	00001517          	auipc	a0,0x1
     4fa:	f6a50513          	add	a0,a0,-150 # 1460 <malloc+0x12c>
     4fe:	00000097          	auipc	ra,0x0
     502:	b58080e7          	jalr	-1192(ra) # 56 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     506:	4701                	li	a4,0
     508:	4681                	li	a3,0
     50a:	f9043603          	ld	a2,-112(s0)
     50e:	f9843583          	ld	a1,-104(s0)
     512:	8552                	mv	a0,s4
     514:	00000097          	auipc	ra,0x0
     518:	cc8080e7          	jalr	-824(ra) # 1dc <redircmd>
     51c:	8a2a                	mv	s4,a0
    switch(tok){
     51e:	03e00b13          	li	s6,62
     522:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     526:	865e                	mv	a2,s7
     528:	85ca                	mv	a1,s2
     52a:	854e                	mv	a0,s3
     52c:	00000097          	auipc	ra,0x0
     530:	f2c080e7          	jalr	-212(ra) # 458 <peek>
     534:	c925                	beqz	a0,5a4 <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     536:	4681                	li	a3,0
     538:	4601                	li	a2,0
     53a:	85ca                	mv	a1,s2
     53c:	854e                	mv	a0,s3
     53e:	00000097          	auipc	ra,0x0
     542:	dce080e7          	jalr	-562(ra) # 30c <gettoken>
     546:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     548:	f9040693          	add	a3,s0,-112
     54c:	f9840613          	add	a2,s0,-104
     550:	85ca                	mv	a1,s2
     552:	854e                	mv	a0,s3
     554:	00000097          	auipc	ra,0x0
     558:	db8080e7          	jalr	-584(ra) # 30c <gettoken>
     55c:	f9851de3          	bne	a0,s8,4f6 <parseredirs+0x32>
    switch(tok){
     560:	fb9483e3          	beq	s1,s9,506 <parseredirs+0x42>
     564:	03648263          	beq	s1,s6,588 <parseredirs+0xc4>
     568:	fb549fe3          	bne	s1,s5,526 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     56c:	4705                	li	a4,1
     56e:	20100693          	li	a3,513
     572:	f9043603          	ld	a2,-112(s0)
     576:	f9843583          	ld	a1,-104(s0)
     57a:	8552                	mv	a0,s4
     57c:	00000097          	auipc	ra,0x0
     580:	c60080e7          	jalr	-928(ra) # 1dc <redircmd>
     584:	8a2a                	mv	s4,a0
      break;
     586:	bf61                	j	51e <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     588:	4705                	li	a4,1
     58a:	60100693          	li	a3,1537
     58e:	f9043603          	ld	a2,-112(s0)
     592:	f9843583          	ld	a1,-104(s0)
     596:	8552                	mv	a0,s4
     598:	00000097          	auipc	ra,0x0
     59c:	c44080e7          	jalr	-956(ra) # 1dc <redircmd>
     5a0:	8a2a                	mv	s4,a0
      break;
     5a2:	bfb5                	j	51e <parseredirs+0x5a>
    }
  }
  return cmd;
}
     5a4:	8552                	mv	a0,s4
     5a6:	70a6                	ld	ra,104(sp)
     5a8:	7406                	ld	s0,96(sp)
     5aa:	64e6                	ld	s1,88(sp)
     5ac:	6946                	ld	s2,80(sp)
     5ae:	69a6                	ld	s3,72(sp)
     5b0:	6a06                	ld	s4,64(sp)
     5b2:	7ae2                	ld	s5,56(sp)
     5b4:	7b42                	ld	s6,48(sp)
     5b6:	7ba2                	ld	s7,40(sp)
     5b8:	7c02                	ld	s8,32(sp)
     5ba:	6ce2                	ld	s9,24(sp)
     5bc:	6165                	add	sp,sp,112
     5be:	8082                	ret

00000000000005c0 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     5c0:	7159                	add	sp,sp,-112
     5c2:	f486                	sd	ra,104(sp)
     5c4:	f0a2                	sd	s0,96(sp)
     5c6:	eca6                	sd	s1,88(sp)
     5c8:	e8ca                	sd	s2,80(sp)
     5ca:	e4ce                	sd	s3,72(sp)
     5cc:	e0d2                	sd	s4,64(sp)
     5ce:	fc56                	sd	s5,56(sp)
     5d0:	f85a                	sd	s6,48(sp)
     5d2:	f45e                	sd	s7,40(sp)
     5d4:	f062                	sd	s8,32(sp)
     5d6:	ec66                	sd	s9,24(sp)
     5d8:	1880                	add	s0,sp,112
     5da:	8a2a                	mv	s4,a0
     5dc:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     5de:	00001617          	auipc	a2,0x1
     5e2:	eaa60613          	add	a2,a2,-342 # 1488 <malloc+0x154>
     5e6:	00000097          	auipc	ra,0x0
     5ea:	e72080e7          	jalr	-398(ra) # 458 <peek>
     5ee:	e905                	bnez	a0,61e <parseexec+0x5e>
     5f0:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     5f2:	00000097          	auipc	ra,0x0
     5f6:	bb4080e7          	jalr	-1100(ra) # 1a6 <execcmd>
     5fa:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5fc:	8656                	mv	a2,s5
     5fe:	85d2                	mv	a1,s4
     600:	00000097          	auipc	ra,0x0
     604:	ec4080e7          	jalr	-316(ra) # 4c4 <parseredirs>
     608:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     60a:	008c0913          	add	s2,s8,8
     60e:	00001b17          	auipc	s6,0x1
     612:	e9ab0b13          	add	s6,s6,-358 # 14a8 <malloc+0x174>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     616:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     61a:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     61c:	a0b1                	j	668 <parseexec+0xa8>
    return parseblock(ps, es);
     61e:	85d6                	mv	a1,s5
     620:	8552                	mv	a0,s4
     622:	00000097          	auipc	ra,0x0
     626:	1bc080e7          	jalr	444(ra) # 7de <parseblock>
     62a:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     62c:	8526                	mv	a0,s1
     62e:	70a6                	ld	ra,104(sp)
     630:	7406                	ld	s0,96(sp)
     632:	64e6                	ld	s1,88(sp)
     634:	6946                	ld	s2,80(sp)
     636:	69a6                	ld	s3,72(sp)
     638:	6a06                	ld	s4,64(sp)
     63a:	7ae2                	ld	s5,56(sp)
     63c:	7b42                	ld	s6,48(sp)
     63e:	7ba2                	ld	s7,40(sp)
     640:	7c02                	ld	s8,32(sp)
     642:	6ce2                	ld	s9,24(sp)
     644:	6165                	add	sp,sp,112
     646:	8082                	ret
      panic("syntax");
     648:	00001517          	auipc	a0,0x1
     64c:	e4850513          	add	a0,a0,-440 # 1490 <malloc+0x15c>
     650:	00000097          	auipc	ra,0x0
     654:	a06080e7          	jalr	-1530(ra) # 56 <panic>
    ret = parseredirs(ret, ps, es);
     658:	8656                	mv	a2,s5
     65a:	85d2                	mv	a1,s4
     65c:	8526                	mv	a0,s1
     65e:	00000097          	auipc	ra,0x0
     662:	e66080e7          	jalr	-410(ra) # 4c4 <parseredirs>
     666:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     668:	865a                	mv	a2,s6
     66a:	85d6                	mv	a1,s5
     66c:	8552                	mv	a0,s4
     66e:	00000097          	auipc	ra,0x0
     672:	dea080e7          	jalr	-534(ra) # 458 <peek>
     676:	e131                	bnez	a0,6ba <parseexec+0xfa>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     678:	f9040693          	add	a3,s0,-112
     67c:	f9840613          	add	a2,s0,-104
     680:	85d6                	mv	a1,s5
     682:	8552                	mv	a0,s4
     684:	00000097          	auipc	ra,0x0
     688:	c88080e7          	jalr	-888(ra) # 30c <gettoken>
     68c:	c51d                	beqz	a0,6ba <parseexec+0xfa>
    if(tok != 'a')
     68e:	fb951de3          	bne	a0,s9,648 <parseexec+0x88>
    cmd->argv[argc] = q;
     692:	f9843783          	ld	a5,-104(s0)
     696:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     69a:	f9043783          	ld	a5,-112(s0)
     69e:	04f93823          	sd	a5,80(s2)
    argc++;
     6a2:	2985                	addw	s3,s3,1
    if(argc >= MAXARGS)
     6a4:	0921                	add	s2,s2,8
     6a6:	fb7999e3          	bne	s3,s7,658 <parseexec+0x98>
      panic("too many args");
     6aa:	00001517          	auipc	a0,0x1
     6ae:	dee50513          	add	a0,a0,-530 # 1498 <malloc+0x164>
     6b2:	00000097          	auipc	ra,0x0
     6b6:	9a4080e7          	jalr	-1628(ra) # 56 <panic>
  cmd->argv[argc] = 0;
     6ba:	098e                	sll	s3,s3,0x3
     6bc:	9c4e                	add	s8,s8,s3
     6be:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     6c2:	040c3c23          	sd	zero,88(s8)
  return ret;
     6c6:	b79d                	j	62c <parseexec+0x6c>

00000000000006c8 <parsepipe>:
{
     6c8:	7179                	add	sp,sp,-48
     6ca:	f406                	sd	ra,40(sp)
     6cc:	f022                	sd	s0,32(sp)
     6ce:	ec26                	sd	s1,24(sp)
     6d0:	e84a                	sd	s2,16(sp)
     6d2:	e44e                	sd	s3,8(sp)
     6d4:	1800                	add	s0,sp,48
     6d6:	892a                	mv	s2,a0
     6d8:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     6da:	00000097          	auipc	ra,0x0
     6de:	ee6080e7          	jalr	-282(ra) # 5c0 <parseexec>
     6e2:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     6e4:	00001617          	auipc	a2,0x1
     6e8:	dcc60613          	add	a2,a2,-564 # 14b0 <malloc+0x17c>
     6ec:	85ce                	mv	a1,s3
     6ee:	854a                	mv	a0,s2
     6f0:	00000097          	auipc	ra,0x0
     6f4:	d68080e7          	jalr	-664(ra) # 458 <peek>
     6f8:	e909                	bnez	a0,70a <parsepipe+0x42>
}
     6fa:	8526                	mv	a0,s1
     6fc:	70a2                	ld	ra,40(sp)
     6fe:	7402                	ld	s0,32(sp)
     700:	64e2                	ld	s1,24(sp)
     702:	6942                	ld	s2,16(sp)
     704:	69a2                	ld	s3,8(sp)
     706:	6145                	add	sp,sp,48
     708:	8082                	ret
    gettoken(ps, es, 0, 0);
     70a:	4681                	li	a3,0
     70c:	4601                	li	a2,0
     70e:	85ce                	mv	a1,s3
     710:	854a                	mv	a0,s2
     712:	00000097          	auipc	ra,0x0
     716:	bfa080e7          	jalr	-1030(ra) # 30c <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     71a:	85ce                	mv	a1,s3
     71c:	854a                	mv	a0,s2
     71e:	00000097          	auipc	ra,0x0
     722:	faa080e7          	jalr	-86(ra) # 6c8 <parsepipe>
     726:	85aa                	mv	a1,a0
     728:	8526                	mv	a0,s1
     72a:	00000097          	auipc	ra,0x0
     72e:	b1a080e7          	jalr	-1254(ra) # 244 <pipecmd>
     732:	84aa                	mv	s1,a0
  return cmd;
     734:	b7d9                	j	6fa <parsepipe+0x32>

0000000000000736 <parseline>:
{
     736:	7179                	add	sp,sp,-48
     738:	f406                	sd	ra,40(sp)
     73a:	f022                	sd	s0,32(sp)
     73c:	ec26                	sd	s1,24(sp)
     73e:	e84a                	sd	s2,16(sp)
     740:	e44e                	sd	s3,8(sp)
     742:	e052                	sd	s4,0(sp)
     744:	1800                	add	s0,sp,48
     746:	892a                	mv	s2,a0
     748:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     74a:	00000097          	auipc	ra,0x0
     74e:	f7e080e7          	jalr	-130(ra) # 6c8 <parsepipe>
     752:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     754:	00001a17          	auipc	s4,0x1
     758:	d64a0a13          	add	s4,s4,-668 # 14b8 <malloc+0x184>
     75c:	a839                	j	77a <parseline+0x44>
    gettoken(ps, es, 0, 0);
     75e:	4681                	li	a3,0
     760:	4601                	li	a2,0
     762:	85ce                	mv	a1,s3
     764:	854a                	mv	a0,s2
     766:	00000097          	auipc	ra,0x0
     76a:	ba6080e7          	jalr	-1114(ra) # 30c <gettoken>
    cmd = backcmd(cmd);
     76e:	8526                	mv	a0,s1
     770:	00000097          	auipc	ra,0x0
     774:	b60080e7          	jalr	-1184(ra) # 2d0 <backcmd>
     778:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     77a:	8652                	mv	a2,s4
     77c:	85ce                	mv	a1,s3
     77e:	854a                	mv	a0,s2
     780:	00000097          	auipc	ra,0x0
     784:	cd8080e7          	jalr	-808(ra) # 458 <peek>
     788:	f979                	bnez	a0,75e <parseline+0x28>
  if(peek(ps, es, ";")){
     78a:	00001617          	auipc	a2,0x1
     78e:	d3660613          	add	a2,a2,-714 # 14c0 <malloc+0x18c>
     792:	85ce                	mv	a1,s3
     794:	854a                	mv	a0,s2
     796:	00000097          	auipc	ra,0x0
     79a:	cc2080e7          	jalr	-830(ra) # 458 <peek>
     79e:	e911                	bnez	a0,7b2 <parseline+0x7c>
}
     7a0:	8526                	mv	a0,s1
     7a2:	70a2                	ld	ra,40(sp)
     7a4:	7402                	ld	s0,32(sp)
     7a6:	64e2                	ld	s1,24(sp)
     7a8:	6942                	ld	s2,16(sp)
     7aa:	69a2                	ld	s3,8(sp)
     7ac:	6a02                	ld	s4,0(sp)
     7ae:	6145                	add	sp,sp,48
     7b0:	8082                	ret
    gettoken(ps, es, 0, 0);
     7b2:	4681                	li	a3,0
     7b4:	4601                	li	a2,0
     7b6:	85ce                	mv	a1,s3
     7b8:	854a                	mv	a0,s2
     7ba:	00000097          	auipc	ra,0x0
     7be:	b52080e7          	jalr	-1198(ra) # 30c <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     7c2:	85ce                	mv	a1,s3
     7c4:	854a                	mv	a0,s2
     7c6:	00000097          	auipc	ra,0x0
     7ca:	f70080e7          	jalr	-144(ra) # 736 <parseline>
     7ce:	85aa                	mv	a1,a0
     7d0:	8526                	mv	a0,s1
     7d2:	00000097          	auipc	ra,0x0
     7d6:	ab8080e7          	jalr	-1352(ra) # 28a <listcmd>
     7da:	84aa                	mv	s1,a0
  return cmd;
     7dc:	b7d1                	j	7a0 <parseline+0x6a>

00000000000007de <parseblock>:
{
     7de:	7179                	add	sp,sp,-48
     7e0:	f406                	sd	ra,40(sp)
     7e2:	f022                	sd	s0,32(sp)
     7e4:	ec26                	sd	s1,24(sp)
     7e6:	e84a                	sd	s2,16(sp)
     7e8:	e44e                	sd	s3,8(sp)
     7ea:	1800                	add	s0,sp,48
     7ec:	84aa                	mv	s1,a0
     7ee:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     7f0:	00001617          	auipc	a2,0x1
     7f4:	c9860613          	add	a2,a2,-872 # 1488 <malloc+0x154>
     7f8:	00000097          	auipc	ra,0x0
     7fc:	c60080e7          	jalr	-928(ra) # 458 <peek>
     800:	c12d                	beqz	a0,862 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     802:	4681                	li	a3,0
     804:	4601                	li	a2,0
     806:	85ca                	mv	a1,s2
     808:	8526                	mv	a0,s1
     80a:	00000097          	auipc	ra,0x0
     80e:	b02080e7          	jalr	-1278(ra) # 30c <gettoken>
  cmd = parseline(ps, es);
     812:	85ca                	mv	a1,s2
     814:	8526                	mv	a0,s1
     816:	00000097          	auipc	ra,0x0
     81a:	f20080e7          	jalr	-224(ra) # 736 <parseline>
     81e:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     820:	00001617          	auipc	a2,0x1
     824:	cb860613          	add	a2,a2,-840 # 14d8 <malloc+0x1a4>
     828:	85ca                	mv	a1,s2
     82a:	8526                	mv	a0,s1
     82c:	00000097          	auipc	ra,0x0
     830:	c2c080e7          	jalr	-980(ra) # 458 <peek>
     834:	cd1d                	beqz	a0,872 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     836:	4681                	li	a3,0
     838:	4601                	li	a2,0
     83a:	85ca                	mv	a1,s2
     83c:	8526                	mv	a0,s1
     83e:	00000097          	auipc	ra,0x0
     842:	ace080e7          	jalr	-1330(ra) # 30c <gettoken>
  cmd = parseredirs(cmd, ps, es);
     846:	864a                	mv	a2,s2
     848:	85a6                	mv	a1,s1
     84a:	854e                	mv	a0,s3
     84c:	00000097          	auipc	ra,0x0
     850:	c78080e7          	jalr	-904(ra) # 4c4 <parseredirs>
}
     854:	70a2                	ld	ra,40(sp)
     856:	7402                	ld	s0,32(sp)
     858:	64e2                	ld	s1,24(sp)
     85a:	6942                	ld	s2,16(sp)
     85c:	69a2                	ld	s3,8(sp)
     85e:	6145                	add	sp,sp,48
     860:	8082                	ret
    panic("parseblock");
     862:	00001517          	auipc	a0,0x1
     866:	c6650513          	add	a0,a0,-922 # 14c8 <malloc+0x194>
     86a:	fffff097          	auipc	ra,0xfffff
     86e:	7ec080e7          	jalr	2028(ra) # 56 <panic>
    panic("syntax - missing )");
     872:	00001517          	auipc	a0,0x1
     876:	c6e50513          	add	a0,a0,-914 # 14e0 <malloc+0x1ac>
     87a:	fffff097          	auipc	ra,0xfffff
     87e:	7dc080e7          	jalr	2012(ra) # 56 <panic>

0000000000000882 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     882:	1101                	add	sp,sp,-32
     884:	ec06                	sd	ra,24(sp)
     886:	e822                	sd	s0,16(sp)
     888:	e426                	sd	s1,8(sp)
     88a:	1000                	add	s0,sp,32
     88c:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     88e:	c521                	beqz	a0,8d6 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     890:	4118                	lw	a4,0(a0)
     892:	4795                	li	a5,5
     894:	04e7e163          	bltu	a5,a4,8d6 <nulterminate+0x54>
     898:	00056783          	lwu	a5,0(a0)
     89c:	078a                	sll	a5,a5,0x2
     89e:	00001717          	auipc	a4,0x1
     8a2:	ca270713          	add	a4,a4,-862 # 1540 <malloc+0x20c>
     8a6:	97ba                	add	a5,a5,a4
     8a8:	439c                	lw	a5,0(a5)
     8aa:	97ba                	add	a5,a5,a4
     8ac:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     8ae:	651c                	ld	a5,8(a0)
     8b0:	c39d                	beqz	a5,8d6 <nulterminate+0x54>
     8b2:	01050793          	add	a5,a0,16
      *ecmd->eargv[i] = 0;
     8b6:	67b8                	ld	a4,72(a5)
     8b8:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     8bc:	07a1                	add	a5,a5,8
     8be:	ff87b703          	ld	a4,-8(a5)
     8c2:	fb75                	bnez	a4,8b6 <nulterminate+0x34>
     8c4:	a809                	j	8d6 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     8c6:	6508                	ld	a0,8(a0)
     8c8:	00000097          	auipc	ra,0x0
     8cc:	fba080e7          	jalr	-70(ra) # 882 <nulterminate>
    *rcmd->efile = 0;
     8d0:	6c9c                	ld	a5,24(s1)
     8d2:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     8d6:	8526                	mv	a0,s1
     8d8:	60e2                	ld	ra,24(sp)
     8da:	6442                	ld	s0,16(sp)
     8dc:	64a2                	ld	s1,8(sp)
     8de:	6105                	add	sp,sp,32
     8e0:	8082                	ret
    nulterminate(pcmd->left);
     8e2:	6508                	ld	a0,8(a0)
     8e4:	00000097          	auipc	ra,0x0
     8e8:	f9e080e7          	jalr	-98(ra) # 882 <nulterminate>
    nulterminate(pcmd->right);
     8ec:	6888                	ld	a0,16(s1)
     8ee:	00000097          	auipc	ra,0x0
     8f2:	f94080e7          	jalr	-108(ra) # 882 <nulterminate>
    break;
     8f6:	b7c5                	j	8d6 <nulterminate+0x54>
    nulterminate(lcmd->left);
     8f8:	6508                	ld	a0,8(a0)
     8fa:	00000097          	auipc	ra,0x0
     8fe:	f88080e7          	jalr	-120(ra) # 882 <nulterminate>
    nulterminate(lcmd->right);
     902:	6888                	ld	a0,16(s1)
     904:	00000097          	auipc	ra,0x0
     908:	f7e080e7          	jalr	-130(ra) # 882 <nulterminate>
    break;
     90c:	b7e9                	j	8d6 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     90e:	6508                	ld	a0,8(a0)
     910:	00000097          	auipc	ra,0x0
     914:	f72080e7          	jalr	-142(ra) # 882 <nulterminate>
    break;
     918:	bf7d                	j	8d6 <nulterminate+0x54>

000000000000091a <parsecmd>:
{
     91a:	7179                	add	sp,sp,-48
     91c:	f406                	sd	ra,40(sp)
     91e:	f022                	sd	s0,32(sp)
     920:	ec26                	sd	s1,24(sp)
     922:	e84a                	sd	s2,16(sp)
     924:	1800                	add	s0,sp,48
     926:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     92a:	84aa                	mv	s1,a0
     92c:	00000097          	auipc	ra,0x0
     930:	240080e7          	jalr	576(ra) # b6c <strlen>
     934:	1502                	sll	a0,a0,0x20
     936:	9101                	srl	a0,a0,0x20
     938:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     93a:	85a6                	mv	a1,s1
     93c:	fd840513          	add	a0,s0,-40
     940:	00000097          	auipc	ra,0x0
     944:	df6080e7          	jalr	-522(ra) # 736 <parseline>
     948:	892a                	mv	s2,a0
  peek(&s, es, "");
     94a:	00001617          	auipc	a2,0x1
     94e:	bae60613          	add	a2,a2,-1106 # 14f8 <malloc+0x1c4>
     952:	85a6                	mv	a1,s1
     954:	fd840513          	add	a0,s0,-40
     958:	00000097          	auipc	ra,0x0
     95c:	b00080e7          	jalr	-1280(ra) # 458 <peek>
  if(s != es){
     960:	fd843603          	ld	a2,-40(s0)
     964:	00961e63          	bne	a2,s1,980 <parsecmd+0x66>
  nulterminate(cmd);
     968:	854a                	mv	a0,s2
     96a:	00000097          	auipc	ra,0x0
     96e:	f18080e7          	jalr	-232(ra) # 882 <nulterminate>
}
     972:	854a                	mv	a0,s2
     974:	70a2                	ld	ra,40(sp)
     976:	7402                	ld	s0,32(sp)
     978:	64e2                	ld	s1,24(sp)
     97a:	6942                	ld	s2,16(sp)
     97c:	6145                	add	sp,sp,48
     97e:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     980:	00001597          	auipc	a1,0x1
     984:	b8058593          	add	a1,a1,-1152 # 1500 <malloc+0x1cc>
     988:	4509                	li	a0,2
     98a:	00001097          	auipc	ra,0x1
     98e:	8c4080e7          	jalr	-1852(ra) # 124e <fprintf>
    panic("syntax");
     992:	00001517          	auipc	a0,0x1
     996:	afe50513          	add	a0,a0,-1282 # 1490 <malloc+0x15c>
     99a:	fffff097          	auipc	ra,0xfffff
     99e:	6bc080e7          	jalr	1724(ra) # 56 <panic>

00000000000009a2 <main>:
{
     9a2:	7139                	add	sp,sp,-64
     9a4:	fc06                	sd	ra,56(sp)
     9a6:	f822                	sd	s0,48(sp)
     9a8:	f426                	sd	s1,40(sp)
     9aa:	f04a                	sd	s2,32(sp)
     9ac:	ec4e                	sd	s3,24(sp)
     9ae:	e852                	sd	s4,16(sp)
     9b0:	e456                	sd	s5,8(sp)
     9b2:	0080                	add	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     9b4:	00001497          	auipc	s1,0x1
     9b8:	b5c48493          	add	s1,s1,-1188 # 1510 <malloc+0x1dc>
     9bc:	4589                	li	a1,2
     9be:	8526                	mv	a0,s1
     9c0:	00000097          	auipc	ra,0x0
     9c4:	47e080e7          	jalr	1150(ra) # e3e <open>
     9c8:	00054963          	bltz	a0,9da <main+0x38>
    if(fd >= 3){
     9cc:	4789                	li	a5,2
     9ce:	fea7d7e3          	bge	a5,a0,9bc <main+0x1a>
      close(fd);
     9d2:	00000097          	auipc	ra,0x0
     9d6:	464080e7          	jalr	1124(ra) # e36 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     9da:	00001a97          	auipc	s5,0x1
     9de:	646a8a93          	add	s5,s5,1606 # 2020 <buf.0>
    while (*cmd == ' ' || *cmd == '\t')
     9e2:	02000913          	li	s2,32
     9e6:	49a5                	li	s3,9
  while(n > 0 && (s[n-1] == ' ' || s[n-1] == '\t' || s[n-1] == '\n' || s[n-1] == '\r'))
     9e8:	00800a37          	lui	s4,0x800
     9ec:	0a4d                	add	s4,s4,19 # 800013 <base+0x7fdf8b>
     9ee:	0a26                	sll	s4,s4,0x9
     9f0:	a049                	j	a72 <main+0xd0>
      cmd++;
     9f2:	0485                	add	s1,s1,1
    while (*cmd == ' ' || *cmd == '\t')
     9f4:	0004c783          	lbu	a5,0(s1)
     9f8:	ff278de3          	beq	a5,s2,9f2 <main+0x50>
     9fc:	ff378be3          	beq	a5,s3,9f2 <main+0x50>
  int n = strlen(s);
     a00:	8526                	mv	a0,s1
     a02:	00000097          	auipc	ra,0x0
     a06:	16a080e7          	jalr	362(ra) # b6c <strlen>
     a0a:	0005071b          	sext.w	a4,a0
  while(n > 0 && (s[n-1] == ' ' || s[n-1] == '\t' || s[n-1] == '\n' || s[n-1] == '\r'))
     a0e:	02e05b63          	blez	a4,a44 <main+0xa2>
     a12:	fff70793          	add	a5,a4,-1
     a16:	97a6                	add	a5,a5,s1
     a18:	ffe48613          	add	a2,s1,-2
     a1c:	963a                	add	a2,a2,a4
     a1e:	377d                	addw	a4,a4,-1
     a20:	1702                	sll	a4,a4,0x20
     a22:	9301                	srl	a4,a4,0x20
     a24:	8e19                	sub	a2,a2,a4
     a26:	a031                	j	a32 <main+0x90>
    s[--n] = 0;
     a28:	00068023          	sb	zero,0(a3)
  while(n > 0 && (s[n-1] == ' ' || s[n-1] == '\t' || s[n-1] == '\n' || s[n-1] == '\r'))
     a2c:	17fd                	add	a5,a5,-1
     a2e:	00c78b63          	beq	a5,a2,a44 <main+0xa2>
     a32:	86be                	mv	a3,a5
     a34:	0007c703          	lbu	a4,0(a5)
     a38:	00e96663          	bltu	s2,a4,a44 <main+0xa2>
     a3c:	00ea5733          	srl	a4,s4,a4
     a40:	8b05                	and	a4,a4,1
     a42:	f37d                	bnez	a4,a28 <main+0x86>
    if (*cmd == 0)
     a44:	0004c783          	lbu	a5,0(s1)
     a48:	c78d                	beqz	a5,a72 <main+0xd0>
    if(cmd[0] == 'c' && cmd[1] == 'd' && (cmd[2] == 0 || cmd[2] == ' ' || cmd[2] == '\t')){
     a4a:	06300713          	li	a4,99
     a4e:	00e79863          	bne	a5,a4,a5e <main+0xbc>
     a52:	0014c703          	lbu	a4,1(s1)
     a56:	06400793          	li	a5,100
     a5a:	02f70a63          	beq	a4,a5,a8e <main+0xec>
    if(fork1() == 0)
     a5e:	fffff097          	auipc	ra,0xfffff
     a62:	61e080e7          	jalr	1566(ra) # 7c <fork1>
     a66:	c549                	beqz	a0,af0 <main+0x14e>
    wait(0);
     a68:	4501                	li	a0,0
     a6a:	00000097          	auipc	ra,0x0
     a6e:	3bc080e7          	jalr	956(ra) # e26 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     a72:	06400593          	li	a1,100
     a76:	8556                	mv	a0,s5
     a78:	fffff097          	auipc	ra,0xfffff
     a7c:	588080e7          	jalr	1416(ra) # 0 <getcmd>
     a80:	08054163          	bltz	a0,b02 <main+0x160>
    char *cmd = buf;
     a84:	00001497          	auipc	s1,0x1
     a88:	59c48493          	add	s1,s1,1436 # 2020 <buf.0>
     a8c:	b7a5                	j	9f4 <main+0x52>
    if(cmd[0] == 'c' && cmd[1] == 'd' && (cmd[2] == 0 || cmd[2] == ' ' || cmd[2] == '\t')){
     a8e:	0024c783          	lbu	a5,2(s1)
     a92:	0df7f713          	and	a4,a5,223
     a96:	c701                	beqz	a4,a9e <main+0xfc>
     a98:	4725                	li	a4,9
     a9a:	fce792e3          	bne	a5,a4,a5e <main+0xbc>
      char *path = cmd + 2;
     a9e:	0489                	add	s1,s1,2
      while(*path == ' ' || *path == '\t')
     aa0:	02000713          	li	a4,32
     aa4:	46a5                	li	a3,9
     aa6:	a011                	j	aaa <main+0x108>
        path++;
     aa8:	0485                	add	s1,s1,1
      while(*path == ' ' || *path == '\t')
     aaa:	0004c783          	lbu	a5,0(s1)
     aae:	fee78de3          	beq	a5,a4,aa8 <main+0x106>
     ab2:	fed78be3          	beq	a5,a3,aa8 <main+0x106>
      if(*path == 0){
     ab6:	eb99                	bnez	a5,acc <main+0x12a>
        fprintf(2, "Usage: cd directory\n");
     ab8:	00001597          	auipc	a1,0x1
     abc:	a6058593          	add	a1,a1,-1440 # 1518 <malloc+0x1e4>
     ac0:	4509                	li	a0,2
     ac2:	00000097          	auipc	ra,0x0
     ac6:	78c080e7          	jalr	1932(ra) # 124e <fprintf>
     aca:	b765                	j	a72 <main+0xd0>
      } else if(chdir(path) < 0){
     acc:	8526                	mv	a0,s1
     ace:	00000097          	auipc	ra,0x0
     ad2:	390080e7          	jalr	912(ra) # e5e <chdir>
     ad6:	f8055ee3          	bgez	a0,a72 <main+0xd0>
        fprintf(2, "cannot cd %s\n", path);
     ada:	8626                	mv	a2,s1
     adc:	00001597          	auipc	a1,0x1
     ae0:	a5458593          	add	a1,a1,-1452 # 1530 <malloc+0x1fc>
     ae4:	4509                	li	a0,2
     ae6:	00000097          	auipc	ra,0x0
     aea:	768080e7          	jalr	1896(ra) # 124e <fprintf>
     aee:	b751                	j	a72 <main+0xd0>
      runcmd(parsecmd(cmd));
     af0:	8526                	mv	a0,s1
     af2:	00000097          	auipc	ra,0x0
     af6:	e28080e7          	jalr	-472(ra) # 91a <parsecmd>
     afa:	fffff097          	auipc	ra,0xfffff
     afe:	5b0080e7          	jalr	1456(ra) # aa <runcmd>
  exit(0);
     b02:	4501                	li	a0,0
     b04:	00000097          	auipc	ra,0x0
     b08:	31a080e7          	jalr	794(ra) # e1e <exit>

0000000000000b0c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     b0c:	1141                	add	sp,sp,-16
     b0e:	e406                	sd	ra,8(sp)
     b10:	e022                	sd	s0,0(sp)
     b12:	0800                	add	s0,sp,16
  int r;
  extern int main();
  r = main();
     b14:	00000097          	auipc	ra,0x0
     b18:	e8e080e7          	jalr	-370(ra) # 9a2 <main>
  exit(r);
     b1c:	00000097          	auipc	ra,0x0
     b20:	302080e7          	jalr	770(ra) # e1e <exit>

0000000000000b24 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     b24:	1141                	add	sp,sp,-16
     b26:	e422                	sd	s0,8(sp)
     b28:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b2a:	87aa                	mv	a5,a0
     b2c:	0585                	add	a1,a1,1
     b2e:	0785                	add	a5,a5,1
     b30:	fff5c703          	lbu	a4,-1(a1)
     b34:	fee78fa3          	sb	a4,-1(a5)
     b38:	fb75                	bnez	a4,b2c <strcpy+0x8>
    ;
  return os;
}
     b3a:	6422                	ld	s0,8(sp)
     b3c:	0141                	add	sp,sp,16
     b3e:	8082                	ret

0000000000000b40 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b40:	1141                	add	sp,sp,-16
     b42:	e422                	sd	s0,8(sp)
     b44:	0800                	add	s0,sp,16
  while(*p && *p == *q)
     b46:	00054783          	lbu	a5,0(a0)
     b4a:	cb91                	beqz	a5,b5e <strcmp+0x1e>
     b4c:	0005c703          	lbu	a4,0(a1)
     b50:	00f71763          	bne	a4,a5,b5e <strcmp+0x1e>
    p++, q++;
     b54:	0505                	add	a0,a0,1
     b56:	0585                	add	a1,a1,1
  while(*p && *p == *q)
     b58:	00054783          	lbu	a5,0(a0)
     b5c:	fbe5                	bnez	a5,b4c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     b5e:	0005c503          	lbu	a0,0(a1)
}
     b62:	40a7853b          	subw	a0,a5,a0
     b66:	6422                	ld	s0,8(sp)
     b68:	0141                	add	sp,sp,16
     b6a:	8082                	ret

0000000000000b6c <strlen>:

uint
strlen(const char *s)
{
     b6c:	1141                	add	sp,sp,-16
     b6e:	e422                	sd	s0,8(sp)
     b70:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     b72:	00054783          	lbu	a5,0(a0)
     b76:	cf91                	beqz	a5,b92 <strlen+0x26>
     b78:	0505                	add	a0,a0,1
     b7a:	87aa                	mv	a5,a0
     b7c:	86be                	mv	a3,a5
     b7e:	0785                	add	a5,a5,1
     b80:	fff7c703          	lbu	a4,-1(a5)
     b84:	ff65                	bnez	a4,b7c <strlen+0x10>
     b86:	40a6853b          	subw	a0,a3,a0
     b8a:	2505                	addw	a0,a0,1
    ;
  return n;
}
     b8c:	6422                	ld	s0,8(sp)
     b8e:	0141                	add	sp,sp,16
     b90:	8082                	ret
  for(n = 0; s[n]; n++)
     b92:	4501                	li	a0,0
     b94:	bfe5                	j	b8c <strlen+0x20>

0000000000000b96 <memset>:

void*
memset(void *dst, int c, uint n)
{
     b96:	1141                	add	sp,sp,-16
     b98:	e422                	sd	s0,8(sp)
     b9a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     b9c:	ca19                	beqz	a2,bb2 <memset+0x1c>
     b9e:	87aa                	mv	a5,a0
     ba0:	1602                	sll	a2,a2,0x20
     ba2:	9201                	srl	a2,a2,0x20
     ba4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     ba8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     bac:	0785                	add	a5,a5,1
     bae:	fee79de3          	bne	a5,a4,ba8 <memset+0x12>
  }
  return dst;
}
     bb2:	6422                	ld	s0,8(sp)
     bb4:	0141                	add	sp,sp,16
     bb6:	8082                	ret

0000000000000bb8 <strchr>:

char*
strchr(const char *s, char c)
{
     bb8:	1141                	add	sp,sp,-16
     bba:	e422                	sd	s0,8(sp)
     bbc:	0800                	add	s0,sp,16
  for(; *s; s++)
     bbe:	00054783          	lbu	a5,0(a0)
     bc2:	cb99                	beqz	a5,bd8 <strchr+0x20>
    if(*s == c)
     bc4:	00f58763          	beq	a1,a5,bd2 <strchr+0x1a>
  for(; *s; s++)
     bc8:	0505                	add	a0,a0,1
     bca:	00054783          	lbu	a5,0(a0)
     bce:	fbfd                	bnez	a5,bc4 <strchr+0xc>
      return (char*)s;
  return 0;
     bd0:	4501                	li	a0,0
}
     bd2:	6422                	ld	s0,8(sp)
     bd4:	0141                	add	sp,sp,16
     bd6:	8082                	ret
  return 0;
     bd8:	4501                	li	a0,0
     bda:	bfe5                	j	bd2 <strchr+0x1a>

0000000000000bdc <gets>:

char*
gets(char *buf, int max)
{
     bdc:	711d                	add	sp,sp,-96
     bde:	ec86                	sd	ra,88(sp)
     be0:	e8a2                	sd	s0,80(sp)
     be2:	e4a6                	sd	s1,72(sp)
     be4:	e0ca                	sd	s2,64(sp)
     be6:	fc4e                	sd	s3,56(sp)
     be8:	f852                	sd	s4,48(sp)
     bea:	f456                	sd	s5,40(sp)
     bec:	f05a                	sd	s6,32(sp)
     bee:	ec5e                	sd	s7,24(sp)
     bf0:	1080                	add	s0,sp,96
     bf2:	8baa                	mv	s7,a0
     bf4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     bf6:	892a                	mv	s2,a0
     bf8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     bfa:	4aa9                	li	s5,10
     bfc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     bfe:	89a6                	mv	s3,s1
     c00:	2485                	addw	s1,s1,1
     c02:	0344d863          	bge	s1,s4,c32 <gets+0x56>
    cc = read(0, &c, 1);
     c06:	4605                	li	a2,1
     c08:	faf40593          	add	a1,s0,-81
     c0c:	4501                	li	a0,0
     c0e:	00000097          	auipc	ra,0x0
     c12:	240080e7          	jalr	576(ra) # e4e <read>
    if(cc < 1)
     c16:	00a05e63          	blez	a0,c32 <gets+0x56>
    buf[i++] = c;
     c1a:	faf44783          	lbu	a5,-81(s0)
     c1e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c22:	01578763          	beq	a5,s5,c30 <gets+0x54>
     c26:	0905                	add	s2,s2,1
     c28:	fd679be3          	bne	a5,s6,bfe <gets+0x22>
  for(i=0; i+1 < max; ){
     c2c:	89a6                	mv	s3,s1
     c2e:	a011                	j	c32 <gets+0x56>
     c30:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c32:	99de                	add	s3,s3,s7
     c34:	00098023          	sb	zero,0(s3)
  return buf;
}
     c38:	855e                	mv	a0,s7
     c3a:	60e6                	ld	ra,88(sp)
     c3c:	6446                	ld	s0,80(sp)
     c3e:	64a6                	ld	s1,72(sp)
     c40:	6906                	ld	s2,64(sp)
     c42:	79e2                	ld	s3,56(sp)
     c44:	7a42                	ld	s4,48(sp)
     c46:	7aa2                	ld	s5,40(sp)
     c48:	7b02                	ld	s6,32(sp)
     c4a:	6be2                	ld	s7,24(sp)
     c4c:	6125                	add	sp,sp,96
     c4e:	8082                	ret

0000000000000c50 <atoi>:
//   return r;
// }

int
atoi(const char *s)
{
     c50:	1141                	add	sp,sp,-16
     c52:	e422                	sd	s0,8(sp)
     c54:	0800                	add	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     c56:	00054683          	lbu	a3,0(a0)
     c5a:	fd06879b          	addw	a5,a3,-48
     c5e:	0ff7f793          	zext.b	a5,a5
     c62:	4625                	li	a2,9
     c64:	02f66863          	bltu	a2,a5,c94 <atoi+0x44>
     c68:	872a                	mv	a4,a0
  n = 0;
     c6a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     c6c:	0705                	add	a4,a4,1
     c6e:	0025179b          	sllw	a5,a0,0x2
     c72:	9fa9                	addw	a5,a5,a0
     c74:	0017979b          	sllw	a5,a5,0x1
     c78:	9fb5                	addw	a5,a5,a3
     c7a:	fd07851b          	addw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     c7e:	00074683          	lbu	a3,0(a4)
     c82:	fd06879b          	addw	a5,a3,-48
     c86:	0ff7f793          	zext.b	a5,a5
     c8a:	fef671e3          	bgeu	a2,a5,c6c <atoi+0x1c>
  return n;
}
     c8e:	6422                	ld	s0,8(sp)
     c90:	0141                	add	sp,sp,16
     c92:	8082                	ret
  n = 0;
     c94:	4501                	li	a0,0
     c96:	bfe5                	j	c8e <atoi+0x3e>

0000000000000c98 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     c98:	1141                	add	sp,sp,-16
     c9a:	e422                	sd	s0,8(sp)
     c9c:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     c9e:	02b57463          	bgeu	a0,a1,cc6 <memmove+0x2e>
    while(n-- > 0)
     ca2:	00c05f63          	blez	a2,cc0 <memmove+0x28>
     ca6:	1602                	sll	a2,a2,0x20
     ca8:	9201                	srl	a2,a2,0x20
     caa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     cae:	872a                	mv	a4,a0
      *dst++ = *src++;
     cb0:	0585                	add	a1,a1,1
     cb2:	0705                	add	a4,a4,1
     cb4:	fff5c683          	lbu	a3,-1(a1)
     cb8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     cbc:	fee79ae3          	bne	a5,a4,cb0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     cc0:	6422                	ld	s0,8(sp)
     cc2:	0141                	add	sp,sp,16
     cc4:	8082                	ret
    dst += n;
     cc6:	00c50733          	add	a4,a0,a2
    src += n;
     cca:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     ccc:	fec05ae3          	blez	a2,cc0 <memmove+0x28>
     cd0:	fff6079b          	addw	a5,a2,-1
     cd4:	1782                	sll	a5,a5,0x20
     cd6:	9381                	srl	a5,a5,0x20
     cd8:	fff7c793          	not	a5,a5
     cdc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     cde:	15fd                	add	a1,a1,-1
     ce0:	177d                	add	a4,a4,-1
     ce2:	0005c683          	lbu	a3,0(a1)
     ce6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     cea:	fee79ae3          	bne	a5,a4,cde <memmove+0x46>
     cee:	bfc9                	j	cc0 <memmove+0x28>

0000000000000cf0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     cf0:	1141                	add	sp,sp,-16
     cf2:	e422                	sd	s0,8(sp)
     cf4:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     cf6:	ca05                	beqz	a2,d26 <memcmp+0x36>
     cf8:	fff6069b          	addw	a3,a2,-1
     cfc:	1682                	sll	a3,a3,0x20
     cfe:	9281                	srl	a3,a3,0x20
     d00:	0685                	add	a3,a3,1
     d02:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     d04:	00054783          	lbu	a5,0(a0)
     d08:	0005c703          	lbu	a4,0(a1)
     d0c:	00e79863          	bne	a5,a4,d1c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     d10:	0505                	add	a0,a0,1
    p2++;
     d12:	0585                	add	a1,a1,1
  while (n-- > 0) {
     d14:	fed518e3          	bne	a0,a3,d04 <memcmp+0x14>
  }
  return 0;
     d18:	4501                	li	a0,0
     d1a:	a019                	j	d20 <memcmp+0x30>
      return *p1 - *p2;
     d1c:	40e7853b          	subw	a0,a5,a4
}
     d20:	6422                	ld	s0,8(sp)
     d22:	0141                	add	sp,sp,16
     d24:	8082                	ret
  return 0;
     d26:	4501                	li	a0,0
     d28:	bfe5                	j	d20 <memcmp+0x30>

0000000000000d2a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     d2a:	1141                	add	sp,sp,-16
     d2c:	e406                	sd	ra,8(sp)
     d2e:	e022                	sd	s0,0(sp)
     d30:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
     d32:	00000097          	auipc	ra,0x0
     d36:	f66080e7          	jalr	-154(ra) # c98 <memmove>
}
     d3a:	60a2                	ld	ra,8(sp)
     d3c:	6402                	ld	s0,0(sp)
     d3e:	0141                	add	sp,sp,16
     d40:	8082                	ret

0000000000000d42 <sbrk>:

char *
sbrk(int n) {
     d42:	1141                	add	sp,sp,-16
     d44:	e406                	sd	ra,8(sp)
     d46:	e022                	sd	s0,0(sp)
     d48:	0800                	add	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     d4a:	4585                	li	a1,1
     d4c:	00000097          	auipc	ra,0x0
     d50:	12a080e7          	jalr	298(ra) # e76 <sys_sbrk>
}
     d54:	60a2                	ld	ra,8(sp)
     d56:	6402                	ld	s0,0(sp)
     d58:	0141                	add	sp,sp,16
     d5a:	8082                	ret

0000000000000d5c <get_time>:
//   return sys_sbrk(n, SBRK_LAZY);
// }


unsigned int 
get_time(void) {
     d5c:	1141                	add	sp,sp,-16
     d5e:	e406                	sd	ra,8(sp)
     d60:	e022                	sd	s0,0(sp)
     d62:	0800                	add	s0,sp,16
    return uptime();
     d64:	00000097          	auipc	ra,0x0
     d68:	11a080e7          	jalr	282(ra) # e7e <uptime>
}
     d6c:	2501                	sext.w	a0,a0
     d6e:	60a2                	ld	ra,8(sp)
     d70:	6402                	ld	s0,0(sp)
     d72:	0141                	add	sp,sp,16
     d74:	8082                	ret

0000000000000d76 <make_filename>:
void 
make_filename(char *buf, const char *prefix, int num) {
    // 复制前缀
    char *p = buf;
    const char *s = prefix;
    while(*s) *p++ = *s++;
     d76:	0005c783          	lbu	a5,0(a1)
     d7a:	cb81                	beqz	a5,d8a <make_filename+0x14>
     d7c:	0585                	add	a1,a1,1
     d7e:	0505                	add	a0,a0,1
     d80:	fef50fa3          	sb	a5,-1(a0)
     d84:	0005c783          	lbu	a5,0(a1)
     d88:	fbf5                	bnez	a5,d7c <make_filename+0x6>
    
    // 处理数字部分
    if (num == 0) {
     d8a:	ca3d                	beqz	a2,e00 <make_filename+0x8a>
make_filename(char *buf, const char *prefix, int num) {
     d8c:	1101                	add	sp,sp,-32
     d8e:	ec22                	sd	s0,24(sp)
     d90:	1000                	add	s0,sp,32
        *p++ = '0';
    } else {
        // 临时缓冲区存放数字
        char digits[16];
        int i = 0;
        while(num > 0) {
     d92:	fe040893          	add	a7,s0,-32
     d96:	87c6                	mv	a5,a7
            digits[i++] = (num % 10) + '0';
     d98:	46a9                	li	a3,10
        while(num > 0) {
     d9a:	4825                	li	a6,9
     d9c:	06c05063          	blez	a2,dfc <make_filename+0x86>
            digits[i++] = (num % 10) + '0';
     da0:	02d6673b          	remw	a4,a2,a3
     da4:	0307071b          	addw	a4,a4,48
     da8:	00e78023          	sb	a4,0(a5)
            num /= 10;
     dac:	85b2                	mv	a1,a2
     dae:	02d6463b          	divw	a2,a2,a3
        while(num > 0) {
     db2:	873e                	mv	a4,a5
     db4:	0785                	add	a5,a5,1
     db6:	feb845e3          	blt	a6,a1,da0 <make_filename+0x2a>
     dba:	4117073b          	subw	a4,a4,a7
     dbe:	0017069b          	addw	a3,a4,1
            digits[i++] = (num % 10) + '0';
     dc2:	0006879b          	sext.w	a5,a3
        }
        // 倒序写入
        while(i > 0) *p++ = digits[--i];
     dc6:	04f05663          	blez	a5,e12 <make_filename+0x9c>
     dca:	fe040713          	add	a4,s0,-32
     dce:	973e                	add	a4,a4,a5
     dd0:	02069593          	sll	a1,a3,0x20
     dd4:	9181                	srl	a1,a1,0x20
     dd6:	95aa                	add	a1,a1,a0
     dd8:	87aa                	mv	a5,a0
     dda:	0785                	add	a5,a5,1
     ddc:	fff74603          	lbu	a2,-1(a4)
     de0:	fec78fa3          	sb	a2,-1(a5)
     de4:	177d                	add	a4,a4,-1
     de6:	feb79ae3          	bne	a5,a1,dda <make_filename+0x64>
     dea:	02069793          	sll	a5,a3,0x20
     dee:	9381                	srl	a5,a5,0x20
     df0:	97aa                	add	a5,a5,a0
    }
    *p = 0; // 字符串结束符
     df2:	00078023          	sb	zero,0(a5)
     df6:	6462                	ld	s0,24(sp)
     df8:	6105                	add	sp,sp,32
     dfa:	8082                	ret
        while(num > 0) {
     dfc:	87aa                	mv	a5,a0
     dfe:	bfd5                	j	df2 <make_filename+0x7c>
        *p++ = '0';
     e00:	00150793          	add	a5,a0,1
     e04:	03000713          	li	a4,48
     e08:	00e50023          	sb	a4,0(a0)
    *p = 0; // 字符串结束符
     e0c:	00078023          	sb	zero,0(a5)
     e10:	8082                	ret
        while(i > 0) *p++ = digits[--i];
     e12:	87aa                	mv	a5,a0
     e14:	bff9                	j	df2 <make_filename+0x7c>

0000000000000e16 <fork>:
.globl unlink
# generated by usys.pl - do not edit
#include "../kernel/sys/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e16:	4885                	li	a7,1
 ecall
     e18:	00000073          	ecall
 ret
     e1c:	8082                	ret

0000000000000e1e <exit>:
.global exit
exit:
 li a7, SYS_exit
     e1e:	4889                	li	a7,2
 ecall
     e20:	00000073          	ecall
 ret
     e24:	8082                	ret

0000000000000e26 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e26:	488d                	li	a7,3
 ecall
     e28:	00000073          	ecall
 ret
     e2c:	8082                	ret

0000000000000e2e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e2e:	4891                	li	a7,4
 ecall
     e30:	00000073          	ecall
 ret
     e34:	8082                	ret

0000000000000e36 <close>:
.global close
close:
 li a7, SYS_close
     e36:	4899                	li	a7,6
 ecall
     e38:	00000073          	ecall
 ret
     e3c:	8082                	ret

0000000000000e3e <open>:
.global open
open:
 li a7, SYS_open
     e3e:	489d                	li	a7,7
 ecall
     e40:	00000073          	ecall
 ret
     e44:	8082                	ret

0000000000000e46 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e46:	4895                	li	a7,5
 ecall
     e48:	00000073          	ecall
 ret
     e4c:	8082                	ret

0000000000000e4e <read>:
.global read
read:
 li a7, SYS_read
     e4e:	48a1                	li	a7,8
 ecall
     e50:	00000073          	ecall
 ret
     e54:	8082                	ret

0000000000000e56 <write>:
.global write
write:
 li a7, SYS_write
     e56:	48a5                	li	a7,9
 ecall
     e58:	00000073          	ecall
 ret
     e5c:	8082                	ret

0000000000000e5e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e5e:	48a9                	li	a7,10
 ecall
     e60:	00000073          	ecall
 ret
     e64:	8082                	ret

0000000000000e66 <makenode>:
.global makenode
makenode:
 li a7, SYS_makenode
     e66:	48ad                	li	a7,11
 ecall
     e68:	00000073          	ecall
 ret
     e6c:	8082                	ret

0000000000000e6e <duplicate>:
.global duplicate
duplicate:
 li a7, SYS_duplicate
     e6e:	48b1                	li	a7,12
 ecall
     e70:	00000073          	ecall
 ret
     e74:	8082                	ret

0000000000000e76 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     e76:	48b5                	li	a7,13
 ecall
     e78:	00000073          	ecall
 ret
     e7c:	8082                	ret

0000000000000e7e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e7e:	48b9                	li	a7,14
 ecall
     e80:	00000073          	ecall
 ret
     e84:	8082                	ret

0000000000000e86 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e86:	48bd                	li	a7,15
 ecall
     e88:	00000073          	ecall
 ret
     e8c:	8082                	ret

0000000000000e8e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e8e:	48c1                	li	a7,16
 ecall
     e90:	00000073          	ecall
 ret
     e94:	8082                	ret

0000000000000e96 <crash_arm>:
.global crash_arm
crash_arm:
 li a7, SYS_crash_arm
     e96:	48c5                	li	a7,17
 ecall
     e98:	00000073          	ecall
     e9c:	8082                	ret

0000000000000e9e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e9e:	1101                	add	sp,sp,-32
     ea0:	ec06                	sd	ra,24(sp)
     ea2:	e822                	sd	s0,16(sp)
     ea4:	1000                	add	s0,sp,32
     ea6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     eaa:	4605                	li	a2,1
     eac:	fef40593          	add	a1,s0,-17
     eb0:	00000097          	auipc	ra,0x0
     eb4:	fa6080e7          	jalr	-90(ra) # e56 <write>
}
     eb8:	60e2                	ld	ra,24(sp)
     eba:	6442                	ld	s0,16(sp)
     ebc:	6105                	add	sp,sp,32
     ebe:	8082                	ret

0000000000000ec0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     ec0:	715d                	add	sp,sp,-80
     ec2:	e486                	sd	ra,72(sp)
     ec4:	e0a2                	sd	s0,64(sp)
     ec6:	fc26                	sd	s1,56(sp)
     ec8:	f84a                	sd	s2,48(sp)
     eca:	f44e                	sd	s3,40(sp)
     ecc:	0880                	add	s0,sp,80
     ece:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     ed0:	c299                	beqz	a3,ed6 <printint+0x16>
     ed2:	0805c363          	bltz	a1,f58 <printint+0x98>
  neg = 0;
     ed6:	4881                	li	a7,0
     ed8:	fb840693          	add	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     edc:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     ede:	00000517          	auipc	a0,0x0
     ee2:	68250513          	add	a0,a0,1666 # 1560 <digits>
     ee6:	883e                	mv	a6,a5
     ee8:	2785                	addw	a5,a5,1
     eea:	02c5f733          	remu	a4,a1,a2
     eee:	972a                	add	a4,a4,a0
     ef0:	00074703          	lbu	a4,0(a4)
     ef4:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     ef8:	872e                	mv	a4,a1
     efa:	02c5d5b3          	divu	a1,a1,a2
     efe:	0685                	add	a3,a3,1
     f00:	fec773e3          	bgeu	a4,a2,ee6 <printint+0x26>
  if(neg)
     f04:	00088b63          	beqz	a7,f1a <printint+0x5a>
    buf[i++] = '-';
     f08:	fd078793          	add	a5,a5,-48
     f0c:	97a2                	add	a5,a5,s0
     f0e:	02d00713          	li	a4,45
     f12:	fee78423          	sb	a4,-24(a5)
     f16:	0028079b          	addw	a5,a6,2

  while(--i >= 0)
     f1a:	02f05863          	blez	a5,f4a <printint+0x8a>
     f1e:	fb840713          	add	a4,s0,-72
     f22:	00f704b3          	add	s1,a4,a5
     f26:	fff70993          	add	s3,a4,-1
     f2a:	99be                	add	s3,s3,a5
     f2c:	37fd                	addw	a5,a5,-1
     f2e:	1782                	sll	a5,a5,0x20
     f30:	9381                	srl	a5,a5,0x20
     f32:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
     f36:	fff4c583          	lbu	a1,-1(s1)
     f3a:	854a                	mv	a0,s2
     f3c:	00000097          	auipc	ra,0x0
     f40:	f62080e7          	jalr	-158(ra) # e9e <putc>
  while(--i >= 0)
     f44:	14fd                	add	s1,s1,-1
     f46:	ff3498e3          	bne	s1,s3,f36 <printint+0x76>
}
     f4a:	60a6                	ld	ra,72(sp)
     f4c:	6406                	ld	s0,64(sp)
     f4e:	74e2                	ld	s1,56(sp)
     f50:	7942                	ld	s2,48(sp)
     f52:	79a2                	ld	s3,40(sp)
     f54:	6161                	add	sp,sp,80
     f56:	8082                	ret
    x = -xx;
     f58:	40b005b3          	neg	a1,a1
    neg = 1;
     f5c:	4885                	li	a7,1
    x = -xx;
     f5e:	bfad                	j	ed8 <printint+0x18>

0000000000000f60 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f60:	711d                	add	sp,sp,-96
     f62:	ec86                	sd	ra,88(sp)
     f64:	e8a2                	sd	s0,80(sp)
     f66:	e4a6                	sd	s1,72(sp)
     f68:	e0ca                	sd	s2,64(sp)
     f6a:	fc4e                	sd	s3,56(sp)
     f6c:	f852                	sd	s4,48(sp)
     f6e:	f456                	sd	s5,40(sp)
     f70:	f05a                	sd	s6,32(sp)
     f72:	ec5e                	sd	s7,24(sp)
     f74:	e862                	sd	s8,16(sp)
     f76:	e466                	sd	s9,8(sp)
     f78:	e06a                	sd	s10,0(sp)
     f7a:	1080                	add	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f7c:	0005c903          	lbu	s2,0(a1)
     f80:	2a090963          	beqz	s2,1232 <vprintf+0x2d2>
     f84:	8b2a                	mv	s6,a0
     f86:	8a2e                	mv	s4,a1
     f88:	8bb2                	mv	s7,a2
  state = 0;
     f8a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     f8c:	4481                	li	s1,0
     f8e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     f90:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     f94:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     f98:	06c00c93          	li	s9,108
     f9c:	a015                	j	fc0 <vprintf+0x60>
        putc(fd, c0);
     f9e:	85ca                	mv	a1,s2
     fa0:	855a                	mv	a0,s6
     fa2:	00000097          	auipc	ra,0x0
     fa6:	efc080e7          	jalr	-260(ra) # e9e <putc>
     faa:	a019                	j	fb0 <vprintf+0x50>
    } else if(state == '%'){
     fac:	03598263          	beq	s3,s5,fd0 <vprintf+0x70>
  for(i = 0; fmt[i]; i++){
     fb0:	2485                	addw	s1,s1,1
     fb2:	8726                	mv	a4,s1
     fb4:	009a07b3          	add	a5,s4,s1
     fb8:	0007c903          	lbu	s2,0(a5)
     fbc:	26090b63          	beqz	s2,1232 <vprintf+0x2d2>
    c0 = fmt[i] & 0xff;
     fc0:	0009079b          	sext.w	a5,s2
    if(state == 0){
     fc4:	fe0994e3          	bnez	s3,fac <vprintf+0x4c>
      if(c0 == '%'){
     fc8:	fd579be3          	bne	a5,s5,f9e <vprintf+0x3e>
        state = '%';
     fcc:	89be                	mv	s3,a5
     fce:	b7cd                	j	fb0 <vprintf+0x50>
      if(c0) c1 = fmt[i+1] & 0xff;
     fd0:	cfc9                	beqz	a5,106a <vprintf+0x10a>
     fd2:	00ea06b3          	add	a3,s4,a4
     fd6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     fda:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     fdc:	c681                	beqz	a3,fe4 <vprintf+0x84>
     fde:	9752                	add	a4,a4,s4
     fe0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     fe4:	05878563          	beq	a5,s8,102e <vprintf+0xce>
      } else if(c0 == 'l' && c1 == 'd'){
     fe8:	07978163          	beq	a5,s9,104a <vprintf+0xea>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     fec:	07500713          	li	a4,117
     ff0:	10e78563          	beq	a5,a4,10fa <vprintf+0x19a>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     ff4:	07800713          	li	a4,120
     ff8:	14e78d63          	beq	a5,a4,1152 <vprintf+0x1f2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     ffc:	07000713          	li	a4,112
    1000:	18e78663          	beq	a5,a4,118c <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
    1004:	06300713          	li	a4,99
    1008:	1ce78a63          	beq	a5,a4,11dc <vprintf+0x27c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
    100c:	07300713          	li	a4,115
    1010:	1ee78263          	beq	a5,a4,11f4 <vprintf+0x294>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1014:	02500713          	li	a4,37
    1018:	04e79963          	bne	a5,a4,106a <vprintf+0x10a>
        putc(fd, '%');
    101c:	02500593          	li	a1,37
    1020:	855a                	mv	a0,s6
    1022:	00000097          	auipc	ra,0x0
    1026:	e7c080e7          	jalr	-388(ra) # e9e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    102a:	4981                	li	s3,0
    102c:	b751                	j	fb0 <vprintf+0x50>
        printint(fd, va_arg(ap, int), 10, 1);
    102e:	008b8913          	add	s2,s7,8
    1032:	4685                	li	a3,1
    1034:	4629                	li	a2,10
    1036:	000ba583          	lw	a1,0(s7)
    103a:	855a                	mv	a0,s6
    103c:	00000097          	auipc	ra,0x0
    1040:	e84080e7          	jalr	-380(ra) # ec0 <printint>
    1044:	8bca                	mv	s7,s2
      state = 0;
    1046:	4981                	li	s3,0
    1048:	b7a5                	j	fb0 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'd'){
    104a:	06400793          	li	a5,100
    104e:	02f68d63          	beq	a3,a5,1088 <vprintf+0x128>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1052:	06c00793          	li	a5,108
    1056:	04f68863          	beq	a3,a5,10a6 <vprintf+0x146>
      } else if(c0 == 'l' && c1 == 'u'){
    105a:	07500793          	li	a5,117
    105e:	0af68c63          	beq	a3,a5,1116 <vprintf+0x1b6>
      } else if(c0 == 'l' && c1 == 'x'){
    1062:	07800793          	li	a5,120
    1066:	10f68463          	beq	a3,a5,116e <vprintf+0x20e>
        putc(fd, '%');
    106a:	02500593          	li	a1,37
    106e:	855a                	mv	a0,s6
    1070:	00000097          	auipc	ra,0x0
    1074:	e2e080e7          	jalr	-466(ra) # e9e <putc>
        putc(fd, c0);
    1078:	85ca                	mv	a1,s2
    107a:	855a                	mv	a0,s6
    107c:	00000097          	auipc	ra,0x0
    1080:	e22080e7          	jalr	-478(ra) # e9e <putc>
      state = 0;
    1084:	4981                	li	s3,0
    1086:	b72d                	j	fb0 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1088:	008b8913          	add	s2,s7,8
    108c:	4685                	li	a3,1
    108e:	4629                	li	a2,10
    1090:	000bb583          	ld	a1,0(s7)
    1094:	855a                	mv	a0,s6
    1096:	00000097          	auipc	ra,0x0
    109a:	e2a080e7          	jalr	-470(ra) # ec0 <printint>
        i += 1;
    109e:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    10a0:	8bca                	mv	s7,s2
      state = 0;
    10a2:	4981                	li	s3,0
        i += 1;
    10a4:	b731                	j	fb0 <vprintf+0x50>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    10a6:	06400793          	li	a5,100
    10aa:	02f60963          	beq	a2,a5,10dc <vprintf+0x17c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    10ae:	07500793          	li	a5,117
    10b2:	08f60163          	beq	a2,a5,1134 <vprintf+0x1d4>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    10b6:	07800793          	li	a5,120
    10ba:	faf618e3          	bne	a2,a5,106a <vprintf+0x10a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    10be:	008b8913          	add	s2,s7,8
    10c2:	4681                	li	a3,0
    10c4:	4641                	li	a2,16
    10c6:	000bb583          	ld	a1,0(s7)
    10ca:	855a                	mv	a0,s6
    10cc:	00000097          	auipc	ra,0x0
    10d0:	df4080e7          	jalr	-524(ra) # ec0 <printint>
        i += 2;
    10d4:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    10d6:	8bca                	mv	s7,s2
      state = 0;
    10d8:	4981                	li	s3,0
        i += 2;
    10da:	bdd9                	j	fb0 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 1);
    10dc:	008b8913          	add	s2,s7,8
    10e0:	4685                	li	a3,1
    10e2:	4629                	li	a2,10
    10e4:	000bb583          	ld	a1,0(s7)
    10e8:	855a                	mv	a0,s6
    10ea:	00000097          	auipc	ra,0x0
    10ee:	dd6080e7          	jalr	-554(ra) # ec0 <printint>
        i += 2;
    10f2:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    10f4:	8bca                	mv	s7,s2
      state = 0;
    10f6:	4981                	li	s3,0
        i += 2;
    10f8:	bd65                	j	fb0 <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 10, 0);
    10fa:	008b8913          	add	s2,s7,8
    10fe:	4681                	li	a3,0
    1100:	4629                	li	a2,10
    1102:	000be583          	lwu	a1,0(s7)
    1106:	855a                	mv	a0,s6
    1108:	00000097          	auipc	ra,0x0
    110c:	db8080e7          	jalr	-584(ra) # ec0 <printint>
    1110:	8bca                	mv	s7,s2
      state = 0;
    1112:	4981                	li	s3,0
    1114:	bd71                	j	fb0 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1116:	008b8913          	add	s2,s7,8
    111a:	4681                	li	a3,0
    111c:	4629                	li	a2,10
    111e:	000bb583          	ld	a1,0(s7)
    1122:	855a                	mv	a0,s6
    1124:	00000097          	auipc	ra,0x0
    1128:	d9c080e7          	jalr	-612(ra) # ec0 <printint>
        i += 1;
    112c:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    112e:	8bca                	mv	s7,s2
      state = 0;
    1130:	4981                	li	s3,0
        i += 1;
    1132:	bdbd                	j	fb0 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1134:	008b8913          	add	s2,s7,8
    1138:	4681                	li	a3,0
    113a:	4629                	li	a2,10
    113c:	000bb583          	ld	a1,0(s7)
    1140:	855a                	mv	a0,s6
    1142:	00000097          	auipc	ra,0x0
    1146:	d7e080e7          	jalr	-642(ra) # ec0 <printint>
        i += 2;
    114a:	2489                	addw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    114c:	8bca                	mv	s7,s2
      state = 0;
    114e:	4981                	li	s3,0
        i += 2;
    1150:	b585                	j	fb0 <vprintf+0x50>
        printint(fd, va_arg(ap, uint32), 16, 0);
    1152:	008b8913          	add	s2,s7,8
    1156:	4681                	li	a3,0
    1158:	4641                	li	a2,16
    115a:	000be583          	lwu	a1,0(s7)
    115e:	855a                	mv	a0,s6
    1160:	00000097          	auipc	ra,0x0
    1164:	d60080e7          	jalr	-672(ra) # ec0 <printint>
    1168:	8bca                	mv	s7,s2
      state = 0;
    116a:	4981                	li	s3,0
    116c:	b591                	j	fb0 <vprintf+0x50>
        printint(fd, va_arg(ap, uint64), 16, 0);
    116e:	008b8913          	add	s2,s7,8
    1172:	4681                	li	a3,0
    1174:	4641                	li	a2,16
    1176:	000bb583          	ld	a1,0(s7)
    117a:	855a                	mv	a0,s6
    117c:	00000097          	auipc	ra,0x0
    1180:	d44080e7          	jalr	-700(ra) # ec0 <printint>
        i += 1;
    1184:	2485                	addw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1186:	8bca                	mv	s7,s2
      state = 0;
    1188:	4981                	li	s3,0
        i += 1;
    118a:	b51d                	j	fb0 <vprintf+0x50>
        printptr(fd, va_arg(ap, uint64));
    118c:	008b8d13          	add	s10,s7,8
    1190:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1194:	03000593          	li	a1,48
    1198:	855a                	mv	a0,s6
    119a:	00000097          	auipc	ra,0x0
    119e:	d04080e7          	jalr	-764(ra) # e9e <putc>
  putc(fd, 'x');
    11a2:	07800593          	li	a1,120
    11a6:	855a                	mv	a0,s6
    11a8:	00000097          	auipc	ra,0x0
    11ac:	cf6080e7          	jalr	-778(ra) # e9e <putc>
    11b0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    11b2:	00000b97          	auipc	s7,0x0
    11b6:	3aeb8b93          	add	s7,s7,942 # 1560 <digits>
    11ba:	03c9d793          	srl	a5,s3,0x3c
    11be:	97de                	add	a5,a5,s7
    11c0:	0007c583          	lbu	a1,0(a5)
    11c4:	855a                	mv	a0,s6
    11c6:	00000097          	auipc	ra,0x0
    11ca:	cd8080e7          	jalr	-808(ra) # e9e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    11ce:	0992                	sll	s3,s3,0x4
    11d0:	397d                	addw	s2,s2,-1
    11d2:	fe0914e3          	bnez	s2,11ba <vprintf+0x25a>
        printptr(fd, va_arg(ap, uint64));
    11d6:	8bea                	mv	s7,s10
      state = 0;
    11d8:	4981                	li	s3,0
    11da:	bbd9                	j	fb0 <vprintf+0x50>
        putc(fd, va_arg(ap, uint32));
    11dc:	008b8913          	add	s2,s7,8
    11e0:	000bc583          	lbu	a1,0(s7)
    11e4:	855a                	mv	a0,s6
    11e6:	00000097          	auipc	ra,0x0
    11ea:	cb8080e7          	jalr	-840(ra) # e9e <putc>
    11ee:	8bca                	mv	s7,s2
      state = 0;
    11f0:	4981                	li	s3,0
    11f2:	bb7d                	j	fb0 <vprintf+0x50>
        if((s = va_arg(ap, char*)) == 0)
    11f4:	008b8993          	add	s3,s7,8
    11f8:	000bb903          	ld	s2,0(s7)
    11fc:	02090163          	beqz	s2,121e <vprintf+0x2be>
        for(; *s; s++)
    1200:	00094583          	lbu	a1,0(s2)
    1204:	c585                	beqz	a1,122c <vprintf+0x2cc>
          putc(fd, *s);
    1206:	855a                	mv	a0,s6
    1208:	00000097          	auipc	ra,0x0
    120c:	c96080e7          	jalr	-874(ra) # e9e <putc>
        for(; *s; s++)
    1210:	0905                	add	s2,s2,1
    1212:	00094583          	lbu	a1,0(s2)
    1216:	f9e5                	bnez	a1,1206 <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
    1218:	8bce                	mv	s7,s3
      state = 0;
    121a:	4981                	li	s3,0
    121c:	bb51                	j	fb0 <vprintf+0x50>
          s = "(null)";
    121e:	00000917          	auipc	s2,0x0
    1222:	33a90913          	add	s2,s2,826 # 1558 <malloc+0x224>
        for(; *s; s++)
    1226:	02800593          	li	a1,40
    122a:	bff1                	j	1206 <vprintf+0x2a6>
        if((s = va_arg(ap, char*)) == 0)
    122c:	8bce                	mv	s7,s3
      state = 0;
    122e:	4981                	li	s3,0
    1230:	b341                	j	fb0 <vprintf+0x50>
    }
  }
}
    1232:	60e6                	ld	ra,88(sp)
    1234:	6446                	ld	s0,80(sp)
    1236:	64a6                	ld	s1,72(sp)
    1238:	6906                	ld	s2,64(sp)
    123a:	79e2                	ld	s3,56(sp)
    123c:	7a42                	ld	s4,48(sp)
    123e:	7aa2                	ld	s5,40(sp)
    1240:	7b02                	ld	s6,32(sp)
    1242:	6be2                	ld	s7,24(sp)
    1244:	6c42                	ld	s8,16(sp)
    1246:	6ca2                	ld	s9,8(sp)
    1248:	6d02                	ld	s10,0(sp)
    124a:	6125                	add	sp,sp,96
    124c:	8082                	ret

000000000000124e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    124e:	715d                	add	sp,sp,-80
    1250:	ec06                	sd	ra,24(sp)
    1252:	e822                	sd	s0,16(sp)
    1254:	1000                	add	s0,sp,32
    1256:	e010                	sd	a2,0(s0)
    1258:	e414                	sd	a3,8(s0)
    125a:	e818                	sd	a4,16(s0)
    125c:	ec1c                	sd	a5,24(s0)
    125e:	03043023          	sd	a6,32(s0)
    1262:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1266:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    126a:	8622                	mv	a2,s0
    126c:	00000097          	auipc	ra,0x0
    1270:	cf4080e7          	jalr	-780(ra) # f60 <vprintf>
}
    1274:	60e2                	ld	ra,24(sp)
    1276:	6442                	ld	s0,16(sp)
    1278:	6161                	add	sp,sp,80
    127a:	8082                	ret

000000000000127c <printf>:

void
printf(const char *fmt, ...)
{
    127c:	711d                	add	sp,sp,-96
    127e:	ec06                	sd	ra,24(sp)
    1280:	e822                	sd	s0,16(sp)
    1282:	1000                	add	s0,sp,32
    1284:	e40c                	sd	a1,8(s0)
    1286:	e810                	sd	a2,16(s0)
    1288:	ec14                	sd	a3,24(s0)
    128a:	f018                	sd	a4,32(s0)
    128c:	f41c                	sd	a5,40(s0)
    128e:	03043823          	sd	a6,48(s0)
    1292:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1296:	00840613          	add	a2,s0,8
    129a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    129e:	85aa                	mv	a1,a0
    12a0:	4505                	li	a0,1
    12a2:	00000097          	auipc	ra,0x0
    12a6:	cbe080e7          	jalr	-834(ra) # f60 <vprintf>
}
    12aa:	60e2                	ld	ra,24(sp)
    12ac:	6442                	ld	s0,16(sp)
    12ae:	6125                	add	sp,sp,96
    12b0:	8082                	ret

00000000000012b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    12b2:	1141                	add	sp,sp,-16
    12b4:	e422                	sd	s0,8(sp)
    12b6:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    12b8:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12bc:	00001797          	auipc	a5,0x1
    12c0:	d547b783          	ld	a5,-684(a5) # 2010 <freep>
    12c4:	a02d                	j	12ee <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    12c6:	4618                	lw	a4,8(a2)
    12c8:	9f2d                	addw	a4,a4,a1
    12ca:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    12ce:	6398                	ld	a4,0(a5)
    12d0:	6310                	ld	a2,0(a4)
    12d2:	a83d                	j	1310 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    12d4:	ff852703          	lw	a4,-8(a0)
    12d8:	9f31                	addw	a4,a4,a2
    12da:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    12dc:	ff053683          	ld	a3,-16(a0)
    12e0:	a091                	j	1324 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12e2:	6398                	ld	a4,0(a5)
    12e4:	00e7e463          	bltu	a5,a4,12ec <free+0x3a>
    12e8:	00e6ea63          	bltu	a3,a4,12fc <free+0x4a>
{
    12ec:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12ee:	fed7fae3          	bgeu	a5,a3,12e2 <free+0x30>
    12f2:	6398                	ld	a4,0(a5)
    12f4:	00e6e463          	bltu	a3,a4,12fc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12f8:	fee7eae3          	bltu	a5,a4,12ec <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    12fc:	ff852583          	lw	a1,-8(a0)
    1300:	6390                	ld	a2,0(a5)
    1302:	02059813          	sll	a6,a1,0x20
    1306:	01c85713          	srl	a4,a6,0x1c
    130a:	9736                	add	a4,a4,a3
    130c:	fae60de3          	beq	a2,a4,12c6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1310:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1314:	4790                	lw	a2,8(a5)
    1316:	02061593          	sll	a1,a2,0x20
    131a:	01c5d713          	srl	a4,a1,0x1c
    131e:	973e                	add	a4,a4,a5
    1320:	fae68ae3          	beq	a3,a4,12d4 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1324:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1326:	00001717          	auipc	a4,0x1
    132a:	cef73523          	sd	a5,-790(a4) # 2010 <freep>
}
    132e:	6422                	ld	s0,8(sp)
    1330:	0141                	add	sp,sp,16
    1332:	8082                	ret

0000000000001334 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1334:	7139                	add	sp,sp,-64
    1336:	fc06                	sd	ra,56(sp)
    1338:	f822                	sd	s0,48(sp)
    133a:	f426                	sd	s1,40(sp)
    133c:	f04a                	sd	s2,32(sp)
    133e:	ec4e                	sd	s3,24(sp)
    1340:	e852                	sd	s4,16(sp)
    1342:	e456                	sd	s5,8(sp)
    1344:	e05a                	sd	s6,0(sp)
    1346:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1348:	02051493          	sll	s1,a0,0x20
    134c:	9081                	srl	s1,s1,0x20
    134e:	04bd                	add	s1,s1,15
    1350:	8091                	srl	s1,s1,0x4
    1352:	0014899b          	addw	s3,s1,1
    1356:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    1358:	00001517          	auipc	a0,0x1
    135c:	cb853503          	ld	a0,-840(a0) # 2010 <freep>
    1360:	c515                	beqz	a0,138c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1362:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1364:	4798                	lw	a4,8(a5)
    1366:	02977f63          	bgeu	a4,s1,13a4 <malloc+0x70>
  if(nu < 4096)
    136a:	8a4e                	mv	s4,s3
    136c:	0009871b          	sext.w	a4,s3
    1370:	6685                	lui	a3,0x1
    1372:	00d77363          	bgeu	a4,a3,1378 <malloc+0x44>
    1376:	6a05                	lui	s4,0x1
    1378:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    137c:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1380:	00001917          	auipc	s2,0x1
    1384:	c9090913          	add	s2,s2,-880 # 2010 <freep>
  if(p == SBRK_ERROR)
    1388:	5afd                	li	s5,-1
    138a:	a895                	j	13fe <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    138c:	00001797          	auipc	a5,0x1
    1390:	cfc78793          	add	a5,a5,-772 # 2088 <base>
    1394:	00001717          	auipc	a4,0x1
    1398:	c6f73e23          	sd	a5,-900(a4) # 2010 <freep>
    139c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    139e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    13a2:	b7e1                	j	136a <malloc+0x36>
      if(p->s.size == nunits)
    13a4:	02e48c63          	beq	s1,a4,13dc <malloc+0xa8>
        p->s.size -= nunits;
    13a8:	4137073b          	subw	a4,a4,s3
    13ac:	c798                	sw	a4,8(a5)
        p += p->s.size;
    13ae:	02071693          	sll	a3,a4,0x20
    13b2:	01c6d713          	srl	a4,a3,0x1c
    13b6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    13b8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    13bc:	00001717          	auipc	a4,0x1
    13c0:	c4a73a23          	sd	a0,-940(a4) # 2010 <freep>
      return (void*)(p + 1);
    13c4:	01078513          	add	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    13c8:	70e2                	ld	ra,56(sp)
    13ca:	7442                	ld	s0,48(sp)
    13cc:	74a2                	ld	s1,40(sp)
    13ce:	7902                	ld	s2,32(sp)
    13d0:	69e2                	ld	s3,24(sp)
    13d2:	6a42                	ld	s4,16(sp)
    13d4:	6aa2                	ld	s5,8(sp)
    13d6:	6b02                	ld	s6,0(sp)
    13d8:	6121                	add	sp,sp,64
    13da:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    13dc:	6398                	ld	a4,0(a5)
    13de:	e118                	sd	a4,0(a0)
    13e0:	bff1                	j	13bc <malloc+0x88>
  hp->s.size = nu;
    13e2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    13e6:	0541                	add	a0,a0,16
    13e8:	00000097          	auipc	ra,0x0
    13ec:	eca080e7          	jalr	-310(ra) # 12b2 <free>
  return freep;
    13f0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    13f4:	d971                	beqz	a0,13c8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    13f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    13f8:	4798                	lw	a4,8(a5)
    13fa:	fa9775e3          	bgeu	a4,s1,13a4 <malloc+0x70>
    if(p == freep)
    13fe:	00093703          	ld	a4,0(s2)
    1402:	853e                	mv	a0,a5
    1404:	fef719e3          	bne	a4,a5,13f6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    1408:	8552                	mv	a0,s4
    140a:	00000097          	auipc	ra,0x0
    140e:	938080e7          	jalr	-1736(ra) # d42 <sbrk>
  if(p == SBRK_ERROR)
    1412:	fd5518e3          	bne	a0,s5,13e2 <malloc+0xae>
        return 0;
    1416:	4501                	li	a0,0
    1418:	bf45                	j	13c8 <malloc+0x94>
