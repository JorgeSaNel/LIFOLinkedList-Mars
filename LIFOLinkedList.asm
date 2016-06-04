	.data
strNum: .asciiz "Introduce una cadena de numeros: "
strPush:.asciiz "Metodo Push => "
strTextRemove:.asciiz "Insert the number you want to remove: "
strRemove:.asciiz "Deleted it. The list now is : "
strNotRemove:.asciiz "Couldn't find the number. The list is: "
strGuion: .asciiz " - "
strOutOfMemory:.asciiz "Out of Memory"
	.text

#typedef struct _node_t {
	#int val; 
	#struct _node_t *prev; /* puntero al nodo anterior */
#} node_t;
		
#int main(){
	#node_t *top
	#int n;
	#while(readln(n) != 0){
		#push(top, n);
		#print(top)
	#}
	#n = readln();
	#remove(top, n)
	#print(top)
#}
## s0 => top
## s1 => value
main:
	#Print insert numbers
	la $a0, strNum
	li $v0, 4
	syscall
	
	li $s0, 0
	loop:
		#Read number
		li $v0, 5
		syscall
		move $s1, $v0
		move $a1, $s1
		
		beqz $a1, finishLoop	#Check if the number is bigger than 0
			move $a0, $s0
			move $a1, $s1
			jal Push
			move $s0, $v0
			
			#Print list
			la $a0, strPush
			li $v0, 4
			syscall
			move $a0, $s0
			jal Print
			b loop
	finishLoop:
		la $a0, strTextRemove
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		#Remove number
		move $a0, $s0
		move $a1, $v0
		jal Remove
		move $s0, $v0
		
		move $a0, $s0
		jal Print
	
	finishProgram:
		li $v0, 10
		syscall
		
#endMain

#--------------------------------------------------------------#
## $s0 => top
## $s1 => val
create:
	# Create Pile
	subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	addu $fp, $sp, 32
	sw $s0, 0($fp)
	sw $s1, 4($fp)
	
	move $s0, $a0
	move $s1, $a1
	
	#Call SBRK
	la $a0, 12
	li $v0, 9
	syscall
	beqz $v0, OutOfMemory
	
	#Save the parameters
	sw $s0, 0($v0)
	sw $s1, 4($v0)	
	
	#Free pile and go back
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	lw $fp, 24($sp)
	lw $ra, 28($sp)
	addu $sp, $sp, 32
	jr $ra
#endCreate

#--------------------------------------------------------------#
#void push(node_t *top, int val){
	#node_t *new_node = *top	//We create a auxNode
	
	#*new_node->val = val
	#*new_node->next = *top->next
	#*top = *new_node
#}
## $s0 => top
## $s1 => val
Push:
	# Create Pile
	subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	addu $fp, $sp, 32
	sw $s0, 0($fp)
	sw $s1, 4($fp)
	
	move $s0, $a0
	move $s1, $a1
	
	#Call create method
	move $a0, $s0
	move $a1, $s1
	jal create
	
	#Free pile and go back
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	lw $fp, 24($sp)
	lw $ra, 28($sp)
	addu $sp, $sp, 32
	jr $ra
#endPush

#--------------------------------------------------------------#
#node_t * remove(node_t *top, int val)
	#node_t *new_node = top
   	#aux = top->val
    	#while (val != aux){
        	#aux = new_node->val
        	#new_node = new_node->next
    	#}
    	#free(new_node)
    	#top = new_node)
#}
## s0 => top
## s1 => val
Remove:
	# Create Pile
	subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	addu $fp, $sp, 32
	sw $s0, 0($fp)
	sw $s1, 4($fp)
	
	move $s0, $a0
	move $s1, $a1
    
    	move $s2, $s0          		# actual = top
    	move $s3, $s0
search: beqz $s2, NotFound              # if(actual == NULL) NotFound;
             lw $t1, 4($s2)             	# $t1 = new_node->val
             beq $t1, $s1, finishSearch    	# if(t1 == val) finishSearch;
                move $s0, $s2                  	# $s0 = anterior
                lw $s2, 0($s2)                  	# new_node = new_node->next
             b search
#When you finish the loop, in $s0 we have the prev node and in $s2 the node we want to delete

      	finishSearch:
       	lw $t0, 0($s2) # Address to the next node we want to delete.
      	sw $t0, 0($s0) # Anterior apunta al siguiente del nodo a eliminar.
     	# Ya nadie hace referencia al nodo apuntado por $s2.

       	#Print Found
       	la $a0, strRemove
      	li $v0, 4
        syscall
        move $v0, $s0 # Devolvemos puntero al nodo eliminado
       	b continue

    	NotFound:   
        	#Number not found
        	la $a0, strNotRemove
        	li $v0, 4
        	syscall    
        	move $v0, $s3
       continue:   	
	#Free pile and go back
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	lw $fp, 24($sp)
	lw $ra, 28($sp)
	addu $sp, $sp, 32
	jr $ra
#endRemove

#--------------------------------------------------------------#
#print(node_t *top){
	#if (top->next =! null) {
		#print(top->next);
	#}
	#printf(“%d\n”, top->val);
	#return;
#}
## s0 => top
Print:
	subu $sp, $sp, 32
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	addu $fp, $sp, 32
	sw $s0, 0($fp)
	
	move $s0, $a0
	lw $a0, 0($s0)
	beqz $a0, finishPrint
		jal Print
	
	finishPrint:
		#Print Number
		lw $a0, 4($s0)
		li $v0, 1
		syscall
		#Print Guion
		li $v0, 4
		la $a0, strGuion
		syscall
	#Free pile
	lw $s0, 0($fp)
	lw $fp, 24($sp)
	lw $ra, 28($sp)
	addu $sp, $sp, 32
	#Go back
	jr $ra
#endPrint

OutOfMemory:
	li $v0, 4
	la $a0, strOutOfMemory
	syscall
	
	j finishProgram
#endOutOfMemory
