
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

    ORG 100h
                    
;   Code  CS:0700h IP: 0100h
;   Data  DS:0700h AX,BX,CX,DX
;   Stack SS:0700h SP: FFFEh  

;   Criptografia: 
;   Ler do TECLADO uma string de texto, e armazenar a string na memoria em TEXTO
;   Criptografar com a "cifra de Cesar" (soma +1 ao codigo ASCII do texto)
;   Exibir o texto criptografado na tela 
    
       
Inicio: 
    MOV  CX,0            ; Contador: Nro. de Caracteres Lidos
    MOV  BX,TEXTO        ; BX <= Endereco de Texto (onde vai guardar a string)

ProxChar:    
    MOV  AH,0
    INT  16h             ; Le tecla (readkey) - Int 16h BIOS

    MOV  [BX],AL         ; Salva no endereco apontado por BX (Texto)
    INC  BX              ; Avanca BX para o proximo endereco
    
    MOV  AH,0Eh          ; Escreve Echo na tela (AL: Char) - Int 10h BIOS
    INT  10h                                                             
    
    CMP  AL,0Dh          ; Compara Tecla com 0Dh (Enter)
    JNZ  ProxChar
                                                
    DEC  BX              ; Despreza o ultimo caracter salvo (0Dh - "Enter")
    MOV  [BX],0h         ; Marca de "fim de string" ('\0') 
      
       
; Uma vez lida a String de Texto, realiza a criptografia com a cifra de Cesar

       
    MOV  BX,TEXTO        ; BX <= Endereco de Texto (onde esta guardada a string)       
    MOV  CX,CRIPTO
Repete:
    MOV  AL,[BX]         ; Obtem o caracter apontado por BX (AL = *Texto)
    INC  AL              ; Soma 1 no codigo ASCII do caracter
    
    PUSH BX              ; Salva BX
    MOV  BX,CX           ; Endereco de destino: CX (move para BX) 
    MOV  [BX],AL         ; Salva caracter cifrado no end. de destino (*Cripto = AL)
    POP  BX              ; Recupera BX
    
    INC  BX              ; Texto++  (ponteiro Texto  avanca para prox. byte)
    INC  CX              ; Cripto++ (ponteiro Cripto avanca para prox. byte)
    CMP  [BX],0          ; Chegou no final da string? ('\0')
    JNZ  Repete         
            
    MOV  BX,CX
    MOV  [BX],'$'        ; Coloca a marca de fim de string (BDOS => '$')
      
      
; Uma vez criada a String de Texto criptografada, exibe na tela (Int21h)        
                  
                  
Exibe:         
    MOV  DX,PULALIN
    MOV  AH,09h
    INT  21h

PrintMsg:                 
    MOV  DX,CRIPTO 
    MOV  AH,09h       ; Int 21h AH=09h - Print Char BDOS
    INT  21h    
    
Fim:
    NOP
    RET     
         

TEXTO:  DB "Espaco reservado para armazenar a string a ser lida do teclado"
        DB ".............................................................."
        DB ".............................................................#"
        DB 0h
       
CRIPTO: DB "Espaco reservado para armazenar a string a ser criptografada.."
        DB ".............................................................."
        DB ".............................................................$"
        DB 0h  
        
PULALIN: DB 0Dh,0Ah,'$'   ; Pula para proxima linha (CR + LF)
                   
; Fim do Codigo 

