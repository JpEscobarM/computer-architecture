; 1) Faça um programa que leia e escreva um vetor de word (16 bits) 
; com 5 elementos utilizando instruções de manipulação de strings.
.model small

.stack 100H   ; define uma pilha de 256 bytes (100H)

.data 
    vetor  dw  5 dup(?)
    
    CR EQU 13 ; define uma constante de valor 13 (Carriage Return)
    LF EQU 10 ; define uma constante de valor 10 (Line Feed)
.code  
; Lê um caractere do teclado sem mostrá-lo 
; Devolve o caractere lido em AL
LER_CHAR proc 
 mov AH, 7
    int 21H   
    ret       
endp
  
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
     
INICIO:  
 ; Configuração do DS
 mov AX, @DATA
 mov DS, AX 
    mov ES, AX                            
                   
    mov DI, offset vetor
    mov CX, 5 
  
    cld  ; Clear Direction Flag ? DF = 0 ?
    ; direcao de leitura/escrita de memoria 
    ;sera "para frente"
  
    LACO_LEITURA:   
     call LER_UINT16
     
     stosw  ;funcao STOre String -> mov ES:DI, AX 
     
            ; add DI, 2
     loop LACO_LEITURA
                               
    mov SI, offset vetor  
    mov CX, 5 
    LACO_ESCRITA:    
     lodsw ; mov AX, [ES:SI] lendo da memória  
           ; add SI, 2
     call ESC_UINT16 
     mov DL, CR      ; Dar um enter após a leitura          
     call ESC_CHAR
     mov DL, LF             
     call ESC_CHAR
     loop LACO_ESCRITA      
 ; Finalização do programa
 mov ah, 4ch   
    int 21h
 end INICIO     