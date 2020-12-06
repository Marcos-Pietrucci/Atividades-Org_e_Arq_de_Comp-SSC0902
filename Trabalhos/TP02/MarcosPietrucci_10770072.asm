# TP02 Marcos Vin�cius Firmino Pietrucci
#      10770072

#       Deletar o arquivo antes de iniciar o programa!!
# 	Deixar o programa criar o arquivo, caso contr�rio acontecer� erro

# Endere�os mapeados em mem�ria para leitura
.text
    	# Abrir arquivo
	li   $v0, 13       
	la   $a0, nome_arquivo
	li $a1, 1            
	li $a2, 0         
	syscall            # open a file 

	move $s0, $v0      # save the file descriptor 	
    	# S0 � reservado exclusivamente para o FD
 
##### Fun��o principal que cont�m o loop do elevador #####
main:
	jal esperar_key
	jal processa_entradas
	jal movimenta_elevadores
	jal imprime_painel_controle
	jal escreve_arquivo
	
	j main

##### Fun��o que escreve o LOG de a��es dos elevadores ####
escreve_arquivo:
	
	# Ecreve pulalin: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, pulalin 
	li   $a2, 1       
	syscall 
	
	# Ecreve pulalin: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, pulalin 
	li   $a2, 1       
	syscall 
	
	# Ecreve E1: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_e1 
	li   $a2, 4       
	syscall
	
	# Ecreve andar atual:
	lb $t1, andar_e1
	add $t1, $t1, 48	# Transforma em caractere
	sb $t1, aux_print
	  
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, aux_print
	li   $a2, 1       
	syscall
	
	# Ecreve espaco: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, espaco 
	li   $a2, 1       
	syscall 
	
	# Ecreve andar destino:
	lb $t1, destino_e1
	add $t1, $t1, 48	# Transforma em caractere
	sb $t1, aux_print
	  
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, aux_print
	li   $a2, 1       
	syscall
	
	# Ecreve espaco: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, espaco 
	li   $a2, 1       
	syscall
	
	# Verificar status da porta
	lb $t1, porta_e1
	beq $t1, 0, print_F_e1
	
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_A
	li   $a2, 1       
	syscall
	j printa_estado_e1
	
print_F_e1:
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_F
	li   $a2, 1       
	syscall
	
printa_estado_e1:
	# Ecreve espaco: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, espaco 
	li   $a2, 1       
	syscall 
	
	# Verificar estado do elevador
	lb $t1, estado_e1
	beq $t1, 0, print_P_e1
	
	# Verifica se o elevador est� parado no terreo
	lb $t1, TemDestino_e1
	lb $t2, andar_e1
	
	beq $t1, 1,  print_M_e1
	beq $t2, 1, print_P_e1 
	
print_M_e1:
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_M
	li   $a2, 1       
	syscall
	j print_elevador_e2
	
print_P_e1:
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_P
	li   $a2, 1       
	syscall
	
print_elevador_e2:
	# Ecreve pulalin: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, pulalin 
	li   $a2, 1       
	syscall 
	
	# Ecreve E2: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_e2 
	li   $a2, 4       
	syscall
	
	# Ecreve andar atual:
	lb $t1, andar_e2
	add $t1, $t1, 48	# Transforma em caractere
	sb $t1, aux_print
	  
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, aux_print
	li   $a2, 1       
	syscall
	
	# Ecreve espaco: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, espaco 
	li   $a2, 1       
	syscall 
	
	# Ecreve andar destino:
	lb $t1, destino_e2
	add $t1, $t1, 48	# Transforma em caractere
	sb $t1, aux_print
	  
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, aux_print
	li   $a2, 1       
	syscall
	
	# Ecreve espaco: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, espaco 
	li   $a2, 1       
	syscall
	
	# Verificar status da porta
	lb $t1, porta_e2
	beq $t1, 0, print_F_e2
	
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_A
	li   $a2, 1       
	syscall
	j printa_estado_e2
	
print_F_e2:
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_F
	li   $a2, 1       
	syscall
	
printa_estado_e2:
	# Ecreve espaco: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, espaco 
	li   $a2, 1       
	syscall 
	
	# Verificar estado do elevador
	lb $t1, estado_e2
	beq $t1, 0, print_P_e2
	
	# Verifica se o elevador est� parado no terreo
	lb $t1, TemDestino_e2
	lb $t2, andar_e2
	
	beq $t1, 1,  print_M_e2
	beq $t2, 1, print_P_e2
	
print_M_e2:
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_M
	li   $a2, 1       
	syscall
	j print_pedidos

print_P_e2:
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_P
	li   $a2, 1       
	syscall
	
print_pedidos:
	# Ecreve pulalin: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, pulalin 
	li   $a2, 1       
	syscall 
	
	# Ecreve B1: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_B1  
	li   $a2, 4       
	syscall 
	
	la $s1, pedidos_internos_e1 
	li $s2, 1

loop_escreve_internos_e1:
	beq $s2, 9, escreve_internos_e2
	
	lb $t1, 0($s1)
	
	beq $t1, 0, escreve_zero_e1
	# Ecreve 1: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_um  
	li   $a2, 2       
	syscall
	j continua_loop_escreve_e1
escreve_zero_e1:
	# Ecreve 0: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_zero  
	li   $a2, 2       
	syscall
	
continua_loop_escreve_e1:
	add $s1, $s1, 1
	add $s2, $s2, 1
	j loop_escreve_internos_e1
	
escreve_internos_e2:

	# Ecreve pulalin: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, pulalin 
	li   $a2, 1       
	syscall 
	
	# Ecreve B2: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_B2  
	li   $a2, 4       
	syscall 
	
	la $s1, pedidos_internos_e2 
	li $s2, 1

loop_escreve_internos_e2:
	beq $s2, 9, escreve_externos
	
	lb $t1, 0($s1)
	
	beq $t1, 0, escreve_zero_e2
	# Ecreve 1: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_um  
	li   $a2, 2       
	syscall
	j continua_loop_escreve_e2
escreve_zero_e2:
	# Ecreve 0: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_zero  
	li   $a2, 2       
	syscall
	
continua_loop_escreve_e2:
	add $s1, $s1, 1
	add $s2, $s2, 1
	j loop_escreve_internos_e2

escreve_externos:
	
	# Ecreve pulalin: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, pulalin 
	li   $a2, 1       
	syscall 
	
	# Ecreve BE: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_BE  
	li   $a2, 4       
	syscall 
	
	la $s1, pedidos_externos
	li $s2, 1

loop_escreve_externo:
	beq $s2, 9, escreve_teclas
	
	lb $t1, 0($s1)
	
	beq $t1, 0, escreve_zero_externo
	# Ecreve 1: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_um  
	li   $a2, 2       
	syscall
	j continua_loop_escreve_externo
escreve_zero_externo:
	# Ecreve 0: 
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_zero  
	li   $a2, 2       
	syscall
	
continua_loop_escreve_externo:
	add $s1, $s1, 1
	add $s2, $s2, 1
	j loop_escreve_externo

escreve_teclas:	
	# Pulalin
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, pulalin 
	li   $a2, 1       
	syscall
	
	# Escreve TC
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_TC  
	li   $a2, 4       
	syscall 
	
	lb $s2, qtde_teclas
	
	# Imprime o vetor de teclas
	li   $v0, 15      
	move $a0, $s0      
	la   $a1, str_teclas  
	move $a2, $s2       
	syscall
	
	li $t1, 0
	sb $t1, qtde_teclas
	
	jr $ra


###### Fun��o que imprime todas as informa��es dos dois elevadores ######
imprime_painel_controle:
	
	li $v0, 4
	la $a0, pulalin
	syscall
	
	li $v0, 4
	la $a0, pulalin
	syscall
	
	#Imprime o t�tulo do elevador 1
	li $v0, 4
	la $a0, titulo_e1
	syscall
	
	li $v0, 4
	la $a0, str_andar_atual
	syscall
	
	li $v0, 1
	lb $a0, andar_e1
	syscall
	
	li $v0, 4
	la $a0, str_situacao
	syscall
	
	lb $t2, estado_e1 
	beq $t2, 1, verifica_destino_e1
	
	#Elevador bloqueado
	li $v0, 4
	la $a0, str_bloq
	syscall
	
	j lista_req_internas_e1

verifica_destino_e1:
	lb $t1, TemDestino_e1
	beq $t1, 0, verifica_novamente_e1
	
	#Se est� aqui, significa que o elevador est� funcional e tem destino
	li $v0, 4
	la $a0, str_movendo
	syscall
	
	li $v0, 1
	lb $a0, destino_e1
	syscall
	
	li $v0, 4
	la $a0, pulalin
	syscall
	
	j lista_req_internas_e1

verifica_novamente_e1:
	lb $t1, andar_e1
	beq $t1, 1, esta_no_terreo_e1  # Verificar se o elevador est� no t�rreo
	
	lb $t1, porta_e1
	beq $t1, 1, porta_aberta_e1
	
	# A porta est� fechada
	li $v0, 4
	la $a0, str_movendo
	syscall
	
	li $v0, 4
	la $a0, str_para_terreo
	syscall
	
	j lista_req_internas_e1
	
porta_aberta_e1:
	# Indicar que a porta est� aberta
	li $v0, 4
	la $a0, str_aberta
	syscall
	j lista_req_internas_e1
	
esta_no_terreo_e1:
	#Se entrou aqui, o E1 est� parado no t�rreo
	li $v0, 4
	la $a0, str_parado
	syscall
	
lista_req_internas_e1:
	
	# Vetor de pedidos internos
	la $s1, pedidos_internos_e1
	li $s2, 1
	
	li $v0, 4
	la $a0, str_lista_reqs_int
	syscall
	
	# Percorre o vetor de pedidos internos imprimindo
loop_pedidos_e1:
	beq $s2, 9, prints_e2
	
	lb $t1, 0($s1)
	
	li   $v0, 1
	move $a0, $t1 
	syscall
	
	li $v0, 4
	la $a0, espaco  
	syscall
	
	add $s1, $s1, 1
	add $s2, $s2, 1
	
	j loop_pedidos_e1

	# Prints referentes ao elevador 2 #
prints_e2:
	
	li $v0, 4
	la $a0, pulalin  
	syscall
	li $v0, 4
	la $a0, pulalin  
	syscall
	
	#Imprime o t�tulo do elevador 2
	li $v0, 4
	la $a0, titulo_e2
	syscall
	
	li $v0, 4
	la $a0, str_andar_atual
	syscall
	
	li $v0, 1
	lb $a0, andar_e2
	syscall
	
	li $v0, 4
	la $a0, str_situacao
	syscall
	
	lb $t2, estado_e2 
	beq $t2, 1, verifica_destino_e2
	
	# Elevador bloqueado
	li $v0, 4
	la $a0, str_bloq
	syscall
	
	j lista_req_internas_e2
	
verifica_destino_e2:
	lb $t1, TemDestino_e2
	beq $t1, 0, verifica_novamente_e2
	
	# Se est� aqui, significa que o elevador est� funcional e tem destino
	li $v0, 4
	la $a0, str_movendo
	syscall
	
	li $v0, 1
	lb $a0, destino_e2
	syscall
	
	li $v0, 4
	la $a0, pulalin
	syscall
	
	j lista_req_internas_e2

verifica_novamente_e2:
	
	lb $t1, andar_e2
	beq $t1, 1, esta_no_terreo_e2  # Verificar se o elevador est� no t�rreo
	
	lb $t1, porta_e2
	beq $t1, 1, porta_aberta_e2
	
	# A porta est� fechada
	li $v0, 4
	la $a0, str_movendo
	syscall
	
	li $v0, 4
	la $a0, str_para_terreo
	syscall
	
	j lista_req_internas_e2
	
porta_aberta_e2:
	# Indicar que a porta est� aberta
	li $v0, 4
	la $a0, str_aberta
	syscall
	j lista_req_internas_e2

esta_no_terreo_e2:
	
	# Se entrou aqui, o E2 est� parado no t�rreo
	li $v0, 4
	la $a0, str_parado
	syscall
	
lista_req_internas_e2:
	# Vetor de pedidos internos 2
	la $s1, pedidos_internos_e2
	li $s2, 1
	
	li $v0, 4
	la $a0, str_lista_reqs_int
	syscall

loop_pedidos_e2:
	# Percorre o vetor de pedidos internos imprimindo
	beq $s2, 9, print_pedidos_ext
	
	lb $t1, 0($s1)
	li $v0, 1
	move $a0, $t1 
	syscall
	
	li $v0, 4
	la $a0, espaco  
	syscall
	
	add $s1, $s1, 1
	add $s2, $s2, 1
	j loop_pedidos_e2

  ### Imprimir a lista de requisi��es externas ###
print_pedidos_ext:
	li $v0, 4
	la $a0, pulalin  
	syscall
	li $v0, 4
	la $a0, pulalin
	syscall
	
	la $s1, pedidos_externos
	li $s2, 1
	
	li $v0, 4
	la $a0, str_lista_reqs_ext
	syscall

loop_pedidos_ext:
	# Percorre o vetor de pedidos internos imprimindo
	beq $s2, 9, return
	
	lb $t1, 0($s1)
	li $v0, 1
	move $a0, $t1 
	syscall
	
	li $v0, 4
	la $a0, espaco  
	syscall
	
	add $s1, $s1, 1
	add $s2, $s2, 1
	j loop_pedidos_ext

	nop

##### Fun��o que realiza os movmentos dos elevadores  ######
movimenta_elevadores:
	
	# Vari�veis de controle
	lb $s1, destino_e1
	lb $s2, destino_e2
	lb $s3, estado_e1
	lb $s4, estado_e2
	lb $t1, porta_e1
	lb $t2, porta_e2
	
	beq $t1, 0, verifica_porta_e2
	sb $zero, porta_e1
	
verifica_porta_e2:
	beq $t2, 0, continua_movimento 
	sb $zero, porta_e2	
	
continua_movimento:
	beq $s3, 0, anda_elevador2	# Se o elevador 1 estiver bloqueado, verificar o segundo
	
	lb $s5, andar_e1		
	sub $s7, $s1, $s5		# Subtrai  Destino - andar_atual
	bne $s7, 0, move_elevador1	# Se j� estiver no destino, n�o faz nada
	
	# Se est� aqui, significa que chegou no destino
	# Resetar vari�veis
	li $t1, 1
	sb $t1, destino_e1
	sb $zero, TemDestino_e1
	sb $t1, porta_e1
	
	j anda_elevador2
	
move_elevador1:
	ble $s7, 0, desce_elevador1 
	
	# Se est� aqui, significa que devo subir o elevador
	addu $s5, $s5, 1
	sb $s5, andar_e1	
	j verifica_situacao_destino_e1
	
desce_elevador1:
	subu $s5, $s5, 1
	sb $s5, andar_e1
	
verifica_situacao_destino_e1:
	
	# Pode ser que ao mover 1 o E1 tenha alcan�ado o destino
	lb $t1, andar_e1
	bne $s1, $t1, anda_elevador2
	
	# Alcan�ou o desino!
	# Resetar vari�veis
	li $t1, 1
	sb $t1, destino_e1
	sb $zero, TemDestino_e1
	sb $t1, porta_e1
	
anda_elevador2:
	beq $s4, 0, return		# Se o elevador 2 estiver bloquado, voltar
	lb $s5, andar_e2
	sub $s7, $s2, $s5		# Subtrai  Destino - andar_atual
	bne $s7, 0, movimenta_elevador2 # Se for diferente de 0, se movimentar
	
	# Se est� aqui, o elevador 2 atingiu seu destino
	li $t1, 1
	sb $t1, destino_e2
	sb $zero, TemDestino_e2
	sb $t1, porta_e2
	jr $ra
	
movimenta_elevador2:
	ble $s7, 0, desce_elevador2
	
	#Se est� aqui, significa que devo subir o elevador
	addu $s5, $s5, 1
	sb $s5, andar_e2
	j verifica_situacao_destino_e2
	
desce_elevador2:
	# Subtrair o andar do elevador
	subu $s5, $s5, 1
	sb $s5, andar_e2
	
verifica_situacao_destino_e2:
	
	# Pode ser que ao mover 1 o E2 tenha alcan�ado o destino
	lb $t1, andar_e2
	bne $s2, $t1, return
	
	# Alcan�ou o desino!
	# Resetar vari�veis
	li $t1, 1
	sb $t1, destino_e2
	sb $zero, TemDestino_e2
	sb $t1, porta_e2
	
	jr $ra
	
##### Fun��o que precessa as entradas e decide qual o destino do elevador #####
processa_entradas:
	
	#Dar prioridade aos pedidos internos
	#Carregar os endere�os e os �ndices
	la $s1, pedidos_internos_e1
	li $s2, 1 			#Ser� o indice do $s1
	la $s3, pedidos_internos_e2
	li $s4, 1			#Ser� o �ndice do $s3
	lb $s5, TemDestino_e1
	lb $s6, TemDestino_e2
	lb $t1, estado_e1
	
	beq $t1, 0, loop_interno_2
	
loop_interno_1:
	
	#Carrega os valores do vetor de pedidos internos
	lb $t2, 0($s1)
	beq $s5, 1, loop_interno_2       	# Se eu j� possuir um destino
	bne $t2, 1, continua_loop_interno_1     # Se eu n�o tiver encontrado um pedido, continuar procurando
	
	# Encontrei um pedido v�lido!
	sb $s2, destino_e1
	sb $zero, 0($s1) 		# Apaga do vetor de pedidos
	li $t1, 1
	sb $t1, TemDestino_e1		# Seta um destino
	
continua_loop_interno_1:
	beq $s2, 8, prepara_loop_2	# Enquanto n�o atingir o fim do vetor
	lb $t1, TemDestino_e1		
	beq $t1, 1, prepara_loop_2	# Se o elevador adquiri um destino, sair
	addu $s2, $s2, 1   # Avan�a no �ndice
	addu $s1, $s1, 1   # Avan�a 1 byte para frente 
	j loop_interno_1	

prepara_loop_2:
	
	#Verifica se o E2 est� operacional
	lb $t1, estado_e2
	beq $t1, 0, busca_destino_externo
loop_interno_2:
	lb $t2, 0($s3)
	beq $s6, 1, busca_destino_externo      # Se j� possuir um destino, pode ser que E1 n�o tenha
	bne $t2, 1, continua_loop_interno_2    # Se eu n�o tiver encontrado um pedido, continuar procurando
	
	# Encontrei um pedido v�lido
	sb $s4, destino_e2
	sb $zero, 0($s3)		# Apaga do vetor de pedidos
	li $t1, 1
	sb $t1, TemDestino_e2		# Seta um destino
	
continua_loop_interno_2:
	beq $s4, 8, busca_destino_externo
	lb $t1, TemDestino_e2
	beq $t1, 1, busca_destino_externo	# Caso o elevador adquira um destino
	addu $s4, $s4, 1   # Avan�a no �ndice
	addu $s3, $s3, 1   # Avan�a 1 byute para frente 
	j loop_interno_2
	
	# A busca de destinos externos � mais complexa pois envolve dois elevadores
busca_destino_externo:
	lb $t1, TemDestino_e1
	lb $t2, TemDestino_e2
	
	#Se n�o tivermos destinos nem no E1 e nem no E2
	beq $t1, 0, continua_busca_destino_externo
	beq $t2, 0, continua_busca_destino_externo
	jr $ra

continua_busca_destino_externo:
	#Carregar os endere�os e os �ndices
	la $s1, pedidos_externos
	li $s2, 1			#Armazena o �ndice dos vetores de pedidos
	 
loop_externo:
	#Carrega os valores do vetor de pedidos externos
	lb $t1, 0($s1)
	bne $t1, 1, continua_loop_externo     #Verifica se eu encontrei um destino v�lido	
	
	# Se entrou aqui � por que encontrou um destino externo!
	lb $t1, TemDestino_e1
	lb $t2, TemDestino_e2	
	
	beq $t1, 1, verifica_e2 		   # Se o elevador 1 estiver ocupado, insere no 2		
	beq $t2, 1, verifica_e1			   # Se o elevador 2 estiver ocupado, inserir em E1
	j decide_qual_melhor_elevador	   # Se ambos estiverem livres
	
decide_qual_melhor_elevador:

	# Subtrai a posi��o e o suposto destino para verificar qual est� mais pr�ximo
	lb $t1, andar_e1
	lb $t2, andar_e2
	subu $t3, $t1, $s2
	subu $t4, $t2, $s2
	lb $t5, estado_e1
	lb $t6, estado_e2
	
	beq $t5, 0, verifica_e2		# Se o elevador 1 estiver parado
	beq $t6, 1, testa_ambos		# Se o elevador 2 estiver funcionando
	j insere_destino_e1		# Se os de cima forem falsos, inserir no E1
	
verifica_e2:
	lb $t6, estado_e2
	beq $t6, 0, return		# Se o elevador 2 estiver parado
	j insere_destino_e2		# Se o de cima for falso, inserir no E2

testa_ambos:
	ble $t3, $t4, insere_destino_e1	# Ambos est�o funcionando, localizar o mais pr�ximo
	j insere_destino_e2

verifica_e1:
	lb $t6, estado_e1
	beq $t6, 0, return		# Se o elevador 2 estiver parado
	j insere_destino_e1		# Se o de cima for falso, inserir no E2
	
insere_destino_e1:
	sb $s2, destino_e1
	sb $zero, 0($s1)			# Salvar novo destino
	li $t1, 1
	sb $t1, TemDestino_e1
	
	j continua_loop_externo
	
insere_destino_e2:
	sb $s2, destino_e2	# Salvar novo destino
	sb $zero, 0($s1)		# Remove o pedido do vetor
	li $t1, 1
	sb $t1, TemDestino_e2	
	
continua_loop_externo:
	beq $s2, 8, return
	lb $t1, TemDestino_e1
	lb $t2, TemDestino_e2
	add $s1, $s1, 1
	add $s2, $s2, 1
	beq $t1, 0, loop_externo
	beq $t2, 0, loop_externo
	jr $ra

######### Fun��o de leitura das entradas #########
esperar_key:	
	#MMIO - Leitura de teclas mapeadas em mem�ria
	lw $t1, 0xffff0000
	andi $t1, $t1, 0x00000001
	beqz $t1, esperar_key
	
	lbu $s2, 0xffff0004 #Carrega a tecla em s2
	
	#Caso tenha entrado um ENTER, sair do loop
	bne $s2, '\n', tratar_entrada
	jr $ra
	j esperar_key

tratar_entrada:

	# Adicionar a entrada no vetor de entradas
	lb $t1, qtde_teclas
	la $t2, str_teclas
	add $t1, $t1, 1
	sb $t1, qtde_teclas
	li $t3, 0
	
procura_lugar_vetor:
	beq $t3, $t1, continuar_leitura
	add $t3, $t3, 1
	add $t2, $t2, 1
	j procura_lugar_vetor
continuar_leitura:
	sb $s2, ($t2)
	
	# Adicionar espa�o no vetor de entradas
	add $t1, $t1, 1
	add $t2, $t2, 1 
	sb $t1, qtde_teclas
	li $t3, 32   			#C�digo ASCII para espa�o
	sb $t3, ($t2)			# Armazena
		
	#39 � o c�digo ascii em hexa para '8'
	li $t1, 56
	ble $s2, $t1, entrada_numero
	j outra_entrada

entrada_numero:	

	la $s1, pedidos_externos
	
	sub $t1, $s2, 49 	# Coloca em t1 o n�mero digitado
	add $s1, $s1, $t1	# Avan�a no vetor de pedidos externos 
	li $t1, 1
	sb $t1, 0($s1)	# Armazena 1 na posi��o do andar externo pedido
	j esperar_key

outra_entrada:
	
# Entradas internas no E1
	la $s1, pedidos_internos_e1
	
	bne $s2, 'q', continua1
	li $a1, 0
	j insere_pedidoInterno	
		
continua1:
	bne $s2, 'w', continua2
	li $a1, 1
	j insere_pedidoInterno
	
continua2:
	bne $s2, 'e', continua3
	li $a1, 2
	j insere_pedidoInterno

continua3:	
	bne $s2, 'r', continua4
	li $a1, 3
	j insere_pedidoInterno

continua4:
	bne $s2, 't', continua5
	li $a1, 4
	j insere_pedidoInterno

continua5:	
	bne $s2, 'y', continua6
	li $a1, 5
	j insere_pedidoInterno
	
continua6:	
	bne $s2, 'u', continua7
	li $a1, 6
	j insere_pedidoInterno

continua7:	
	bne $s2, 'i', continua8
	li $a1, 7
	j insere_pedidoInterno

#Entradas internas do elevador 2
continua8:

	la $s1, pedidos_internos_e2
	bne $s2, 'a', continua9
	li $a1, 0
	j insere_pedidoInterno	
		
continua9:
	bne $s2, 's', continua10
	li $a1, 1
	j insere_pedidoInterno

continua10:
	bne $s2, 'd', continua11
	li $a1, 2
	j insere_pedidoInterno

continua11:
	bne $s2, 'f', continua12
	li $a1, 3
	j insere_pedidoInterno

continua12:
	bne $s2, 'g', continua13
	li $a1, 4
	j insere_pedidoInterno

continua13:
	bne $s2, 'h', continua14
	li $a1, 5
	j insere_pedidoInterno

continua14:
	bne $s2, 'j', continua15
	li $a1, 6
	j insere_pedidoInterno

continua15:
	bne $s2, 'k', continua16
	li $a1, 7
	j insere_pedidoInterno
	
continua16:
	bne $s2, 'z', continua17
	li $t1, 0
	sb $t1, estado_e1
	j esperar_key
	
continua17:
	bne $s2, 'c', continua18
	li $t1, 0
	sb $t1, estado_e2
	j esperar_key
	
continua18:
	bne $s2, 'x', continua19
	li $t1, 1
	sb $t1, estado_e1
	j esperar_key

continua19:
	bne $s2, 'v', continua20
	li $t1, 1
	sb $t1, estado_e2
	j esperar_key

continua20:
	bne $s2, 'b', esperar_key
	j fim
	
insere_pedidoInterno:
	#O �ndice do pedido est� em $a1
	move $t3, $s1      # Copia o endere�o do vetor de pedido interno para T3
	add $t3, $t3, $a1  # Avan�a no vetor
	li $t2, 1
	sb $t2, 0($t3)
	j esperar_key
	
print_msg:
	#Printa a mensagem contida em $a1
	li $v0, 4       
        move $a0, $a1 
        syscall 
		
	jr $ra

return:
	jr $ra

fim:	
	li $v0, 16
	move $a0, $s0
	syscall	
	nop

    .data

##### String referentes ao arquivo ####
nome_arquivo:    .asciiz "log_saida.txt"
str_e1:		 .asciiz "E1: "
str_e2:		 .asciiz "E2: "
str_A:		.asciiz "A "
str_F:		.asciiz "F "
str_M:		.asciiz "M "
str_P:		.asciiz "P "
str_BE:		.asciiz "BE: " 
str_B1:		.asciiz "B1: "
str_B2:		.asciiz "B2: " 
str_TC:		.asciiz "TC: "
str_um:		.asciiz "1 "
str_zero:	.asciiz "0 "
aux_print:	.asciiz " "

####### Strings do print na tela #########
titulo_e1:	 .asciiz "###### ELEVADOR 1 ######"
titulo_e2:	 .asciiz "###### ELEVADOR 2 ######"
str_andar_atual: .asciiz "\nAndar atual: "
str_situacao:    .asciiz "\nSitua��o da cabine: "
str_lista_reqs_int: .asciiz "Lista de requisi��es internas: "
str_lista_reqs_ext: .asciiz "Lista de requisi��es externas: "
str_aberta:      .asciiz "porta aberta\n"
str_bloq:	 .asciiz  "elevador parado pelo bot�o\n"
str_movendo:	 .asciiz "movendo-se para "
str_parado:	 .asciiz "parado no t�rreo\n"
str_para_terreo: .asciiz "o terreo\n"
elevador1_subiu: .asciiz "\nO elevador 1 subiu 1 andar"
elevador2_subiu: .asciiz "\nO elevador 2 subiu 1 andar"
elevador1_desceu: .asciiz "\nO elevador 1 desceu 1 andar"
elevador2_desceu: .asciiz "\nO elevador 2 desceu 1 andar"
str_teclas:	  .space 56
qtde_teclas:      .byte 0
pulalin: .asciiz "\n"
espaco:  .asciiz " "

###### Strings de controle interno do elevador ######
pedidos_externos:    .byte 0, 0, 0, 0, 0, 0, 0, 0  #Manipilar com sb e lb
pedidos_internos_e1: .byte 0, 0, 0, 0, 0, 0, 0, 0
pedidos_internos_e2: .byte 0, 0, 0, 0, 0, 0, 0, 0
destino_e1: .byte 1
destino_e2: .byte 1
TemDestino_e1:  .byte 0
TemDestino_e2:  .byte 0
andar_e1:   .byte 1
andar_e2:   .byte 1
estado_e1:   .byte 1   # 0 para bloqueado, 1 para ativado
estado_e2:   .byte 1
porta_e1:    .byte 0	# 0 para porta fechada, 1 para aberta
porta_e2:    .byte 0

entradas: .word 0
