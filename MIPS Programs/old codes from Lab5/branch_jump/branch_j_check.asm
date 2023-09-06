.data 
	a: .word 0
	b: .word 4
	c: .word 0
.text
		lw   $t2,a # a starts in address 0
		lw   $t3,b # b starts in address 4
		lw   $t4,c
L:		beq  $t2,$t3,end
change:		addi $t4,$t4,1	# increment counter counter
		addi $t2,$t2,1	
		addi $t3,$t3,-1
		bne  $t2,$t3,change
		j    L
end:		sw   $t4,c 
	
