.data
	numOfNodes: .word 0
	head: .word 0
	tail: .word 0
	buffer: .space 64
	memoryArray: .space 60 	# Number of available spaces is 15, obtained from 15 * 4 = 60
	memoryIndex: .word 0 	# Points at the first empty element in the array
	inputMessage: .asciiz "Input product serial number: "
	inputPosMessage: .asciiz "Input position: "
	totalNodesFoundMessage: .asciiz "Number of nodes found: "
	menuHead: .asciiz "<<PRODUCTS CONTROL SYSTEM>>\n\nPick an action:\n"
	menu1: .asciiz "1: Add a new product on the first shelf\n"
	menu2: .asciiz "2: Add a new product on a selected shelf\n"
	menu3: .asciiz "3: Add a new product on the last shelf\n"
	menu4: .asciiz "4: remove a product from the first shelf\n"
	menu5: .asciiz "5: remove a product from a selected shelf\n"
	menu6: .asciiz "6: remove a product from the last shelf\n"
	menu7: .asciiz "7: Find a product by position\n"
	menu8: .asciiz "8: Find a product by its serial number\n"
	menu9: .asciiz "9: Print products' serial number from the fisrt to the last shelf\n"
	menu10: .asciiz "10: Print products' serial number from the last to the first shelf\n"
	menu0: .asciiz "0: Exit\n"
	printErrorMessage: .asciiz "\nNo products on shelves\n"
	invalidPositionMessage: .asciiz "\nPosition exceeds number of current products, please try again.\n"
	zeroPositionMessage: .asciiz "\nPosition 0 cannot exist."
	emptyListMessage: .asciiz "\shelves are empty\n"
	nodeFound1: .asciiz "Found product at position "
	nodeFound2: .asciiz " with serial number "
	arrow: .asciiz "<==>"
	arrayFullMessage: .asciiz "Memory array full, can't save address. Consider increasing memory array size. Application performance not impacted."
	endMsg: .asciiz "\nEverything is in the right position, Good job :)\n"
	newLine: .asciiz "\n"
	invalid_msg: .asciiz "Invalid input\n"
.globl main
.text
	main:
		jal initDLL
		
	inputLoop:
		li $v0, 4
		la $a0, menuHead
		syscall
		
		li $v0, 4
		la $a0, menu1
		syscall
		
		li $v0, 4
		la $a0, menu2
		syscall
		
		li $v0, 4
		la $a0, menu3
		syscall
		
		li $v0, 4
		la $a0, menu4
		syscall
		
		li $v0, 4
		la $a0, menu5
		syscall
		
		li $v0, 4
		la $a0, menu6
		syscall
		
		li $v0, 4
		la $a0, menu7
		syscall
		
		li $v0, 4
		la $a0, menu8
		syscall
		
		li $v0, 4
		la $a0, menu9
		syscall
		
	        li $v0, 4
		la $a0, menu10
		syscall
		
		li $v0, 4
		la $a0, menu0
		syscall
		
		subi $sp, $sp, 4
		sw $ra, 0($sp)
		jal getUserInput
		lw $ra, 0($sp)
		addi $sp, $sp, 4		
	
	printMenu:
		beqz $v0, end
		beq $v0, 1, addNodeAtHead
		beq $v0, 2, addNodeAtPos
		beq $v0, 3, addNodeAtTail
		beq $v0, 4, delNodeAtHead
		beq $v0, 5, delNodeAtPos
		beq $v0, 6, delNodeAtTail
		beq $v0, 7, findNodePos
		beq $v0, 8, findNodeByValue
		beq $v0, 9, printList
		beq $v0, 10, printListReverse
		
		j inputLoop		
		
#######################################################################################################################################################
		
	initDLL:				# Create Head and Tail pointers and store their adresses for future reference
			
		la $s0, head		# Load head address at $S0		
		la $s1, tail		# Load tail address at $S1		
		jr $ra
		
#######################################################################################################################################################
		
	addNodeAtHead:
		lw $t9, numOfNodes
		addiu $t9, $t9, 1
		sw $t9, numOfNodes
		
		li $v0, 4			# Prepare to print message
		la $a0, inputMessage
		syscall
		
		subi $sp, $sp, 4
		sw $ra, 0($sp)
		jal getUserInput
		lw $ra, 0($sp)
		addi $sp, $sp, 4			# Prepare to read integer

		move $s2, $v0		# Move read int to s2
		
		addi $sp, $sp, 4	# Save $ra to the stack in order to call another function
		sw $ra, 0($sp)
		jal allocateMemory	# Allocates 3 words of memory
		lw $ra, 0($sp)
		subi $sp, $sp, 4
		
		sw $s2, 0($v0)		# Store int at first word
		sw $s0, 4($v0)		# Store head address at second word
		
		lw $t0, 0($s0)		# Load first node address
		beqz $t0, firstNode	# If first node address is zero, branch to first node
		
		sw $t0, 8($v0)		# Store first node's address at third word
		sw $v0, 4($t0)  	# Store current node's address at second word of first node
		sw $v0, 0($s0)		# Set head to current node
		
		jal printList
		
		j inputLoop
	
	 firstNode:
	 	sw $s1, 8($v0)		# Store tail address at third word
	 	sw $v0, 0($s0)		# Store current node's address at head
	 	sw $v0, 0($s1)		# Store current node's address at tail
	 	j inputLoop
	 	
#######################################################################################################################################################

	addNodeAtTail:
		lw $t9, numOfNodes
		addiu $t9, $t9, 1
		sw $t9, numOfNodes
		
		li $v0, 4			# Prepare to print message
		la $a0, inputMessage
		syscall
		
		subi $sp, $sp, 4
		sw $ra, 0($sp)
		jal getUserInput
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		move $s2, $v0		# Move read int to s2

		addi $sp, $sp, 4	# Save $ra to the stack in order to call another function
		sw $ra, 0($sp)
		jal allocateMemory	# Allocates 3 words of memory
		lw $ra, 0($sp)
		subi $sp, $sp, 4
		
		sw $s2, 0($v0)		# Store int at first word
		sw $s1, 8($v0)		# Store tail address at third word
		
		lw $t0, 0($s1)		# Load last node address
		beqz $t0, lastNode	# If last node address is zero, branch to last node
		
		sw $t0, 4($v0)		# Store last node's address at second word
		sw $v0, 8($t0)  	# Store current node's address at third word of first node
		sw $v0, 0($s1)		# Set tail to current node
		
		j printList
		
		j inputLoop
	
	 lastNode:
	 	sw $s0, 4($v0)		# Store head address at second word
	 	sw $v0, 0($s0)		# Store current node's address at head
	 	sw $v0, 0($s1)		#Store current node's address at tail
	 	j inputLoop

#######################################################################################################################################################

	addNodeAtPos:
		li $v0, 4			# Prepare to print message
		la $a0, inputPosMessage
		syscall
		
		subi $sp, $sp, 4
		sw $ra, 0($sp)
		jal getUserInput
		lw $ra, 0($sp)
		addi $sp, $sp, 4					# Prompt user for position to insert at
		
		lw $t0, numOfNodes
		beq $v0, 1, addNodeAtHead
		beqz $v0, addNodeAtPos	
		bgt $v0, $t0, invalidAddPosition	# If position exceeds the number of nodes in the list, print an error, and prompt the user again
		beq $v0, $t0, addNodeAtTail		# If position is equal to the number of nodes, branch to addNodeAtTail
		
		addiu $t0, $t0, 1
		sw $t0, numOfNodes
		
		move $a0, $v0					# Move position to $a0
		li $a1, 0						# A 0 in $a1 when calling the search function indicates to not print the node value
		addi $sp, $sp, 4				# Store $ra on the stack
		sw $ra, 0($sp)
		jal findNodeAtPos				
		lw $ra, 0($sp)					
		subi $sp, $sp, 4				
		
		lw $s3, 4($v0)					# Loads previous node relative to one found by findNodeAtPos
		
		li $v0, 4						# Prepare to print message
		la $a0, inputMessage
		syscall
				
		subi $sp, $sp, 4
		sw $ra, 0($sp)
		jal getUserInput
		lw $ra, 0($sp)
		addi $sp, $sp, 4					# Prepare to read integer
				
		move $s2, $v0					# Move read int to s2

		addi $sp, $sp, 4	# Save $ra to the stack in order to call another function
		sw $ra, 0($sp)
		jal allocateMemory	# Allocates 3 words of memory
		lw $ra, 0($sp)
		subi $sp, $sp, 4
		
		sw $s2, 0($v0)					# Store int at first word
		lw $t3, 8($s3)					# Loads next node address
		sw $t3, 8($v0)					# Links next node to current node
		sw $v0, 8($s3)					# Links current node to previous node
		sw $s3, 4($v0)					# Links previous node to current node
		sw $v0, 4($t3)					# Links current node to next node
		
		j printList
		
		j inputLoop
		
		
	invalidAddPosition:
		li $v0, 4
		la $a0, invalidPositionMessage
		syscall
		j addNodeAtPos
		

#######################################################################################################################################################

	delNodeAtHead:
		lw $t0, numOfNodes
		beqz $t0, emptyList			# Check if list is empty
	    addi $t0, $t0, -1
    	sw $t0, numOfNodes  		# Update number of nodes
    	beqz $t0, delLastNode		# Branch if the list has only one node remaining
    	
		
		lw $t1, 0($s0)	# Load head node into $t1
		lw $t2, 8($t1)	# Load next node into $t2
		sw $t2, 0($s0)	# Store next node into head, making it effectively the first node
		sw $s0, 4($t2)	# Store head into next node
		
		move $a0, $t1			# Move address of deleted node to a0
		addi $sp, $sp, 4		# Save $ra to the stack in order to call another function
		sw $ra, 0($sp)
		jal deallocateMemory	# Deallocates 3 words of memory
		lw $ra, 0($sp)
		subi $sp, $sp, 4
		
		j printList
		
		j inputLoop	

#######################################################################################################################################################

	delNodeAtTail:		
		lw $t0, numOfNodes
		beqz $t0, emptyList			# Check if list is empty
	    addi $t0, $t0, -1
    	sw $t0, numOfNodes  # Update number of nodes
    	beqz $t0, delLastNode		# Branch if the list has only one node remaining
		
		lw $t1, 0($s1)	# Load tail node into $t1
		lw $t2, 4($t1)	# Load prev node into $t2
		sw $t2, 0($s1)	# Store next node into tail, making it effectively the last node
		sw $s1, 8($t2)
		
		move $a0, $t1			# Move address of deleted node to a0
		addi $sp, $sp, 4		# Save $ra to the stack in order to call another function
		sw $ra, 0($sp)
		jal deallocateMemory	# Deallocates 3 words of memory
		lw $ra, 0($sp)
		subi $sp, $sp, 4
		
		j printList
		
		j inputLoop

#######################################################################################################################################################

	delNodeAtPos:
		lw $s2, numOfNodes
		beqz $s2, emptyList					# Check if list is empty
		beq $s2, 1, delLastNode				# Branch if the list has only one node remaining
		
		li $v0, 4						# Prepare to print message
		la $a0, inputPosMessage
		syscall
		
		subi $sp, $sp, 4
		sw $ra, 0($sp)
		jal getUserInput
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		bgt $v0, $s2, invalidDelPosition	# If position exceeds the number of nodes in the list, print an error, and prompt the user again
		beq $v0, 1, delNodeAtHead
		beqz $v0, delNodeAtPos	
		beq $v0, $s2, delNodeAtTail			# If position is equal to the number of nodes, branch to delNodeAtTail
		
		subi $t0, $t0, 1
		sw $t0, numOfNodes
		
		move $a0, $v0					# Move position to $a0
		li $a1, 0						# A 0 in $a1 when calling the search function indicates to not print the node value
		addi $sp, $sp, 4				# Store $ra on the stack
		sw $ra, 0($sp)
		jal findNodeAtPos				
		lw $ra, 0($sp)					
		subi $sp, $sp, 4
		
		lw $t1, 4($v0)
		lw $t2, 8($v0)
		sw $t2, 8($t1)
		sw $t1, 4($t2)
		
		move $a0, $v0			# Move address of deleted node to a0
		addi $sp, $sp, 4		# Save $ra to the stack in order to call another function
		sw $ra, 0($sp)
		jal deallocateMemory	# Deallocates 3 words of memory
		lw $ra, 0($sp)
		subi $sp, $sp, 4
		
		j printList
		
		j inputLoop
		
	invalidDelPosition:
		li $v0, 4
		la $a0, invalidPositionMessage
		syscall
		j delNodeAtPos
		
#######################################################################################################################################################

	delLastNode:
		lw $a0, 0($s0)
		sw $zero, numOfNodes
		sw $zero, 0($s0)
		sw $zero, 0($s1)
		
		addi $sp, $sp, 4		# Save $ra to the stack in order to call another function
		sw $ra, 0($sp)
		jal deallocateMemory	# Deallocates 3 words of memory
		lw $ra, 0($sp)
		subi $sp, $sp, 4
		
		j inputLoop

#######################################################################################################################################################
		
	emptyList:
		li $v0, 4
		la $a0, emptyListMessage
		syscall
		j inputLoop

#######################################################################################################################################################
	 	
	 printList:
	 	lw $t0, numOfNodes
	 	beqz $t0, printError
		lw $t0, 0($s0)			# Load address of first node to t0
		beqz $t0, endPrintList	# Check if address of first node is zero, if so, end print
		
		li $v0, 4
		la $a0, newLine
		syscall	
		
	printLoop:	
		li $v0, 1			# Prepare to print integer
		lw $a0, 0($t0)		# Load value of current node
		syscall				# Print
		
		lw $t1, 8($t0)		# Load address of next node to t1
		beq $s1, $t1, endPrintList	# Check if next node is tail, if so, end print
		move $t0, $t1		# Move address of second node to t0 
		
		li $v0, 4
		la $a0, arrow
		syscall		
		
	 	j printLoop
	 	
	printError:
		li $v0, 4
		la $a0, printErrorMessage
		syscall 	
		 	
	endPrintList:
		li $v0, 4
		la $a0, newLine
		syscall
		syscall	
		j inputLoop
###################################################################################################################################################
printListReverse:
    lw $t0, numOfNodes         # Load the value of numOfNodes into $t0
    beqz $t0, printError       # Branch to printError if numOfNodes is zero
    lw $t0, 0($s1)             # Load the address of the tail node to $t0
    beqz $t0, endPrintListRev  # If $t0 is zero, it means the list is empty, so branch to endPrintListRev

    li $v0, 4                  # Load immediate value 4 into $v0 (syscall code for printing a string)
    la $a0, newLine            # Load the address of the string "newLine" into $a0
    syscall                    # Print a newline

printLoopRev:
    li $v0, 1                  # Load immediate value 1 into $v0 (syscall code for printing an integer)
    lw $a0, 0($t0)             # Load the value of the current node into $a0
    syscall                    # Print the integer

    lw $t1, 4($t0)             # Load the address of the previous node into $t1
    beq $t1, $s0, endPrintListRev # If $t1 is equal to $s0 (the head), end the print loop
    move $t0, $t1              # Move the address of the previous node into $t0

    li $v0, 4                  # Load immediate value 4 into $v0 (syscall code for printing a string)
    la $a0, arrow              # Load the address of the string "arrow" into $a0
    syscall                    # Print " -> "

    j printLoopRev             # Jump back to printLoopRev to continue printing the list in reverse order
  
endPrintListRev:
    li $v0, 4                  # Load immediate value 4 into $v0 (syscall code for printing a string)
    la $a0, newLine            # Load the address of the string "newLine" into $a0
    syscall                    # Print a newline
    syscall                    # Print another newline (this seems to be redundant)
    j inputLoop                # Jump back to the calling function

		
#######################################################################################################################################################

	findNodePos:
		lw $t9, numOfNodes
		
		li $v0, 4
		la $a0, inputPosMessage
		syscall
		
		subi $sp, $sp, 4
		sw $ra, 0($sp)
		jal getUserInput
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		bgt $v0, $t9, invalidFindPos
		beqz $v0, zeroPosition

		li $a1, 1
		move $a0, $v0
		move $t8, $a0
	findNodeAtPos:
		lw $t1, 0($s0)
	
	findPosLoop:
		beq $a0, 1, endLoop
		lw $t1, 8($t1)
		subi $a0, $a0, 1
		j findPosLoop
		
	endLoop:
		beq $a1, 1, printNodeAtPos
		move $v0, $t1
		jr $ra
	
	printNodeAtPos:
		li $v0, 4
		la $a0, nodeFound1
		syscall
		
		li $v0, 1
		move $a0, $t8
		syscall
		
		li $v0, 4
		la $a0, nodeFound2
		syscall
		
		li $v0, 1
		lw $a0, 0($t1)
		syscall
		
		li $v0, 4
		la $a0, newLine
		syscall
		
		j inputLoop
		
	invalidFindPos:
		li $v0, 4
		la $a0, invalidPositionMessage
		syscall
		j findNodePos
		
	zeroPosition:
		li $v0, 4
		la $a0, zeroPositionMessage
		syscall
		j findNodePos

#######################################################################################################################################################

	findNodeByValue:
		li $v0, 4
		la $a0, inputMessage
		syscall
		
		subi $sp, $sp, 4
		sw $ra, 0($sp)
		jal getUserInput
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		move $t0, $v0			# The value being searched for, stored in $t0
		lw $t9, numOfNodes		# List length stored in $t9
		move $t1, $zero			# Position of current node stored in $t1
		lw $t2, 0($s0)			# Pointer to current node stored in $t2
		move $t3, $zero			# Number of nodes found stored in $t3
	findValueLoop:
		beq $t1, $t9, endValueLoop		# If position equals number of nodes in the list, end loop
		lw $t4, 0($t2)					# Load current node value in $t4
		beq $t4, $t0, printFoundNode	# If current node value equals the value the user is searching for, branch to print function
		lw $t2, 8($t2)					# Load pointer to next node 
		addi $t1, $t1, 1				# Increment position variable
		j findValueLoop					# Jump to beginning of loop
		
	printFoundNode:						# Print found node
		addi $t3, $t3, 1				# Increment found nodes variable
	
		li $v0, 4
		la $a0, nodeFound1
		syscall
		
		addi $t7, $t1, 1
		
		li $v0, 1
		move $a0, $t7
		syscall
		
		li $v0, 4
		la $a0, nodeFound2
		syscall
		
		li $v0, 1
		move $a0, $t0
		syscall
		
		li $v0, 4
		la $a0, newLine
		syscall
		
		lw $t2, 8($t2)					# Load pointer to next node 
		addi $t1, $t1, 1				# Increment position variable
		
		j findValueLoop
		
	endValueLoop:
		li $v0, 4
		la $a0, totalNodesFoundMessage
		syscall
		
		li $v0, 1
		move $a0, $t3
		syscall
		
		li $v0, 4
		la $a0, newLine
		syscall
		
		j inputLoop
		
#######################################################################################################################################################

	allocateMemory:
		lw $t1, memoryIndex			# Load current array index
		beqz $t1, allocateNew		# If it's equal zero, allocate new memory
		subi $t1, $t1, 4			# Decrement by 4 to point at last value in the array
		sw $t1, memoryIndex			# Save new index
		la $t8, memoryArray			# Load pointer to array
		add $t8, $t8, $t1			# Add index to array address to get the address of the last element
		lw $v0, 0($t8)				# Load address into $v0
		sw $zero, 0($t8)			# Remove that element from the array
		jr $ra 						# Return
		
		
	allocateNew:
		li $v0, 9			# Allocate 3 words of memory
		li $a0, 12
		syscall
		
		jr $ra

#######################################################################################################################################################

	deallocateMemory:
		sw $zero, 0($a0)			# Zero deallocated memory
		sw $zero, 4($a0)
		sw $zero, 8($a0)
		lw $t1, memoryIndex			# Load current array index
		beq $t1, 60, arrayFull		# Check if array is full
		la $t8, memoryArray			# Load pointer to array
		add $t8, $t8, $t1			# Add index to array address to get the address of the last element
		sw $a0, 0($t8)				# Store free memory address to memory array
		addi $t1, $t1, 4			# Increment memory index
		sw $t1, memoryIndex			# Store new index
		
		jr $ra
		
	arrayFull:
		li $v0, 4
		la $a0, arrayFullMessage
		syscall
		
		jr $ra

#######################################################################################################################################################

	getUserInput:
        la $a0, buffer
    	li $a1, 64
    	li $v0, 8
    	syscall
	
	checkInput:
		move $t1, $zero			# Set t1 to zero
		move $t6, $a0
		move $t4, $zero
	
    loop:								# Loop through each character of the string
        lb $t0, 0($t6)    	 			# Load the current character into $t0
        beqz $t0, convertString			# If the character is null, we've reached the end of the string
        beq $t0, 10, convertString		# If the character is a newline, we've reached the end of the string
        blt $t0, '0', invalid  			# If the character is less than '0', it's not a digit
        bgt $t0, '9', invalid  			# If the character is greater than '9', it's not a digit
        addi $t1, $t1, 1				# Represents number of digits within the string
        addiu $t6, $t6, 1  				# Move to the next character
        j loop
    # If we've reached here, all characters were digits
    convertString:
        move $t6, $a0
    loop1:
    	lb $t0, 0($t6)    	
    	subi $t0, $t0, '0'
    	move $t5, $t1
    	li $t2, 1
    loop2:
		subi $t5, $t5, 1
    	beqz $t5, endloop2
    	mulu $t2, $t2, 10
    endloop2:
    	mulu $t3, $t0, $t2
    	add $t4, $t4, $t3
    	subi $t1, $t1, 1
    	addi $t6, $t6, 1
    	beqz $t1, endloop1
    	j loop1

    invalid:
        la $a0, invalid_msg  # Load the address of invalid_msg into $a0
        li $v0, 4            # Prepare to call print_string
        syscall              # Call print_string
        li $v0, 99
        jr $ra

    endloop1:
    	move $v0, $t4
        jr $ra


#######################################################################################################################################################
	end:
		lw $t0, numOfNodes
		lw $t1, 0($s0)
		
	deleteNodes:
		beqz $t0, exit
		lw $t2, 8($t1)
		sw $zero, 0($t1)
		sw $zero, 4($t1)
		sw $zero, 8($t1)
		move $t1, $t2
		subi $t0, $t0, 1
		j deleteNodes
		
	exit:
		li $v0, 4
		la $a0, endMsg
		syscall
		
		li $v0, 17
		syscall
		
		
		
		
		
		
		
		
		
		
		
		
		
