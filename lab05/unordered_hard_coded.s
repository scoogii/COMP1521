# Read 10 numbers into an array
# print 0 if they are in non-decreasing order
# print 1 otherwise

# i in register $t0

main:

# for debugging purposes skip reading the numbers in
# and use the values the array has been initialized to

#    li $t0, 0           # i = 0
#loop0:
#    bge $t0, 10, end0   # while (i < 10) {
#
#    li $v0, 5           #   scanf("%d", &numbers[i]);
#    syscall             #
#
#    mul $t1, $t0, 4     #   calculate &numbers[i]
#    la $t2, numbers     #
#    add $t3, $t1, $t2   #
#    sw $v0, ($t3)       #   store entered number in array
#
#    add $t0, $t0, 1     #   i++;
#    b loop0             # }
#end0:


    # PUT YOUR CODE HERE


    li $a0, $42         # printf("%d", 42)
    li $v0, 1           #
    syscall

    li   $a0, '\n'      # printf("%c", '\n');
    li   $v0, 11
    syscall

    jr $31

.data

numbers:
#    .word 0 0 0 0 0 0 0 0 0 0  # int numbers[10] = {0};
    .word 1 0 2 3 4 5 6 7 8 9  # int numbers[10] = {1,0,2,3,4,5,6,7,8,9};
