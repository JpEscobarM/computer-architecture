.model small

.stack 100H

.data 

 CR equ 0DH ; Carriage reaturn
 LF equ 0AH ; Nova linha
 str db 'exemplo$'
 
.code   

ESC_CHAR proc
  push AX  
  mov AH, 2
  int 21H
  pop AX 
  ret  
endp  

ESC_UINT16 proc  
  push AX
  push BX
  push CX
  push DX
  
  mov BX, 10
  xor CX, CX ; CX = 0
LACO:
  xor DX, DX; DX = 0
  div BX ; AX = Quociente DX = Resto
  push DX
  inc CX
  cmp AX, 0
  jne LACO
  
LACO_ESC:  
  pop DX
  add DL, '0' 
  call ESC_CHAR
  dec CX
  jnz LACO_ESC 
     
  pop DX
  pop CX
  pop BX
  pop AX   
  ret  
endp  

STRLEN proc 
   xor CX, CX
LACO_STRLEN:   
   cmp [DI],'$'
   je FIM_STRLEN
   inc DI    
   inc CX
   jmp LACO_STRLEN     
FIM_STRLEN:    
   ret
endp
     
STRLEN2 proc 
   mov CX, DI
LACO_STRLEN2:   
   cmp [DI],'$'
   je FIM_STRLEN2
   inc DI    
   jmp LACO_STRLEN2     
FIM_STRLEN2:    
   sub DI, CX
   mov CX, DI 
   ret
endp

STRLEN3 proc 
   xor CX, CX
   mov AL, '$'
   cld ; DI++
LACO_STRLEN3:   
   scasb ; cmp AL, [ES:DI] ; inc DI 
   je FIM_STRLEN3
   inc CX
   jmp LACO_STRLEN3     
FIM_STRLEN3:    
   ret
endp

STRLEN4 proc 
   xor CX, CX
   mov AL, '$'
   cld ; DI++
LACO_STRLEN4:   
   inc CX
   scasb ; cmp AL, [ES:DI] ; inc DI 
   jne LACO_STRLEN4
FIM_STRLEN4: 
   dec CX   
   ret
endp   

STRLEN5 proc 
   mov CX, 0FFFFH ; maior valor possivel que sera usado
   ;durante o rpne pra decrementar
   mov SI, DI
   mov AL, '$'
   cld ; DI++
   
   repne scasb ; cmp AL, [ES:DI] ; inc DI 
   ; SCASB compara AL com byte em ES:DI e incrementa DI
   ;rpne = Repeat While Not Equal
   ;pode ser tambem repnz RepeatWihleNotZero
   
   sub DI, SI ; 6. Calcula quantos bytes percorreu: DI - SI vai dar o tamanho da string
   mov CX, DI
   dec CX ;decrementa pra retirar o $
   ret
endp
  
   inicio:     
       mov AX, @DATA
       mov DS, AX
       mov ES, AX 
       
       mov DI, offset str
       call STRLEN5
       mov AX, CX
       call ESC_UINT16
              
       mov AH, 4CH       
       int 21H

end inicio