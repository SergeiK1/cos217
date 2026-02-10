	.arch armv8-a
	.file	"decomment3.c"
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"Error: line %d: unterminated comment\n"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	mov	w0, 1
	str	w0, [sp, 56]
	mov	w0, 1
	str	w0, [sp, 52]
	str	wzr, [sp, 48]
	str	wzr, [sp, 44]
	str	wzr, [sp, 40]
	str	wzr, [sp, 36]
	str	wzr, [sp, 32]
	str	wzr, [sp, 28]
.L26:
	ldr	w0, [sp, 28]
	cmp	w0, 0
	bne	.L2
	bl	getchar
	str	w0, [sp, 60]
	b	.L3
.L2:
	str	wzr, [sp, 28]
.L3:
	ldr	w0, [sp, 60]
	cmn	w0, #1
	beq	.L29
	ldr	w0, [sp, 60]
	cmp	w0, 10
	bne	.L6
	ldr	w0, [sp, 56]
	add	w0, w0, 1
	str	w0, [sp, 56]
.L6:
	ldr	w0, [sp, 48]
	cmp	w0, 0
	beq	.L7
	ldr	w0, [sp, 60]
	cmp	w0, 10
	bne	.L8
	mov	w0, 10
	bl	putchar
.L8:
	ldr	w0, [sp, 44]
	cmp	w0, 0
	beq	.L9
	ldr	w0, [sp, 60]
	cmp	w0, 47
	bne	.L9
	str	wzr, [sp, 48]
	str	wzr, [sp, 44]
	b	.L11
.L9:
	ldr	w0, [sp, 60]
	cmp	w0, 42
	cset	w0, eq
	and	w0, w0, 255
	str	w0, [sp, 44]
	b	.L11
.L7:
	ldr	w0, [sp, 40]
	cmp	w0, 0
	beq	.L12
	ldr	w0, [sp, 60]
	bl	putchar
	ldr	w0, [sp, 32]
	cmp	w0, 0
	beq	.L13
	str	wzr, [sp, 32]
	b	.L30
.L13:
	ldr	w0, [sp, 60]
	cmp	w0, 92
	bne	.L15
	mov	w0, 1
	str	w0, [sp, 32]
	b	.L30
.L15:
	ldr	w0, [sp, 60]
	cmp	w0, 34
	bne	.L30
	str	wzr, [sp, 40]
	b	.L30
.L12:
	ldr	w0, [sp, 36]
	cmp	w0, 0
	beq	.L16
	ldr	w0, [sp, 60]
	bl	putchar
	ldr	w0, [sp, 32]
	cmp	w0, 0
	beq	.L17
	str	wzr, [sp, 32]
	b	.L31
.L17:
	ldr	w0, [sp, 60]
	cmp	w0, 92
	bne	.L19
	mov	w0, 1
	str	w0, [sp, 32]
	b	.L31
.L19:
	ldr	w0, [sp, 60]
	cmp	w0, 39
	bne	.L31
	str	wzr, [sp, 36]
	b	.L31
.L16:
	ldr	w0, [sp, 60]
	cmp	w0, 34
	bne	.L20
	mov	w0, 1
	str	w0, [sp, 40]
	str	wzr, [sp, 32]
	ldr	w0, [sp, 60]
	bl	putchar
	b	.L11
.L20:
	ldr	w0, [sp, 60]
	cmp	w0, 39
	bne	.L21
	mov	w0, 1
	str	w0, [sp, 36]
	str	wzr, [sp, 32]
	ldr	w0, [sp, 60]
	bl	putchar
	b	.L11
.L21:
	ldr	w0, [sp, 60]
	cmp	w0, 47
	bne	.L22
	bl	getchar
	str	w0, [sp, 24]
	ldr	w0, [sp, 24]
	cmn	w0, #1
	bne	.L23
	mov	w0, 47
	bl	putchar
	b	.L5
.L23:
	ldr	w0, [sp, 24]
	cmp	w0, 10
	bne	.L24
	ldr	w0, [sp, 56]
	add	w0, w0, 1
	str	w0, [sp, 56]
.L24:
	ldr	w0, [sp, 24]
	cmp	w0, 42
	bne	.L25
	mov	w0, 32
	bl	putchar
	mov	w0, 1
	str	w0, [sp, 48]
	str	wzr, [sp, 44]
	ldr	w0, [sp, 56]
	str	w0, [sp, 52]
	b	.L11
.L25:
	mov	w0, 47
	bl	putchar
	ldr	w0, [sp, 24]
	str	w0, [sp, 60]
	mov	w0, 1
	str	w0, [sp, 28]
	b	.L11
.L22:
	ldr	w0, [sp, 60]
	cmn	w0, #1
	beq	.L26
	ldr	w0, [sp, 60]
	bl	putchar
	b	.L26
.L30:
	nop
	b	.L26
.L31:
	nop
.L11:
	b	.L26
.L29:
	nop
.L5:
	ldr	w0, [sp, 48]
	cmp	w0, 0
	beq	.L27
	adrp	x0, stderr
	add	x0, x0, :lo12:stderr
	ldr	x3, [x0]
	ldr	w2, [sp, 52]
	adrp	x0, .LC0
	add	x1, x0, :lo12:.LC0
	mov	x0, x3
	bl	fprintf
	mov	w0, 1
	b	.L28
.L27:
	mov	w0, 0
.L28:
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 11.5.0 20240719 (Red Hat 11.5.0-11)"
	.section	.note.GNU-stack,"",@progbits
