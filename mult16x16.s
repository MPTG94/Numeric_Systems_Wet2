# Operands to multiply
.data
a: .word 0xBAD
b: .word 0xFEED

.text
main:   # Load data from memory
		la      t3, a
        lw      t3, 0(t3)
        la      t4, b
        lw      t4, 0(t4)
        
        # t6 will contain the result
        add		t6, x0, x0

        # Mask for 16x8=24 multiply
        ori		t0, x0, 0xff
        slli	t0, t0, 8
        ori		t0, t0, 0xff
        slli	t0, t0, 8
        ori		t0, t0, 0xff
        
####################
# Start of your code
        
        # create mask to keep only 8 lower bits of word
        addi    t1, x0, 0xFF
        # save only 8 lower bits of a to t2
        and     t2, t1, t3
        # multiply 8 lower bits of a with total b
        mul     s1, t4, t2
        # keep only lower 24 bits of result
        and     s1, s1, t0
        
        # create mask to keep only 8 upper bits of word
        slli    t1, t1, 8
        # save only 8 upper bits of a to t2
        and     t2, t1, t3
        # shift 8 upper bits of a to the right and save in t2
        srli    t2, t2, 8
        # multiply 8 upper bits of a with total b
        mul     s2, t4, t2
        # keep only lower 24 bits of result
        and     s2, s2, t0
        # shift result of upper a and b to the left 8 bits and save in s2
        slli    s2, s2, 8
        # add 2 results of multiplication and save in t6
        add     t6, s1, s2

# Use the code below for 16x8 multiplication
#   mul		<PROD>, <FACTOR1>, <FACTOR2>
#   and		<PROD>, <PROD>, t0

# End of your code
####################
		
finish: addi    a0, x0, 1
        addi    a1, t6, 0
        ecall # print integer ecall
        addi    a0, x0, 10
        ecall # terminate ecall


