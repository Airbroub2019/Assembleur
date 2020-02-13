global main
extern printf
extern scanf

; ===== DATA SECTION =====
section .data   ;1 ou plusieurs espaces avant .data

	x dd 2 ; x est un entier sur 32 bits
	y dd 1 ; y est un entier sur 32 bits
	msg_inf 	db "%d inferieur a %d", 10, 0
	msg_sup_egal 	db "%d superieur ou egal a %d", 10, 0
	saisir_x 	db "saisie x ?" , 10 , 0
	saisir_y 	db "saisie y ?" , 10 , 0
	msg_scanf 	db "%d" , 0

; ===== CODE SECTION =====
section .text

main:
	push ebp			; entrée dans le sous-programme
	mov ebp,esp
	
	pushad				; sauvegarde les 8 registres
					; généraux



	; printf("saisie x ? ");
	push	dword	saisir_x
	call 	printf
	add	esp,4			; supprime le paramètre msg_inf
	
	; scanf("%d", &x);
	push	dword x			; scanf f prend 2 parametre      
					; parametre le plus à droite
	push	dword msg_scanf		; puis à gauche
	call	scanf
	add	esp, 8
	
	; printf("saisie y ? ");
	push	dword	saisir_y
	call 	printf
	add	esp,4			; supprime le paramètre msg_inf
		
	; scanf("%d", &y);
	push	dword y
	push	dword msg_scanf
	call	scanf
	add	esp, 8
	
	
		
	
.if:
	
	mov	eax,  [x] 		;x est une adresse et non une variable (comme en C)
	mov 	ebx,  [y]
	cmp	eax, ebx		; x <,=,> y ?
					; elle va faire la soustraction x-y
	jge	.else			; jump on greater or qual			
.then:
	; printf("%d est inférieur à %d \n , x , y);
	push	dword [y]	; push ebx
	push	dword [x]	; push eax
	push	dword	msg_inf
	call 	printf
	add	esp,12			; supprime le paramètre msg_inf
	
	jmp	.endif
	
.else:
	; printf("%d superieur ou egal a %d");
	push	ebx	; push ebx
	push	eax	; push eax
	push	dword	msg_sup_egal
	call 	printf
	add	esp,12			; supprime le paramètre msg_inf
	
	jmp	.endif
	
.endif:

					
	popad
	
	
	
	xor eax,eax  			; mov eax, 0       je met la valeur 0 à eax        
		      			;  ça correspond à return EXIT_SUCCESS en C
	
	mov esp,ebp			; sortie du sous-programme
	pop ebp
	ret



