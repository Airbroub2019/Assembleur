global main
extern printf

; ===== DATA SECTION =====
section .data   ;1 ou plusieurs espaces avant .data

	MAXI	EQU	20
	tab	times	MAXI dd 0     ;fait MAXI fois ce qui se trouve après dd        20entiers de 32bits inisialiser à 0
	
	msg	 db "la somme est %d" , 10 , 0
	

; ===== CODE SECTION =====
section .text


calc_sum:
	
	push	ebp			; entrée dans le sous-programme
	mov	ebp, esp
	
	push	ebx			; sauvegarde ebx car il ne doit psa étre modifié
	
	mov	ebx, [ebp+8]		; int *t
	mov	edx, [ebp+12]		; int n
	
	mov	eax, 0			; sum <- 0
	mov	ecx, 0			; i <- 0
	
.for:
	cmp	ecx, edx
	jge	.endfor
	
		add eax, [ebx + ecx * 4] ; sum+=t[i]
	
	inc	ecx
	jmp	.for
	
.endfor:
	
	pop	ebx			; estaire ebx
	
	mov	esp, ebp		; sortie du sous-programme
	pop	ebp
	ret

main:
	push ebp			; entrée dans le sous-programme
	mov ebp,esp
	
	pushad				; sauvegarde les 8 registres
	mov 	ebx, tab
	xor	ecx, ecx		; i <-0

.for_i:
	cmp	ecx, MAXI
	jge	.endfor_i
		mov	eax, ecx	; eax <- ecx = i
		shl	eax, 1		; eax <- eax * 2^1
					; un décalage au lieu d'une multiplication
		mov	[ebx + ecx * 4], eax		

	inc	ecx
	jmp 	.for_i

.endfor_i:
		

	; printf("...", calc_sum(tab,MAXI));
	push	dword MAXI
	push	dword tab
	call	calc_sum
	add	esp, 8
	; après l'appel à calc_sum, eax contient le résultat de la fonction
	push	eax
	push	dword msg
	call	printf
	add	esp, 8
	popad
	
	
	
	xor eax,eax  			; mov eax, 0       je met la valeur 0 à eax        
		      			;  ça correspond à return EXIT_SUCCESS en C
	
	mov esp,ebp			; sortie du sous-programme
	pop ebp
	
	ret
