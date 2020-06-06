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
        
        # create mask to leave only 8 lower bits of word
        srli    t2, t0, 16
        # save only 8 lower bits of word b 
        and     s1, t4, t2
        # multiply 8 lower bits of word b with entirety of a
        mul     t5, t3, s1

        # create mask to leave only 8 upper bits of word
        slli    t2, t2, 8
        # save only 8 upper bits of word b
        and     s1, t4, t2
        # multiply 8 upper bits of word b with entirety pf a
        mul     t6, t3, s1
        # add result from both multiplication products and save in result register
        add     t6, t6, t5

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


