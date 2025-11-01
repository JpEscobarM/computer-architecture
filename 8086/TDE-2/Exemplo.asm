.model small
.stack

.data
    menu db 0
    ; 0 - Menu
    ; 1 - Setor
    ; 2 - Jogo
    ; 3 - Game Over
    screen db 0
    sector db 1
    timeout db 0
    time db 60
    score dw 0

    sector_time db 60

    score_buffer db '00000'
    score_buffer_len equ $-score_buffer

    time_buffer db '00'
    time_buffer_len equ $-time_buffer

    ship_speed dw 5
    
    shot_count db 3
    shot_array_pos dw 305*30,305*30,305*30
    shot_array_shoot db 0,0,0

    ; Re-renders
    rerender_ship db 1
    rerender_allies db 1
    rerender_score db 1
    
    ; For pseudo random number generation
    seed dw 0

    ; Strings para o t?tulo e bot?es
    string  db 7 dup(" ")," _  __   ___ _            ",13,10
            db 7 dup(" "),"| |/ /__/ __| |_ __ _ _ _ ",13,10
            db 7 dup(" "),"| ' <___\__ \  _/ _` | '_|",13,10
            db 7 dup(" "),"|_|\_\  |___/\__\__,_|_|  ",13,10
            db 7 dup(" "),"| _ \__ _| |_ _ _ ___| |  ",13,10
            db 7 dup(" "),"|  _/ _` |  _| '_/ _ \ |  ",13,10
            db 7 dup(" "),"|_| \__,_|\__|_| \___/_|  ",13,10

    string_length equ $-string
    
    score_str db "SCORE:"
    score_str_len equ $-score_str
    
    time_str db "TEMPO:"
    time_str_len equ $-time_str

    sector_one  db 5 dup(" "), " ___       _              _    ",13,10
                db 5 dup(" "), "/ __| ___ | |_ ___ _ _   / |   ",13,10
                db 5 dup(" "), "\__ \/ -_)|  _/ _ \ '_|  | |   ",13,10
                db 5 dup(" "), "|___/\___\ \__\___/_|    |_|   ",13,10

    sector_two  db 5 dup(" "), " ___       _              ___  ",13,10
                db 5 dup(" "), "/ __| ___ | |_ ___ _ _   |_  ) ",13,10
                db 5 dup(" "), "\__ \/ -_)|  _/ _ \ '_|   / /  ",13,10
                db 5 dup(" "), "|___/\___\ \__\___/_|    /___| ",13,10

    sector_three    db 5 dup(" "), " ___       _              ____ ",13,10
                    db 5 dup(" "), "/ __| ___ | |_ ___ _ _   |__ / ",13,10
                    db 5 dup(" "), "\__ \/ -_)|  _/ _ \ '_|   |_ \ ",13,10
                    db 5 dup(" "), "|___/\___\ \__\___/_|    |___/ ",13,10

    sector_len equ $-sector_three

    game_over   db 10 dup(" "), "  ___                ",13,10
                db 10 dup(" "), " / __|__ _ _ __  ___ ",13,10
                db 10 dup(" "), "| (_ / _` | '  \/ -_)",13,10
                db 10 dup(" "), " \___\__,_|_|_|_\___|",13,10
                db 10 dup(" "), " / _ \__ _____ _ _   ",13,10
                db 10 dup(" "), "| (_) \ V / -_) '_|  ",13,10
                db 10 dup(" "), " \___/ \_/\___|_|    ",13,10

    game_over_len equ $-game_over

    you_win db " __   __                  _         _ ",13,10
            db " \ \ / /__ _ _  __ ___ __| |___ _ _| |",13,10
            db "  \ V / -_) ' \/ _/ -_) _` / _ \ '_|_|",13,10
            db "   \_/\___|_||_\__\___\__,_\___/_| (_)",13,10

    you_win_len equ $-you_win

    sector_vec dw offset sector_one, offset sector_two, offset sector_three

    btn_iniciar db  14 dup(" "),218,196,196,196,196,196,196,196,196,196,191,13,10
                 db 14 dup(" "),179," INICIAR ",179,10,13
                 db 14 dup(" "),192,196,196,196,196,196,196,196,196,196,217,13,10

    btn_iniciar_length equ $-btn_iniciar

    btn_sair db  14 dup(" "),218,196,196,196,196,196,196,196,196,196,191,13,10
              db 14 dup(" "),179,"  SAIR   ",179,10,13
              db 14 dup(" "),192,196,196,196,196,196,196,196,196,196,217,13,10

    btn_sair_length equ $-btn_sair

    terrain db 320 dup(0)
        db 320 dup(0)
        db 168 dup(0),3 dup (6),149 dup(0)
        db 166 dup(0),6 dup (6),148 dup(0)
        db 34 dup(0),4 dup (6),7 dup(0),6 dup (6),63 dup(0),2 dup (6),25 dup(0),6 dup (6),18 dup(0),8 dup (6),87 dup(0),9 dup (6),51 dup(0)
        db 33 dup(0),6 dup (6),5 dup(0),9 dup (6),37 dup(0),9 dup (6),12 dup(0),7 dup (6),20 dup(0),10 dup (6),17 dup(0),9 dup (6),15 dup(0),5 dup (6),40 dup(0),5 dup (6),19 dup(0),11 dup (6),15 dup(0),4 dup (6),32 dup(0)
        db 12 dup(0),4 dup (6),16 dup(0),7 dup (6),4 dup(0),11 dup (6),17 dup(0),3 dup (6),15 dup(0),11 dup (6),10 dup(0),10 dup (6),15 dup(0),14 dup (6),15 dup(0),11 dup (6),13 dup(0),7 dup (6),8 dup(0),6 dup (6),23 dup(0),9 dup (6),15 dup(0),15 dup (6),12 dup(0),7 dup (6),30 dup(0)
        db 11 dup(0BH),7 dup (6),14 dup(0BH),23 dup (6),16 dup(0BH),3 dup (6),15 dup(0BH),11 dup (6),9 dup(0BH),11 dup (6),13 dup(0BH),17 dup (6),14 dup(0BH),12 dup (6),11 dup(0BH),9 dup (6),5 dup(0BH),9 dup (6),20 dup(0BH),12 dup (6),13 dup(0BH),17 dup (6),10 dup(0BH),9 dup (6),29 dup(0BH)
        db 1 dup (6),9 dup(0BH),10 dup (6),10 dup(0BH),26 dup (6),15 dup(0BH),5 dup (6),12 dup(0BH),34 dup (6),8 dup(0BH),21 dup (6),12 dup(0BH),14 dup (6),9 dup(0BH),11 dup (6),2 dup(0BH),13 dup (6),16 dup(0BH),17 dup (6),8 dup(0BH),20 dup (6),8 dup(0BH),11 dup (6),8 dup(0BH),3 dup (6),8 dup(0BH),6 dup (6),2 dup(0BH),1 dup (6)
        db 2 dup (6),7 dup(0BH),12 dup (6),8 dup(0BH),31 dup (6),10 dup(0BH),6 dup (6),10 dup(0BH),65 dup (6),11 dup(0BH),17 dup (6),7 dup(0BH),28 dup (6),12 dup(0BH),49 dup (6),5 dup(0BH),13 dup (6),5 dup(0BH),7 dup (6),4 dup(0BH),11 dup (6)
        db 3 dup (6),5 dup(0BH),14 dup (6),4 dup(0BH),36 dup (6),6 dup(0BH),10 dup (6),6 dup(0BH),68 dup (6),9 dup(0BH),19 dup (6),5 dup(0BH),109 dup (6),3 dup(0BH),8 dup (6),3 dup(0BH),12 dup (6)
        db 63 dup (6),4 dup(0BH),11 dup (6),4 dup(0BH),71 dup (6),7 dup(0BH),23 dup (6),1 dup(0BH),122 dup (6),1 dup(0BH),13 dup (6)
        db 320 dup (6)
        db 320 dup (6)
        db 320 dup (6)
        db 320 dup (6)
        db 320 dup (6)
        db 320 dup (6)
        db 320 dup (6)
        db 320 dup (6)

    terrain_pos dw 320 * 180

    ship        db 15,15,15,15,15,15,15,15,15,15,15,15,0,0,0
                db 0,0,15,15,0,0,0,0,0,0,0,0,0,0,0
                db 0,0,15,15,15,15,0,0,0,0,0,0,0,0,0
                db 0,0,15,15,15,15,15,15,0,0,0,0,0,0,0
                db 0,0,15,15,15,15,15,15,15,15,15,15,15,15,15
                db 0,0,15,15,15,15,15,15,0,0,0,0,0,0,0
                db 0,0,15,15,15,15,0,0,0,0,0,0,0,0,0
                db 0,0,15,15,0,0,0,0,0,0,0,0,0,0,0
                db 15,15,15,15,15,15,15,15,15,15,15,15,0,0,0

    ship_pos dw 0
    ship_color db 0FH
    is_ship_colliding db 0
    
    allies_pos_vec dw 320 * 20, 320 * 40, 320 * 60, 320 * 80, 320 * 100, 320 * 120, 320 * 140, 320 * 160
    
    ; each bit represents an ally ship
    allies_count db 8

    alien_ship  db 0,0,0,0,0,0,0,0,9,9,9,9,9,9,9
                db 0,0,0,0,0,0,0,0,9,9,0,0,0,0,0
                db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                db 0,0,0,0,9,9,9,9,0,0,0,0,0,0,0
                db 9,9,9,9,9,9,9,9,9,9,9,9,0,0,0
                db 0,0,0,0,9,9,9,9,0,0,0,0,0,0,0
                db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                db 0,0,0,0,0,0,0,0,9,9,0,0,0,0,0
                db 0,0,0,0,0,0,0,0,9,9,9,9,9,9,9

    alien_ship_pos dw 0

    enemies_count db 5
    enemies_pos dw 20 dup(305*30)

    shot        db 15,15,15,15,15,15,15,15,15,0,0,0,0,0,0
                db 15 dup (0)
                db 15 dup (0)
                db 15 dup (0)
                db 0,0,0,0,0,0,15,15,15,15,15,15,15,15,15
                db 15 dup (0)
                db 15 dup (0)
                db 15 dup (0)
                db 15,15,15,15,15,15,15,15,15,0,0,0,0,0,0

.code
; Procedimento para navega??o no menu usando as setas
HANDLE_INPUT PROC
    cmp ah, 48H
    je ARROW_UP

    cmp ah, 50H
    je ARROW_DOWN

    jmp END_HANDLE

ARROW_UP:
    xor ah, ah
    mov menu, ah

    jmp RENDER_BUTTONS

ARROW_DOWN:
    mov ah, 1
    mov menu, ah

RENDER_BUTTONS:
    cmp screen, 0
    jne END_HANDLE
    call PRINT_BUTTONS

END_HANDLE:
    ret
ENDP



; Proc para controle da nave
HANDLE_CONTROLS proc
    push si
    push di
    push ax
    push bx
    push cx

    mov si, offset ship_pos
    mov di, [si]

    cmp ah, 48H
    je MOVE_UP

    cmp ah, 50H
    je MOVE_DOWN
    
    cmp ah, 39H
    je FIRE
    
    cmp al, 'q'
    jne END_CONTROLS

    xor ax, ax
    int 16h
    call END_GAME

MOVE_UP:
    mov al, 1
    call CLEAR_SPRITE

    mov bx, [ship_pos]
    cmp bx, 320 * 20 + 47
    jb END_CONTROLS
    je END_CONTROLS

    mov ah, 1
    mov bx, ship_speed
    call MOVE_SPRITE
    jmp END_CONTROLS

MOVE_DOWN:
    mov al, 1
    call CLEAR_SPRITE

    mov bx, [ship_pos]
    cmp bx, 320 * 160 + 47
    je END_CONTROLS
    ja END_CONTROLS

    xor ah, ah
    mov bx, ship_speed
    call MOVE_SPRITE
    jmp END_CONTROLS

FIRE:
    call SHOOT

END_CONTROLS:
    pop cx
    pop bx
    pop ax
    pop di
    pop si
    ret
endp

PRINT_TITLE_MENU proc
    mov ax, ds 
    mov es, ax

    mov bp, offset string
    mov cx, string_length ; tamanho
    mov bl, 02H ; Cor verde (se bit 1 de AL estiver limpo, usamos BL)
    xor dx, dx ;linha / coluna
    call PRINT_STRING

    ret
endp

; AL = axis (0 is X, 1 is Y)
; AH = direction (0 is positive, 1 is negative)
; SI = position pointer
; BX = increment
MOVE_SPRITE proc
    push si
    push ax
    push bx

    mov cx, [si]
    cmp al, 0
    jne MOVE_Y_AXIS
    jmp CHECK_DIRECTION

MOVE_Y_AXIS:
    push ax
    mov ax, 320
    mul bx
    mov bx, ax
    pop ax

CHECK_DIRECTION:
    cmp ah, 0
    jne MOVE_NEGATIVE
    add cx, bx
    jmp SAVE_POS

MOVE_NEGATIVE:
    sub cx, bx

SAVE_POS:
    mov [si], cx

    pop bx
    pop ax
    pop si
    ret
endp

PRINT_STRING PROC
    push AX
    push BX
    push DS
    push ES
    push SI
    push BP

    ; Configura os par?metros para a fun??o 13h
    mov ah, 13h         ; Fun??o para escrever string com atributos de cor
    mov al, 1           ; Modo: atualiza cursor ap?s a escrita
                        ; AL = 1 -> modo de atualiza??o de cursor
    xor bh, bh           ; P?gina de v?deo 0
    int 10h             ; Chamada de interrup??o para exibir a string

    pop BP
    pop SI
    pop ES
    pop DS
    pop BX
    pop AX
    ret
ENDP

; SI = sprite pointer
; BL = color
CHANGE_SPRITE_COLOR proc
    push ax
    push bx
    push cx
    push si

    mov cx, 15*9

PIXEL_LOOP:
    mov al, [si]
    cmp al, 0
    jz SKIP_REPLACE
    mov [si], bl

SKIP_REPLACE:
    inc si
    loop PIXEL_LOOP

    pop si
    pop cx
    pop bx
    pop ax
    ret
endp

; DI = sprite position
CLEAR_SPRITE proc
    push ax
    push cx
    push di
    push es
    
    mov ax, 0A000H
    mov es, ax
    mov cx, 9

CLEAR_LINE:
    push cx
    mov cx, 15
    xor ax, ax
    rep stosb
    add di, 305
    pop cx
    loop CLEAR_LINE

    pop es
    pop di
    pop cx
    pop ax
    ret
endp

; AX = sprite position
; SI = sprite pointer
RENDER_SPRITE proc
    push bx
    push cx
    push dx
    push di
    push es
    push ds
    push ax

    mov ax, @data
    mov ds, ax

    mov ax, 0A000h
    mov es, ax

    pop ax
    mov di, ax
    mov dx, 9
    push ax

DRAW_LINE:
    mov cx, 15
    rep movsb
    add di, 320 - 15
    dec dx
    jnz DRAW_LINE

    pop ax
    pop ds  
    pop es
    pop di
    pop dx
    pop cx
    pop bx
ret
endp

; Procedimento para exibir os bot?es INICIAR e SAIR
PRINT_BUTTONS proc
    push ax
    mov bl, 0FH
    mov ah, menu
    cmp ah, 0
    jne START_BTN
    mov bl, 0CH

START_BTN:
    ; Exibe o bot?o INICIAR
    mov bp, offset btn_iniciar
    mov cx, btn_iniciar_length ; tamanho
    xor dl, dl ; coluna
    mov dh, 18 ; linha
    call PRINT_STRING

    mov bl, 0FH
    mov ah, menu
    cmp ah, 1
    jne EXIT_BTN
    mov bl, 0CH

EXIT_BTN:
    mov bp, offset btn_sair
    mov cx, btn_sair_length
    xor dl, dl ; coluna
    mov dh, 21 ; linha
    call PRINT_STRING

    pop ax
    ret
endp

RESET_CROSS_SHIP_POS proc
    push ax

    mov ax, 100 * 320
    mov ship_pos, ax
    add ax, 305
    mov alien_ship_pos, ax

    pop ax
    ret
endp

CROSS_SHIPS proc
    mov ax, ship_pos
    mov di, ax
    call CLEAR_SPRITE

    cmp ax, 101*320-15
    je MOVE_ALIEN_SHIP

    inc ship_pos
    inc ax
    mov si, offset ship
    call RENDER_SPRITE

    xor cx, cx
    mov dx, 2710H
    mov ah, 86H
    int 15h
    jmp END_POS_UPDATE

MOVE_ALIEN_SHIP:
    mov ax, alien_ship_pos
    mov di, ax

    push ax
    cmp ax, 100*320
    pop ax

    je RESET_POS
    call CLEAR_SPRITE

    dec alien_ship_pos
    dec ax
    mov si, offset alien_ship
    call RENDER_SPRITE
    
    xor cx, cx
    mov dx, 2710H
    mov ah, 86H
    int 15h
    jmp END_POS_UPDATE

RESET_POS:
    call RESET_CROSS_SHIP_POS

END_POS_UPDATE:
    ret
endp


; CX = ally id
KILL_ALLY proc
    push di
    push bx
    push cx

    dec cx ; ally index
    mov bx, offset allies_pos_vec
    shl cx, 1
    add bx, cx

    mov di, [bx]
    call CLEAR_SPRITE
    mov word ptr [bx], 0

    pop cx
    pop bx
    pop di
    ret
endp

; DI = position of object to check collision against
; CX = enemy id
CHECK_ALLIES_COLLISION proc
    push bp
    push si
    push bx

    mov bp, sp
    push cx ; [bp - 2]

    mov cx, 1
    mov bx, offset allies_pos_vec
CHECK_SINGLE_COLLISION:
    push cx ; [bp - 4]

    mov si, [bx]
    call CHECK_COLLISION
    cmp cl, 1
    jne SKIP_ALLY

    mov cx, [bp - 4]
    call KILL_ALLY

    mov cx, [bp - 2]
    call RESET_ENEMY

SKIP_ALLY:
    pop cx
    add bx, 2
    inc cx
    cmp cx, 9
    jne CHECK_SINGLE_COLLISION

    pop cx
    mov sp, bp
    pop bx
    pop si
    pop bp
    ret
endp


RENDER_ALLY_SHIPS proc
    push si
    push di
    push dx
    push cx
    push bx
    push ax

    mov cx, 8
    mov di, offset allies_pos_vec

RENDER_SINGLE:
    mov ax, [di]
    cmp ax, 0
    je AFTER_CLEAR

    mov si, offset ship

    ; get color based on iteration
    mov bl, cl
    add bl, 6

    call CHANGE_SPRITE_COLOR
    call RENDER_SPRITE

AFTER_CLEAR:
    add di, 2
    loop RENDER_SINGLE

    pop ax
    pop bx
    pop cx
    pop dx
    pop di
    pop si
    ret
endp

CLEAR_SCREEN proc
    push ax
    push cx
    push es
    push di

    mov ax,0A000h
    mov es,ax
    xor di, di
    mov cx, 32000d
    cld
    xor ax, ax
    rep stosw
    
    pop di
    pop es
    pop cx
    pop ax
    ret
endp

SHOW_YOU_WIN proc
    call CLEAR_SCREEN

    mov bp, offset you_win
    mov cx, you_win_len
    mov bl, 0AH
    xor dl, dl
    mov dh, 7
    call PRINT_STRING

    mov bl, 0FH ; color = white

    mov bp, offset score_str
    mov cx, score_str_len
    mov dl, 12
    mov dh, 13
    call PRINT_STRING

    mov bp, offset score_buffer
    mov cx, score_buffer_len
    mov dl, 20
    mov dh, 13
    call PRINT_STRING

    xor ax, ax
    int 16h
    call MAIN

    ret
endp

; This proc uses LCG to generate a random number.
; returns in AX a random 16 bit unsigned integer 
RANDOM_UINT16 proc
    push dx

    mov ax, 39541
    mul seed
    add ax, 16259
    mov seed, ax

    pop dx
    ret
endp

; AH = range upper boundary (max 255)
; return random 8 bit unsigned interger to AL, between 0 and 254
RANDOM_UINT8_RANGE proc
    push bx
    push cx
    push dx
    push ax

    xor cx, cx
    mov cl, ah

    call RANDOM_UINT16

    xor dx, dx
    mov bx, cx
    div bx

    pop ax

    mov al, dl

    pop dx
    pop cx
    pop bx
    ret
endp

SHOW_GAME_OVER proc
    call CLEAR_SCREEN

    mov bp, offset game_over
    mov cx, game_over_len
    mov bl, 0CH
    xor dl, dl ; coluna
    mov dh, 8 ; linha
    call PRINT_STRING

    xor ax, ax
    int 16h
    call MAIN
    ret
endp

; SI = first position
; DI = second position
; return CL = 1 if positions collide
CHECK_COLLISION proc
    push bp
    push ax
    push bx
    push dx

    mov bp, sp 

    xor dx, dx
    xor cl, cl
    mov bx, 320

    mov ax, si
    xor dx, dx
    div bx

    push dx ; value of X1 - [bp-2]
    push ax ; value of Y1 - [bp-4]

    mov ax, di
    xor dx, dx
    div bx

    push dx ; value of X2 - [bp-6]

CHECK_Y_IN_RANGE:
    add ax, 9
    jnc SKIP_Y_MAX
    mov ax, 0FFFFH

SKIP_Y_MAX:
    mov dx, [bp - 4]
    cmp dx, ax
    ja END_COLLISION

    sub ax, 18
    jnc SKIP_Y_MIN
    xor ax, ax

SKIP_Y_MIN:
    cmp dx, ax
    jb END_COLLISION

CHECK_X_IN_RANGE:
    mov ax, [bp - 2]
    add ax, 15
    jnc SKIP_X_MAX
    mov ax, 0FFFFH

SKIP_X_MAX:
    mov dx, [bp - 6]
    cmp dx, ax
    ja END_COLLISION

    sub ax, 30
    jnc SKIP_X_MIN
    xor ax, ax

SKIP_X_MIN:
    cmp dx, ax
    jb END_COLLISION

    mov cl, 1

END_COLLISION:

    mov sp, bp

    pop dx
    pop bx
    pop ax
    pop bp
    ret
endp

RENDER_SECTOR proc
    push ax
    push bx
    push cx
    push dx
    push bp

    call CLEAR_SCREEN

    ; Print Sector
    xor ax, ax
    mov al, sector

    cmp al, 4
    jne SUM_POINTS
    call SHOW_YOU_WIN

SUM_POINTS:
    dec al ; number vector index

    mov bx, 1000
    mul bx
    xor bx, bx
    mov bl, allies_count
    mul bx
    add score, ax

    xor ax, ax
    mov al, sector
    dec al ; number vector index
    shl al, 1 ; multiply by 2 (since num_vec values are dw)
    mov bx, offset sector_vec ; get the vector
    add bx, ax ; add the index to the vector ptr
    mov bp, [bx] ; set BP to base address of number
    mov cx, sector_len
    xor dl, dl; line
    mov dh, 10

    mov ah, 6 ; random value from 0 to 5
    call RANDOM_UINT8_RANGE
    mov bl, al
    add bl, 9H
    call PRINT_STRING

    ; Wait 4s
    mov cx, 3DH
    mov dx, 900H
    mov ah, 86H
    int 15h
    
    call CLEAR_SCREEN

    pop bp
    pop dx
    pop cx
    pop bx
    pop ax
    ret
endp

RESET_ALLIES proc
    push si
    push ax
    push bx
    push cx
    push dx

    mov cx, 8
    mov bx, cx
    dec bx
    shl bx, 1

    mov si, offset allies_pos_vec
    add si, bx
LOOP_RESET_ALLY:

    xor dx, dx
    mov ax, 20
    mul cx
    xor dx, dx

    mov bx, 320
    mul bx

    mov word ptr [si], ax

    sub si, 2
    loop LOOP_RESET_ALLY

    pop dx
    pop cx
    pop bx
    pop ax
    pop si
endp 

RESET_SECTOR proc
    mov sector, 1
endp

; CX = enemy id
RESET_ENEMY proc
    push si
    push di
    push ax
    push bx
    push cx
    push dx

    mov si, offset enemies_pos
    dec cx
    shl cx, 1
    add si, cx
    mov di, [si]
    call CLEAR_SPRITE

    xor dx, dx
    mov ax, 320
    
    push ax
    
    mov ah, 140
    call RANDOM_UINT8_RANGE
    xor bx, bx
    mov bl, al
    add bl, 20

    pop ax

    mul bx
    add ax, 270
    mov [si], ax

    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop si
    ret
endp

; Returns: CX = live ally id, 0 if none 
FIND_ALLY_ALIVE proc
    push si
    push bx

    mov cx, 1
    mov si, offset allies_pos_vec

CHECK_ALIVE:
    cmp word ptr [si], 0
    jne FOUND_ALIVE 

    add si, 2
    inc cx
    cmp cx, 9
    jne CHECK_ALIVE

    xor cx, cx

FOUND_ALIVE:

    pop bx
    pop si
    ret
endp

; CX = enemy id
UPDATE_ENEMY proc
    push bp
    push si
    push di
    push ax
    push bx
    push cx

    mov bp, sp
    push cx ; [bp - 2] = enemy ID

    mov ax, 0100H
    mov si, offset enemies_pos
    dec cx
    shl cx, 1
    add si, cx

    push si ; [bp - 4]
    push cx

    mov di, [si]
    mov cx, [bp - 2]
    call CHECK_ALLIES_COLLISION

    pop cx

    mov di, [si]
    call CLEAR_SPRITE
    mov bx, 1
    call MOVE_SPRITE

    mov cx, [bp - 2]
    call RENDER_ENEMY

    xor cx, cx
    mov cl, shot_count

CHECK_SHOTS_COLLISION:
    push cx
    dec cx
    mov si, offset shot_array_shoot
    add si, cx
    mov bh, [si]
    cmp bh, 0
    pop cx
    je SKIP_SHOT

    push cx
    dec cx
    shl cx, 1
    mov si, offset shot_array_pos
    add si, cx
    mov si, [si]
    mov bx, [bp - 4]
    mov di, [bx]

    call CHECK_COLLISION
    cmp cl, 1
    pop cx

    jne SKIP_SHOT
    mov rerender_score, 1
    add score, 100
    call CLEAR_SPRITE
    call RESET_SHOT

    mov cx, [bp - 2]
    call RESET_ENEMY

SKIP_SHOT:
    loop CHECK_SHOTS_COLLISION


CHECK_SHIP_COLLISION:
    mov si, ship_pos
    call CHECK_COLLISION
    cmp cl, 1
    jne RESET_SHIP_COLLISION

    mov ah, is_ship_colliding
    cmp ah, 1
    je END_ENEMY_UPDATE

    call FIND_ALLY_ALIVE
    cmp cx, 0
    jne CONTINUE_COLLISION
    call SHOW_GAME_OVER

CONTINUE_COLLISION:
    mov is_ship_colliding, 1

    call KILL_ALLY
    mov ch, 0FH
    sub ch, cl
    mov cl, ch
    mov ship_color, cl

    mov rerender_allies, 1
    mov rerender_ship, 1
    mov cx, [bp - 2]
    call RESET_ENEMY
    dec allies_count
    jmp END_ENEMY_UPDATE

RESET_SHIP_COLLISION:
    mov is_ship_colliding, 0

CHECK_EOS: ; end of screen
    xor dx, dx
    mov ax, di
    mov bx, 320
    div bx
    cmp dx, 0
    jne END_ENEMY_UPDATE
    mov cx, [bp - 2]
    call RESET_ENEMY
    mov rerender_allies, 1
    mov rerender_score, 1
    xor dx, dx
    mov ax, 10
    mov dl, sector
    mul dx
    sub score, ax
    jnc END_ENEMY_UPDATE
    mov score, 0

END_ENEMY_UPDATE:

    mov sp, bp

    pop cx
    pop bx
    pop ax
    pop di
    pop si
    pop bp
    ret
endp

RENDER_TERRAIN proc
    push bx
    push cx
    push dx
    push di
    push es
    push ds
    push ax

    mov ax, @data
    mov ds, ax

    mov ax, 0A000h
    mov es, ax

    mov si, offset terrain
    mov di, terrain_pos
    dec terrain_pos
    ; mov bx, terrain_pos
    cmp terrain_pos, 320*180 - 1
    jnz SKIP_POS_UPDATE
    mov terrain_pos, 320*181 - 1 

SKIP_POS_UPDATE:
    mov cx, 320*20
    rep movsb

    pop ax
    pop ds  
    pop es
    pop di
    pop dx
    pop cx
    pop bx
    ret
endp

; CX = enemy id
RENDER_ENEMY proc
    push si
    push ax
    push bx
    push cx

    mov bx, offset enemies_pos
    dec cx
    shl cx, 1
    add bx, cx
    mov ax, [bx]
    mov si, offset alien_ship
    call RENDER_SPRITE

    pop cx
    pop bx
    pop ax
    pop si
    ret
endp

RESET_SHIP_COLOR proc
    push si
    push bx

    mov bx, 0FH
    mov ship_color, bl
    mov si, offset ship
    call CHANGE_SPRITE_COLOR

    pop bx
    pop si
    ret
endp

RESET_SHIP proc
    push si
    push bx

    mov ship_pos, 320 * 95 + 41 ; Ship stating position
    
    pop bx
    pop si
    ret
endp

RENDER_SHIP proc
    push si
    push di
    push bx
    push ax
    
    mov ax, ship_pos
    mov di, ax
    call CLEAR_SPRITE

    mov si, offset ship
    mov bl, ship_color ; white
    call CHANGE_SPRITE_COLOR
    call RENDER_SPRITE

    pop ax
    pop bx
    pop di
    pop si
    ret
endp

UPDATE_SHIP proc
    push si
    push di
    push ax
    push bx

    mov ah, 1H
    int 16H
    jz END_SHIP_UPDATE

    call HANDLE_CONTROLS
    xor ah, ah
    int 16H

    call RENDER_SHIP

END_SHIP_UPDATE:
    
    pop bx
    pop ax
    pop di
    pop si
    ret
endp

; AX = uint16 value to output
; SI = offset of end off string buffer
; CX = number of digits to write
CONVERT_UINT16 proc 
    push si
    push ax
    push bx
    push cx
    push dx

    mov bx, 10

LOOP_DIV:
    xor dx, dx
    div bx

    add dl, '0'
    mov byte ptr ds:[si], dl
    dec si

    cmp ax, 0
    dec cx
    jnz LOOP_DIV

    cmp cx, 0
    je END_CONVERSION

    mov dl, '0'
    mov byte ptr ds:[si], dl

END_CONVERSION:
    pop dx
    pop cx
    pop bx
    pop ax
    pop si
    ret     
endp

RENDER_SCORE proc
    push si
    push bp
    push ax
    push bx
    push cx
    push dx

    mov bp, offset score_str
    mov cx, score_str_len
    mov bl, 0FH ; white
    xor dx, dx
    call PRINT_STRING

    mov ax, score
    mov si, offset score_buffer
    add si, score_buffer_len - 1
    mov cx, score_buffer_len
    call CONVERT_UINT16
    
    mov bp, offset score_buffer
    mov bl, 02H ; green
    xor dh, dh
    mov dl, 8
    call PRINT_STRING

    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    pop si

    ret
endp

RENDER_TIME proc
    push bp
    push bx
    push cx
    push dx

    mov bp, offset time_str
    mov cx, time_str_len
    mov bl, 0FH ; white
    xor dh, dh
    mov dl, 25
    call PRINT_STRING

    xor ax, ax
    mov al, time
    mov si, offset time_buffer
    add si, time_buffer_len - 1
    mov cx, 2
    call CONVERT_UINT16
    
    mov bp, offset time_buffer
    mov cx, time_buffer_len
    mov bl, 02H ; green
    xor dh, dh
    mov dl, 32
    call PRINT_STRING

    pop dx
    pop cx
    pop bx
    pop bp

    ret
endp

UPDATE_TIME proc
    push ax

    mov ah, timeout
    inc ah
    cmp ah, 100
    jne SAVE_TIMEOUT

    mov ah, time
    dec ah
    jnz SAVE_TIME

    mov ah, sector
    inc ah
    mov sector, ah
    
    call RENDER_SECTOR
    call RESET
    
    jmp END_TIME

SAVE_TIME:
    mov time, ah
    xor ah, ah

SAVE_TIMEOUT:
    mov timeout, ah

END_TIME:
    pop ax
    ret
endp

SHOOT proc
    push si
    push bx
    push cx

    ; Find a shot that was not fired yet
    xor cx, cx
    mov cl, shot_count
    mov si, offset shot_array_shoot
    add si, cx
    dec si

FIND_SHOT:
    mov bl, [si]
    cmp bl, 0
    je FOUND_SHOT
    dec si
    loop FIND_SHOT

    cmp cx, 0
    je END_SHOOT

FOUND_SHOT:
    call RESET_SHOT
    mov byte ptr [si], 1 ; Set shot as fired

END_SHOOT:
    pop cx
    pop bx
    pop si
    ret
endp

; CX = shot id
RESET_SHOT proc
    push cx
    push si
    push di
    push bx

    dec cx ; Get shot index
    push cx
    shl cx, 1 ; Multiply index by 2 (for word)
    mov si, offset shot_array_pos ; Get shot position array
    add si, cx ; Find shot in array

    mov di, [si] ; Set DI to shot position
    call CLEAR_SPRITE ; Clear shot

    mov bx, ship_pos
    add bx, 15
    mov [si], bx

    mov si, offset shot_array_shoot ; Get shot fired array
    pop cx
    add si, cx ; Find shot in array
    mov byte ptr [si], 0 ; Set shot as not fired    

    pop bx
    pop di
    pop si
    pop cx
    ret
endp

UPDATE_SHOT proc
    push di
    push si
    push ax
    push bx
    push cx
    push dx

    xor cx, cx
    mov cl, shot_count
SINGLE_SHOT:
    mov bp, sp
    push cx ; [bp - 2]

    ; Find shot index
    dec cx
    mov si, offset shot_array_shoot
    add si, cx
    cmp byte ptr [si], 1
    jne NO_UPDATE

    ; Clear shot
    shl cx, 1 ; Multiply index by 2 (for word array)
    mov si, offset shot_array_pos
    add si, cx
    mov di, [si]
    call CLEAR_SPRITE

    ; Reset shot
    xor dx, dx
    mov ax, di
    add ax, 15
    mov bx, 320
    div bx
    cmp dx, 0
    jne MOVE_SHOT
    mov cx, [bp - 2]
    call RESET_SHOT
    jmp NO_UPDATE

MOVE_SHOT:
    ; Move shot
    xor ax, ax
    mov bx, 3
    call MOVE_SPRITE

    ; Render shot
    mov ax, [si]
    mov si, offset shot
    call RENDER_SPRITE

NO_UPDATE:
    pop cx
    loop SINGLE_SHOT

    mov sp, bp

    pop dx
    pop cx
    pop bx
    pop ax
    pop si
    pop di
    ret
endp

RESET_TIME proc
    push ax

    xor ah, ah
    mov timeout, ah
    mov ah, sector_time
    mov time, ah

    pop ax
endp

RESET_RERENDERS proc
    push ax
    
    mov ah, 1
    mov rerender_ship, 1
    mov rerender_allies, 1
    mov rerender_score, 1

    pop ax
    ret
endp

RESET proc ; Contains all procedures for reseting values
    call RESET_SHIP

    push cx
    xor cx, cx
    mov cl, enemies_count
ENEMIES_RESET:
    call RESET_ENEMY
    loop ENEMIES_RESET
    pop cx

    call RESET_TIME
    call RESET_RERENDERS
    ret
endp

UPDATE proc ; Contains all procedures for updating game state
    call UPDATE_SHIP
    call UPDATE_TIME
    call UPDATE_SHOT
    push cx
    xor cx, cx
    mov cl, enemies_count
ENEMIES_UPDATE:
    call UPDATE_ENEMY
    loop ENEMIES_UPDATE
    pop cx

    ret
endp

RENDER proc ; Contains all procedures for rendering game objects
    push ax
    call RENDER_TIME
    call RENDER_TERRAIN

    ; should re-render ship?
    mov al, rerender_ship
    cmp al, 0
    je SKIP_2_ALLIES
    call RENDER_SHIP
    mov rerender_ship, 0

SKIP_2_ALLIES: 
    ; should re-render allies?
    mov al, rerender_allies
    cmp al, 1
    jne SKIP_2_SCORE
    call RENDER_ALLY_SHIPS
    mov rerender_allies, 0

SKIP_2_SCORE:
    ; should re-render score?
    mov al, rerender_score
    cmp al, 1
    jne END_RENDER
    call RENDER_SCORE
    mov rerender_score, 0

END_RENDER:
    pop ax
    ret
endp

END_GAME proc
    ; Back to text mode
    xor ah, ah
    mov al, 3h
    int 10h

    ; Ends program
    mov ah, 4ch
    xor al, al
    int 21h
    ret
endp

THROTTLE proc
    push ax
    push cx
    push dx

    xor cx, cx
    mov dx, 2710H
    mov ah, 86H
    int 15h

    pop dx
    pop cx
    pop ax
    ret
endp

SYSTIME_SEED proc
    push ax
    push cx
    push dx

    xor ax, ax
    int 1AH
    mov seed, dx

    pop dx
    pop cx
    pop ax
    ret
endp

MAIN proc
    mov AX, @data
    mov DS, AX
    mov AX, 0A000H
    mov ES, AX
    xor DI, DI

    call SYSTIME_SEED

    ; Define o modo de video
    xor ah, ah
    xor bh, bh
    mov al, 13h
    int 10h

    ; Exibe t?tulo e bot?es do menu
    call PRINT_TITLE_MENU
    call PRINT_BUTTONS
    call RESET_CROSS_SHIP_POS
    call RESET_ALLIES
    call RESET_SHIP_COLOR
    ; call RESET_SHIP
    call RESET_SECTOR

MENU_LOOP:
    call CROSS_SHIPS
    
    ; Recebe entrada do usu?rio
    mov ah, 1H
    int 16H
    jz MENU_LOOP

    ; Chama a fun??o de navega??o
    call HANDLE_INPUT

    ; Condi??o para iniciar o jogo
    cmp ah, 1CH
    je SELECT_OPTION

    ; Retorno ao loop do menu
    xor ah, ah
    int 16H
    jmp MENU_LOOP

SELECT_OPTION:
    xor ah, ah
    int 16H
    
    mov ah, menu
    cmp ah, 1
    je FINISH

    call RENDER_SECTOR

    call RESET

GAME_LOOP:
    call THROTTLE
    call UPDATE
    call RENDER

    jmp GAME_LOOP

FINISH:
    CALL END_GAME
    
    ret
endp

end MAIN