.data
A: .word 15
B: .word 15
C: .word 10
Z: .word 0

finalMsg: 	.ascii "final Z value"

.text

main: 
lw a0, A
lw a1, B
lw a2, C
lw a3, Z

slt t0, a0, a1      # t0 gets 1 if A<B
addi t1, zero, 5    # t1 = 5
slt t1, t1, a2      # t1 gets 1 if 5<C
bne t1, t0, elseif  # if t1 not equal to t0 go to elseif
addi a3, zero, 1
j switch

elseif:

slt t2, a1, a0  # t2 gets 1 if B<A
addi t3, a2, 1  # t3 = C+1
addi t4, zero, -7  # t4 = 7

bne t3, t4, else

beq t2, zero, else  # if t2 = 0 branch
addi a3, zero, 2    # z gets 2
j switch

else:
addi a3, zero, 3  # z gets 3

switch:

addi s2, zero, -1 
addi s3, zero, -2
addi s4, zero, -3

beq a3, s2, break 
beq a3, s3, break
beq a3, s4, break

break:

sw a3, Z, t1
sw a0, A, t1
sw a1, B, t1
sw a2, C, t1



li  a7, 4 			# print prompt string
la  a0, finalMsg
    ecall
    
li  a7, 1 			# print integer
lw  a0, Z 
ecall
    
li a7,10
lw t1, Z
ecall
