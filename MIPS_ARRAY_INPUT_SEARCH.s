#This is a program in MIPS assembly
#The Program takes input from the user and
#stores it in an array at memory
#It searches the input of user in the 
#array and gives the output and the 
#location of the array in memory (if Present)
#Else the program displays an Error. 
.data
    myarray:.space 400   
    print_str:  .asciiz "Terminating program ...\n" 
    b1 : .asciiz "array_a["
    b2 : .asciiz  "] = "
    newline: .asciiz "\n"
    not_found: .asciiz "That value does not exist in the array!\n"
    search_string: .asciiz "ENTER A SEARCH VALUE: "
.text    
	main:

	la $s1,myarray  #load address of myarray
	li $t0,0		#initialize t0 to 0


input_array:        
	beq $t0,40,_print_array #checking loop condition
    # Getting user input
    li $v0, 5  				#setting v0 to 5 for getting userinput
    syscall
    add $s1,$s1,$t0 		#adding counter to the memory index			
    sw $v0,0($s1)			#storing the user input in the array at position of index
    add $t0,$t0,4			#incrementing
    j input_array   		#loop

_print_array:			
	la $s1,myarray			#loading address of myarray to s1
	li $t0,0				#resetting counter to 1
	
_print_val:			
	beq $t0,40, _checkval			#checking loop condition to exit 	
	add $s1,$s1,$t0			#adding couter to the memory index
	add $a1,$t0,0
	lw 	$a2,0($s1)			#loading value from the array to print
	add $t0,$t0,4			#adding to the counter
	jal _printf
	j _print_val

_printf:
	li $v0, 4        #setting up v0 to 4 for printing out text using syscall
    la $a0, b1   # loading text to a0 for printing argument
    syscall
    li $v0, 1
    div $a0,$a1,4
    syscall
    li $v0, 4        #setting up v0 to 4 for printing out text using syscall
    la $a0, b2   # loading text to a0 for printing argument
    syscall
     li $v0, 1
    add $a0,$a2,0
    syscall
     li $v0, 4
     la $a0,newline #newline cha
     syscall
    jr $ra

_checkval:    
    jal _enter_val     
    la $s1,myarray          #loading address of myarray to s1
    li $t0,0                #resetting counter to 1
    li $s2,0
    
_print_eq_val:         
    beq $t0,40, _check_nomatch           #checking loop condition to exit    
    add $s1,$s1,$t0         #adding couter to the memory index
    add $a1,$t0,0
    lw  $a2,0($s1)          #loading value from the array to print
    add $t0,$t0,4           #adding to the counter
    beq $s3,$a2,_print_equal
    j _print_eq_val

_print_equal:
    jal _printf
    add $s2,$s2,1
    j _print_eq_val
    
_enter_val:
    li $v0, 4
    la $a0,search_string    #newline cha
    syscall                 
    li $v0, 5               #setting v0 to 5 for getting userinput
    syscall
    add $s3,$v0,0
    jr $ra


_check_nomatch:
    beq $s2,$zero,print_nomatch
    b _exit

print_nomatch:
    li $v0, 4            #setting up v0 to 4 for printing out text using syscall
    la $a0, not_found    # loading text to a0 for printing argument
    syscall
    b _exit

_exit:
    li $v0, 10
    syscall
