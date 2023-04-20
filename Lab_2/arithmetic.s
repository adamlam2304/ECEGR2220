.data
Z: .word 0       # integer word to store final result
test: .asciiz"Z="

.text
.globl main
main:
    # initialize variables A, B, C, D, E, F
    li a0, 15    # A=15
    li a1, 10    # B=10
    li a2, 5     # C=5
    li a3, 2     # D=2
    li a4, 18    # E=18
    li a5, -3    # F=-3

    # perform arithmetic operations
    sub s0, a0, a1  # t0 = A - B
    
    mul s1, a2, a3  # t1 = C * D
    
    sub s2, a4, a5  # t2 = E - F
    
    divu s3, a0, a2  # t3 = A / C
    
    add s4, s0, s1  # t4 = (A - B) + (C * D)
    add s5, s4, s2  # t4 = (A - B) + (C * D)+ (E - F)  
    sub s6, s5, s3  # t4 = (A - B) + (C * D)+ (E - F) - (A / C) 

    # store final result in memory
    sw s6, Z, s7

    # exit program
    li a7, 10    # exit syscall code for exit success
    ecall       # exit program
