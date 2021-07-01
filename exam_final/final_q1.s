# Christian Nguyen - z5310911
# Aug 19 2020
# this code reads 1 integer and prints it
# change it to read 2 integers
# then print their sum

main:
    li   $v0, 5        #   scanf("%d", &x);
    syscall            #
    
    move $s0, $v0      #   $s0 = x

    li   $v0, 5
    syscall

    move $s1, $v0      #   $s1 = y
    
    add  $s2, $s1, $s0 #   $s2 = x + y
    
    move $a0, $s2      #   printf("%d\n", x);
    li   $v0, 1
    syscall

    li   $a0, '\n'     #   printf("%c", '\n');
    li   $v0, 11
    syscall

    li   $v0, 0        # return 0
    jr   $ra
