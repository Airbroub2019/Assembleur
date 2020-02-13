global 	main
extern	printf

section	.data

	x:	dd	0.2 

section.text 


	

puissance:

	push	ebp
	mov	ebp, esp


	fld1				; on affecte la valeur 1 à st0
	mov	ecx, [ebp+12]

.while:

	cmp	ecx, 0
	jle	.endwhile

	fmul	dword[ebp+8]		; ou 	fld dword [ebp+8]
					; puis 	fmulp st1, st0

	dec	ecx

	jmp .while


	


.endwhile:

	mov esp, ebp
	pop	ebp
	ret


.main:
	push	ebp
	mov	ebp, esp




.for:

	mov	ebx, 10
	
	mov	ecx, 1
	

	cmp	ecx, edx
	jg	.endfor

	push	ebx
	push	dword [x]

	call	puissance

	inc	ecx

	jmp .for

.end_for:
	

	

	

	

	

	

