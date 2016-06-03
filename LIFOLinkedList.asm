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
	
	loop:
		#Read number
		li $v0, 5
		syscall
		move $a1, $v0
	
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


create:
#endCreate
#--------------------------------------------------------------#

Push:
#endPush
#--------------------------------------------------------------#


Remove:
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
		#Print Guion
		li $v0, 4
		la $a0, strGuion
		syscall
		#Print Number
		lw $a0, 4($s0)
		li $v0, 1
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