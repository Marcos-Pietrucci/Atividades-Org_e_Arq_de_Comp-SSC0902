org 100h

;index registers BX, SI, DI and BP 
;SI armazena indice do vetor 1
;DI armazena indice do vetor 2
;BX armazena indice do vetor Maior

LEA SI,Vetor1 ; OU MOV SI, 0    Comando LEA linka os registradores de index ao index da variavel
LEA DI,Vetor2 ; OU MOV DI, 0
LEA BX,VetorM ; OU MOV bx, 0
            
compara:    MOV  AH, [SI]        ; OU MOV  AH, Vetor1[SI]  
            MOV  AL, [DI]        ; OU MOV  AL, Vetor2[DI]
            INC  SI
            INC  DI
            CMP  AH, 0
            JZ   resultado       ;Se leu zero, acabar a comparacao
            CMP  AH, AL          ;AH-AL => Afeta flags
            JNLE v1Maior
            JMP  v2Maior

v1Maior:    INC  [QtdeV1]
            MOV  [BX], AH
            INC  BX
            JMP  compara
           
v2Maior:    INC  QtdeV2
            MOV  [BX], AL
            INC  BX
            JMP  compara            

resultado:  PUSHA
            MOV  CH, QtdeV1
            MOV  CL, QtdeV2
            CMP  CH,CL           ;CMP so funciona com valores em registradores
            JNLE msgV1 
            JMP  msgV2

msgV1:      MOV  DX, offset msg1
            JMP  print

msgV2:      MOV  DX, offset msg2            
                    
print:      MOV  AH, 9
            int  21h
            POPA
            RET
            

;Sao BYTES entao valores de 0-255
;Vou considerar que empates nunca acontecem (nao os tratei)

Vetor1 db 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 0 

Vetor2 db 15, 5, 35, 45, 55, 25, 35, 85, 95, 1, 0

QtdeV1 db 0

QtdeV2 db 0

msg1   db "Vetor1 ganhou a disputa$"

msg2   db "Vetor2 ganhou a disputa$" 

VetorM db 0

;Devo colocar no final para nao escrever em cima dos outros dados
;Nao existe "alocacao" dinamica em assembly, eh so eu literalmente colocar valores na memoria
;VetorM na realidade eh so o endereco inicial do VetorM



