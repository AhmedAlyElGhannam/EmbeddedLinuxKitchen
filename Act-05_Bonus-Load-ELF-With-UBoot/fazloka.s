
kernel7.elf:     file format elf64-littleaarch64


Disassembly of section .text:

000000000c100000 <__start>:
 c100000:	14000010 	b	c100040 <main>

000000000c100004 <here>:
 c100004:	14000000 	b	c100004 <here>

000000000c100008 <delay>:
 c100008:	d10083ff 	sub	sp, sp, #0x20
 c10000c:	f90007e0 	str	x0, [sp, #8]
 c100010:	14000004 	b	c100020 <delay+0x18>
 c100014:	b9401fe0 	ldr	w0, [sp, #28]
 c100018:	11000400 	add	w0, w0, #0x1
 c10001c:	b9001fe0 	str	w0, [sp, #28]
 c100020:	b9801fe0 	ldrsw	x0, [sp, #28]
 c100024:	f94007e1 	ldr	x1, [sp, #8]
 c100028:	eb00003f 	cmp	x1, x0
 c10002c:	54ffff48 	b.hi	c100014 <delay+0xc>  // b.pmore
 c100030:	d503201f 	nop
 c100034:	d503201f 	nop
 c100038:	910083ff 	add	sp, sp, #0x20
 c10003c:	d65f03c0 	ret

000000000c100040 <main>:
 c100040:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
 c100044:	910003fd 	mov	x29, sp
 c100048:	d2800100 	mov	x0, #0x8                   	// #8
 c10004c:	f2a7e400 	movk	x0, #0x3f20, lsl #16
 c100050:	b9400001 	ldr	w1, [x0]
 c100054:	d2800100 	mov	x0, #0x8                   	// #8
 c100058:	f2a7e400 	movk	x0, #0x3f20, lsl #16
 c10005c:	120b7021 	and	w1, w1, #0xffe3ffff
 c100060:	b9000001 	str	w1, [x0]
 c100064:	d2800100 	mov	x0, #0x8                   	// #8
 c100068:	f2a7e400 	movk	x0, #0x3f20, lsl #16
 c10006c:	b9400001 	ldr	w1, [x0]
 c100070:	d2800100 	mov	x0, #0x8                   	// #8
 c100074:	f2a7e400 	movk	x0, #0x3f20, lsl #16
 c100078:	320e0021 	orr	w1, w1, #0x40000
 c10007c:	b9000001 	str	w1, [x0]
 c100080:	d2800380 	mov	x0, #0x1c                  	// #28
 c100084:	f2a7e400 	movk	x0, #0x3f20, lsl #16
 c100088:	b9400001 	ldr	w1, [x0]
 c10008c:	d2800380 	mov	x0, #0x1c                  	// #28
 c100090:	f2a7e400 	movk	x0, #0x3f20, lsl #16
 c100094:	32060021 	orr	w1, w1, #0x4000000
 c100098:	b9000001 	str	w1, [x0]
 c10009c:	d2a00200 	mov	x0, #0x100000              	// #1048576
 c1000a0:	97ffffda 	bl	c100008 <delay>
 c1000a4:	d2800500 	mov	x0, #0x28                  	// #40
 c1000a8:	f2a7e400 	movk	x0, #0x3f20, lsl #16
 c1000ac:	b9400001 	ldr	w1, [x0]
 c1000b0:	d2800500 	mov	x0, #0x28                  	// #40
 c1000b4:	f2a7e400 	movk	x0, #0x3f20, lsl #16
 c1000b8:	32060021 	orr	w1, w1, #0x4000000
 c1000bc:	b9000001 	str	w1, [x0]
 c1000c0:	d2a00200 	mov	x0, #0x100000              	// #1048576
 c1000c4:	97ffffd1 	bl	c100008 <delay>
 c1000c8:	17ffffee 	b	c100080 <main+0x40>
