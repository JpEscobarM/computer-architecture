.model small


.stack 100H


.data
op_menu db 1

seed dw 0 
      
fase db 1 ;indicia fase atual 
      
menu_selecao db 0   ; 0 = Jogar, 1 = Sair



inicia_jogo  db 0   ; Flag para iniciar o jogo
fps dw 10000        ; tempo em microsegundos (/10 para frames por segundo)
tempo_tela_fase dd 1000 * 1000 * 1


;VARIAVEIS
estado db 0 ;flag de estados de fases, 1= fase 1 = 2 = fase 2, 3 = fase 3 , 4  = final
pontos dw 0
qtd_alien dw 0 ;controla quantidade de aliens 
qtd_meteoro dw 0 ;controla a quantidade de meteoros
tiro_flag db 0 ;checa existencia do tiro, s? pode atirar quando tiro_flag == 0
tiro_desloc dw 0 ;variavel para deslocamento da posicao do tiro


tempo_fase equ 30 ; variavel que define o tempo de cada fase
cronometro db 0  ;cronometro que ficar? decrementando baseado no tempo_fase
cronometro_string db 2 dup(?) ;2 casas decimais
tamanho_cronometro_string equ $-cronometro_string

posicoes_aliens dw 20 dup(0) ; posicao dos aliens

aliens_restante_fase db ?;? inicializada em MOSTRA_SETOR com naves_set1/2/3 (o limite desejado).
;Ao gerar uma inimiga (GERAR_INIMIGO) voc? decrementa=  consome 1 ?cr?dito? de spawn.
;Quando a inimiga morre ou sai da tela (LIMPAR_NAVE_INIMIGA e tamb?m no trecho de ?escapou? em MOVIMENTA_INIMIGOS),
;voc? incrementa =  devolve o cr?dito.

  vidas db 3 dup(1) ;vida = 1 , sem vida = 0
  vidas_qtd db 3
  vida_posicao_x db 132 ;vetor de posicao de cada vida
                 db 152
                 db 172
    
  
  pontos_string db 6 dup (?)
  tamanho_pontos_string equ $-pontos_string
  
   frase_score db "SCORE: "
  score_tamanho equ $-frase_score
  frase_tempo db "TEMPO: "
  tempo_tamanho equ $- frase_tempo
  frase_pontuacao db "PONTUACAO: "
  pontuacao_tamanho equ $ - frase_pontuacao

;=====  
  
largura_video dw 320
altura_video dw 200

nave_posicao dw 0
nave_inimica_posicao dw 0
meteoro_posicao dw 0

alien_posicao dw 0
alien_y dw 0
alien_x dw 0
alien_direction dw 1 ;1 = esquerda, 2 = direita

 

; Terreno (amarelo = 0EH, azul claro = 09H, preto = 0H)
terreno_planeta  db 125 dup(0H) , 7 dup(09H) , 5 dup(0EH) , 343 dup(0H)
                 db 125 dup(0H) , 7 dup(09H) , 5 dup(0EH) , 343 dup(0H)
                 db 8 dup(0H) , 5 dup(09H) , 118 dup(0H) , 5 dup(09H) , 344 dup(0H)
                 db 6 dup(0H) , 2 dup(09H) , 5 dup(0EH) , 09H , 466 dup(0H)
                 db 4 dup(0H) , 09H , 8 dup(0EH) , 09H , 466 dup(0H)
                 db 3 dup(0H) , 2 dup(09H) , 8 dup(0EH) , 3 dup(09H) , 464 dup(0H)
                 db 3 dup(0H) , 13 dup(0EH) , 09H , 463 dup(0H)
                 db 0H , 2 dup(09H) , 5 dup(0EH) , 2 dup(09H) , 6 dup(0EH) , 09H , 463 dup(0H)
                 db 0H , 09H , 6 dup(0EH) , 2 dup(09H) , 6 dup(0EH) , 09H , 463 dup(0H)
                 db 6 dup(0EH) , 2 dup(09H) , 6 dup(0EH) , 09H , 465 dup(0H)
                 db 5 dup(0EH) , 8 dup(09H) , 2 dup(0EH) , 5 dup(09H) , 460 dup(0H)
                 db 4 dup(0EH) , 3 dup(09H) , 0EH , 5 dup(09H) , 7 dup(0EH) , 460 dup(0H)
                 db 3 dup(0EH) , 26 dup(09H) , 451 dup(0H)
                 db 3 dup(0EH) , 17 dup(09H) , 8 dup(0EH) , 09H , 451 dup(0H)
                 db 0EH , 18 dup(09H) , 7 dup(0EH) , 09H , 453 dup(0H)
                 db 0EH , 18 dup(09H) , 7 dup(0EH) , 09H , 453 dup(0H)
                 db 22 dup(09H) , 4 dup(0EH) , 09H , 453 dup(0H)
                 db 22 dup(09H) , 5 dup(0EH) , 3 dup(09H) , 450 dup(0H)
                 db 22 dup(09H) , 8 dup(0EH) , 09H , 449 dup(0H)
                 db 23 dup(09H) , 8 dup(0EH) , 10 dup(09H) , 439 dup(0H)
                 db 24 dup(09H) , 16 dup(0EH) , 09H , 439 dup(0H)
                 db 32 dup(09H) , 6 dup(0EH) , 09H , 441 dup(0H)
                 db 37 dup(09H) , 2 dup(0EH) , 3 dup(09H) , 438 dup(0H)
                 db 37 dup(09H) , 5 dup(0EH) , 438 dup(0H)
                 db 40 dup(09H) , 2 dup(0EH) , 7 dup(09H) , 431 dup(0H)
                 db 41 dup(09H) , 7 dup(0EH) , 09H , 431 dup(0H)
                 db 44 dup(09H) , 15 dup(0EH) , 421 dup(0H)
                 db 45 dup(09H) , 14 dup(0EH) , 5 dup(09H) , 416 dup(0H)
                 db 46 dup(09H) , 18 dup(0EH) , 416 dup(0H)
                 db 57 dup(09H) , 7 dup(0EH) , 4 dup(09H) , 412 dup(0H)
                 db 58 dup(09H) , 9 dup(0EH) , 09H , 412 dup(0H)
                 db 64 dup(09H) , 7 dup(0EH) , 2 dup(09H) , 407 dup(0H)
                 db 65 dup(09H) , 7 dup(0EH) , 5 dup(09H) , 403 dup(0H)
                 db 68 dup(09H) , 9 dup(0EH) , 09H , 402 dup(0H)
                 db 71 dup(09H) , 7 dup(0EH) , 09H , 401 dup(0H)
                 db 71 dup(09H) , 8 dup(0EH) , 09H , 400 dup(0H)
                 db 74 dup(09H) , 8 dup(0EH) , 09H , 8 dup(0H) , 09H , 25 dup(0EH) , 2 dup(09H) , 26 dup(0H) , 2 dup(09H) , 9 dup(0EH) , 2 dup(09H) , 14 dup(0H) , 2 dup(09H) , 7 dup(0EH) , 2 dup(09H) , 6 dup(0H) , 09H , 10 dup(0EH) , 2 dup(09H) , 6 dup(0H) , 09H , 9 dup(0EH) , 09H , 11 dup(0H) , 09H , 10 dup(0EH) , 09H , 20 dup(0H) , 09H , 22 dup(0EH) , 2 dup(09H) , 30 dup(0H) , 09H , 10 dup(0EH) , 09H , 15 dup(0H) , 09H , 8 dup(0EH) , 09H , 7 dup(0H) , 09H , 10 dup(0EH) , 09H , 6 dup(0H) , 2 dup(09H) , 8 dup(0EH) , 09H , 11 dup(0H) , 2 dup(09H) , 10 dup(0EH) , 09H , 11 dup(0H) , 09H , 7 dup(0EH) , 09H , 3 dup(0H) , 09H , 9 dup(0EH) , 09H , 6 dup(0H) , 2 dup(09H) , 4 dup(0EH) , 09H , 15 dup(0H) , 09H , 3 dup(0EH)
                 db 74 dup(09H) , 8 dup(0EH) , 9 dup(09H) , 27 dup(0EH) , 7 dup(09H) , 20 dup(0H) , 2 dup(09H) , 10 dup(0EH) , 16 dup(09H) , 10 dup(0EH) , 7 dup(09H) , 11 dup(0EH) , 7 dup(09H) , 10 dup(0EH) , 13 dup(09H) , 11 dup(0EH) , 3 dup(09H) , 11 dup(0H) , 7 dup(09H) , 23 dup(0EH) , 09H , 25 dup(0H) , 5 dup(09H) , 11 dup(0EH) , 16 dup(09H) , 10 dup(0EH) , 7 dup(09H) , 12 dup(0EH) , 7 dup(09H) , 10 dup(0EH) , 12 dup(09H) , 11 dup(0EH) , 13 dup(09H) , 8 dup(0EH) , 3 dup(09H) , 10 dup(0EH) , 8 dup(09H) , 6 dup(0EH) , 15 dup(0H) , 09H , 3 dup(0EH)
                 db 74 dup(09H) , 51 dup(0EH) , 22 dup(0H) , 98 dup(0EH) , 09H , 9 dup(0H) , 09H , 30 dup(0EH) , 09H , 24 dup(0H) , 09H , 149 dup(0EH) , 15 dup(0H) , 09H , 3 dup(0EH)
                 db 79 dup(09H) , 21 dup(0EH) , 13 dup(09H) , 11 dup(0EH) , 09H , 22 dup(0H) , 11 dup(0EH) , 4 dup(09H) , 8 dup(0EH) , 4 dup(09H) , 14 dup(0EH) , 6 dup(09H) , 15 dup(0EH) , 7 dup(09H) , 15 dup(0EH) , 9 dup(09H) , 5 dup(0EH) , 11 dup(09H) , 12 dup(0EH) , 13 dup(09H) , 5 dup(0EH) , 2 dup(09H) , 20 dup(0H) , 4 dup(09H) , 7 dup(0EH) , 16 dup(09H) , 14 dup(0EH) , 7 dup(09H) , 14 dup(0EH) , 8 dup(09H) , 14 dup(0EH) , 13 dup(09H) , 4 dup(0EH) , 4 dup(09H) , 14 dup(0EH) , 20 dup(09H) , 14 dup(0EH) , 15 dup(09H) , 4 dup(0EH)
                 db 80 dup(09H) , 19 dup(0EH) , 14 dup(09H) , 10 dup(0EH) , 09H , 23 dup(0H) , 10 dup(0EH) , 6 dup(09H) , 6 dup(0EH) , 6 dup(09H) , 13 dup(0EH) , 7 dup(09H) , 13 dup(0EH) , 9 dup(09H) , 13 dup(0EH) , 11 dup(09H) , 26 dup(0EH) , 14 dup(09H) , 7 dup(0EH) , 20 dup(0H) , 09H , 9 dup(0EH) , 18 dup(09H) , 13 dup(0EH) , 7 dup(09H) , 13 dup(0EH) , 9 dup(09H) , 13 dup(0EH) , 14 dup(09H) , 3 dup(0EH) , 6 dup(09H) , 13 dup(0EH) , 21 dup(09H) , 32 dup(0EH)
                 db 120 dup(09H) , 4 dup(0EH) , 6 dup(09H) , 15 dup(0H) , 2 dup(09H) , 5 dup(0EH) , 95 dup(09H) , 7 dup(0EH) , 27 dup(09H) , 7 dup(0EH) , 2 dup(09H) , 15 dup(0H) , 3 dup(09H) , 7 dup(0EH) , 165 dup(09H)
                 db 120 dup(09H) , 10 dup(0EH) , 09H , 14 dup(0H) , 09H , 6 dup(0EH) , 96 dup(09H) , 6 dup(0EH) , 27 dup(09H) , 8 dup(0EH) , 09H , 14 dup(0H) , 09H , 10 dup(0EH) , 165 dup(09H)
                 db 122 dup(09H) , 9 dup(0EH) , 09H , 8 dup(0H) , 09H , 6 dup(0EH) , 136 dup(09H) , 9 dup(0EH) , 09H , 8 dup(0H) , 09H , 6 dup(0EH) , 172 dup(09H)
                 db 125 dup(09H) , 7 dup(0EH) , 9 dup(09H) , 6 dup(0EH) , 141 dup(09H) , 5 dup(0EH) , 9 dup(09H) , 5 dup(0EH) , 173 dup(09H)
                 db 125 dup(09H) , 24 dup(0EH) , 139 dup(09H) , 18 dup(0EH) , 174 dup(09H)
                 db 128 dup(09H) , 16 dup(0EH) , 151 dup(09H) , 7 dup(0EH) , 178 dup(09H)
                 db 129 dup(09H) , 14 dup(0EH) , 152 dup(09H) , 6 dup(0EH) , 179 dup(09H)
                 db 480 dup (09H) 
  
arte_titulo db 3 dup(" ")," ___                    _    _     ", 10, 13
            db 3 dup(" "),"/ __| __ _ _ __ _ _ __ | |__| |___ ", 10, 13
            db 3 dup(" "),"\__ \/ _| '_/ _` | '  \| '_ \ / -_)", 10, 13
            db 3 dup(" "),"|___/\__|_| \__,_|_|_|_|_.__/_\___|", 10, 13
       
tamanho_arte equ $ - arte_titulo

arte_f1 db 10 dup(" ")," ___               _ ", 10, 13
        db 10 dup(" "),"| __|_ _ ___ ___  / |", 10, 13
        db 10 dup(" "),"| _/ _` (_-</ -_) | |", 10, 13
        db 10 dup(" "),"|_|\__,_/__/\___| |_|", 10, 13
            
tamanho_f1 equ $ - arte_f1

arte_f2 db 10 dup(" ")," ___               ___ ", 10, 13
        db 10 dup(" "),"| __|_ _ ___ ___  |_  )", 10, 13
        db 10 dup(" "),"| _/ _` (_-</ -_)  / / ", 10, 13
        db 10 dup(" "),"|_|\__,_/__/\___| /___|", 10, 13
            
tamanho_f2 equ $ - arte_f2

arte_f3 db 10 dup(" ")," ___               ____ ", 10, 13
        db 10 dup(" "),"| __|_ _ ___ ___  |__ / ", 10, 13
        db 10 dup(" "),"| _/ _` (_-</ -_)  |_ \ ", 10, 13
        db 10 dup(" "),"|_|\__,_/__/\___| |___/ ", 10, 13
tamanho_f3 equ $ - arte_f3
            
;  _____  _____  __  __  _____    _____  __ __  _____  _____ 
; /   __\/  _  \/  \/  \/   __\  /  _  \/  |  \/   __\/  _  \
; |  |_ ||  _  ||  \/  ||   __|  |  |  |\  |  /|   __||  _  <
; \_____/\__|__/\__ \__/\_____/  \_____/ \___/ \_____/\__|\_/
;  __ __  _____  _____  _____  _____  _____  _____  _____    
; /  |  \/   __\/  _  \/     \/   __\|  _  \/  _  \/  _  \   
; \  |  /|   __||  |  ||  |--||   __||  |  ||  |  ||  _  <   
;  \___/ \_____/\__|__/\_____/\_____/|_____/\_____/\__|\_/   



btn_jogar db 15 dup(" "),218,196,196,196,196,196,196,196,191,10,13
          db 15 dup(" "),179,           " JOGAR ",       179,10,13
          db 15 dup(" "),192,196,196,196,196,196,196,196,217,10,13
          
tamanho_jogar equ $-btn_jogar ;$-> como se fosse um contador de posicao, ao montar uma string
                              ;$ aponta para o final dela.
                              

btn_sair  db 15 dup(" "),218,196,196,196,196,196,196,196,191,10,13
          db 15 dup(" "),179,           " SAIR  ",        179,10,13
          db 15 dup(" "),192,196,196,196,196,196,196,196,217,10,13


tamanho_sair equ $-btn_sair


;FORMULA BASICA DE POSICIONAMENTO NA TELA: LINHA * 320 + COLUNA.
; 13 linhas x 29 colunas
nave db 09H,09H,09H,09H,09H,09H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H
     db 00H,09H,09H,09H,09H,09H,09H,09H,00H,00H,00H,00H,00H,00H,00H,0CH,0CH,0CH,0CH,00H,0EH,0EH,0EH,00H,00H,00H,00H,00H,00H
     db 00H,00H,08H,09H,09H,09H,09H,09H,09H,00H,00H,00H,0CH,0CH,0CH,0CH,0CH,0CH,0CH,00H,0EH,0EH,0EH,0EH,0EH,0EH,00H,00H,00H
     db 00H,00H,00H,09H,09H,09H,09H,09H,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,00H,0EH,0EH,00H,08H,0EH,0EH,08H,00H,00H
     db 00H,00H,00H,00H,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,00H,0EH,0EH,00H,08H,0EH,0EH,0EH,06H,00H
     db 00H,00H,00H,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,08H,0EH,00H,0EH,0EH,0EH,08H,0EH,0EH
     db 0EH,0EH,0EH,0EH,0EH,0EH,0EH,0EH,0EH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,06H,00H,00H,00H,00H,00H,00H,00H,00H
     db 00H,00H,00H,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH
     db 00H,00H,00H,00H,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,06H,00H
     db 00H,00H,00H,09H,09H,09H,09H,09H,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,08H,00H,00H
     db 00H,08H,09H,09H,09H,09H,09H,09H,01H,00H,00H,00H,06H,06H,06H,0CH,0CH,0CH,0CH,06H,06H,06H,06H,06H,08H,00H,00H,00H,00H
     db 00H,09H,09H,09H,09H,09H,09H,09H,00H,00H,00H,00H,00H,00H,00H,06H,06H,06H,06H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H
     db 09H,09H,09H,09H,09H,09H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H

nave_tamanho equ $-nave

                                       
vida db 09H,09H,09H,09H,09H,00H,0CH,0CH,0CH,00H,0EH,0EH,0EH,00H,00H,00H
     db 00H,09H,09H,09H,0CH,0CH,0CH,0CH,0CH,00H,0EH,00H,00H,0EH,0EH,00H
     db 00H,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,00H,0EH,00H,0EH,0EH,00H,0EH
     db 0EH,0EH,0EH,0EH,0CH,0CH,0CH,0CH,0CH,0CH,00H,00H,00H,00H,00H,00H
     db 00H,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH
     db 00H,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,00H,00H
     db 09H,09H,09H,09H,09H,00H,0CH,0CH,0CH,0CH,0CH,0CH,00H,00H,00H,00H

vida_tamanho equ $-vida
     
    
    
; ========= METEORO 13x29 (valores em 00H..0FH) =========
; 13 linhas x 29 colunas
meteoro db 00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,05H,05H,05H,05H,05H,08H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H
        db 00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,05H,0DH,0DH,0DH,05H,05H,08H,00H,00H,05H,05H,00H,00H,00H,00H,00H,00H,00H,00H
        db 00H,00H,00H,00H,00H,00H,00H,00H,05H,05H,0CH,0DH,05H,05H,05H,0CH,0CH,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H
        db 00H,00H,00H,00H,00H,00H,05H,05H,05H,05H,0CH,0CH,05H,05H,05H,05H,0CH,0CH,0CH,00H,00H,00H,0DH,0DH,0CH,00H,00H,00H,00H
        db 00H,00H,00H,00H,00H,00H,05H,05H,0CH,05H,0CH,0CH,05H,05H,05H,0CH,0CH,05H,05H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H
        db 00H,00H,00H,00H,00H,05H,0CH,0CH,05H,0CH,0CH,0CH,05H,05H,0CH,05H,05H,0CH,05H,05H,05H,00H,00H,05H,05H,00H,00H,00H,00H
        db 00H,00H,00H,00H,05H,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,05H,00H,00H,00H,00H,00H,00H,00H,00H,00H
        db 00H,00H,00H,00H,05H,0CH,0CH,0CH,05H,05H,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,0CH,05H,00H,00H,00H,00H,00H,00H,00H,00H,00H
        db 00H,00H,00H,00H,00H,05H,05H,0DH,0CH,05H,0CH,0CH,0CH,0CH,0CH,05H,05H,0CH,0CH,0CH,0CH,00H,00H,0CH,0CH,00H,00H,00H,00H
        db 00H,00H,00H,00H,00H,08H,05H,0DH,0DH,0CH,05H,0CH,0CH,0CH,0CH,05H,05H,05H,0CH,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H
        db 00H,00H,00H,00H,00H,00H,00H,05H,0DH,0DH,0CH,0CH,0CH,0CH,0CH,05H,05H,05H,00H,00H,0CH,0CH,00H,00H,00H,00H,00H,00H,00H
        db 00H,00H,00H,00H,00H,00H,00H,00H,08H,08H,05H,05H,05H,05H,0CH,08H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H
        db 00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,05H,05H,05H,05H,05H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H,00H

meteoro_tamanho equ $-meteoro


alien  db 00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,02h,02h,02h,02h,0Ah,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00H
       db 00h,00h,00h,00h,00h,00h,02h,02h,02h,0Ah,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00H
       db 00h,00h,00h,00h,02h,02h,02h,02h,02h,0Ah,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00H
       db 00h,00h,00h,00h,02h,02h,05h,05h,05h,0Dh,0Eh,0Eh,05h,05h,05h,0Dh,0Eh,0Eh,05h,05h,05h,0Dh,0Eh,0Eh,0Eh,00h,00h,00h,00H
       db 00h,00h,02h,02h,02h,02h,05h,05h,05h,0Dh,0Eh,0Eh,05h,05h,05h,0Dh,0Eh,0Eh,05h,05h,05h,0Dh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00H
       db 00h,00h,02h,02h,02h,02h,05h,05h,05h,0Dh,0Eh,0Eh,05h,05h,05h,0Dh,0Eh,0Eh,05h,05h,05h,0Dh,0Eh,0Eh,0Eh,0Eh,0Eh,00h,00H
       db 02H,02H,02H,02H,02H,02H,02H,02H,02H,02H,02H,02H,02H,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh
       db 02H,02H,02H,02H,02H,02H,02H,02H,02H,02H,02H,02H,02H,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0Eh,0EH
       db 00h,00h,00h,00h,05h,05h,05h,0Dh,02h,02h,0Ah,0Eh,0Eh,0Eh,05h,05h,05h,0Dh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00H
       db 00h,00h,00h,00h,05h,05h,05h,0Dh,02h,02h,0Ah,0Eh,0Eh,0Eh,05h,05h,05h,0Dh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00H
       db 00h,00h,00h,00h,05h,05h,05h,0Dh,02h,02h,0Ah,0Eh,0Eh,0Eh,05h,05h,05h,0Dh,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00H
       db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00H
       db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,02h,02h,02h,0Ah,0Ah,0Eh,0Eh,0Eh,0Eh,00h,00h,00h,00h,00h,00h,00h,00h,00h,00H
alien_tamanho equ $ - alien

        
        
.code
; Funcao generica que escreve Strings com cor na tela
ESCREVE_STRING proc 
    push AX
    push BX
    push DS
    push ES
    push SI
    push BP
    push BX
    
    mov BX, DS
    mov ES, BX

    mov AH, 13h ;escreve string com atributos de cor
    mov AL, 01h ;modo: atualiza o cursor apos a escrita   
    pop BX  
    xor BH, BH  ;pagina de video 0
    int 10h     ; Interrupcao para escrever a string
    
    pop BP
    pop SI
    pop ES
    pop DS
    pop BX
    pop AX
           
    ret
endp

LIMPA_TELA proc
    push CX
    push AX
    push DI
    
    mov AX, 0A000h
    mov ES, AX
    
    xor DI, DI
    xor AX, AX
    CLD ;zera o DF, DF = 0 avanca e DF = 1 volta
    
    mov CX,32000  ;como avanca +2 em stoswORD precisa percorrer 32k nao 64k
    mov DI,0

    rep stosw  ;repete CX vezes: [ES:DI] = AX; DI += 2. 
    
    pop DI
    pop AX
    pop CX
    ret
endp

VERIFICA_TECLADO_JOGO proc
    push AX
    push DI
    mov DI, [nave_posicao]
    
    mov AH, 01h
    int 16h
    jz FIM_TECLADO_JOGO
    
    xor AH, AH
    int 16h
    
    cmp AH, 48H
    je SETA_CIMA
    
    cmp AH, 50H
    je SETA_BAIXO
    
    cmp AH, 4BH
    je SETA_ESQUERDA
    
    cmp AH, 4DH
    je SETA_DIREITA
    
    jmp FIM_TECLADO_JOGO
    
    SETA_CIMA:
        mov AX, 0 ; 0 = Cima
        call MOVER_VERTICAL
        jmp FIM_TECLADO_JOGO
        
    SETA_BAIXO:
        mov AX, 1 ; 1 = Baixo
        call MOVER_VERTICAL
        jmp FIM_TECLADO_JOGO

    SETA_ESQUERDA:
        mov AX, 0 ; 0 = Esquerda
        call MOVER_HORIZONTAL
        jmp FIM_TECLADO_JOGO

    SETA_DIREITA:
        mov AX, 1 ; 1 = Direita
        call MOVER_HORIZONTAL
        jmp FIM_TECLADO_JOGO
        
    FIM_TECLADO_JOGO:
        mov [nave_posicao], DI
        pop AX
        pop DI
        ret
    endp

MOVER_VERTICAL proc
    ; AX=0 (Cima), AX=1 (Baixo)
    push BX
    mov BX, [largura_video]
    
    cmp AX, 0
    je MOVER_CIMA
    MOVER_BAIXO:
        add DI, BX
        jmp SAIR_MOVIMENTO_VERTICAL
    
    MOVER_CIMA:
        sub DI, BX
        jmp SAIR_MOVIMENTO_VERTICAL
    
    SAIR_MOVIMENTO_VERTICAL:
        pop BX
        ret
endp

MOVER_HORIZONTAL proc
    ; AX=0 (Esquerda), AX=1 (Direita)
    cmp AX, 0
    je MOVER_ESQUERDA
    
    MOVER_DIREITA:
        inc DI
        jmp SAIR_MOVIMENTO_HORIZONTAL
    
    MOVER_ESQUERDA:
        dec DI
        jmp SAIR_MOVIMENTO_HORIZONTAL
    
    SAIR_MOVIMENTO_HORIZONTAL:
        ret
endp

CARREGA_FASE proc       ; Espera X segundos e depois limpa a tela
    mov CX, WORD PTR [tempo_tela_fase + 2]
    mov DX, WORD PTR [tempo_tela_fase]
    mov AH, 86h
    int 15h
    
    call LIMPA_TELA
    ret
endp

PARTIDA proc 

    call MOSTRAR_HEADER 
    JOGANDO:
        call BUSCA_INTERACAO
        
        mov DI, [nave_posicao]
        call LIMPA_13x29; apaga 13x29 na posicao DI.
        
        call VERIFICA_TECLADO_JOGO
        
        mov AX, [nave_posicao]
        mov SI, offset nave ;prepara SI para MOVSB Move de DS:SI -> ES:DI
        call DESENHA; RENDER_SPRITE
        

        jmp JOGANDO

    ret
endp

JOGAR_SAIR proc                     ; Verifica qual opcao esta marcada
    cmp menu_selecao, 1
    jne JOGAR_F1
    call TERMINA_JOGO
    
    JOGAR_F1:
        xor inicia_jogo, 1
        call LIMPA_TELA
        mov DH, 10
        mov DL, 0
        mov BL, 0FH
        mov BP, offset arte_f1
        mov CX, tamanho_f1
        call ESCREVE_STRING
        
        call CARREGA_FASE
        ; call PARTIDA
        
    JOGAR_F2:
        call LIMPA_TELA
        mov DH, 10
        mov DL, 0
        mov BL, 0CH
        mov BP, offset arte_f2
        mov CX, tamanho_f2
        call ESCREVE_STRING
        
        call CARREGA_FASE
        ; call PARTIDA
        
    JOGAR_F3:
        call LIMPA_TELA
        mov DH, 10
        mov DL, 0
        mov BL, 04H
        mov BP, offset arte_f3
        mov CX, tamanho_f3
        call ESCREVE_STRING
        
        call CARREGA_FASE
        call PARTIDA
        

    ret
endp

TERMINA_JOGO proc ; Encerra o jogo
    mov AH, 4Ch
    int 21h
    ret
endp

VERIFICA_OPCAO proc         ; Verifica qual opcao esta marcada no menu (jogar/sair)
    push BP
    push BX
    push CX
    push DX
    
    cmp menu_selecao, 0
    jne OPCAO_SAIR
    
    mov DH, 18                   ; Opcao "Jogar" selecionada
    mov DL, 0
    mov BL, 0CH
    mov BP, offset btn_jogar
    mov CX, tamanho_jogar
    call ESCREVE_STRING
    
    mov DH, 21
    mov BL, 0FH
    mov BP, offset btn_sair
    mov CX, tamanho_sair
    call ESCREVE_STRING
    jmp VOLTAR_VERIFICA_OPCAO
    
    OPCAO_SAIR:                 ; Opcao "Sair" selecionada
        mov DH, 18
        mov DL, 0
        mov BL, 0FH
        mov BP, offset btn_jogar
        mov CX, tamanho_jogar
        call ESCREVE_STRING
        
        mov DH, 21
        mov BL, 0CH
        mov BP, offset btn_sair
        mov CX, tamanho_sair
        call ESCREVE_STRING
    
    VOLTAR_VERIFICA_OPCAO:
        pop DX
        pop CX
        pop BX
        pop BP
        ret
endp

INTERAGE_MENU proc      ; Verifica se houve alguma interacao na tela do menu
    push AX
    
    mov AH, 01H
    int 16H
    jz VOLTAR_MENU
    
    xor AH, AH
    int 16H
    
    cmp AH, 48H         ; Seta Cima
    jne BOTAO_BAIXO
    xor menu_selecao, 1
    jmp VOLTAR_MENU
    
    BOTAO_BAIXO:
        cmp AH, 50H     ; Seta Baixo
        jne BOTAO_ENTER
        xor menu_selecao, 1
        jmp VOLTAR_MENU
        
    BOTAO_ENTER:
        cmp AH, 1CH     ; Enter
        jne VOLTAR_MENU
        call JOGAR_SAIR
        
    VOLTAR_MENU:
        pop AX
        ret
endp

BUSCA_INTERACAO proc ; Cria pausas para ver se houve interacao no teclado
    push CX
    push DX
    
    xor CX, CX      ; Parte alta do tempo
    mov DX, [fps]   ; Parte baixa do tempo
    mov AH, 86h
    int 15h
    
    pop DX
    pop CX
    ret
endp

UINT16_TO_STRING proc
    push AX
    push BX
    push CX
    push DX
    
    mov BX, 10    
    xor CX, CX
    
    cmp AX, 10
    jnl LACO_DIGITO2
    
    cmp AX, 0
    je LACO_DIGITO2
    
    mov DL, '0'
    mov [DI], DL
    inc DI
    
  LACO_DIGITO2:    
    xor DX, DX         
    div BX
    
    push DX
       
    inc CX
    
    cmp AX, 0   
        
    jnz LACO_DIGITO2
                          
     
  LACO_ESCRITA2:                    
    pop DX
    add DL, '0'
    mov [DI], DL
    inc DI
    dec CX
    cmp CX, 0
    jnz LACO_ESCRITA2
          
          
    pop DX
    pop CX
    pop BX
    pop AX
       
    ret
endp

;Proc que diminui a quantidade de vidas na tela baseando-se 
;em vidas_qtd
DIMINUIR_VIDA proc
    push AX
    push BX
    push CX
    push DX
    push DI
    push ES
    
    mov AX, 0A000H
    mov ES, AX
    
    xor BX,BX
    xor AX,AX
    
    mov AL, vidas_qtd
    cmp AL, 0
    jz DIMINUIR_FIM ;se a quantidade de vidas = 0 entao pula
    
    dec AL ; 0..2
    mov vidas_qtd, AL ;atualiza qtd
    
    mov BL,AL ;BL usado como indice
    mov vidas[BX],0
    
    mov AL, vida_posicao_x[BX] ;DI = posicao atual da vida na tela
    mov DI,AX
    mov DX, 7 

DIMINUIR_VIDA_LOOP:
    mov CX,16
    mov AL,0
    rep stosb ;STOSB ESCREVE AL EM ES:DI, CX vezes
    
    add DI, 320-16
    dec DX
    jnz DIMINUIR_VIDA_LOOP
    
    
DIMINUIR_FIM:
    pop ES
    pop DI
    pop DX
    pop CX
    pop BX
    pop AX
    
    ret
endp

MOSTRAR_VIDAS proc
    push ax
    push bx
    push cx
    push dx
    push si

       
    xor  BX, BX
    xor AX,AX
    mov  CX, 3 ; tr?s vidas

DESENHAR_LOOP2:
      lea  si, vida  

    
      mov  AL, [vidas+bx]
      cmp  AX, 0
    je   PROXIMA_VIDA ; se destru?da, s? avan?a

   
    mov  AL, [vida_posicao_x+BX] ;vida_posicao_x = vetor de posicoes na tela de cada vida


    ;AX = posicao na tela
    ;SI = offset no .data do desenho da vida
    call DESENHA_7x16

PROXIMA_VIDA:
    inc  bx
    loop DESENHAR_LOOP2

    pop  si
    pop  dx
    pop  cx
    pop  bx
    pop  ax
    ret
endp


MOSTRAR_HEADER proc
   mov BP, offset frase_score 
   mov DH, 0
   mov DL, 0
   mov CX, score_tamanho 
   mov BL, 0FH ;0FH = cor branco
   call ESCREVE_STRING
   
   mov AX, pontos
   mov DI, OFFSET pontos_string
   call UINT16_TO_STRING
   
   mov BP, offset pontos_string
   mov DH,0
   mov DL, score_tamanho
   mov CX, tamanho_pontos_string
   mov BL, 02H ;cor verde escuro
   call ESCREVE_STRING
   
   call MOSTRAR_VIDAS
   
   mov BP, offset frase_tempo
   mov DH, 0
   mov DL, 32
   mov CX, tempo_tamanho
   mov BL, 0FH 
   call ESCREVE_STRING
   
   xor AX,AX
   mov AL, cronometro
   mov DI, offset cronometro_string
   call UINT16_TO_STRING
    
   mov BP, OFFSET cronometro_string
   mov DH, 0
   mov DL, 38
   mov CX, tamanho_cronometro_string
   mov BL, 02H
   call ESCREVE_STRING
   
   
  ret
endp
;ZERA_VARIAVIES_SETOR proc
;zera as naves aliens inimigas antes de entrar na proxima fase
ZERAR_ALIENS proc
    push AX
    push CX
    push DI
    push ES
    
    mov AX, @data
    mov ES,AX
    lea DI,posicoes_aliens
    mov CX, LENGTH posicoes_aliens 
    xor AX,AX
    cld ;garantindo DF = 0 (avan?ando )
    
    rep stosw ;escreve AX (0) em ES:DI, CX vezes
    
    pop ES
    pop DI
    pop CX
    pop AX
    ret

endp
;MOSTRA_SETOR proc
; setar qual tela esta (1,2,3)
INICIANDO_FASE proc
    mov qtd_alien,0 ;inimigas_vivas_setor
    mov qtd_meteoro,0 
    mov tiro_flag,0
    mov tiro_desloc, 0

    call ZERAR_ALIENS
    
    cmp estado,1
    je FASE_1
    
    ;cmp estado,2
    ;je FASE_1
    
   ; cmp estado,3
   ;je FASE_1
    
    
   ; xor AX,AX
   ;mov BX,30
   ;call CALCULA_BONUS_SETOR
   ;mov venceu, 1
   ;call VENCEU_PERDEU
FASE_1:
    
       mov qtd_alien,10 ;quantidade de aliens por fase  = mov naves_inimigas_restante_setor, naves_set1 
  
      call LIMPA_TELA
        mov DH, 10
        mov DL, 0
        mov BL, 0FH
        mov BP, offset arte_f1
        mov CX, tamanho_f1
        call ESCREVE_STRING
        
        call CARREGA_FASE
        mov pontos,0
        mov cronometro,tempo_fase
        
        mov nave_posicao,320*99 ;inicia nave no meio da tela
        
    ret
endp


JOGO proc                       ; Carrega a tela inicial do jogo (menu)
    call ESCREVE_TITULO
    call ESCREVE_BOTOES  
    call RESET_ALIEN_MENU  ;posiona nave alien em uma posicao aleatoria na tela
    call RESET_POSICOES_MENU;posiciona nave e meteoro nas extremidades
     
    MENU:
        call BUSCA_INTERACAO
        call INTERAGE_MENU
        call MENU_ANIMATION
        jne CONTINUA_LOOP
    
    CONTINUA_LOOP:
        call VERIFICA_OPCAO
        jmp MENU

    ret
endp

 
ESCREVE_TITULO proc ;prepara registradores pra executar o call print
    mov AX,DS
    mov ES,AX
    
    mov BP, offset arte_titulo
    mov CX, tamanho_arte
    mov BL, 02H ;representa a cor verde
    xor DX,DX ;zerando o registrador DX -> DH=linha/DL=coluna
    
    call ESCREVE_STRING      
    
    ret
endp 
    
ESCREVE_BOTOES proc
    push AX
    
    mov BL, 0FH ;cor
    mov AH, op_menu
    
    cmp AH, 1     
    
    jne INICIA_BTN
    mov BL, 0CH

    INICIA_BTN:
        mov BP, offset btn_jogar 
        mov CX, tamanho_jogar
        
        xor DL,DL ;coluna = 0 
        mov DH,18 ;linha = 18 
        call ESCREVE_STRING
        
        mov BL, 0FH
        mov AH, op_menu
        cmp AH, 0
        jne SAIR_BTN
        mov BL, 0CH
        
    SAIR_BTN:
       mov BP, offset btn_sair
       mov CX, tamanho_sair
       xor DL, DL ;colunha =0;
       mov DH, 21 ;linha
       call ESCREVE_STRING
       
   pop AX
   ret
endp 

REINICIA_FASE proc  ;RESET_SECTOR
    mov fase, 1
    
    ret
endp

;INT 1AH - CLOCK 00H - GET TIME OF DAY
;Obtem os valores do controlador do relogio
;do sistema.
SEED_FROM_TICKS proc  ;SYSTIME_SEED
    push AX
    push CX
    push DX
    mov  AH, 00h
    int  1Ah              ; CX:DX = ticks desde 00:00
    mov  seed, DX         
    pop  DX
    pop  CX
    pop  AX
    
    ret
endp


;proc que usa LCG para gerar um numero pseudoaleatorio de 16 bits sem sinal retornado em AX
RAND_16 proc
    
    mov AX,39541
    mul seed
    add AX, 16259
    mov seed,AX
    

    ret
endp

;proc que retorna um numero de 8 bit sem sinal em AL,
;AH = passado como parametro sendo o valor maximo,
;AL = retorno, entre 0 e AL
RAND_8 proc

   push BX
   push CX
   push DX
   push AX
   
   xor CX,CX
   mov CL,AH ;salva o max em CL
   
   call RAND_16; atualiza o seed e retorna UINT16 em AX
   
   xor DX,DX ;prepara DX para receber o resto DX = resto da divisao, entre 0...AH
   mov BX,CX
   div BX
   
   pop AX 
   
   mov AL,DL ;passa para AL o numero pseudoaleatorio
   
   pop DX
   pop CX
   pop BX

    ret
endp

;proc que reposiciona naves e objetos no menu inicial
RESET_POSICOES_MENU proc
    
    ;FORMULA BASICA DE POSICIONAMENTO NA TELA: LINHA * 320 + COLUNA.
    push AX   
    
    xor AX,AX ;zera antes 
    mov AX, 50*320 
    mov nave_posicao, AX ;posiciona a nave
     
    add AX, 291 ;vai ate o fim da linha onde vem o meteoro 
    add AX, 20*320  ;20 pixel pra baixo da nave, tem que multiplicar por 320 
    mov meteoro_posicao, AX  ;posiciona o meteoro
    
      
    pop AX
    
  ret
endp


;proc que redefine a posicao do alien no menu inicial
RESET_ALIEN_MENU proc
    
    push AX
    push DX
    push BX
    
    xor AX,AX
    mov AH, 133 ;AH = MAX
    
    call RAND_8 ; retorna um valor peseudoaleatorio em AL onde AL < AH
    cmp AL,90 ; se AL < 83 -> sendo 83 = 70 do inicio do meteoro + 13 altura do meteoro
    jae Y_OK 
    mov AL,90;come??a depois do meteoro
     
Y_OK:
    xor DX,DX
    mov DL,AL
    mov alien_y,DX ;passa altura minima para Y
    
    mov AH,255 ; max largura
    call RAND_8
    
    cmp AL,50 ;coluna minima 29
    jae X_OK
    mov AL,50
X_OK:
    xor DX,DX
    mov DL,AL
    mov alien_x,DX ;coluna minima para X
    
    
    mov BX,320 ;adiciona 320 que o maximo de deslocamento por linha
    
    mov AX,alien_y ; move o valor em alien_y para AX
    mul BX ;multiplica alien_y em AX para obter a linha correta, ja que a formula de deslocamento ? Y*320 + X
       
    add AX,alien_x
  
    mov alien_posicao, AX
    
    mov alien_direction,1

    

    pop BX
    pop DX
    pop AX
    
   ret
endp 


;proc que "limpa" 13x29 pixeis na posicao DI
;DI = POSICAO
LIMPA_13x29 proc;            
    push AX
    push CX
    push DI
    push ES
    
    mov AX, 0A000H
    mov ES, AX
    mov CX, 13

LIMPA_LINHA:
    push CX
    mov CX, 29
    xor AX, AX
    rep stosb
    add DI, 291
    pop CX
    loop LIMPA_LINHA

    pop ES
    pop DI
    pop CX
    pop AX
    ret

  ret
endp

;proc que desenha um elemento na tela utilizando rep movsb ;DS:SI -> ES:DI 
; AX = posicao atual do elemento
; SI = offset do elemento no DS
DESENHA proc
     push BX
     push CX
     push DX
     push DI
     push ES
     push DS
     push AX ;salva a posicao
      
     mov AX, @data
     mov DS, AX
     
     mov AX, 0A000H;SEGMENTO DE VIDEO
     mov ES, AX
     
     
     pop AX ;volta a posicao salva
     mov DI, AX
     MOV DX, 13 ;altura 13
     
     push AX
     
    LINHA_LOOP:
         mov CX, 29 ;largura 29
         rep movsb ;DS:SI -> ES:DI 
         add DI, 320-29  ;+320 avanca 1 linha - 29 para ir na posicao correta do inicio da nave
         
         dec DX ;terminou uma linha decrementa o contador de altura 
         jnz LINHA_LOOP 
         
    pop AX
    pop DS
    pop ES
    pop DI
    pop DX
    pop CX
    pop BX
     
    ret
endp

; AX = posicao atual do elemento
; SI = offset do elemento no DS
DESENHA_7x16 proc
     push BX
     push CX
     push DX
     push DI
     push ES
     push DS
     push AX ;salva a posicao
      
     mov AX, @data
     mov DS, AX
     
     mov AX, 0A000H;SEGMENTO DE VIDEO
     mov ES, AX
     
     
     pop AX ;volta a posicao salva
     mov DI, AX
     MOV DX, 7 ;altura
     
     push AX
     
 LINHA_LOOP2:
         mov CX, 16 ;largura
         rep movsb ;DS:SI -> ES:DI 
         add DI, 320-16  ;+320 avanca 1 linha - tamanho do elemento
         
         dec DX ;terminou uma linha decrementa o contador de altura 
         jnz LINHA_LOOP2 
         
    pop AX
    pop DS
    pop ES
    pop DI
    pop DX
    pop CX
    pop BX
     
    ret
endp


MENU_ANIMATION proc
    MOVE_NAVE:
        mov AX, nave_posicao
        mov DI, AX   
        
        call LIMPA_13x29; apaga 13x29 na posicao DI.
        
        cmp AX, 50*320+291 ;LINHA 70 + COLUNA = 291 compara se a nave chegou na borda direita
        je MOVE_METEORO
        
        inc nave_posicao ;move 1 pixel
        inc AX ;move tambem AX 1 pixel 
        
        mov SI, offset nave ;prepara SI para MOVSB Move de DS:SI -> ES:DI
        call DESENHA; RENDER_SPRITE
    
      
    
    MOVE_METEORO:
        mov AX, meteoro_posicao
        mov DI, AX;move a posicao do meteoro para DI
        
        cmp AX, 70*320 ;linha 70 = 50 da nave + 20 do reset posicoes
        
        
        je RESET_NAVE_METEORO
        
        call LIMPA_13x29; apaga 13x29 na posicao DI.
            
        ;meteoro vem pra direita    
        dec meteoro_posicao
        dec AX
        
        mov SI, offset meteoro
        call DESENHA; RENDER_SPRIT
        
        
      
     MOVE_ALIEN:
    
     mov DX,alien_direction
     cmp DX,1   
     jne ALIEN_DIREITA
     
        mov AX, alien_posicao
        mov DI, AX;move a posicao do meteoro para DI
        
        mov DX,alien_x 
        
        cmp DX,0 ;Chegou na borda da esquerda
        
        je RESET_ALIEN_DIRECTION
        
        call LIMPA_13x29; apaga 13x29 na posicao DI.
            
        ;alien vem pra esquerda    
        dec alien_posicao
        dec AX
        dec alien_x
        
        mov SI, offset alien
        call DESENHA; RENDER_SPRIT
        
        jmp END_POS_UPDATE
        
 ALIEN_DIREITA:
        mov AX, alien_posicao
        mov DI, AX;move a posicao do aliwn para DI
        mov DX,alien_x  
        ;push AX
        cmp DX,291 ;Chegou na borda da esquerda     
        ;pop AX     
        je RESET_ALIEN_DIRECTION_2
        
        call LIMPA_13x29; apaga 13x29 na posicao DI.
            
        ;alien vem pra direita    
        inc alien_posicao
        inc AX
        inc alien_x
        
        mov SI, offset alien
        call DESENHA; RENDER_SPRIT 
         jmp END_POS_UPDATE
    
  RESET_ALIEN_DIRECTION:
        mov alien_direction,2
        jmp END_POS_UPDATE
        
    RESET_ALIEN_DIRECTION_2:
        mov alien_direction,1
        jmp END_POS_UPDATE
        
  RESET_NAVE_METEORO:
        call LIMPA_13x29; apaga 13x29 na posicao DI.
        call RESET_POSICOES_MENU 
    
    END_POS_UPDATE:
      ret
endp


SLEEP_LENTO proc 
    push CX
    push DX
    push AX
          
    mov AX, 0          ; zera lixo em AX (opcional)
    mov CX, 0FH          ; parte alta -> 0x0007
    mov DX, 0A120H    ; parte baixa -> 0xA120
    ; 0x0007A120 = 500.000 ?s ? 0,5 segundo

    mov AH, 86h        ; BIOS wait
    int 15h

    pop AX
    pop DX
    pop CX
    ret
SLEEP_LENTO endp

; recebe em CX:DX o tempo de espera
SLEEP proc 
    push CX                 ;salva contexto
    push DX             
    push AX             
      
    xor CX, CX              ;zera CX, pois o tempo e definido por CX:DX
    mov DX, fps             ;espera
    mov AH, 86h             ;configura o modo de espera
    int 15h                 ;chama a espera no sistema
    
    pop AX
    pop DX
    pop CX
    ret
endp



MAIN:
    ;referencia o segmento de dados em ds
    mov AX, @data
    mov DS, AX
    
    ;referencia o segmento de memoria de video em ES
    mov AX, 0A000H
    mov ES, AX
    
    call SEED_FROM_TICKS
    
    ;inicia modo de video com 0A000H
    xor AH, AH
    mov AL, 13H
    int 10H
    
    ;call JOGO
    mov CX,3
    
TESTE:
    call MOSTRAR_HEADER
    call SLEEP_LENTO
    call DIMINUIR_VIDA
    loop TESTE

    
end MAIN