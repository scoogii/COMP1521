# Read 10 numbers into an array
# print 0 if they are in non-decreasing order
# print 1 otherwise

# i in register $t0
# $s1 is &numbers[i] -> $s3 is the value
# $s2 is &numbers[i-1] -> $s4 is the value

main:

    li $t0, 0                   # i = 0
loop0:
    bge $t0, 10, loop1Prompt    # while (i < 10) {

    li $v0, 5                   # scanf("%d", &numbers[i]);
    syscall                     #

    mul $t1, $t0, 4             # calculate &numbers[i]
    la $t2, numbers             #
    add $t3, $t1, $t2           #
    sw $v0, ($t3)               # store entered number in array

    add $t0, $t0, 1             # i++;
    b loop0                     # }

loop1Prompt:
    li  $t0, 1                  # i = 1;
    li  $s0, 0                  # int swapped = 0;

loop1:
    bge  $t0, 10, end            # if (i >= 10) goto end;        

    mul  $t1, $t0, 4             # calculate &numbers[i]
    add  $s1, $t1, $t2           # &numbers[i]

    addi $t4, $t0, -1            # calculating (i - 1)
    mul  $t1, $t4, 4             # calculate &numbers[i-1]
    add  $s2, $t1, $t2           # &numbers[i-1]      

    lw   $s3, ($s1)              # load numbers[i] = x
    lw   $s4, ($s2)              # load numbers[i-1] = y

    blt  $s3, $s4, fail

    addi $t0, $t0, 1             # i++;

    j loop1


fail:
    addi $s0, $s0, 1             # swapped = 1;
    
end:
    move   $a0, $s0                # $v0 <- $s0
    li   $v0, 1                  # printf("%d", swapped);
    syscall

    li   $a0, '\n'               # printf("%c", '\n');
    li   $v0, 11
    syscall

    li   $v0, 0
    jr   $ra

.data

numbers:
    .word 0 0 0 0 0 0 0 0 0 0  # int numbers[10] = {0};

