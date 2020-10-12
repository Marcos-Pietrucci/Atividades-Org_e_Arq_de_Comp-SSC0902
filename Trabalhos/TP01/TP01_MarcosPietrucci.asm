;TP01 Marcos Vinicius Firmino Pietrucci

;Consideracoes:

;   O sistema buscara por novas entradas a cada novo deslocamento de andar
;   O predio possui 8 andares (1 ao 8)
;

org 100h

inicio:     call  acabou_luz
            MOV AH, 9h
            MOV DX, offset teste
            INT 21h
            ret
            

acabou_luz: MOV AH, andar
            MOV CH, 1
            CMP CH, AH
            JE  return
dec_luz:    CALL print_desce
            DEC AH
            CMP CH,AH
            JE  return     
            JMP dec_luz
            
            
print_desce: PUSHA
             MOV AH, 9h
             MOV DX, offset descendo
             INT 21h
             MOV DX, offset pulalin
             INT 21h
             POPA
             JMP return


return:     ret


;Definindo as variaveis

;   Terreo, Topo, Status Porta, Presenca porta
flags DB  0, 0, 0, 0                        

andar DB 4

descendo db "O elevador desceu 1 andar$"
teste    db "Isto eh um teste$" 

pulalin: db 0Dh,0Ah,'$'

