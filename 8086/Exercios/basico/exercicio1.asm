; Exercícios de Assembly 8086/8088
; 1. Faça uma rotina que escreva na tela um número  
; de 16 bits sem sinal armazenado no registrador AX. 
.model small

.stack 100H   ; define uma pilha de 256 bytes (100H)

.data 
   ; Não há dados!    

.code  

; Escreve na tela um caractere armazenado em DL     
ESC_CHAR proc
 push AX    ; salvar o reg AX
 mov AH, 2
 int 21H
 pop AX     ; restaurar o reg AX
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
    loop LACO_ESCDIG ; decrementa o contador de dígitos

    pop DX       ; Restaurar registradores utilizados na proc
    pop CX
    pop BX
    pop AX
    ret     
endp   

INICIO:   
   ; Configuração do DS
   mov AX, @DATA
   mov DS, AX 

    mov AX, 357 ; valor de exemplo

   call ESC_UINT16 

 ; Finalização do programa
 mov ah, 4ch   
 int 21h    
end INICIO         