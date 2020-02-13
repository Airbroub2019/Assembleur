global	ps_x87
global	ps_sse	

global	ps_sse_ur2
global	ps_avx
;x = esi
;y = edi
;sz = eax
;i = ecx
;sum = st0
	
ps_x87:

	push	ebp
	mov	ebp,esp

	push 	esi
	push 	edi
	mov	esi, [ebp+8]
	mov	edi, [ebp+12]
	mov	eax, [ebp+16]

	fldz		; sum = st0 = 0
	xor	 ecx, ecx
.for:

	cmp	ecx, eax
	jge	.endfor
	; sum+= x[i]*y[i]
	fld	dword [esi + ecx * 4]
	fmul	dword [edi + ecx * 4]
	faddp	st1, st0

	inc	ecx
	jmp	.for

.endfor:	

	pop edi
	pop esi

	mov esp, ebp
	pop ebp
	ret

; xmm0 = sum[0:3]
; xmm1 = x[i:i+3]
; xmm2 = y[i:i+3]

ps_sse:

	push	ebp
	mov	ebp,esp

	push 	esi
	push 	edi
	mov	esi, [ebp+8]
	mov	edi, [ebp+12]
	mov	eax, [ebp+16]

	pxor	xmm0, xmm0	; sum[0:3] = 0
	xor	ecx, ecx
.for:

	cmp	ecx, eax
	jge	.endfor
	; sum[0:3] += x[i:i+3]*y[i:i+3]
	movaps	xmm1, [esi + ecx *4]	; x[i:i+3] -> xmm1
	movaps	xmm2, [edi + ecx *4]	; y[i:i+3] -> xmm2
	mulps	xmm1, xmm2		; xmm1 <- [ x(i+3)*y(i+3), ..., x(i)*y(i)]
	addps	xmm0, xmm1

	add	ecx, 4
	jmp	.for

.endfor:	
	haddps	xmm0, xmm0
	haddps	xmm0, xmm0		; [sum, sum, sum, sum]
	sub	esp, 4
	movss 	[esp], xmm0
	fld	dword [esp]
	add	esp, 4

	pop edi
	pop esi

	mov esp, ebp
	pop ebp
	ret


ps_sse_ur2:


	push	ebp
	mov	ebp,esp

	push 	esi
	push 	edi
	mov	esi, [ebp+8]
	mov	edi, [ebp+12]
	mov	eax, [ebp+16]

	pxor	xmm4, xmm4	; sum[0:3] = 0
	pxor	xmm0, xmm0	; sum[0:3] = 0
	xor	ecx, ecx
.for:

	cmp	ecx, eax
	jge	.endfor
	; sum[0:3] += x[i:i+3]*y[i:i+3]
	movaps	xmm1, [esi + ecx *4]		; x[i:i+3] -> xmm1
	movaps	xmm2, [edi + ecx *4]		; y[i:i+3] -> xmm2
	mulps	xmm1, xmm2			; xmm1 <- [ x(i+3)*y(i+3), ..., x(i)*y(i)]
	addps	xmm0, xmm1

	; sum[0:3] += x[i+4:i+7]*y[i+4:i+7]
	movaps	xmm5, [esi + ecx *4 + 16]	; x[i:i+3] -> xmm1
	movaps	xmm6, [edi + ecx *4 + 16]	; y[i:i+3] -> xmm2
	mulps	xmm5, xmm6			; xmm1 <- [ x(i+3)*y(i+3), ..., x(i)*y(i)]
	addps	xmm4, xmm5

	add	ecx, 8
	jmp	.for

.endfor:	
	haddps	xmm0, xmm0
	haddps	xmm0, xmm0		; [sum, sum, sum, sum]
	haddps	xmm4, xmm4		; [sum, sum, sum, sum]
	haddps	xmm4, xmm4		; [sum, sum, sum, sum]
	addps	xmm0, xmm4

	sub	esp, 4
	movss 	[esp], xmm0
	fld	dword [esp]
	add	esp, 4

	pop edi
	pop esi

	mov esp, ebp
	pop ebp
	ret




ps_avx:


	push	ebp
	mov	ebp,esp

	push 	esi
	push 	edi
	mov	esi, [ebp+8]
	mov	edi, [ebp+12]
	mov	eax, [ebp+16]

	vpxor	ymm0, ymm0	; sum[0:3] = 0
	xor	ecx, ecx
.for:

	cmp	ecx, eax
	jge	.endfor
	; sum[0:3] += x[i:i+3]*y[i:i+3]
	vmovaps	ymm1, [esi + ecx *4]	; x[i:i+3] -> xmm1
	vmovaps	ymm2, [edi + ecx *4]	; y[i:i+3] -> xmm2
	vmulps	ymm1, ymm2		; xmm1 <- [ x(i+3)*y(i+3), ..., x(i)*y(i)]
	vaddps	ymm0, ymm1

	add	ecx, 8
	jmp	.for

.endfor:	
	haddps	xmm0, xmm0
	haddps	xmm0, xmm0		 
	
	vextractf128	xmm1, ymm0, 1

	haddps	xmm1, xmm1
	haddps	xmm1, xmm1	

	addps	xmm0, xmm1	 
	
	sub	esp, 4
	movss 	[esp], xmm0
	fld	dword [esp]
	add	esp, 4

	pop edi
	pop esi

	mov esp, ebp
	pop ebp
	ret


