; Programa que lê e escreve um vetor de números inteiros
; de 16 bits sem sinal utilizando endereçamento indireto

.model small

.stack 100H   ; define uma pilha de 256 bytes (100H)

.data 
     vetor dw 5 dup(?) ; 10 bytes da memoria nao inicializados
    CR EQU 13 ; define uma constante de valor 13
    LF EQU 10 ; define uma constante de valor 10
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
    jz LER_UINT16_FIM         ; jz == je
      
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
     
INICIO:  
    mov AX, @DATA
    mov DS, AX 
   
    ; Versão que destroi o endereçamento indireto
    mov BX, offset vetor   ; NUNCA utilizem LEA lea BX, VETOR
    mov CX, 5   
                   
    LACO_PRINCIPAL:                         
       call LER_UINT16
       mov [BX], AX   
       add BX, 2
       loop LACO_PRINCIPAL ; dec CX
 
    ; Para escrever, pode-se utilizar o 
    ; registrador SI, mas o DI também 
    ; poderia ter sido utilizado
    mov CX, 5 
    mov SI, offset vetor
    ESCREVE_VETOR:
        mov AX, [SI]
        call ESC_UINT16 
        add SI, 2   
        mov DL, CR      ; Dar um enter após a leitura          
        call ESC_CHAR
        mov DL, LF             
        call ESC_CHAR
        loop ESCREVE_VETOR 
        
    ; Finalização do programa
    mov ah, 4ch   
    int 21h
 end INICIO   