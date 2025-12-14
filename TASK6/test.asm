
test.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <test_basic_syscalls>:
   0:	fe010113          	add	sp,sp,-32
   4:	00113c23          	sd	ra,24(sp)
   8:	00813823          	sd	s0,16(sp)
   c:	02010413          	add	s0,sp,32
  10:	00001517          	auipc	a0,0x1
  14:	ce050513          	add	a0,a0,-800 # cf0 <uptime+0x10>
  18:	00001097          	auipc	ra,0x1
  1c:	914080e7          	jalr	-1772(ra) # 92c <printf>
  20:	00001097          	auipc	ra,0x1
  24:	c9c080e7          	jalr	-868(ra) # cbc <getpid>
  28:	00050793          	mv	a5,a0
  2c:	fef42623          	sw	a5,-20(s0)
  30:	fec42783          	lw	a5,-20(s0)
  34:	00078593          	mv	a1,a5
  38:	00001517          	auipc	a0,0x1
  3c:	cd850513          	add	a0,a0,-808 # d10 <uptime+0x30>
  40:	00001097          	auipc	ra,0x1
  44:	8ec080e7          	jalr	-1812(ra) # 92c <printf>
  48:	00001097          	auipc	ra,0x1
  4c:	ba8080e7          	jalr	-1112(ra) # bf0 <fork>
  50:	00050793          	mv	a5,a0
  54:	fef42423          	sw	a5,-24(s0)
  58:	fe842783          	lw	a5,-24(s0)
  5c:	0007879b          	sext.w	a5,a5
  60:	02079863          	bnez	a5,90 <test_basic_syscalls+0x90>
  64:	00001097          	auipc	ra,0x1
  68:	c58080e7          	jalr	-936(ra) # cbc <getpid>
  6c:	00050793          	mv	a5,a0
  70:	00078593          	mv	a1,a5
  74:	00001517          	auipc	a0,0x1
  78:	cb450513          	add	a0,a0,-844 # d28 <uptime+0x48>
  7c:	00001097          	auipc	ra,0x1
  80:	8b0080e7          	jalr	-1872(ra) # 92c <printf>
  84:	02a00513          	li	a0,42
  88:	00001097          	auipc	ra,0x1
  8c:	b74080e7          	jalr	-1164(ra) # bfc <exit>
  90:	fe842783          	lw	a5,-24(s0)
  94:	0007879b          	sext.w	a5,a5
  98:	02f05863          	blez	a5,c8 <test_basic_syscalls+0xc8>
  9c:	fe440793          	add	a5,s0,-28
  a0:	00078513          	mv	a0,a5
  a4:	00001097          	auipc	ra,0x1
  a8:	b64080e7          	jalr	-1180(ra) # c08 <wait>
  ac:	fe442783          	lw	a5,-28(s0)
  b0:	00078593          	mv	a1,a5
  b4:	00001517          	auipc	a0,0x1
  b8:	c8c50513          	add	a0,a0,-884 # d40 <uptime+0x60>
  bc:	00001097          	auipc	ra,0x1
  c0:	870080e7          	jalr	-1936(ra) # 92c <printf>
  c4:	0140006f          	j	d8 <test_basic_syscalls+0xd8>
  c8:	00001517          	auipc	a0,0x1
  cc:	c9850513          	add	a0,a0,-872 # d60 <uptime+0x80>
  d0:	00001097          	auipc	ra,0x1
  d4:	85c080e7          	jalr	-1956(ra) # 92c <printf>
  d8:	00000013          	nop
  dc:	01813083          	ld	ra,24(sp)
  e0:	01013403          	ld	s0,16(sp)
  e4:	02010113          	add	sp,sp,32
  e8:	00008067          	ret

00000000000000ec <test_parameter_passing>:
  ec:	fd010113          	add	sp,sp,-48
  f0:	02113423          	sd	ra,40(sp)
  f4:	02813023          	sd	s0,32(sp)
  f8:	03010413          	add	s0,sp,48
  fc:	00001517          	auipc	a0,0x1
 100:	c7450513          	add	a0,a0,-908 # d70 <uptime+0x90>
 104:	00001097          	auipc	ra,0x1
 108:	828080e7          	jalr	-2008(ra) # 92c <printf>
 10c:	00001797          	auipc	a5,0x1
 110:	cec78793          	add	a5,a5,-788 # df8 <uptime+0x118>
 114:	0007b703          	ld	a4,0(a5)
 118:	fce43c23          	sd	a4,-40(s0)
 11c:	0087a703          	lw	a4,8(a5)
 120:	fee42023          	sw	a4,-32(s0)
 124:	00c7d783          	lhu	a5,12(a5)
 128:	fef41223          	sh	a5,-28(s0)
 12c:	20200593          	li	a1,514
 130:	00001517          	auipc	a0,0x1
 134:	c6050513          	add	a0,a0,-928 # d90 <uptime+0xb0>
 138:	00001097          	auipc	ra,0x1
 13c:	b24080e7          	jalr	-1244(ra) # c5c <open>
 140:	00050793          	mv	a5,a0
 144:	fef42623          	sw	a5,-20(s0)
 148:	fec42783          	lw	a5,-20(s0)
 14c:	0007879b          	sext.w	a5,a5
 150:	0607c863          	bltz	a5,1c0 <test_parameter_passing+0xd4>
 154:	fd840793          	add	a5,s0,-40
 158:	00078513          	mv	a0,a5
 15c:	00000097          	auipc	ra,0x0
 160:	3b0080e7          	jalr	944(ra) # 50c <strlen>
 164:	00050793          	mv	a5,a0
 168:	0007879b          	sext.w	a5,a5
 16c:	0007869b          	sext.w	a3,a5
 170:	fd840713          	add	a4,s0,-40
 174:	fec42783          	lw	a5,-20(s0)
 178:	00068613          	mv	a2,a3
 17c:	00070593          	mv	a1,a4
 180:	00078513          	mv	a0,a5
 184:	00001097          	auipc	ra,0x1
 188:	aa8080e7          	jalr	-1368(ra) # c2c <write>
 18c:	00050793          	mv	a5,a0
 190:	fef42423          	sw	a5,-24(s0)
 194:	fe842783          	lw	a5,-24(s0)
 198:	00078593          	mv	a1,a5
 19c:	00001517          	auipc	a0,0x1
 1a0:	c0450513          	add	a0,a0,-1020 # da0 <uptime+0xc0>
 1a4:	00000097          	auipc	ra,0x0
 1a8:	788080e7          	jalr	1928(ra) # 92c <printf>
 1ac:	fec42783          	lw	a5,-20(s0)
 1b0:	00078513          	mv	a0,a5
 1b4:	00001097          	auipc	ra,0x1
 1b8:	a84080e7          	jalr	-1404(ra) # c38 <close>
 1bc:	0580006f          	j	214 <test_parameter_passing+0x128>
 1c0:	00001517          	auipc	a0,0x1
 1c4:	bf050513          	add	a0,a0,-1040 # db0 <uptime+0xd0>
 1c8:	00000097          	auipc	ra,0x0
 1cc:	764080e7          	jalr	1892(ra) # 92c <printf>
 1d0:	fd840793          	add	a5,s0,-40
 1d4:	00078513          	mv	a0,a5
 1d8:	00000097          	auipc	ra,0x0
 1dc:	334080e7          	jalr	820(ra) # 50c <strlen>
 1e0:	00050793          	mv	a5,a0
 1e4:	0007879b          	sext.w	a5,a5
 1e8:	0007871b          	sext.w	a4,a5
 1ec:	fd840793          	add	a5,s0,-40
 1f0:	00070613          	mv	a2,a4
 1f4:	00078593          	mv	a1,a5
 1f8:	00100513          	li	a0,1
 1fc:	00001097          	auipc	ra,0x1
 200:	a30080e7          	jalr	-1488(ra) # c2c <write>
 204:	00001517          	auipc	a0,0x1
 208:	bec50513          	add	a0,a0,-1044 # df0 <uptime+0x110>
 20c:	00000097          	auipc	ra,0x0
 210:	720080e7          	jalr	1824(ra) # 92c <printf>
 214:	fd840793          	add	a5,s0,-40
 218:	00a00613          	li	a2,10
 21c:	00078593          	mv	a1,a5
 220:	fff00513          	li	a0,-1
 224:	00001097          	auipc	ra,0x1
 228:	a08080e7          	jalr	-1528(ra) # c2c <write>
 22c:	00a00613          	li	a2,10
 230:	00000593          	li	a1,0
 234:	00100513          	li	a0,1
 238:	00001097          	auipc	ra,0x1
 23c:	9f4080e7          	jalr	-1548(ra) # c2c <write>
 240:	fd840793          	add	a5,s0,-40
 244:	fff00613          	li	a2,-1
 248:	00078593          	mv	a1,a5
 24c:	00100513          	li	a0,1
 250:	00001097          	auipc	ra,0x1
 254:	9dc080e7          	jalr	-1572(ra) # c2c <write>
 258:	00000013          	nop
 25c:	02813083          	ld	ra,40(sp)
 260:	02013403          	ld	s0,32(sp)
 264:	03010113          	add	sp,sp,48
 268:	00008067          	ret

000000000000026c <test_security>:
 26c:	fe010113          	add	sp,sp,-32
 270:	00113c23          	sd	ra,24(sp)
 274:	00813823          	sd	s0,16(sp)
 278:	02010413          	add	s0,sp,32
 27c:	00001517          	auipc	a0,0x1
 280:	b8c50513          	add	a0,a0,-1140 # e08 <uptime+0x128>
 284:	00000097          	auipc	ra,0x0
 288:	6a8080e7          	jalr	1704(ra) # 92c <printf>
 28c:	010007b7          	lui	a5,0x1000
 290:	fef43423          	sd	a5,-24(s0)
 294:	00a00613          	li	a2,10
 298:	fe843583          	ld	a1,-24(s0)
 29c:	00100513          	li	a0,1
 2a0:	00001097          	auipc	ra,0x1
 2a4:	98c080e7          	jalr	-1652(ra) # c2c <write>
 2a8:	00050793          	mv	a5,a0
 2ac:	fef42223          	sw	a5,-28(s0)
 2b0:	fe442783          	lw	a5,-28(s0)
 2b4:	00078593          	mv	a1,a5
 2b8:	00001517          	auipc	a0,0x1
 2bc:	b6850513          	add	a0,a0,-1176 # e20 <uptime+0x140>
 2c0:	00000097          	auipc	ra,0x0
 2c4:	66c080e7          	jalr	1644(ra) # 92c <printf>
 2c8:	fe040793          	add	a5,s0,-32
 2cc:	3e800613          	li	a2,1000
 2d0:	00078593          	mv	a1,a5
 2d4:	00000513          	li	a0,0
 2d8:	00001097          	auipc	ra,0x1
 2dc:	948080e7          	jalr	-1720(ra) # c20 <read>
 2e0:	00050793          	mv	a5,a0
 2e4:	fef42223          	sw	a5,-28(s0)
 2e8:	00001517          	auipc	a0,0x1
 2ec:	b6850513          	add	a0,a0,-1176 # e50 <uptime+0x170>
 2f0:	00000097          	auipc	ra,0x0
 2f4:	63c080e7          	jalr	1596(ra) # 92c <printf>
 2f8:	00000013          	nop
 2fc:	01813083          	ld	ra,24(sp)
 300:	01013403          	ld	s0,16(sp)
 304:	02010113          	add	sp,sp,32
 308:	00008067          	ret

000000000000030c <test_syscall_performance>:
 30c:	fd010113          	add	sp,sp,-48
 310:	02113423          	sd	ra,40(sp)
 314:	02813023          	sd	s0,32(sp)
 318:	03010413          	add	s0,sp,48
 31c:	00001517          	auipc	a0,0x1
 320:	b5450513          	add	a0,a0,-1196 # e70 <uptime+0x190>
 324:	00000097          	auipc	ra,0x0
 328:	608080e7          	jalr	1544(ra) # 92c <printf>
 32c:	00001097          	auipc	ra,0x1
 330:	894080e7          	jalr	-1900(ra) # bc0 <get_time>
 334:	fea43023          	sd	a0,-32(s0)
 338:	fe042623          	sw	zero,-20(s0)
 33c:	0180006f          	j	354 <test_syscall_performance+0x48>
 340:	00001097          	auipc	ra,0x1
 344:	97c080e7          	jalr	-1668(ra) # cbc <getpid>
 348:	fec42783          	lw	a5,-20(s0)
 34c:	0017879b          	addw	a5,a5,1 # 1000001 <__global_pointer$+0xffd8c9>
 350:	fef42623          	sw	a5,-20(s0)
 354:	fec42783          	lw	a5,-20(s0)
 358:	0007871b          	sext.w	a4,a5
 35c:	000027b7          	lui	a5,0x2
 360:	70f78793          	add	a5,a5,1807 # 270f <__BSS_END__+0x7bf>
 364:	fce7dee3          	bge	a5,a4,340 <test_syscall_performance+0x34>
 368:	00001097          	auipc	ra,0x1
 36c:	858080e7          	jalr	-1960(ra) # bc0 <get_time>
 370:	fca43c23          	sd	a0,-40(s0)
 374:	fd843703          	ld	a4,-40(s0)
 378:	fe043783          	ld	a5,-32(s0)
 37c:	40f707b3          	sub	a5,a4,a5
 380:	00078593          	mv	a1,a5
 384:	00001517          	auipc	a0,0x1
 388:	b0c50513          	add	a0,a0,-1268 # e90 <uptime+0x1b0>
 38c:	00000097          	auipc	ra,0x0
 390:	5a0080e7          	jalr	1440(ra) # 92c <printf>
 394:	00000013          	nop
 398:	02813083          	ld	ra,40(sp)
 39c:	02013403          	ld	s0,32(sp)
 3a0:	03010113          	add	sp,sp,48
 3a4:	00008067          	ret

00000000000003a8 <run_syscall_tests>:
 3a8:	ff010113          	add	sp,sp,-16
 3ac:	00113423          	sd	ra,8(sp)
 3b0:	00813023          	sd	s0,0(sp)
 3b4:	01010413          	add	s0,sp,16
 3b8:	00000097          	auipc	ra,0x0
 3bc:	c48080e7          	jalr	-952(ra) # 0 <test_basic_syscalls>
 3c0:	00000097          	auipc	ra,0x0
 3c4:	d2c080e7          	jalr	-724(ra) # ec <test_parameter_passing>
 3c8:	00000097          	auipc	ra,0x0
 3cc:	ea4080e7          	jalr	-348(ra) # 26c <test_security>
 3d0:	00000097          	auipc	ra,0x0
 3d4:	f3c080e7          	jalr	-196(ra) # 30c <test_syscall_performance>
 3d8:	00001517          	auipc	a0,0x1
 3dc:	ae050513          	add	a0,a0,-1312 # eb8 <uptime+0x1d8>
 3e0:	00000097          	auipc	ra,0x0
 3e4:	54c080e7          	jalr	1356(ra) # 92c <printf>
 3e8:	0000006f          	j	3e8 <run_syscall_tests+0x40>

00000000000003ec <main>:
 3ec:	ff010113          	add	sp,sp,-16
 3f0:	00113423          	sd	ra,8(sp)
 3f4:	00813023          	sd	s0,0(sp)
 3f8:	01010413          	add	s0,sp,16
 3fc:	00001517          	auipc	a0,0x1
 400:	adc50513          	add	a0,a0,-1316 # ed8 <uptime+0x1f8>
 404:	00000097          	auipc	ra,0x0
 408:	528080e7          	jalr	1320(ra) # 92c <printf>
 40c:	00000097          	auipc	ra,0x0
 410:	f9c080e7          	jalr	-100(ra) # 3a8 <run_syscall_tests>
 414:	00001517          	auipc	a0,0x1
 418:	ae450513          	add	a0,a0,-1308 # ef8 <uptime+0x218>
 41c:	00000097          	auipc	ra,0x0
 420:	510080e7          	jalr	1296(ra) # 92c <printf>
 424:	00000513          	li	a0,0
 428:	00000097          	auipc	ra,0x0
 42c:	7d4080e7          	jalr	2004(ra) # bfc <exit>

0000000000000430 <strcpy>:
 430:	fd010113          	add	sp,sp,-48
 434:	02813423          	sd	s0,40(sp)
 438:	03010413          	add	s0,sp,48
 43c:	fca43c23          	sd	a0,-40(s0)
 440:	fcb43823          	sd	a1,-48(s0)
 444:	fd843783          	ld	a5,-40(s0)
 448:	fef43423          	sd	a5,-24(s0)
 44c:	00000013          	nop
 450:	fd043703          	ld	a4,-48(s0)
 454:	00170793          	add	a5,a4,1
 458:	fcf43823          	sd	a5,-48(s0)
 45c:	fd843783          	ld	a5,-40(s0)
 460:	00178693          	add	a3,a5,1
 464:	fcd43c23          	sd	a3,-40(s0)
 468:	00074703          	lbu	a4,0(a4)
 46c:	00e78023          	sb	a4,0(a5)
 470:	0007c783          	lbu	a5,0(a5)
 474:	fc079ee3          	bnez	a5,450 <strcpy+0x20>
 478:	fe843783          	ld	a5,-24(s0)
 47c:	00078513          	mv	a0,a5
 480:	02813403          	ld	s0,40(sp)
 484:	03010113          	add	sp,sp,48
 488:	00008067          	ret

000000000000048c <strcmp>:
 48c:	fe010113          	add	sp,sp,-32
 490:	00813c23          	sd	s0,24(sp)
 494:	02010413          	add	s0,sp,32
 498:	fea43423          	sd	a0,-24(s0)
 49c:	feb43023          	sd	a1,-32(s0)
 4a0:	01c0006f          	j	4bc <strcmp+0x30>
 4a4:	fe843783          	ld	a5,-24(s0)
 4a8:	00178793          	add	a5,a5,1
 4ac:	fef43423          	sd	a5,-24(s0)
 4b0:	fe043783          	ld	a5,-32(s0)
 4b4:	00178793          	add	a5,a5,1
 4b8:	fef43023          	sd	a5,-32(s0)
 4bc:	fe843783          	ld	a5,-24(s0)
 4c0:	0007c783          	lbu	a5,0(a5)
 4c4:	00078c63          	beqz	a5,4dc <strcmp+0x50>
 4c8:	fe843783          	ld	a5,-24(s0)
 4cc:	0007c703          	lbu	a4,0(a5)
 4d0:	fe043783          	ld	a5,-32(s0)
 4d4:	0007c783          	lbu	a5,0(a5)
 4d8:	fcf706e3          	beq	a4,a5,4a4 <strcmp+0x18>
 4dc:	fe843783          	ld	a5,-24(s0)
 4e0:	0007c783          	lbu	a5,0(a5)
 4e4:	0007871b          	sext.w	a4,a5
 4e8:	fe043783          	ld	a5,-32(s0)
 4ec:	0007c783          	lbu	a5,0(a5)
 4f0:	0007879b          	sext.w	a5,a5
 4f4:	40f707bb          	subw	a5,a4,a5
 4f8:	0007879b          	sext.w	a5,a5
 4fc:	00078513          	mv	a0,a5
 500:	01813403          	ld	s0,24(sp)
 504:	02010113          	add	sp,sp,32
 508:	00008067          	ret

000000000000050c <strlen>:
 50c:	fd010113          	add	sp,sp,-48
 510:	02813423          	sd	s0,40(sp)
 514:	03010413          	add	s0,sp,48
 518:	fca43c23          	sd	a0,-40(s0)
 51c:	fe042623          	sw	zero,-20(s0)
 520:	0100006f          	j	530 <strlen+0x24>
 524:	fec42783          	lw	a5,-20(s0)
 528:	0017879b          	addw	a5,a5,1
 52c:	fef42623          	sw	a5,-20(s0)
 530:	fec42783          	lw	a5,-20(s0)
 534:	fd843703          	ld	a4,-40(s0)
 538:	00f707b3          	add	a5,a4,a5
 53c:	0007c783          	lbu	a5,0(a5)
 540:	fe0792e3          	bnez	a5,524 <strlen+0x18>
 544:	fec42783          	lw	a5,-20(s0)
 548:	00078513          	mv	a0,a5
 54c:	02813403          	ld	s0,40(sp)
 550:	03010113          	add	sp,sp,48
 554:	00008067          	ret

0000000000000558 <memset>:
 558:	fd010113          	add	sp,sp,-48
 55c:	02813423          	sd	s0,40(sp)
 560:	03010413          	add	s0,sp,48
 564:	fca43c23          	sd	a0,-40(s0)
 568:	00058793          	mv	a5,a1
 56c:	00060713          	mv	a4,a2
 570:	fcf42a23          	sw	a5,-44(s0)
 574:	00070793          	mv	a5,a4
 578:	fcf42823          	sw	a5,-48(s0)
 57c:	fd843783          	ld	a5,-40(s0)
 580:	fef43023          	sd	a5,-32(s0)
 584:	fe042623          	sw	zero,-20(s0)
 588:	0280006f          	j	5b0 <memset+0x58>
 58c:	fec42783          	lw	a5,-20(s0)
 590:	fe043703          	ld	a4,-32(s0)
 594:	00f707b3          	add	a5,a4,a5
 598:	fd442703          	lw	a4,-44(s0)
 59c:	0ff77713          	zext.b	a4,a4
 5a0:	00e78023          	sb	a4,0(a5)
 5a4:	fec42783          	lw	a5,-20(s0)
 5a8:	0017879b          	addw	a5,a5,1
 5ac:	fef42623          	sw	a5,-20(s0)
 5b0:	fec42703          	lw	a4,-20(s0)
 5b4:	fd042783          	lw	a5,-48(s0)
 5b8:	0007879b          	sext.w	a5,a5
 5bc:	fcf768e3          	bltu	a4,a5,58c <memset+0x34>
 5c0:	fd843783          	ld	a5,-40(s0)
 5c4:	00078513          	mv	a0,a5
 5c8:	02813403          	ld	s0,40(sp)
 5cc:	03010113          	add	sp,sp,48
 5d0:	00008067          	ret

00000000000005d4 <strchr>:
 5d4:	fe010113          	add	sp,sp,-32
 5d8:	00813c23          	sd	s0,24(sp)
 5dc:	02010413          	add	s0,sp,32
 5e0:	fea43423          	sd	a0,-24(s0)
 5e4:	00058793          	mv	a5,a1
 5e8:	fef403a3          	sb	a5,-25(s0)
 5ec:	02c0006f          	j	618 <strchr+0x44>
 5f0:	fe843783          	ld	a5,-24(s0)
 5f4:	0007c703          	lbu	a4,0(a5)
 5f8:	fe744783          	lbu	a5,-25(s0)
 5fc:	0ff7f793          	zext.b	a5,a5
 600:	00e79663          	bne	a5,a4,60c <strchr+0x38>
 604:	fe843783          	ld	a5,-24(s0)
 608:	0200006f          	j	628 <strchr+0x54>
 60c:	fe843783          	ld	a5,-24(s0)
 610:	00178793          	add	a5,a5,1
 614:	fef43423          	sd	a5,-24(s0)
 618:	fe843783          	ld	a5,-24(s0)
 61c:	0007c783          	lbu	a5,0(a5)
 620:	fc0798e3          	bnez	a5,5f0 <strchr+0x1c>
 624:	00000793          	li	a5,0
 628:	00078513          	mv	a0,a5
 62c:	01813403          	ld	s0,24(sp)
 630:	02010113          	add	sp,sp,32
 634:	00008067          	ret

0000000000000638 <atoi>:
 638:	fd010113          	add	sp,sp,-48
 63c:	02813423          	sd	s0,40(sp)
 640:	03010413          	add	s0,sp,48
 644:	fca43c23          	sd	a0,-40(s0)
 648:	fe042623          	sw	zero,-20(s0)
 64c:	0440006f          	j	690 <atoi+0x58>
 650:	fec42783          	lw	a5,-20(s0)
 654:	00078713          	mv	a4,a5
 658:	00070793          	mv	a5,a4
 65c:	0027979b          	sllw	a5,a5,0x2
 660:	00e787bb          	addw	a5,a5,a4
 664:	0017979b          	sllw	a5,a5,0x1
 668:	0007871b          	sext.w	a4,a5
 66c:	fd843783          	ld	a5,-40(s0)
 670:	00178693          	add	a3,a5,1
 674:	fcd43c23          	sd	a3,-40(s0)
 678:	0007c783          	lbu	a5,0(a5)
 67c:	0007879b          	sext.w	a5,a5
 680:	00f707bb          	addw	a5,a4,a5
 684:	0007879b          	sext.w	a5,a5
 688:	fd07879b          	addw	a5,a5,-48
 68c:	fef42623          	sw	a5,-20(s0)
 690:	fd843783          	ld	a5,-40(s0)
 694:	0007c783          	lbu	a5,0(a5)
 698:	00078713          	mv	a4,a5
 69c:	02f00793          	li	a5,47
 6a0:	00e7fc63          	bgeu	a5,a4,6b8 <atoi+0x80>
 6a4:	fd843783          	ld	a5,-40(s0)
 6a8:	0007c783          	lbu	a5,0(a5)
 6ac:	00078713          	mv	a4,a5
 6b0:	03900793          	li	a5,57
 6b4:	f8e7fee3          	bgeu	a5,a4,650 <atoi+0x18>
 6b8:	fec42783          	lw	a5,-20(s0)
 6bc:	00078513          	mv	a0,a5
 6c0:	02813403          	ld	s0,40(sp)
 6c4:	03010113          	add	sp,sp,48
 6c8:	00008067          	ret

00000000000006cc <putc>:
 6cc:	fe010113          	add	sp,sp,-32
 6d0:	00113c23          	sd	ra,24(sp)
 6d4:	00813823          	sd	s0,16(sp)
 6d8:	02010413          	add	s0,sp,32
 6dc:	00050793          	mv	a5,a0
 6e0:	00058713          	mv	a4,a1
 6e4:	fef42623          	sw	a5,-20(s0)
 6e8:	00070793          	mv	a5,a4
 6ec:	fef405a3          	sb	a5,-21(s0)
 6f0:	feb40713          	add	a4,s0,-21
 6f4:	fec42783          	lw	a5,-20(s0)
 6f8:	00100613          	li	a2,1
 6fc:	00070593          	mv	a1,a4
 700:	00078513          	mv	a0,a5
 704:	00000097          	auipc	ra,0x0
 708:	528080e7          	jalr	1320(ra) # c2c <write>
 70c:	00000013          	nop
 710:	01813083          	ld	ra,24(sp)
 714:	01013403          	ld	s0,16(sp)
 718:	02010113          	add	sp,sp,32
 71c:	00008067          	ret

0000000000000720 <printint>:
 720:	fc010113          	add	sp,sp,-64
 724:	02113c23          	sd	ra,56(sp)
 728:	02813823          	sd	s0,48(sp)
 72c:	04010413          	add	s0,sp,64
 730:	00050793          	mv	a5,a0
 734:	00068713          	mv	a4,a3
 738:	fcf42623          	sw	a5,-52(s0)
 73c:	00058793          	mv	a5,a1
 740:	fcf42423          	sw	a5,-56(s0)
 744:	00060793          	mv	a5,a2
 748:	fcf42223          	sw	a5,-60(s0)
 74c:	00070793          	mv	a5,a4
 750:	fcf42023          	sw	a5,-64(s0)
 754:	fe042423          	sw	zero,-24(s0)
 758:	fc042783          	lw	a5,-64(s0)
 75c:	0007879b          	sext.w	a5,a5
 760:	02078663          	beqz	a5,78c <printint+0x6c>
 764:	fc842783          	lw	a5,-56(s0)
 768:	0007879b          	sext.w	a5,a5
 76c:	0207d063          	bgez	a5,78c <printint+0x6c>
 770:	00100793          	li	a5,1
 774:	fef42423          	sw	a5,-24(s0)
 778:	fc842783          	lw	a5,-56(s0)
 77c:	40f007bb          	negw	a5,a5
 780:	0007879b          	sext.w	a5,a5
 784:	fef42223          	sw	a5,-28(s0)
 788:	00c0006f          	j	794 <printint+0x74>
 78c:	fc842783          	lw	a5,-56(s0)
 790:	fef42223          	sw	a5,-28(s0)
 794:	fe042623          	sw	zero,-20(s0)
 798:	fc442783          	lw	a5,-60(s0)
 79c:	fe442703          	lw	a4,-28(s0)
 7a0:	02f777bb          	remuw	a5,a4,a5
 7a4:	0007861b          	sext.w	a2,a5
 7a8:	fec42783          	lw	a5,-20(s0)
 7ac:	0017871b          	addw	a4,a5,1
 7b0:	fee42623          	sw	a4,-20(s0)
 7b4:	00001697          	auipc	a3,0x1
 7b8:	78468693          	add	a3,a3,1924 # 1f38 <digits.0>
 7bc:	02061713          	sll	a4,a2,0x20
 7c0:	02075713          	srl	a4,a4,0x20
 7c4:	00e68733          	add	a4,a3,a4
 7c8:	00074703          	lbu	a4,0(a4)
 7cc:	ff078793          	add	a5,a5,-16
 7d0:	008787b3          	add	a5,a5,s0
 7d4:	fee78023          	sb	a4,-32(a5)
 7d8:	fc442783          	lw	a5,-60(s0)
 7dc:	fe442703          	lw	a4,-28(s0)
 7e0:	02f757bb          	divuw	a5,a4,a5
 7e4:	fef42223          	sw	a5,-28(s0)
 7e8:	fe442783          	lw	a5,-28(s0)
 7ec:	0007879b          	sext.w	a5,a5
 7f0:	fa0794e3          	bnez	a5,798 <printint+0x78>
 7f4:	fe842783          	lw	a5,-24(s0)
 7f8:	0007879b          	sext.w	a5,a5
 7fc:	04078463          	beqz	a5,844 <printint+0x124>
 800:	fec42783          	lw	a5,-20(s0)
 804:	0017871b          	addw	a4,a5,1
 808:	fee42623          	sw	a4,-20(s0)
 80c:	ff078793          	add	a5,a5,-16
 810:	008787b3          	add	a5,a5,s0
 814:	02d00713          	li	a4,45
 818:	fee78023          	sb	a4,-32(a5)
 81c:	0280006f          	j	844 <printint+0x124>
 820:	fec42783          	lw	a5,-20(s0)
 824:	ff078793          	add	a5,a5,-16
 828:	008787b3          	add	a5,a5,s0
 82c:	fe07c703          	lbu	a4,-32(a5)
 830:	fcc42783          	lw	a5,-52(s0)
 834:	00070593          	mv	a1,a4
 838:	00078513          	mv	a0,a5
 83c:	00000097          	auipc	ra,0x0
 840:	e90080e7          	jalr	-368(ra) # 6cc <putc>
 844:	fec42783          	lw	a5,-20(s0)
 848:	fff7879b          	addw	a5,a5,-1
 84c:	fef42623          	sw	a5,-20(s0)
 850:	fec42783          	lw	a5,-20(s0)
 854:	0007879b          	sext.w	a5,a5
 858:	fc07d4e3          	bgez	a5,820 <printint+0x100>
 85c:	00000013          	nop
 860:	00000013          	nop
 864:	03813083          	ld	ra,56(sp)
 868:	03013403          	ld	s0,48(sp)
 86c:	04010113          	add	sp,sp,64
 870:	00008067          	ret

0000000000000874 <printptr>:
 874:	fd010113          	add	sp,sp,-48
 878:	02113423          	sd	ra,40(sp)
 87c:	02813023          	sd	s0,32(sp)
 880:	03010413          	add	s0,sp,48
 884:	00050793          	mv	a5,a0
 888:	fcb43823          	sd	a1,-48(s0)
 88c:	fcf42e23          	sw	a5,-36(s0)
 890:	fdc42783          	lw	a5,-36(s0)
 894:	03000593          	li	a1,48
 898:	00078513          	mv	a0,a5
 89c:	00000097          	auipc	ra,0x0
 8a0:	e30080e7          	jalr	-464(ra) # 6cc <putc>
 8a4:	fdc42783          	lw	a5,-36(s0)
 8a8:	07800593          	li	a1,120
 8ac:	00078513          	mv	a0,a5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	e1c080e7          	jalr	-484(ra) # 6cc <putc>
 8b8:	fe042623          	sw	zero,-20(s0)
 8bc:	0480006f          	j	904 <printptr+0x90>
 8c0:	fd043783          	ld	a5,-48(s0)
 8c4:	03c7d793          	srl	a5,a5,0x3c
 8c8:	00000717          	auipc	a4,0x0
 8cc:	65070713          	add	a4,a4,1616 # f18 <uptime+0x238>
 8d0:	00f707b3          	add	a5,a4,a5
 8d4:	0007c703          	lbu	a4,0(a5)
 8d8:	fdc42783          	lw	a5,-36(s0)
 8dc:	00070593          	mv	a1,a4
 8e0:	00078513          	mv	a0,a5
 8e4:	00000097          	auipc	ra,0x0
 8e8:	de8080e7          	jalr	-536(ra) # 6cc <putc>
 8ec:	fec42783          	lw	a5,-20(s0)
 8f0:	0017879b          	addw	a5,a5,1
 8f4:	fef42623          	sw	a5,-20(s0)
 8f8:	fd043783          	ld	a5,-48(s0)
 8fc:	00479793          	sll	a5,a5,0x4
 900:	fcf43823          	sd	a5,-48(s0)
 904:	fec42783          	lw	a5,-20(s0)
 908:	00078713          	mv	a4,a5
 90c:	00f00793          	li	a5,15
 910:	fae7f8e3          	bgeu	a5,a4,8c0 <printptr+0x4c>
 914:	00000013          	nop
 918:	00000013          	nop
 91c:	02813083          	ld	ra,40(sp)
 920:	02013403          	ld	s0,32(sp)
 924:	03010113          	add	sp,sp,48
 928:	00008067          	ret

000000000000092c <printf>:
 92c:	f8010113          	add	sp,sp,-128
 930:	02113c23          	sd	ra,56(sp)
 934:	02813823          	sd	s0,48(sp)
 938:	04010413          	add	s0,sp,64
 93c:	fca43423          	sd	a0,-56(s0)
 940:	00b43423          	sd	a1,8(s0)
 944:	00c43823          	sd	a2,16(s0)
 948:	00d43c23          	sd	a3,24(s0)
 94c:	02e43023          	sd	a4,32(s0)
 950:	02f43423          	sd	a5,40(s0)
 954:	03043823          	sd	a6,48(s0)
 958:	03143c23          	sd	a7,56(s0)
 95c:	04040793          	add	a5,s0,64
 960:	fcf43023          	sd	a5,-64(s0)
 964:	fc043783          	ld	a5,-64(s0)
 968:	fc878793          	add	a5,a5,-56
 96c:	fcf43823          	sd	a5,-48(s0)
 970:	fe042023          	sw	zero,-32(s0)
 974:	fe042223          	sw	zero,-28(s0)
 978:	21c0006f          	j	b94 <printf+0x268>
 97c:	fe442783          	lw	a5,-28(s0)
 980:	fc843703          	ld	a4,-56(s0)
 984:	00f707b3          	add	a5,a4,a5
 988:	0007c783          	lbu	a5,0(a5)
 98c:	fcf42e23          	sw	a5,-36(s0)
 990:	fe042783          	lw	a5,-32(s0)
 994:	0007879b          	sext.w	a5,a5
 998:	02079e63          	bnez	a5,9d4 <printf+0xa8>
 99c:	fdc42783          	lw	a5,-36(s0)
 9a0:	0007871b          	sext.w	a4,a5
 9a4:	02500793          	li	a5,37
 9a8:	00f71863          	bne	a4,a5,9b8 <printf+0x8c>
 9ac:	02500793          	li	a5,37
 9b0:	fef42023          	sw	a5,-32(s0)
 9b4:	1d40006f          	j	b88 <printf+0x25c>
 9b8:	fdc42783          	lw	a5,-36(s0)
 9bc:	0ff7f793          	zext.b	a5,a5
 9c0:	00078593          	mv	a1,a5
 9c4:	00100513          	li	a0,1
 9c8:	00000097          	auipc	ra,0x0
 9cc:	d04080e7          	jalr	-764(ra) # 6cc <putc>
 9d0:	1b80006f          	j	b88 <printf+0x25c>
 9d4:	fe042783          	lw	a5,-32(s0)
 9d8:	0007871b          	sext.w	a4,a5
 9dc:	02500793          	li	a5,37
 9e0:	1af71463          	bne	a4,a5,b88 <printf+0x25c>
 9e4:	fdc42783          	lw	a5,-36(s0)
 9e8:	0007871b          	sext.w	a4,a5
 9ec:	06400793          	li	a5,100
 9f0:	02f71863          	bne	a4,a5,a20 <printf+0xf4>
 9f4:	fd043783          	ld	a5,-48(s0)
 9f8:	00878713          	add	a4,a5,8
 9fc:	fce43823          	sd	a4,-48(s0)
 a00:	0007a783          	lw	a5,0(a5)
 a04:	00100693          	li	a3,1
 a08:	00a00613          	li	a2,10
 a0c:	00078593          	mv	a1,a5
 a10:	00100513          	li	a0,1
 a14:	00000097          	auipc	ra,0x0
 a18:	d0c080e7          	jalr	-756(ra) # 720 <printint>
 a1c:	1680006f          	j	b84 <printf+0x258>
 a20:	fdc42783          	lw	a5,-36(s0)
 a24:	0007871b          	sext.w	a4,a5
 a28:	07800793          	li	a5,120
 a2c:	02f71863          	bne	a4,a5,a5c <printf+0x130>
 a30:	fd043783          	ld	a5,-48(s0)
 a34:	00878713          	add	a4,a5,8
 a38:	fce43823          	sd	a4,-48(s0)
 a3c:	0007a783          	lw	a5,0(a5)
 a40:	00000693          	li	a3,0
 a44:	01000613          	li	a2,16
 a48:	00078593          	mv	a1,a5
 a4c:	00100513          	li	a0,1
 a50:	00000097          	auipc	ra,0x0
 a54:	cd0080e7          	jalr	-816(ra) # 720 <printint>
 a58:	12c0006f          	j	b84 <printf+0x258>
 a5c:	fdc42783          	lw	a5,-36(s0)
 a60:	0007871b          	sext.w	a4,a5
 a64:	07000793          	li	a5,112
 a68:	02f71463          	bne	a4,a5,a90 <printf+0x164>
 a6c:	fd043783          	ld	a5,-48(s0)
 a70:	00878713          	add	a4,a5,8
 a74:	fce43823          	sd	a4,-48(s0)
 a78:	0007b783          	ld	a5,0(a5)
 a7c:	00078593          	mv	a1,a5
 a80:	00100513          	li	a0,1
 a84:	00000097          	auipc	ra,0x0
 a88:	df0080e7          	jalr	-528(ra) # 874 <printptr>
 a8c:	0f80006f          	j	b84 <printf+0x258>
 a90:	fdc42783          	lw	a5,-36(s0)
 a94:	0007871b          	sext.w	a4,a5
 a98:	07300793          	li	a5,115
 a9c:	06f71263          	bne	a4,a5,b00 <printf+0x1d4>
 aa0:	fd043783          	ld	a5,-48(s0)
 aa4:	00878713          	add	a4,a5,8
 aa8:	fce43823          	sd	a4,-48(s0)
 aac:	0007b783          	ld	a5,0(a5)
 ab0:	fef43423          	sd	a5,-24(s0)
 ab4:	fe843783          	ld	a5,-24(s0)
 ab8:	02079c63          	bnez	a5,af0 <printf+0x1c4>
 abc:	00000797          	auipc	a5,0x0
 ac0:	47478793          	add	a5,a5,1140 # f30 <uptime+0x250>
 ac4:	fef43423          	sd	a5,-24(s0)
 ac8:	0280006f          	j	af0 <printf+0x1c4>
 acc:	fe843783          	ld	a5,-24(s0)
 ad0:	0007c783          	lbu	a5,0(a5)
 ad4:	00078593          	mv	a1,a5
 ad8:	00100513          	li	a0,1
 adc:	00000097          	auipc	ra,0x0
 ae0:	bf0080e7          	jalr	-1040(ra) # 6cc <putc>
 ae4:	fe843783          	ld	a5,-24(s0)
 ae8:	00178793          	add	a5,a5,1
 aec:	fef43423          	sd	a5,-24(s0)
 af0:	fe843783          	ld	a5,-24(s0)
 af4:	0007c783          	lbu	a5,0(a5)
 af8:	fc079ae3          	bnez	a5,acc <printf+0x1a0>
 afc:	0880006f          	j	b84 <printf+0x258>
 b00:	fdc42783          	lw	a5,-36(s0)
 b04:	0007871b          	sext.w	a4,a5
 b08:	06300793          	li	a5,99
 b0c:	02f71663          	bne	a4,a5,b38 <printf+0x20c>
 b10:	fd043783          	ld	a5,-48(s0)
 b14:	00878713          	add	a4,a5,8
 b18:	fce43823          	sd	a4,-48(s0)
 b1c:	0007a783          	lw	a5,0(a5)
 b20:	0ff7f793          	zext.b	a5,a5
 b24:	00078593          	mv	a1,a5
 b28:	00100513          	li	a0,1
 b2c:	00000097          	auipc	ra,0x0
 b30:	ba0080e7          	jalr	-1120(ra) # 6cc <putc>
 b34:	0500006f          	j	b84 <printf+0x258>
 b38:	fdc42783          	lw	a5,-36(s0)
 b3c:	0007871b          	sext.w	a4,a5
 b40:	02500793          	li	a5,37
 b44:	00f71c63          	bne	a4,a5,b5c <printf+0x230>
 b48:	02500593          	li	a1,37
 b4c:	00100513          	li	a0,1
 b50:	00000097          	auipc	ra,0x0
 b54:	b7c080e7          	jalr	-1156(ra) # 6cc <putc>
 b58:	02c0006f          	j	b84 <printf+0x258>
 b5c:	02500593          	li	a1,37
 b60:	00100513          	li	a0,1
 b64:	00000097          	auipc	ra,0x0
 b68:	b68080e7          	jalr	-1176(ra) # 6cc <putc>
 b6c:	fdc42783          	lw	a5,-36(s0)
 b70:	0ff7f793          	zext.b	a5,a5
 b74:	00078593          	mv	a1,a5
 b78:	00100513          	li	a0,1
 b7c:	00000097          	auipc	ra,0x0
 b80:	b50080e7          	jalr	-1200(ra) # 6cc <putc>
 b84:	fe042023          	sw	zero,-32(s0)
 b88:	fe442783          	lw	a5,-28(s0)
 b8c:	0017879b          	addw	a5,a5,1
 b90:	fef42223          	sw	a5,-28(s0)
 b94:	fe442783          	lw	a5,-28(s0)
 b98:	fc843703          	ld	a4,-56(s0)
 b9c:	00f707b3          	add	a5,a4,a5
 ba0:	0007c783          	lbu	a5,0(a5)
 ba4:	dc079ce3          	bnez	a5,97c <printf+0x50>
 ba8:	00000013          	nop
 bac:	00000013          	nop
 bb0:	03813083          	ld	ra,56(sp)
 bb4:	03013403          	ld	s0,48(sp)
 bb8:	08010113          	add	sp,sp,128
 bbc:	00008067          	ret

0000000000000bc0 <get_time>:
 bc0:	ff010113          	add	sp,sp,-16
 bc4:	00113423          	sd	ra,8(sp)
 bc8:	00813023          	sd	s0,0(sp)
 bcc:	01010413          	add	s0,sp,16
 bd0:	00000097          	auipc	ra,0x0
 bd4:	110080e7          	jalr	272(ra) # ce0 <uptime>
 bd8:	00050793          	mv	a5,a0
 bdc:	00078513          	mv	a0,a5
 be0:	00813083          	ld	ra,8(sp)
 be4:	00013403          	ld	s0,0(sp)
 be8:	01010113          	add	sp,sp,16
 bec:	00008067          	ret

0000000000000bf0 <fork>:
 bf0:	00100893          	li	a7,1
 bf4:	00000073          	ecall
 bf8:	00008067          	ret

0000000000000bfc <exit>:
 bfc:	00200893          	li	a7,2
 c00:	00000073          	ecall
 c04:	00008067          	ret

0000000000000c08 <wait>:
 c08:	00300893          	li	a7,3
 c0c:	00000073          	ecall
 c10:	00008067          	ret

0000000000000c14 <pipe>:
 c14:	00400893          	li	a7,4
 c18:	00000073          	ecall
 c1c:	00008067          	ret

0000000000000c20 <read>:
 c20:	00500893          	li	a7,5
 c24:	00000073          	ecall
 c28:	00008067          	ret

0000000000000c2c <write>:
 c2c:	01000893          	li	a7,16
 c30:	00000073          	ecall
 c34:	00008067          	ret

0000000000000c38 <close>:
 c38:	01500893          	li	a7,21
 c3c:	00000073          	ecall
 c40:	00008067          	ret

0000000000000c44 <kill>:
 c44:	00600893          	li	a7,6
 c48:	00000073          	ecall
 c4c:	00008067          	ret

0000000000000c50 <exec>:
 c50:	00700893          	li	a7,7
 c54:	00000073          	ecall
 c58:	00008067          	ret

0000000000000c5c <open>:
 c5c:	00f00893          	li	a7,15
 c60:	00000073          	ecall
 c64:	00008067          	ret

0000000000000c68 <mknod>:
 c68:	01100893          	li	a7,17
 c6c:	00000073          	ecall
 c70:	00008067          	ret

0000000000000c74 <unlink>:
 c74:	01200893          	li	a7,18
 c78:	00000073          	ecall
 c7c:	00008067          	ret

0000000000000c80 <fstat>:
 c80:	00800893          	li	a7,8
 c84:	00000073          	ecall
 c88:	00008067          	ret

0000000000000c8c <link>:
 c8c:	01300893          	li	a7,19
 c90:	00000073          	ecall
 c94:	00008067          	ret

0000000000000c98 <mkdir>:
 c98:	01400893          	li	a7,20
 c9c:	00000073          	ecall
 ca0:	00008067          	ret

0000000000000ca4 <chdir>:
 ca4:	00900893          	li	a7,9
 ca8:	00000073          	ecall
 cac:	00008067          	ret

0000000000000cb0 <dup>:
 cb0:	00a00893          	li	a7,10
 cb4:	00000073          	ecall
 cb8:	00008067          	ret

0000000000000cbc <getpid>:
 cbc:	00b00893          	li	a7,11
 cc0:	00000073          	ecall
 cc4:	00008067          	ret

0000000000000cc8 <sbrk>:
 cc8:	00c00893          	li	a7,12
 ccc:	00000073          	ecall
 cd0:	00008067          	ret

0000000000000cd4 <sleep>:
 cd4:	00d00893          	li	a7,13
 cd8:	00000073          	ecall
 cdc:	00008067          	ret

0000000000000ce0 <uptime>:
 ce0:	00e00893          	li	a7,14
 ce4:	00000073          	ecall
 ce8:	00008067          	ret
