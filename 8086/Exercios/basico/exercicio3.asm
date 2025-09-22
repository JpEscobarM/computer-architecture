; 3) Fa?a uma rotina que receba um valor X no registrador AL, 
;    um valor n no registrador AH e calcula X^n retornando o 
;    valor calculado em AX.
.model small

.stack 100H   ; define uma pilha de 256 bytes (100H)

.data 
   ; N?o h? dados!    
   
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
       
    mov BX, 10   ; divis?es sucessivas por 10
    xor CX, CX   ; contador de d?gitos
      
LACO_DIV:
    xor DX, DX   ; zerar DX pois o dividendo ? DXAX
    div BX       ; divis?o para separar o d?gito em DX
    
    push DX      ; empilhar o d?gito
    inc CX       ; incrementa o contador de d?gitos
     
    cmp AX, 0    ; AX chegou a 0?
    jnz LACO_DIV ; enquanto AX diferente de 0 salte para LACO_DIV
           
 LACO_ESCDIG:   
    pop DX       ; desempilha o d?gito    
    add DL, '0'  ; converter o d?gito para ASCII
    call ESC_CHAR               
    loop LACO_ESCDIG ; decrementa o contador de d?gitos
    
    pop DX       ; Restaurar registradores utilizados na proc
    pop CX
    pop BX
    pop AX
    ret     
endp  

; Escreve na tela um inteiro COM sinal    
; de 16 bits armazenado no registrador AX
ESC_INT16 proc 
    push AX         
    cmp AX, 0 ; Se AX < 0, SF = 1
    jns ESCREVE_NUMERO
     
    ; Escrever o sinal de menos
    mov DL, '-'    
    call ESC_CHAR 
     
    neg AX ; Inverte o sinal 
    
ESCREVE_NUMERO:
    call ESC_UINT16

    pop AX   
    ret
endp    
     
;int potencia(int base, int pot) {
; int resultado = 1;
; for (; pot>0; pot--)
; {
; resultado *= base;
; }
; return resultado;
;}

POTENCIA proc   
    push BX
    push CX  
    push DX
                
    ; Copiar AX para BX
    mov BX, AX

    ; Setar o AX
    mov AX, 1   
    
    test BH, BH
    je FIM_POTENCIA  
     
    ; Setar CX com a pot?ncia
    mov CL, BH
    xor CH, CH              
    
    ; Zerar a parte alta de BX         
    xor BH, BH
    
 LACO_POTENCIA:    
    mul BX  ; DXAX = AX * BX 
    loop LACO_POTENCIA      
    
FIM_POTENCIA:
    pop DX
    pop CX 
    pop BX
    
    ret
endp    
    
INICIO:   
    ; Configura??o do DS
    mov AX, @DATA
    mov DS, AX 
             
    ; Calcular 5^3         
    mov AL, 5; Base
    mov AH, 3; Pot?ncia    
    call POTENCIA   
    call ESC_INT16 
     
    ; Finaliza??o do programa
    mov ah, 4ch   
    int 21h    
end INICIO  