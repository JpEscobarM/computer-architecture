.model small    


.stack 100H

.data


cenario_1   db 2 dup (0EH), 2 dup(0EH), 478 dup(00H) 
            db 2 dup (480 dup(0EH)
            db 480 dup(09H)
            db 480 dup(09H)
  
      


scroll_cenario dw 0
                 
.code

DESENHA_CENARIO proc
    push ax
    push cx
    push dx
    push si
    push di

    mov ax, 0A000H       ; Segmento de mem?ria de v?deo (modo gr?fico 13h)
    mov es, ax                  ; Aponta ES para o segmento de v?deo

    mov si, offset cenario_1      ; Aponta SI para o in?cio do vetor `cenario`
    add si, scroll_cenario          ; Aplica o deslocamento para o cen?rio

PRINTA_CENARIO:
    mov di, 57600               ; 200 - 49(tamanho do terreno) = 160 * 320 = 51200  <- offset da linha 160
    mov dx, 4                  ; N?mero de linhas a desenhar
desenha_linha_ter:
    mov cx, 320                 ; N?mero de pixels por linha
    rep movsb                   ; Copia a linha do cen?rio para a tela

    add si, 160                 ; Avan?a o ponteiro no cen?rio para a pr?xima linha (480 - 320 = 160 que ?  parte que faltou desenhar)
    dec dx                      ; Decrementa o contador de linhas
    jnz desenha_linha_ter       ; Continua enquanto houver linhas a desenhar

END_PROC:
    pop di
    pop si
    pop dx
    pop cx
    pop ax
    ret
ENDP


                 
MAIN:
    ;referencia o segmento de dados em ds
    mov AX, @data
    mov DS, AX
    
    ;referencia o segmento de memoria de video em ES
    mov AX, 0A000H
    mov ES, AX
    

    
    ;inicia modo de video com 0A000H
    xor AH, AH
    mov AL, 13H
    int 10H
    
    call DESENHA_CENARIO
    
  
    mov AH, 4Ch
    int 21h
    
end MAIN