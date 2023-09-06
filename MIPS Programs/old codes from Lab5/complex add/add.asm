.data 
	a: .word 1
	b: .word 2
	c: .word 0
.text
	lw  $t2,a # a starts in address 0
	lw  $t3,b # b starts in address 4
	add $t4,$t3,$t2
	sw  $t4,c # c starts in address 8
