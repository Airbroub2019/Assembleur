global 	main
extern	atoi
extern	printf
extern	malloc
extern	free
extern  memcpy 				; tp2_4
extern	posix_memalign			; tp2_5/6
section	.data

	N	EQU	128000
	tab1	dd	0
	tab2	dd	0

	msg	db	"iterations = %d" , 10 , 0
section .text	

main:
	push	ebp
	mov	ebp, esp
	pushad

	; maxi = atoi(argv[1]);
	mov	eax, [ebp+12]		; eax <- &argv[0]
	push	dword [eax + 4]
	call	atoi
	add	esp, 4
	mov	ebx, eax

	; tab1 = (int *) malloc(N*sizeof(int));
	; tab1 = new int [ N ]
	mov	eax, N
	shl	eax, 2			; eax <- eax * 2^2
	push	eax

	push	dword 16
	push	dword tab1
	call	posix_memalign
	add	esp, 12

	; tab2 = (int *) malloc(N*sizeof(int));
	; tab2 = new int [ N ]
	mov	eax, N
	shl	eax, 2			; eax <- eax * 2^2
	push	eax

	push	dword 16
	push	dword tab2
	call	posix_memalign
	add	esp, 12
	
	mov	edx, 1			; number <-1
	
.for_number:

	cmp	edx, ebx		; number <,=,> maxi ?
	jg	.endfor_number

	; -----
	
	mov	esi, [tab1]
	mov	edi, [tab2]
	mov	eax, N
	shl	eax, 2			; nombre d'octets à transférer

	; boucle for
	xor	ecx, ecx

.for_j:
	cmp	ecx, eax		; compare j avec eax
	jge 	.endfor_j		; si on est supérieur ou égal on sort de la boucle j

		movdqa xmm0, [esi + ecx]
		movdqa [edi + ecx], xmm0
		
	add	ecx, 16	
	jmp	.for_j
.endfor_j:
	

	; -----

	inc	edx			; ++ number
	jmp	.for_number

.endfor_number:

	push	edx
	; free(tab1);

	push	dword [tab1]
	call	free
	add	esp, 4 ; supprime les 4 octets qu'on avait mit

  	; free(tab2);

 	push	dword [tab2]
	call	free
	add	esp, 4 ; supprime les 4 octets qu'on avait mit

	pop 	edx

  	; printf("iterations = %d\n", number);
	push	edx
	push	dword msg
	call	printf
	add	esp, 8

	popad
	xor	eax, eax
	mov	esp, ebp
	pop	ebp
	ret
