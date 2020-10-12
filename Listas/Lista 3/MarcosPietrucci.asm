org 100h


;SI armazena indice do vetor 1
;DI armazena indice do vetor 2
;BX armazena indice do vetor Maior

lea SI,Vetor1
lea DI,Vetor2
lea BX,VetorM


compara:    MOV  AH, [SI]
            MOV  AL, [DI]
            INC  SI
            INC  DI
            CMP  AH, 0
            JZ   resultado       ;Se leu zero, acabar a comparacao
            CMP  AH, AL          ;AH-AL => Afeta flags
            JNLE v1Maior
            JMP  v2Maior

v1Maior:    MOV  DH, QtdeV1
            INC  DH
            MOV  QtdeV1, DH
            MOV  [BX], AH
            INC  BX
            JMP  compara
           
v2Maior:    MOV  DH, QtdeV2
            INC  DH
            MOV  QtdeV2, DH
            MOV  [BX], AL
            INC  BX
            JMP  compara            

resultado:  PUSHA
            MOV  CH, QtdeV1
            MOV  CL, QtdeV2
            CMP  CH, CL
            JNLE msgV1 
            JMP  msgV2

msgV1:      MOV  DX, offset msg1
            JMP  print

msgV2:      MOV DX, offset msg2            
           
print:      MOV  AH, 9
            int 21h
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




