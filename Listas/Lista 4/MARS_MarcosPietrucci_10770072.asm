.data
	vetor:     	.word 15, 31, 63, 127, 255, 511, 1023, 2047, 4097, 65536, 0
	ListaInicio: 	.word 0
	pulalin:   	.asciiz "\n"
.text

# S0 armazena o índice do vetor
# S1 armazena a quantidade de valores que foram lidos
# S2 armazena o valor da posição atual do vetor
# S3 armazena o endereço alocado pelo sbrk

	.globl main
main:
	# Inicializa variáveis de controle da leitura
	la $s0, vetor
	li $s1, -1     
	
loop_leitura:

	lw $s2, 0($s0)  # Carrega no S2 o valor do vetor
	beq $s2, $zero, imprime_lista   # Testa se o valor lido foi o 0
	
	# sbrk (malloc)
    	li $a0, 8   # Aloca duas word (8 bytes) na memoria
    	li $v0,9    # 4 bytes para o valor, 4 bytes para o endereco do proximo
    	syscall     
 
 	# Se for a primeira vez no loop, continuar
    	beq $s1, -1, continua_loop 
    	
    	# Se não, devo adicioanr o novo endereço ao nodo antigo (Linkar a lista)
	sw $v0, 0($s3)  # Armazena o endereço atualmente alocado
	
continua_loop:
	
    	move $s3, $v0		# Carrega em S3 o endereço alocado
    	sw $s2, 0($s3)	  	# Carrega nos primeiros 4 bytes o valor lido do vetor
    	add $s0, $s0, 4		# Avança o ponteiro do vetor para os próximos 4 bytes alocados
    	add $s3, $s3, 4		# Avança 4 bytes no "nodo", atingindo a posição de escrever o endereço do próximo 
    	add $s1, $s1, 1         # Soma 1 no contador de leituras
	
	# Se não for a primeira alocação, continuar com o loop
	bne $s1, $zero, loop_leitura
	
	# Se foi, guardar o endereço do primeiro (ListaInicio)
	sw  $v0, ListaInicio # Armazenar o endereço do ListaInicio
	j loop_leitura	
	
imprime_lista:

	# Inicializa variáveis de controle da leitura
	li $s2, 2		# Carrega um valor diferente de 0 no S2
	la $s0, ListaInicio	# Carrega no S0 o endereço do ListaInicio
	lw  $s0, 0($s0)		# Carrega no S0 o valor do ListaInicio (Que é o endereço do primeiro nodo alocado)

loop_imprime:	
	
	beq $s2, $zero, fim_codigo # Testa se o valor lido foi o 0
	
	lw $s2, 0($s0)		   # Carrega no S2 o valor contido no endereço S0
	
	# print int (Tela da Console)
    	li $v0, 1
    	move $a0, $s2
    	syscall
    	
    	# Print "\n" (nova linha)
    	li $v0, 4
    	la $a0, pulalin
    	syscall
	
	# Acessa o endereço do proximo!!
	add $s0, $s0, 8    # S0 agora contém o endereço do próximo elemento
	j loop_imprime
	
 fim_codigo:	
 	nop
 	