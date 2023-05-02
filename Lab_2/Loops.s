.data 

Z: .word 2
i: .word 0

finalMsg: 	.ascii "final Z value"

.text

main:

lw a0, Z
lw a1, i

forloop:
slti t1, a1, 21 # t1 gets 1 if i < 21
beq t1, zero, doloop # check if t1 is 0, then jump to doloop
addi a0, a0, 1 #increment z by one
addi a1, a1, 2 # increments i by 2

j forloop

doloop:
addi t2, zero, 100 # setting a limit of 100
addi a0, a0, 1 # increment z by one
beq a0, t2, whileloop # Breaks out of loop if z = 100

j doloop

whileloop:
addi a0, a0, -1 # decrease of Z by 1
addi a1, a1, -1 # decrese of i by 1
beq a1, zero, end # ends the program when i = 0

j whileloop

end:
sw a0, Z, a4 # stores contents of a4 into the memory address of Z

li  a7, 4 			# print prompt string
la  a0, finalMsg
    ecall
    
    li  a7, 1 			# print integer
    lw  a0, Z 
    ecall
    
li a7,10
lw t1, Z
ecall