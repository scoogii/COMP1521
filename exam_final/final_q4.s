# this code reads 1 integer and prints it
# change it to read integers until their sum is >= 42
# and then print their sum

# '#defines'
CONDITION = 42

main:
    li   $s0, 0               # int sum = 0

loop:
    bge  $s0, CONDITION, printSum 

    li   $v0, 5               #   scanf("%d", &x);
    syscall                   #

    move $t0, $v0             # $t0 = x
    add  $s0, $s0, $t0        # sum = sum + x;
    
    b loop

printSum:
    move $a0, $s0             #   printf("%d\n", x);
    li   $v0, 1
    syscall

    li   $a0, '\n'            #   printf("%c", '\n');
    li   $v0, 11
    syscall

end:
    li   $v0, 0               # return 0
    jr   $ra
