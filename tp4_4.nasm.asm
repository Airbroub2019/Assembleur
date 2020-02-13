global 	main

section	.data

	a:	dd	1
	b:	dd	2
	c:	dd	1
	delta 	; b*b - 4*a*c
	x1
	x2
	quatre	dd	4.0
	deux	dd	2.0

	msg:	db " "

section.text 


main:
	push	ebp
	mov		ebp, esp
	pushad

; calculer delta

	fld	dword [b]	
	fld	dword [b]
	fmulp	st1, st0		; b*b

	fld	dword [quatre]	
	fld	dword [a]
	fmulp	st1, st0		; 4*a
	
	fld 	dword [c]

	fmulp	st1 , st0		; 4*a*c

	fsubp	st1, st0		; b*b - 4*a*c

	fstp	dword [delta]
	
	fldz	
	fcomip	st1,st0
	
	jl	.endif

; calculer x1

 	fld	dword [delta]	
	fsqrt				; sqrt(Delta)

	fld	dword [b]

	fsubp	st1, st0		; sqrt(Delta) - b

	fld	dword [a]
	fld	dword [deux]

	fmulp	st1, st0		; 2*a
	
	fdivp 	st1, st0		;  (sqrt(Delta) - b) / 2*a

	fstp	dword [x1]		; x1 = (sqrt(Delta) - b) / 2*a

; calculer x2

 	fld	dword [delta]	
	fsqrt				; sqrt(Delta)
	fchs				; - sqrt(Delta

	fld	dword [b]

	fsubp	st1, st0		; - sqrt(Delta) - b

	fld	dword [a]
	fld	dword [deux]

	fmulp	st1, st0		; 2*a
	
	fdivp 	st1, st0		;  (sqrt(Delta) - b) / 2*a

	fstp	dword [x2]		; x2 = ( - sqrt(Delta) - b) / 2*a
	

	

.endif:
	
	fld 	dword [b]
	sub	esp, 8
	fstp	qword [esp]
	push	dword msg
	call	printf
	add	esp, 12
	
	popad
	mov	esp, ebp
	pop	ebp
	xor	eax, eax
	ret
	




	

	

	
	
	

	


	




