.model small


.stack 100H ;pilha de 256 bytes

.data
   CR EQU 13; define uma constante de valor 13(carriage Return)
   LF EQU 10 ; define uma constante de valor 10 (new line)
   
   
.code


;ler um inteiro 16 bits(2bytes) sem sinal
;do teclado
;devolve o valor lido em AX
    

ESC_CHAR proc
    push AX
    mov AH,2
    int 21H
    
    pop AX   
       
    ret
endp    
           
           
LER_CHAR proc
    mov AH,7
    int 21H
    
    ret
endp     
     
     
ESC_UINT16 proc
    push AX
    push BX
    push CX
    push DX
    
    mov BX,10
    xor CX,CX
    
LACO_DIV:
   xor DX,DX
   div BX
   
   push DX
   inc CX
   
   cmp AX,0
   jnz LACO_DIV
   
LACO_ESCDIG:
    pop DX
    add DL,'0'
    call ESC_CHAR
    loop LACO_ESCDIG
    
    pop DX
    pop CX
    pop BX
    pop AX
    
    ret
endp


LER_UINT16 proc  
   ;salva os registradores
   ;que serao usados na proc
   push BX
   push CX
   push DX
   
   
   ;inicializando registradores
   xor AX,AX
   xor CX,CX
   mov BX,10
   
LER_UINT16_SALVA:
   push AX              ;salvando o acumulador
   
LER_UINT16_LEITURA:
   call LER_CHAR        ;le sem mostrar
   
   cmp AL,CR        ;verifica se eh ENTER
   jz LER_UINT16_FIM
   
   cmp AL,'0'
   jb LER_UINT16_LEITURA ;volta pro inicio
   
   cmp AL,'9'
   ja LER_UINT16_LEITURA ;volta inicio
   
   mov DL,AL
   call ESC_CHAR
   
   sub DL,'0' ;transforma o caractere em valor
   
    pop AX          ; restaurando o acumulador 
    push DX         ; salvar DX 
   
    mul BX          ; deslocamento esquerda do número para a soma   
   
    pop DX
    add AX,DX
       
    jmp LER_UINT16_SALVA 
     
   
LER_UINT16_FIM:
    pop AX
    
    mov DL,CR
    call ESC_CHAR
    mov DL,LF
    call ESC_CHAR
    
    pop DX
    pop CX
    pop BX
    
    
    ret
endp    



INICIO:
   mov AX,@DATA
   mov DS,AX
              
   call LER_UINT16
   call ESC_UINT16          
              
   mov AH,4ch 
   int 21h
end INICIO