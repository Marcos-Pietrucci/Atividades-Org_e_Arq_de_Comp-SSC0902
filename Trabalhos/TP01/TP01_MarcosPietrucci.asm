;TP01 Marcos Vinicius Firmino Pietrucci

;Consideracoes:

;   O sistema buscara por novas entradas a cada novo deslocamento de andar
;   O predio possui 8 andares (1 ao 8)


;---------------- REGISTRADORES --------------------------;
; SI armazena o indice das entradas (Endereco de memoria)
; DL armazena a quantidade de valores no vetor de entradas
                                                           
                                                           
                                                           
; ---------- EXPLICACAO DAS ENTRADAS ---------------------;

;  Entradas (decimal): 1  2  3  4  5  6  7  8    a  b  c  d  e  f  g  h

;  Seu codigo  (hexa): 31 32 33 34 35 36 37 38   61 62 63 64 65 66 67 68  

;----------------------------------------------------------;
            
org 100h
             
main_loop:      LEA SI,entradas
                MOV DL, 0
                CALL le_teclado
                CALL interpreta
mov_func:       CMP energia, 1
                JE  continua_loop
                MOV energia, 1
                JMP main_loop            
continua_loop:  CALL move_elevador
                CALL painel_de_controle
                JMP main_loop 
                RET
            
           
; ------ Funcao que le (polling) ----------;

le_teclado      PROC    
leitura:        MOV AH, 0       ;Le a entrada
                INT 16h         
                            
                MOV [SI], AL    ;Coloca a entrada no vetor de entradas

            
                INC SI
                INC DL
            
            
                CMP AL, 0Dh     ;Caso nao for o ENTER, continuar lendo
                JNZ leitura
            
                DEC SI          ;Desconsidera o ENTER
                DEC DL
                RET         
le_teclado      ENDP                       
                       
                       
; ----- Interpreta Entrada ----------------;

interpreta      PROC
                MOV CH, DL
                MOV CL, -1
                MOV BX, -1                   ;Aqui, BX sera o indice das entradas
            
entry_loop:     INC BX
                    
                CMP CH,0
                JE  return
            
                MOV AH,entradas[BX]         ;Move o caractere da posicao BX
                       
                       
                ;---- Entradas de 0 a 9 -----;                     
                            
                CMP AH, 38h                 ;As entradas de pessoas chamando o elevador sao os numeros (0->9)
            
                JNLE continua1
                CALL chama_andar                   
                JMP  continua2
 
                ;-------- Entrada X --------;          
continua1:      CMP AH, 78h                 ;78h -> 120dec -> Tecla 'x'
            
                JNE  nao_acabou
                JMP  acabou_luz
                      
                ;------- Entrada p ---------;         ;A funcao da entrada p ira aguardar por 'P'
                             
nao_acabou:     CMP AH, 70h                 ;70h -> 112dec -> Tecla 'p'
            
                JNE  nao_para
                CALL para_elev 
            
            
                ;------- Entrada s ---------;         ;A porta fica aberta ate inserir 's' novamente            
nao_para:       CMP AH, 73h                  ;73h -> 115dec -> Tecla 's'

                JNE  nao_obstruiu                                                                          
                NOT  sensor_obstr 
       
                ;----- Entradas de 'a' a 'h'                    
                             
nao_obstruiu:   CMP AH, 68h                 ;As entradas de andares (a->h) sao valores de 96->104
            
                JNLE continua2
                CALL manda_andar             ; Foi pedido o elevador em algum andar
                
continua2:      DEC CH
            
                CMP CH, 0
                JNLE entry_loop             
            
                RET
interpreta      ENDP

; ------------- chama_andar ---------------;
;Algum botao externo de andar foi pressionado 
;O elevador esta em AH            
chama_andar     PROC
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
chama_andar     ENDP                                

;--------------- Manda_andar ------------- ;
;Algum botao interno de andar foi pressionado
manda_andar     PROC
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
manda_andar     ENDP

;------------- PARA o elevador ------------;
;O botao 'p' foi pressionado
para_elev       PROC
                PUSHA
            
bloqueado:      CALL print_pulalin
                CALL print_pulalin
                MOV AH, 09h
                MOV DX, offset msg_pause 
                INT 21h
            
                CALL painel_de_controle
                MOV AH, 0       ;Le a entrada
                INT 16h                  
            
                CMP AL, 50h     ;Caso nao for o 'P', continuar lendo
                JNZ bloqueado
            
                POPA
                RET    
para_elev       ENDP

; -------------- Acabou a luz ------------ ;   
    
acabou_luz      PROC
                CALL print_pulalin
                CALL print_pulalin
                MOV AH,09h
                MOV DX, offset pane
                INT 21h
                CALL print_pulalin
                LEA SI,entradas
                MOV DL, 0
                MOV energia, 0
                MOV sensor_obstr, 0
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
                CMP andar, 1
                JE  mov_func          ;Verifica se ja estou no 1 
dec_luz:        CALL elevador_desce
                CALL painel_de_controle
           
                DEC AH
                CMP CH,AH
                JNE dec_luz
                MOV andar, 1
                JMP mov_func
            
acabou_luz      ENDP     

; ------------ Move Elevador ------------ ;
; Realiza todos os movimentos
move_elevador     PROC     
                  MOV CH, andar
                                   
                  ;Testar se alguem quer entrar no elevador
                  MOV BH,0 
                  MOV BL,andar
                  MOV AH, require_andar[BX]
                  OR  porta, AH      ; Caso alguem queira entrar neste andar
                  
                  ;Se alguem entrou (porta aberta) remover a solicitacao de entrada
                  MOV require_andar[BX], 0
                  
                  ;Testar caso alguem queira parar neste andar
                  MOV AH, destino_andar[BX]
                  OR  porta, AH
                  
                  ;Se alguem saiu (porta aberta) remover a solicitacao de saida
                  MOV destino_andar[BX], 0                                  
                  
                  ;Feito a carga e descarga, impedir qualquer movimento caso esteja obstruido
                  CMP sensor_obstr, 0FFh
                  JNE continua_mov
                  CALL print_porta_obstr
                  RET
                  
                  ;Testar se o elevador deve ficar ocioso
continua_mov:     CMP sem_pedidos, 1
                  JE  busca_destino_ant  
                  
                  ;Testar se estou no andar destino
                  MOV BH, andar
                  CMP BH, andar_destino
                  JNE continua3
                  OR porta, 1b                          
                                           
                  ;Caso estiver no destino, devo buscar um novo destino
                  ;Procura destino nos botoes internos
busca_destino_ant:MOV DI, 0
busca_destino:    INC DI
                  CMP DI, 9
                  JG  busca_destino2 
                  CMP destino_andar[DI], 1
                  JE  set_destino
                  JNE  busca_destino
                
                  ;Busca um destino nos botoes externos 
busca_destino2:   MOV DI, 0
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

fim_move:         RET    
move_elevador     ENDP  

;--------- O elevador vai subir 1 andar ---;

elevador_sobe     PROC
                  PUSHA
                  MOV BL, andar
                  INC BL
                  MOV andar, BL
                  CALL print_sobe
                  POPA
                  RET
elevador_sobe     ENDP
               
;-------- O elevador vai descer 1 andar ---;
elevador_desce    PROC
                  PUSHA
                  MOV BL, andar
                  DEC BL
                  MOV andar, BL
                  CALL print_desce 
                  POPA 
                  RET
elevador_desce    ENDP

;-------- O elevador fica parado no andar 1 ;

elevador_parado   PROC
                  CALL print_parado
                   
                  RET
elevador_parado   ENDP




;-------- Print da MSG de descendo --------;            
print_desce       PROC
                  PUSHA
                
                  MOV AH, 9h
                  CALL print_pulalin 
                  CALL print_pulalin
                  CMP porta, 0
                  JE continua_desce
                  CMP energia, 0
                  JE fecha_apenas
                  MOV DX, offset msg_porta_aberta
                  INT 21h
                  CALL print_pulalin
fecha_apenas:     MOV DX, offset msg_porta_fechada
                  INT 21h
                  MOV porta, 0
             
continua_desce:   CALL print_pulalin
                  CALL print_pulalin
                  MOV DX, offset descendo
                  INT 21h
                  MOV DX, offset pulalin
                  INT 21h
                    
fim_desce:        POPA  
                  RET
print_desce       ENDP   
                                          
;-------- Print da MSG de subindo ---------;                                          
print_sobe        PROC
                  PUSHA
               
                  MOV AH, 9h
                  CALL print_pulalin 
                  CALL print_pulalin
                  CMP porta, 1
                  JNE continua_sobe
                  MOV DX, offset msg_porta_aberta
                  INT 21h
                  CALL print_pulalin
                  MOV DX, offset msg_porta_fechada
                  INT 21h
                  MOV porta, 0
             
continua_sobe:    CALL print_pulalin
                  CALL print_pulalin
                  MOV DX, offset subindo
                  INT 21h
                  MOV DX, offset pulalin
                  INT 21h
                    
fim_sobe:         POPA  
                  RET
print_sobe        ENDP
 
;-------- Print da MSG de parado --------;            
print_parado      PROC
                  PUSHA
              
                  CALL print_pulalin
                  CALL print_pulalin
                  MOV AH, 9h
                  MOV DX, offset msg_parado
                  INT 21h
            
                  POPA  
                  RET
print_parado      ENDP   


;-------- Print sobre a porta estar aberta ;

print_porta_obstr PROC
             
                  PUSHA
                  CALL print_pulalin
                  CALL print_pulalin
                  MOV DX, offset msg_porta_aberta
                  INT 21h
                  CALL print_pulalin
                  MOV DX, offset msg_porta_travada
                  INT 21h
             
                  POPA
                  RET
print_porta_obstr ENDP                            
 
 
 
;-------- Print do pula linha -------------;
print_pulalin     PROC
                  
                  MOV AH, 9h
                  MOV DX, offset pulalin
                  INT 21h   
                  RET
                  
print_pulalin     ENDP


;-------- Painel de controle --------------;

painel_de_controle    PROC
                    
                      PUSHA
                      
                      ;Imprimir o titulo
                      CALL print_pulalin
                      CALL print_pulalin
                      CALL print_pulalin
                      MOV AH,9h
                      MOV DX, offset titulo                 
                      INT 21h
                      CALL print_pulalin
                      ;---------------------------------;
                    
                      ;Escreve o andar atual, seja ele '?' ou um numero; 
                      MOV CL, andar
                      ADD CL, 48 
                      CMP energia, 1
                      JE  escreve_andar
                      CMP andar, 1
                      JE  escreve_andar
                      MOV andar_atual[25], '?'
                      MOV DX, offset andar_atual
                      JMP escreve_andar2
                
escreve_andar:        MOV andar_atual[25], CL
                      MOV DX, offset andar_atual
escreve_andar2:       INT 21h
                      
                      CMP andar, 1
                      JE  imprime_terreo
                      CMP andar, 8
                      JE  imprime_topo
                      
                      JMP contiua_imp
                      
imprime_terreo:       MOV DX, offset msg_terreo
                      INT 21h
                      JMP contiua_imp
imprime_topo:         MOV DX, offset msg_topo
                      INT 21h                        
                      ;---------------------------------;
                      
                      ;Escreve o andar destino
contiua_imp:          CALL print_pulalin
                      MOV CH, andar_destino
                      ADD CH, 48
                      MOV txt_andar_destino[15], CH
                      MOV DX, offset txt_andar_destino
                      INT 21h
                      ;---------------------------------;                                                               
                      
                      ;Escreve o status da porta                
                      CALL print_pulalin                
                      MOV DX, offset status_porta
                      INT 21h                                
                      CMP sensor_obstr, 0
                      JE porta_fechada
                      MOV DX, offset msg_status_porta_open
                      JMP escreve 
porta_fechada:        MOV DX, offset msg_status_porta_close
escreve:              INT 21h                                ; Imprime o status da porta 
                      ;---------------------------------;
                     
                      ;Escreve o status do sensor da porta
                      CALL print_pulalin
                      MOV DX, offset sensor
                      INT 21h                                ;Imprime o status do sensor da porta
                      CMP sensor_obstr, 0
                      JE porta_livre
                      MOV DX, offset msg_sensor_on
                      JMP escreve2 
porta_livre:          MOV DX, offset msg_sensor_off
escreve2:             INT 21h
                      ;---------------------------------;
                    
                      ;Escreve o numero dos pedidos
                      CALL print_pulalin
                      CALL cont_pedidos_internos             ; O numero de pedidos internos esta em CH
                      CALL cont_pedidos_externos             ; O numero de pedidos externos esta em CL                
                      MOV AH, 9h
                
                      ADD CL, 48
                      ADD CH, 48
                      MOV reqs_ext[18], CL
                      MOV reqs_int[18], CH
                    
                      MOV DX, offset reqs_ext
                      INT 21h
                      CALL print_pulalin
                      MOV DX, offset reqs_int
                      INT 21h
                      ;---------------------------------;
                    
                      ;Escreve a lista de comandos
                      CALL print_pulalin
                      MOV DX, offset comandos
                      INT 21h            
                      CALL print_pulalin
                      MOV DX, offset C1
                      INT 21h
                      CALL print_pulalin
                      MOV DX, offset C2
                      INT 21h
                      CALL print_pulalin
                      MOV DX, offset C3
                      INT 21h
                      CALL print_pulalin
                      MOV DX, offset C4
                      INT 21h
                      CALL print_pulalin
                      MOV DX, offset C5
                      INT 21h       
                      ;---------------------------------;
                    
                      POPA   
                      RET
painel_de_controle    ENDP                               
;------ Conta pedidos internos    ----------;

cont_pedidos_internos PROC
               
                      MOV BX, -1
                      MOV CH, 0
loop_pedidos:         INC BX
                      CMP BX, 9
                      JE  return
                      CMP destino_andar[BX], 1
                      JNE loop_pedidos
                      INC CH
                      JMP loop_pedidos
               
                      RET
cont_pedidos_internos ENDP

;------ Conta pedidos externos    ----------;

cont_pedidos_externos PROC
                     
                      MOV BX, -1
                      MOV CL, 0
loop_pedidos2:        INC BX
                      CMP BX, 9
                      JE  return
                      CMP require_andar[BX], 1
                      JNE loop_pedidos2
                      INC CL
                      JMP loop_pedidos2
               
                      RET
cont_pedidos_externos ENDP

;------ Instrucoes de proposito geral ------;

return: RET 


;------------------- VARIAVEIS ----------------------;

; ---------- Prints e painel de controle ----------;

titulo                   DB "-----Status atual do elevador------$"
andar_atual              DB "Andar atual do elevador:  $"
txt_andar_destino            DB "Andar destino:  $"
status_porta             DB "Status da porta: $"
sensor                   DB "Sensor de presenca: $"
reqs_ext                 DB "Pedidos externos:  $"
reqs_int                 DB "Pedidos internos:  $"
comandos                 DB "Comandos: $"
C1                       DB "- 1 ao 8 sao botoes EXTERNOS$"
C2                       DB "- 'a' ao 'h' sao botoes INTERNOS$"
C3                       DB "- 'x' indica falha de energia$"
C4                       DB "- 'p' e 'P' pausam e despausam (respectivamente) o elevador$"
C5                       DB "- 's' indica que a porta esta obstruida$"
msg_status_porta_open    DB "Aberta$"
msg_status_porta_close   DB "Fechada$"
msg_sensor_on            DB "Ativado$"
msg_sensor_off           DB "Desativado$"
msg_terreo               DB " (Terreo)$"
msg_topo                 DB " (Topo)$"

;--------------------------------------------------;

; --------- Prints informativos gerais ------------;
pane                     DB "!!!QUEDA DE ENERGIA!!!$"
msg_pause                DB "O botao de PARAR foi pressionado$"
msg_porta_aberta         DB "A porta foi aberta$"
msg_porta_fechada        DB "A porta foi fechada$"
msg_parado               DB "O elevador esta parado no primeiro andar$"
descendo                 DB "O elevador desceu 1 andar$"
subindo                  DB "O elevador subiu 1 andar$"
msg_porta_travada        DB "A porta esta obstruida, aguarde a desobstrucao para poder continuar$"
pulalin                  DB 0Dh,0Ah,'$'
;--------------------------------------------------;

; ----------- FLAGS do elevador -------------------;

terreo                   DB 0   ;indica se estou no terreo ou nao
topo                     DB 0   ;indica se estou no topo ou nao
porta                    DB 0   ;0 para fechada, 1 para aberta
sensor_obstr             DB 0   ;Indica se a porta esta obstruida

andar_destino            DB 1   ;Inicialmente o elevador comeca sem pedidos
sem_pedidos              DB 1
energia                  DB 1   ;Indica se a energia esta ligada ou nao
                       
andar                    DB 1

require_andar            DB 0, 0, 0, 0, 0, 0, 0, 0, 0     ;Botoes externos
destino_andar            DB 0, 0, 0, 0, 0, 0, 0, 0, 0     ;Botoes internos 

entradas                 DB 0
