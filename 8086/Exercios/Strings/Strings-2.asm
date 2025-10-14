; Programa que lê um vetor de word (16 bits) com 10 elementos e 
; copia para um segundo vetor de mesmo tamanho. A cópia é realizada 
; por meio de uma proc, chamada CopiaVet16, que recebe os endereços 
; dos vetores origem e destino pelos registradores SI e DI, 
; respectivamente e o tamanho do vetor em CX. Esta versão utiliza 
; instruções de manipulação de strings
.model small

.stack 100H

.data 
    TAM   equ 5
    CR EQU 13
    LF EQU 10
    
	ORIGEM  dw TAM dup(?) 
	DESTINO dw TAM dup(?) 

.code  
; Lê um caractere do teclado sem mostrÃ¡-lo 
; Devolve o caractere lido em AL
LER_CHAR proc 
	mov AH, 7
    int 21H   
    ret       
endp
  
; Escreve um caractere armazenado em DL na tela     
ESC_CHAR proc ; escreve um caractere em DL
	push AX    ; salva o reg AX
	mov AH, 2
	int 21H
	pop AX     ; restaura o reg AX
	ret  
endp   

; Escreve na tela um inteiro sem sinal    
; de 16 bits armazenado no registrador AX
ESC_UINT16 proc 
    push AX      ; Salvar registradores utilizados na proc
    push BX
    push CX
    push DX 
       
    mov BX, 10   ; divisões sucessivas por 10
    xor CX, CX   ; contador de dígitos
      
LACO_DIV:
    xor DX, DX   ; zerar DX pois o dividendo é DXAX
    div BX       ; divisão para separar o dígito em DX
    
    push DX      ; empilhar o dígito
    inc CX       ; incrementa o contador de dígitos
     
    cmp AX, 0    ; AX chegou a 0?
    jnz LACO_DIV ; enquanto AX diferente de 0 salte para LACO_DIV
           
 LACO_ESCDIG:   
    pop DX       ; desempilha o dígito    
    add DL, '0'  ; converter o dígito para ASCII
    call ESC_CHAR               
    loop LACO_ESCDIG    ; decrementa o contador de dígitos
    
    pop DX       ; Restaurar registradores utilizados na proc
    pop CX
    pop BX
    pop AX
    ret     
endp   
     
; Lê um inteiro de 16 bits sem sinal do teclado
; Devolve o valor lido em AX
LER_UINT16 proc  
 ; Salvar registradores utilizados na proc
 push BX
 push CX
 push DX 


 xor AX, AX 
 xor CX, CX
 mov BX, 10
 
LER_UINT16_SALVA:
 push AX    ; salvando o acumulador
  
LER_UINT16_LEITURA:       
 call LER_CHAR           ; ler o caractere
  
 cmp AL, CR              ; verifica se eh ENTER
 jz LER_UINT16_FIM  ; jz == je
   
 cmp AL, '0'             ; verificar se eh valido
 jb LER_UINT16_LEITURA 
  
 cmp AL, '9'
 ja LER_UINT16_LEITURA 
  
 mov DL, AL      ; escrever o caractere
 call ESC_CHAR
  
 mov CL, AL      ; salvar em CL o caractere
 sub CL, '0'     ; transforma o caractere em valor ('3' -> 3)
 
 pop AX          ; restaurando o acumulador 
 
 mul BX          ; deslocamento esquerda do número para a soma
 add AX,CX
 
 jmp LER_UINT16_SALVA


LER_UINT16_FIM: 
 pop AX          ; restaurando o acumulador 
      
      
 mov DL, CR      ; Dar um enter após a leitura          
 call ESC_CHAR
 mov DL, LF             
 call ESC_CHAR


 ; Restaurar registradores utilizados na proc
 pop DX
 pop CX
 pop BX
   
 ret
endp  
    
; Rotina que copia o conteúdo de um vetor de 16 bits com endereço no
; reg SI para um vetor com endereço no reg DI. O número de elementos 
; do vetor no reg CX    
COPIAVETOR16 proc
    push SI   ; Salvar registradores utilizados na proc
    push DI
    push CX  
    
    ; Repetir CX vezes a instrução movsw      
 rep movsw
 
 pop CX    ; Restaurar registradores utilizados na proc
 pop DI
 pop SI
    ret
endp    


INICIO:  
    mov AX, @DATA
    mov DS, AX 
    mov ES, AX    ; Necessário para utilizar as instruções 
                  ;de manipulação de string
   
    mov DI, offset ORIGEM
    mov CX, TAM             
    
    cld ; DF = 0, i.e., incrementar
                       
    LACO_PRINCIPAL:                         
       call LER_UINT16
       stosw
    loop LACO_PRINCIPAL 


    ; Copia os elementos de vetor1 para vetor2
    mov CX, TAM
    mov SI, offset ORIGEM
    mov DI, offset DESTINO
    call COPIAVETOR16 
   
         
    ; Escrita do vetor
    mov CX, TAM 
    mov SI, offset DESTINO
    cld ; DF = 0, i.e., incrementar

    ESCREVE_VETOR:
        lodsw
        call ESC_UINT16 
        mov DL, ' '          
        call ESC_CHAR
    loop ESCREVE_VETOR  
      
    mov ah, 4ch
    int 21h
 end INICIO   