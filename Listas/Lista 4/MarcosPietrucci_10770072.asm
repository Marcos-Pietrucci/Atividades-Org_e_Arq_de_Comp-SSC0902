.data
	vetor:     	.word 15, 31, 63, 127, 255, 511, 1023, 2047, 4097, 65536, 0
	ListaInicio: 	.word 0
	pulalin:   	.asciiz "\n"
.text

# S0 armazena o �ndice do vetor
# S1 armazena a quantidade de valores que foram lidos
# S2 armazena o valor da posi��o atual do vetor
# S3 armazena o endere�o alocado pelo sbrk

	.globl main
main:
	# Inicializa vari�veis de controle da leitura
	la $s0, vetor
	li $s1, -1     
	
loop_leitura:

	lw $s2, 0($s0)  # Carrega no S2 o valor do vetor
	beq $s2, $zero, imprime_lista   # Testa se o valor lido foi o 0
	
	# sbrk (malloc)
    	li $a0, 8   # Aloca duas word (8 bytes) na memoria
    	li $v0,9    # 4 bytes para o valor, 4 bytes para o endereco do proximo
    	syscall     # Armazena o endere�o alocado em $v0
 
 	# Se for a primeira vez no loop, continuar
    	beq $s1, -1, continua_loop 
    	
    	# Se n�o, devo adicioanr o novo endere�o ao nodo antigo (Linkar a lista)
	sw $v0, 0($s3)  # Pega o endere�o atualmente alocado
	
continua_loop:
	
    	move $s3, $v0		# Carrega em S3 o endere�o alocado
    	sw $s2, 0($s3)	  	# Carrega nos primeiros 4 bytes o valor lido do vetor
    	add $s0, $s0, 4		# Avan�a o ponteiro do vetor para os pr�ximos 4 bytes alocados
    	add $s3, $s3, 4		# Avan�a 4 bytes no "nodo", atingindo a posi��o de escrever o endere�o do pr�ximo 
    	add $s1, $s1, 1         # Soma 1 no contador de leituras
	

	# Se n�o for a primeira aloca��o, continuar com o loop
	bne $s1, $zero, loop_leitura
	
	# Se foi, guardar o endere�o do primeiro (ListaInicio)
	sw  $v0, ListaInicio # Armazenar o endere�o do ListaInicio
	j loop_leitura	
	
imprime_lista:

	# Inicializa vari�veis de controle da leitura
	li $s2, 2		# Carrega um valor diferente de 0 no S2
	la $s0, ListaInicio	# Carrega no S0 o endere�o do ListaInicio
	lw  $s0, 0($s0)		# Carrega no S0 o valor do ListaInicio (Que � o endere�o do primeiro nodo alocado)

loop_imprime:	
	
	beq $s2, $zero, fim_codigo # Testa se o valor lido foi o 0
	
	lw $s2, 0($s0)		   # Carrega no S2 o valor contido no endere�o S0
	
	# print int (Tela da Console)
    	li $v0, 1
    	move $a0, $s2
    	syscall
    	
    	# Print "\n" (nova linha)
    	li $v0, 4
    	la $a0, pulalin
    	syscall
	
	# S0 passa a acessar o endere�o do pr�ximo elemento
	add $s0, $s0, 8    # Acessa o endere�o do proximo!!
	j loop_imprime
	
 fim_codigo:	
 	nop
	
	

	
	