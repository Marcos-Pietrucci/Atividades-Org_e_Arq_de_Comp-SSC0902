#TP02 Marcos Vinícius Firmino Pietrucci

# Endereços mapeados em memória
#CONS_RECEIVER_CONTROL           =   0xffff0000
#CONS_RECEIVER_DATA              =   0xffff0004

# Código param manipular valores na STACK
#sub $sp, $sp, 8 
#sw $t1, 4($sp) 
#sw $t2, 0($sp)

    .text
main:
	jal esperar_key
	
			
	j fim
	
esperar_key:	
	#MMIO - Leitura de teclas mapeadas em memória
	lw $t1, 0xffff0000
	andi $t1, $t1, 0x00000001
	beqz $t1, esperar_key
	
	lbu $s2, 0xffff0004 #Carrega a tecla em s2
	
	#Caso tenha entrado um ENTER, sair do loop
	la $a1, msg1
	bne $s2, '\n', tratar_entrada
	jr $ra
	j esperar_key

tratar_entrada:
	#39 é o código ascii em hexa para '9'
	li $t1, 0x39
	ble $s2, $t1, entrada_numero
	j outra_entrada

entrada_numero:	

	la $s1, pedidos_externos
	
	sub $t1, $s2, 0x30 	# Coloca em t1 o número digitado
	mul $t1, $t1, 1		# Calcula o deslocamento (índice) correspondente à entrada
	add $s1, $s1, $t1	# Avança no vetor de pedidos externos 
	li $t1, 1
	sb $t1, 0($s1)	# Armazena 1 na posição do andar externo pedido
	j esperar_key

outra_entrada:
	
# Entradas internas no E1
	la $s1, pedidos_internos_e1
	
	bne $s2, 'q', continua1
	li $a1, 1
	j insere_pedidoInterno	
		
continua1:
	bne $s2, 'w', continua2
	li $a1, 2
	j insere_pedidoInterno
	
continua2:
	bne $s2, 'e', continua3
	li $a1, 3
	j insere_pedidoInterno

continua3:	
	bne $s2, 'r', continua4
	li $a1, 4
	j insere_pedidoInterno

continua4:
	bne $s2, 't', continua5
	li $a1, 5
	j insere_pedidoInterno

continua5:	
	bne $s2, 'y', continua6
	li $a1, 6
	j insere_pedidoInterno
	
continua6:	
	bne $s2, 'u', continua7
	li $a1, 7
	j insere_pedidoInterno

continua7:	
	bne $s2, 'i', continua8
	li $a1, 8
	j insere_pedidoInterno

#Entradas internas do elevador 2
continua8:

	la $s1, pedidos_internos_e2
	bne $s2, 'a', continua9
	li $a1, 1
	j insere_pedidoInterno	
		
continua9:
	bne $s2, 's', continua10
	li $a1, 2
	j insere_pedidoInterno

continua10:
	bne $s2, 'd', continua11
	li $a1, 3
	j insere_pedidoInterno

continua11:
	bne $s2, 'f', continua12
	li $a1, 4
	j insere_pedidoInterno

continua12:
	bne $s2, 'g', continua13
	li $a1, 5
	j insere_pedidoInterno

continua13:
	bne $s2, 'h', continua14
	li $a1, 6
	j insere_pedidoInterno

continua14:
	bne $s2, 'j', continua15
	li $a1, 7
	j insere_pedidoInterno

continua15:
	bne $s2, 'k', continua16
	li $a1, 8
	j insere_pedidoInterno
	
continua16:
	bne $s2, 'z', continua17
	li $t1, 0
	sw $t1, estado_e1
	j esperar_key
	
continua17:
	bne $s2, 'c', continua18
	li $t1, 0
	sw $t1, estado_e2
	j esperar_key
	
continua18:
	bne $s2, 'x', continua19
	li $t1, 1
	sw $t1, estado_e1
	j esperar_key

continua19:
	bne $s2, 'v', continua19
	li $t1, 1
	sw $t1, estado_e2
	j esperar_key
	
insere_pedidoInterno:
	#O índice do pedido está em $a1
	move $t3, $s1      # Copia o endereço do vetor de pedido interno para T3
	mul $t2, $a1, 1    # Calcula o deslocamento (índice) correspondente à entrada
	add $t3, $t3, $t2  # Avança no vetor
	li $t2, 1	   
	sw $t2, 0($t3)
	j esperar_key
	
print_msg:
	#Printa a mensagem contida em $a1
	li $v0, 4       
        move $a0, $a1 
        syscall 
		
	jr $ra

fim:
	nop

    .data
msg1:   .asciiz "Pressionou Enter"
msg2:   .asciiz "Puro teste"
pulalin: .asciiz "\n"

pedidos_externos:    .byte 0, 0, 0, 0, 0, 0, 0, 0  #Manipilar com sb e lb
pedidos_internos_e1: .byte 0, 0, 0, 0, 0, 0, 0, 0
pedidos_internos_e2: .byte 0, 0, 0, 0, 0, 0, 0, 0
destino_e1: .word 0
destino_e2: .word 0
estado_e1:  .word 1
estado_e2:  .word 1

entradas: .word 0
