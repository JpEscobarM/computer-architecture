                                      
.model small

.stack 100H   ; define uma pilha de 256 bytes (100H)

.data 
    ;ENDERECOS DE VETORES
    vetor dw 5 dup(?) ; 10 bytes da memoria nao inicializados
    
     
    frase db 8 dup(?)
    
    
    
    ;TAMANHO 
    TAM_VETOR16 EQU 5
    TAM_FRASES EQU 8
    
    
    CR EQU 13 ; define uma constante de valor 13
    LF EQU 10 ; define uma constante de valor 10


.code  

NOVA_LINHA proc
    push AX
    
    mov AH,2
    mov DL,CR
    int 21H
    mov DL,LF
    int 21H
    
    pop AX
    
    ret
endp 

; L? um caractere do teclado sem mostr�-lo 
; Devolve o caractere lido em AL
LER_CHAR proc 
    mov AH, 7
    int 21H   
    ret       
endp


; Escreve um caractere armazenado em DL na tela     
ESC_CHAR proc
    
    push AX
    
    mov AH,2
    int 21H
    
    pop AX
    
    ret
endp  

ESC_UINT16 proc
    push AX
    push BX
    push CX
    push DX
    
    mov BX,10
    
    xor CX,CX ; contador de digitos
    
LACO_DIV:
 
    xor DX,DX ;DX recebe o resto da divisao
    div BX
    
    push DX
    inc CX
        
    cmp AX,0    ;se ax = 0 nao tem mais numeros pra empilhar
    jnz LACO_DIV

LACO_ESCDIG:
    pop DX ;DX tem que receber o digito pois int 21H com AH=2 escreve o caracter em DL
    add DL,'0' ;obter o valor do digito na tabela ASCII
    
    call ESC_CHAR   
    
    loop LACO_ESCDIG ;funcao loop decrementa o CX ate 0
    
    pop DX
    pop CX
    pop BX
    pop AX
    
 ret
endp      
           
; L? um inteiro de 16 bits sem sinal do teclado
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
    
    mul BX          ; deslocamento esquerda do n?mero para a soma
    add AX,CX
    
    jmp LER_UINT16_SALVA

LER_UINT16_FIM: 
    pop AX          ; restaurando o acumulador 
         
         
    mov DL, CR      ; Dar um enter ap?s a leitura          
    call ESC_CHAR
    mov DL, LF             
    call ESC_CHAR

    ; Restaurar registradores utilizados na proc
    pop DX
    pop CX
    pop BX
              
    ret
endp  


ESC_VETOR1 proc
    
    push AX
    push BX
    push CX
    push DX
    
   
    mov BX, offset frase
    
    mov [BX],'v'
    add BX,1
  
    mov [BX],'e'
    add BX,1
  
    mov [BX],'t'
    add BX,1
    
    mov [BX],'o'
    add BX,1
    
    mov [BX],'r'
    add BX,1
    
    mov [BX],'-'
    add BX,1
    
     mov [BX],'1'
    add BX,1
    
    mov [BX],':' 
   
   
    mov CX,TAM_FRASES
    
    mov BX, offset frase  
    
ESC_BYTE:
     
    mov DL, [BX]
    
    call ESC_CHAR
    add BX,1  
    loop ESC_BYTE    
    
    mov DL, 20H
    call ESC_CHAR
    
    
   
    pop DX
    pop CX
    pop BX
    pop AX
    
    
 ret
endp


ESC_MAIOR proc
    
   
    push BX
    push CX
    push DX
    
   
    mov BX, offset frase
    
    mov [BX],'m'
    add BX,1
  
    mov [BX],'a'
    add BX,1
  
    mov [BX],'i'
    add BX,1
    
    mov [BX],'o'
    add BX,1
    
    mov [BX],'r' 
    add BX,1
        
    mov [BX],':'
    add BX,1 
            
    mov [BX],' '
    add BX,1        
            
    mov [BX],0
    add BX,1
    
    mov BX,offset frase
    
ESC:
    mov DL,[BX]
    cmp DL,0
    je FIM_FRASE
    
    call ESC_CHAR
    
    add BX,1
    jmp ESC   
            
    
FIM_FRASE:   
    pop DX
    pop CX
    pop BX
   
    
    
 ret
endp

COPIAVETOR16 proc
   
   push AX
   push BX
   push CX
   push DX
   push SI
   push DI
           
   mov CX,TAM_VETOR16       
           
LACO_COPIA:
   mov AX, [SI]
    
   mov [DI],AX 
   add SI,2
   add DI,2
    
   loop LACO_COPIA 
    
  pop DI
  pop SI
  pop DX
  pop CX
  pop BX
  pop AX 
    
 ret
endp

SOMA_VETOR16 proc
   
   push BX
   push CX
  

  
  mov BX,offset vetor  
  
  mov CX, TAM_VETOR16
    
  xor AX,AX  
    
PERCORRE_VETOR:

    add AX,[BX]
    add BX,2    
    
    loop PERCORRE_VETOR  
    
    
    

  
  pop CX
  pop BX
   

    ret
endp

MAIOR_VETOR16 proc
   
   push BX
   push CX
   push SI

  
  mov SI,offset vetor  
  
  mov CX, TAM_VETOR16
    
  xor AX,AX  
    
PERCORRE_MAIOR:
    
    
    cmp [SI],AX ;compara o AX zerado com o valor atual    
    jb PROXIMO ;jump below (se SI for menor pula para PROXIMO)
    mov AX,[SI] ;se nao pulou entao o valor em SI e maior, move pro AX 
    
PROXIMO:
    add SI,2 ;incrementa pro proximo valor   
        
    loop PERCORRE_MAIOR  
    
    
    

  pop SI
  pop CX
  pop BX
   

    ret
endp 

INICIO:  
    mov AX, @DATA
    mov DS, AX 
   
    ; Vers?o que destroi o endere?amento indireto
    mov BX, offset vetor   ; NUNCA utilizem LEA lea BX, VETOR
    mov CX, TAM_VETOR16 
                   
    LACO_PRINCIPAL:                         
       call LER_UINT16
       mov [BX], AX   
       add BX, 2
       loop LACO_PRINCIPAL ; dec CX
 
    ; Para escrever, pode-se utilizar o 
    ; registrador SI, mas o DI tamb?m 
    ; poderia ter sido utilizado
    mov CX, TAM_VETOR16 
    mov BX, offset vetor     
    
    
    call ESC_VETOR1
    
    mov DL,'['
    call ESC_CHAR
                   
                   
    ESCREVE_VETOR: 
    
        mov AX, [BX]
        call ESC_UINT16 
        add BX, 2   
        
         mov DL,20H
        call ESC_CHAR
        
        loop ESCREVE_VETOR 
     
    mov DL,']'
    call ESC_CHAR
    
    call NOVA_LINHA
    
    call ESC_MAIOR   
    
    call MAIOR_VETOR16 ;retorna o maior em AX
   
    call ESC_UINT16
    
    
    call NOVA_LINHA
    
    
    
    
    ; Finaliza??o do programa
    mov ah, 4ch   
    int 21h
 end INICIO   