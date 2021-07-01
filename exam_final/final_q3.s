# Christian Nguyen - z5310911
# Aug 19 2020
# this code reads 1 integer and prints it
# add code so that prints 1 iff
# the least significant (bottom) byte of the number read
# is equal to the 2nd least significant byte
# and it prints 0 otherwise

main:
    li   $v0, 5     # scanf("%d", &x);
    syscall

    move $s0, $v0   # $s0 = x
    
getLSB:
    li   $t0, 0xFF
    and  $s1, $s0, $t0    # $s1 = $s0 & 0xFF 

getSLSB:
    li   $t1, 8
    srl  $s2, $s0, $t1    # $s2 = $s0 >> SIZE_BYTE
    and  $s2, $s2, $t0    # $s2 = $s2 & 0xFF

checkEqual:
    beq  $s1, $s2, printOne

printZero:
    li   $a0, 0
    b    end

printOne:
    li   $a0, 1
    b    end

end:
    li   $v0, 1
    syscall

    li   $a0, '\n'
    li   $v0, 11
    syscall


    li   $v0, 0
    jr   $ra
