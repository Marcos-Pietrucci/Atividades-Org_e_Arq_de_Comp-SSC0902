.data
	vetor:     .word 15,31,63,127,255,511,1023,2047,4097,65536,0
	raiz: 	   .word 0
	pulalin:   .asciiz "\n"
.text

# S0 armazena o índice do vetor
# S1 armazena a quantidade de valores que foram lidos
# S3 armazena o endereço alocado pelo sbrk

	.globl main
main:
	#Inicializa variáveis de controle da leitura
	la $s0, vetor
	li $s1, -1      #flag que indica se é ou não a primeira vez que rodo o programa
	
loop:
	lw $s2, 0($s0)  #&s2 armazena os valores do vetor
	
	beq $s2, $zero, imprime_lista   #testa se o valor lido foi o 0
	
	# sbrk (malloc) => Aloca memoria (em blocos de 4 bytes - words)
    	li $a0, 8   #aloca duas word (8 bytes) na memoria
    	li $v0,9    # 4 bytes para o valor, 4 bytes para o endereco do proximo
    	syscall     # Armazena o endereço alocado em $v0
 
    	beq $s1, -1, continua_loop
    	#Se nao for a primeira vez que executou
    	
	sw $v0, 0($s3)  #Pega o endereço atualmente alocado
	
continua_loop:
	
    	move $s3, $v0
    	
    	sw $s2, 0($s3)
    	    	
    	add $s0, $s0, 4
    	add $s3, $s3, 4
    	add $s1, $s1, 1
	

	bne $s1, $zero, loop	
	#Armazenar o nó raiz no registrador $s4
	sw  $v0, raiz
	
	j loop	
	
imprime_lista:
	#Inicializa variáveis de controle da leitura
	li $s2, 2
	la $s0, raiz
	lw  $s0, 0($s0)

loop_imprime:	

	beq $s2, $zero, fim_codigo 
	
	lw $s2, 0($s0)
	
	# print int (Tela da Console)
    	li $v0, 1
    	move $a0, $s2
    	syscall
    	
    	# Print "\n" (nova linha)
    	li $v0, 4
    	la $a0, pulalin
    	syscall
	
	add $s0, $s0, 8    #Acessa o endereço do proximo!!

	
	j loop_imprime
	
 fim_codigo:	
	
	

	
	