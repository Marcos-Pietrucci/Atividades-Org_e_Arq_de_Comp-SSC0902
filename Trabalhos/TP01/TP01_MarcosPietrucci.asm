;TP01 Marcos Vinicius Firmino Pietrucci

;Consideracoes:

;   O sistema buscara por novas entradas a cada novo deslocamento de andar
;   O predio possui 8 andares (1 ao 8)


;---------- EXPLICACAO DE REGISTRADORES ------------------;
; SI armazena o indice das entradas (Endereco de memoria)
; DL armazena a quantidade de valores no vetor de entradas
                                                           
                                                           
                                                           
; ---------- EXPLICACAO DAS ENTRADAS ---------------------;

;  char ASCII  HEXA
;      
;   8 -> 56  -> 38 
;   
;   H -> 72  -> 68            


;  Entradas (decimal): 1  2  3  4  5  6  7  8    a  b  c  d  e  f  g  h

;  Seu codigo  (hexa): 31 32 33 34 35 36 37 38   61 62 63 64 65 66 67 68  

;----------------------------------------------------------;
            
org 100h
             
main_loop:  LEA SI,entradas
            MOV DL, 0
            CALL le_teclado
            CALL interpreta
mov_func:   CALL move_elevador
            JMP main_loop 
            RET
            
           
; ------ Funcao que le (polling) ----------;

le_teclado  PROC    
leitura:    MOV AH, 0       ;Le a entrada
            INT 16h         
                            
            MOV [SI], AL    ;Coloca a entrada no vetor de entradas

            
            INC SI
            INC DL
            
            
            CMP AL, 0Dh     ;Caso nao for o ENTER, continuar lendo
            JNZ leitura
            
            DEC SI          ;Desconsidera o ENTER
            DEC DL
            RET         
le_teclado  ENDP                       
                       
                       
; ----- Interpreta Entrada ----------------;

interpreta  PROC
            MOV CH, DL
            MOV CL, -1
            MOV BX, -1                   ;Aqui, BX sera o indice das entradas
            
entry_loop: INC BX
                
            CMP CH,0
            JE  return
            
            MOV AH,entradas[BX]         ;Move o caractere da posicao BX
                       
                       
  ;---- Entradas de 0 a 9 -----;                     
                            
            CMP AH, 38h                 ;As entradas de pessoas chamando o elevador sao os numeros (0->9)
            
            JNLE continua1
            CALL chama_andar                   
            JMP  continua2
 
  ;Devo testar agora pela falha de energia e pela parada
  ;Implementar SOS, lock e Open depois 
  
  ;-------- Entrada X --------;          
continua1:  CMP AH, 78H                 ;78h -> 120dec -> Tecla 'x'
            
            JNE  nao_acabou
            JMP  acabou_luz
                      
  ;------- Entrada p ---------;         ;A funcao da entrada p ira aguardar por 'P'
                             
nao_acabou: CMP AH, 70h                 ;70h -> 112dec -> Tecla 'p'
            
            JNE  nao_para
            CALL para_elev 

   
  ;----- Entradas de 'a' a 'h'                    
                             
nao_para:   CMP AH, 68h                 ;As entradas de andares (a->h) sao valores de 96->104
            
            JNLE continua2
            CALL manda_andar             ; Foi pedido o elevador em algum andar
                
            
   
continua2:  DEC CH
            
            CMP CH, 0
            JNLE entry_loop             
            
            RET
            
interpreta  ENDP

; ------------- chama_andar ---------------;
;Algum botao externo de andar foi pressionado 
;O elevador esta em AH            
chama_andar PROC
            PUSHA
            
            MOV AL, AH
            MOV AH, 0          
            MOV CL, 10h
            IDIV CL           ; AH = AX % 16
                              ; No caso, o resultado sera de 1 ate 8 
            
            MOV BL, AH
            MOV BH, 0
            
            OR  require_andar[BX], 1b ; Seta como 1 o andar no vetor de andares requeridos
            
            POPA
            RET
chama_andar ENDP                                

;--------------- Manda_andar ------------- ;
;Algum botao interno de andar foi pressionado
manda_andar PROC
            PUSHA
            
            MOV AL, AH
            MOV AH, 0          
            MOV CL, 10h
            IDIV CL           ; AH = AX % 16
                              ; No caso, o resultado sera de 1 ate 8 
            
            MOV BL, AH
            MOV BH, 0
            
            OR  destino_andar[BX], 1b ; Seta como 1 o andar no vetor de andares requeridos
            
            POPA
            RET
manda_andar ENDP

;------------- Para o elevador ------------;

para_elev   PROC
            PUSHA
    
bloqueado:  MOV AH, 0       ;Le a entrada
            INT 16h                  
            
            CMP AL, 50h     ;Caso nao for o 'P', continuar lendo
            JNZ bloqueado
            
            POPA
            RET    
para_elev   ENDP

; -------------- Acabou a luz ------------ ;   


acabou_luz  PROC
            LEA SI,entradas
            MOV CL, 0
            MOV andar_destino, 1
            MOV sem_pedidos, 1 
            MOV require_andar[1],0
            MOV require_andar[2],0
            MOV require_andar[3],0
            MOV require_andar[4],0
            MOV require_andar[5],0
            MOV require_andar[6],0
            MOV require_andar[7],0
            MOV require_andar[8],0
            MOV destino_andar[1],0
            MOV destino_andar[2],0
            MOV destino_andar[3],0
            MOV destino_andar[4],0
            MOV destino_andar[5],0
            MOV destino_andar[6],0
            MOV destino_andar[7],0
            MOV destino_andar[8],0   
            MOV AH, andar
            MOV CH, 1
            CMP CH, AH
            JE  return          ;Verifica se ja estou no 1 
dec_luz:    CALL print_desce
            DEC AH
            CMP CH,AH
            JNE dec_luz
            MOV andar, 1
            JMP mov_func
acabou_luz  ENDP     

; ------------ Move Elevador ------------ ;

move_elevador     PROC     
                  MOV CH, andar
                  
                  ;Testar se alguem quer entrar no elevador
                  MOV BH,0 
                  MOV BL,andar
                  MOV AH, require_andar[BX]
                  CMP AH, BL
                  OR  porta, AH      ; Caso alguem queira entrar neste andar
                  
                  ;Se alguem entrou (porta aberta) remover a solicitacao de entrada
                  CMP porta, 1
                  MOV BL, andar
                  MOV BH, 0
                  MOV require_andar[BX], 0
                  
                  ;Testar caso alguem queira para neste andar
                  MOV BH,0 
                  MOV BL,andar
                  MOV AH, destino_andar[BX]
                  CMP AH, BL
                  OR  porta, AH
                  
                  ;Se alguem saiu (porta aberta) remover a solicitacao de saida
                  CMP porta, 1
                  MOV BL, andar
                  MOV BH, 0
                  MOV destino_andar[BX], 0                                  
                  
                  ;Testar se o elevador deve ficar ocioso
                  MOV AH, sem_pedidos
                  CMP AH, 1
                  JE  busca_destino_ant  
                  
                  
                  ;Testar se estou no andar destino
                  MOV AH, andar
                  MOV AL, andar_destino
                  CMP AH, AL
                  JNE continua3
                  OR porta, 1b                          
                  
                  MOV BL, AH
                  MOV BH, 0
                  MOV destino_andar[BX], 0
                                         
                  ;Caso estiver no destino, devo buscar um novo destino
                  ;Procura destino nos botoes internos
busca_destino_ant:MOV DI, 0
busca_destino:    INC DI
                  CMP DI, 9
                  JG  busca_destino2
                  MOV CL, destino_andar[DI]
                  CMP CL, 1
                  JE  set_destino
                  JNE  busca_destino
                
                  ;Busca um destino nos botoes externos 
busca_destino2:   MOV DI, -1
loop_destino2:    INC DI
                  CMP DI, 9
                  JG  sem_destino
                  MOV CL, require_andar[DI]
                  CMP CL, 1
                  JE  set_destino
                  JNE  loop_destino2
                  
                  
                  ;Nao importa qual a origem do destino, o andar vai ser o DI
set_destino:      MOV sem_pedidos, 0
                  MOV BX, DI
                  MOV BH, 0
                  MOV andar_destino, BL                                 
                  JMP continua3    
                                      
sem_destino:      MOV andar_destino, 1           ;Se nao ha requisicoes, o elevador vai para o terreo
                  MOV sem_pedidos, 1
                                                      
continua3:        CMP sem_pedidos, 1
                  JE  ocioso
continua4:        MOV CL, andar
                  CMP CL, andar_destino
                  JL  jmp_sobe  
                  CALL elevador_desce
                  JMP fim_move
                  
jmp_sobe:         CALL elevador_sobe         
                  JMP fim_move
                  
ocioso:           CMP  andar, 1
                  JNE  continua4
                  CALL elevador_parado

fim_move:     RET    
move_elevador ENDP  


;--------- O elevador vai subir 1 andar ---;

elevador_sobe     PROC
                  
                  MOV BL, andar
                  INC BL
                  MOV andar, BL
                  
                  CALL print_sobe
                  RET
elevador_sobe     ENDP
               
;-------- O elevador vai descer 1 andar ---;
elevador_desce     PROC
                   MOV BL, andar
                   DEC BL
                   MOV andar, BL
                   CALL print_desce 
                    
                   RET
elevador_desce     ENDP

;-------- O elevador fica parado no andar 1 ;

elevador_parado    PROC
                   CALL print_parado
                    
                   RET
elevador_parado    ENDP




;-------- Print da MSG de descendo --------;            
print_desce  PROC
             PUSHA
             MOV AH, 9h 
             
             CMP porta, 1
             JNE continua_desce
             MOV DX, offset msg_porta_aberta
             INT 21h
             CALL print_pulalin
             MOV DX, offset msg_porta_fechada
             INT 21h
             MOV porta, 0
             
continua_desce:CALL print_pulalin
               CALL print_pulalin
               MOV DX, offset descendo
               INT 21h
               MOV DX, offset pulalin
               INT 21h
                    
fim_desce:    POPA  
              RET
print_desce   ENDP   
                                          
;-------- Print da MSG de subindo ---------;                                          
print_sobe   PROC
             PUSHA
             MOV AH, 9h 
             
             CMP porta, 1
             JNE continua_sobe
             MOV DX, offset msg_porta_aberta
             INT 21h
             CALL print_pulalin
             MOV DX, offset msg_porta_fechada
             INT 21h
             MOV porta, 0
             
continua_sobe: CALL print_pulalin
               CALL print_pulalin
               MOV DX, offset subindo
               INT 21h
               MOV DX, offset pulalin
               INT 21h
                    
fim_sobe:    POPA  
             RET
print_sobe   ENDP
 
;-------- Print da MSG de parado --------;            
print_parado PROC
             PUSHA
             MOV AH, 9h 
             CALL print_pulalin
             CALL print_pulalin
             MOV DX, offset msg_parado
             INT 21h
            
             POPA  
             RET
print_parado ENDP   
                             
 
 
 
;-------- Print do pula linha -------------;
print_pulalin PROC
              MOV AH, 9h
              MOV DX, offset pulalin
              INT 21h   
              RET
print_pulalin ENDP


;------ Instrucoes de proposito geral ------;

return: RET 


;Definindo as variaveis
msg_porta_aberta db "A porta foi aberta$"
msg_porta_fechada db "A porta foi fechada$"
msg_parado db "O elevador esta parado no primeiro andar$"
descendo db "O elevador desceu 1 andar$"
subindo  db "O elevador subiu 1 andar$"
pulalin db 0Dh,0Ah,'$'

; FLAGS do elevador

terreo  DB 0
topo    DB 0
porta   DB 0    ;0 para fechada, 1 para aberta

andar_destino DB 1     ;Inicialmente o elevador comeca sem pedidos
sem_pedidos   DB 1
                       
andar   DB 1

require_andar DB 0, 0, 0, 0, 0, 0, 0, 0, 0     ;Botoes externos
destino_andar DB 0, 0, 0, 0, 0, 0, 0, 0, 0     ;Botoes internos 

entradas db 0 
