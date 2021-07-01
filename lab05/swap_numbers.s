# read 10 numbers into an array
# swap any pairs of of number which are out of order
# then print the 10 numbers

# i in register $t0,
# registers $t1 - $t3 used to hold temporary results

main:

    li $t0, 0                   # i = 0
loop0:
    bge $t0, 10, Loop1Prompt    # while (i < 10) {

    li $v0, 5                   #   scanf("%d", &numbers[i]);
    syscall                     #

    mul $t1, $t0, 4             #   calculate &numbers[i]
    la $t2, numbers             #
    add $t3, $t1, $t2           #
    sw $v0, ($t3)               #   store entered number in array

    add $t0, $t0, 1             #   i++;
    b loop0                     # }

Loop1Prompt:
    li  $t0, 1

Loop1:
    bge $t0, 10, beforePrint

    mul  $t1, $t0, 4             # calculate &numbers[i]
    add  $s1, $t1, $t2           # &numbers[i] (x)

    addi $t4, $t0, -1            # calculating (i - 1)
    mul  $t1, $t4, 4             # calculate &numbers[i-1]
    add  $s2, $t1, $t2           # &numbers[i-1] (y)

    lw   $s3, ($s1)              # numbers[i] = x;
    lw   $s4, ($s2)              # numbers[i-1] = y;

    blt  $s3, $s4, Swap

    addi $t0, $t0, 1

    j Loop1

Swap:
    move   $t5, $s3               # temp1 = numbers[i]
    move   $t6, $s4               # temp2 = numbers[i-1]

    sw     $t6, ($s1)             # temp2 -> x
    sw     $t5, ($s2)             # temp1 -> y
    
    addi   $t0, $t0, 1

    j Loop1

beforePrint:
    li $t0, 0

Print:
    bge $t0, 10, End            # while (i < 10) {

    mul $t1, $t0, 4             #   calculate &numbers[i]
    la $t2, numbers             #
    add $t3, $t1, $t2           #
    lw $a0, ($t3)               #   load numbers[i] into $a0
    li $v0, 1                   #   printf("%d", numbers[i])
    syscall

    li   $a0, '\n'              #   printf("%c", '\n');
    li   $v0, 11
    syscall

    add $t0, $t0, 1             #   i++
    j Print                     # }

End:

    jr $ra              # return

.data

numbers:
    .word 0 0 0 0 0 0 0 0 0 0  # int numbers[10] = {0};

