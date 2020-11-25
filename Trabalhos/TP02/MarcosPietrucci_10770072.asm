#CONS_RECEIVER_CONTROL           =   0xffff0000
#CONS_RECEIVER_READY_MASK        =   0x00000001
#CONS_RECEIVER_DATA              =   0xffff0004
    
    .data
msg1:   .asciiz "Pressionou Enter"
msg2:   .asciiz "Puro teste"

    .text
esperar_key:
	
	#MMIO - Leitura de teclas mapeadas em memória
	lw $t1, 0xffff0000
	andi $t1, $t1, 0x00000001
	beqz $t1, esperar_key
	
	lbu $s1, 0xffff0004
	
	#Caso tenha entrado um ENTER, sair do loop
	la $a1, msg1
	beq $s1, 10, print_msg
	
	la $a1, msg2
				
	move $a0, $s1
	li $v0, 1
	syscall		#Printa o caractere lido
 
	li $a0, 10
	li $v0, 11
	syscall
	
	j esperar_key


print_msg:

	#Printa a mensagem contida em $a1
	li $v0, 4       
        move $a0, $a1 
        syscall 
		
	j esperar_key	
