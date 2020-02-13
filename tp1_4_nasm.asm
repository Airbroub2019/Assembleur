global main
extern printf

; ===== DATA SECTION =====
section .data   ;1 ou plusieurs espaces avant .data

	msg	 db "la somme est %d" , 10 , 0
	

; ===== CODE SECTION =====
section .text

main:
	push ebp			; entrée dans le sous-programme
	mov ebp,esp
	
	pushad				; sauvegarde les 8 registres
	
 	mov	eax, 0			; sum <- 0
 	mov	ebx, 15			; n <- 15
 	mov	ecx, 0			; i <- 0
 	
.for: 

	cmp	ecx, ebx		; i <,=,> n ?
	jge	.endfor
	
		; corps de la boucle sump+=i
		add eax, ecx
		
	add	ecx, 1			; inc ecx
	jmp	.for
	
.endfor:
	
	push eax
	push dword msg
	call	printf
	add	esp, 8
	
		
	popad
	
	
	
	xor eax,eax  			; mov eax, 0       je met la valeur 0 à eax        
		      			;  ça correspond à return EXIT_SUCCESS en C
	
	mov esp,ebp			; sortie du sous-programme
	pop ebp
	
	ret
