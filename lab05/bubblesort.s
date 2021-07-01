# read 10 numbers into an array
# bubblesort them
# then print the 10 numbers

# i in register $t0
# registers $t1, $t2 & $t3 used to hold temporary results

# $s0 


main:

    li $t0, 0                           # i = 0
Scan:
    bge $t0, 10, Loop1Prompt            # while (i < 10) {

    li $v0, 5                           #   scanf("%d", &numbers[i]);
    syscall                             #

    mul $t1, $t0, 4                     #   calculate &numbers[i]
    la $t2, numbers                     #
    add $t3, $t1, $t2                   #
    sw $v0, ($t3)                       #   store entered number in array

    add $t0, $t0, 1                     #   i++;
    b Scan                              # }

Loop1Prompt:
    li  $s0, 1                          # int swapped = 1;

Loop1:
    beq $s0, 0, PrintPrompt             # if (swapped = 0) goto PrintPrompt
    
    li  $s0, 0                          # swapped = 0;
    li  $t0, 1                          # i = 1;

    j Loop2

Loop2:
    bge     $t0, 10, Loop1              # if (i >= 10) goto Loop1

    mul     $t1, $t0, 4                 # calculating &numbers[i]
    add     $s1, $t1, $t2               # &numbers[i] (x)

    addi    $t4, $t0, -1                # i - 1
    mul     $t1, $t4, 4                 # calculating &numbers[i-1]
    add     $s2, $t1, $t2               # &numbers[i-1] (y)

    lw      $s3, ($s1)
    lw      $s4, ($s2)                    
    blt     $s3, $s4, Swap              # if (x < y) goto Swap;

    addi    $t0, $t0, 1       

    j Loop2

Swap:
    # move    $t5, $s3                    # temp1 = numbers[i]
    # move    $t6, $s4                    # temp2 = numbers[i-1]

    sw      $s4, ($s1)                  # numbers[i-1] -> &numbers[i]
    sw      $s3, ($s2)                  # numbers[i] -> &numbers[i-1]

    li      $s0, 1
    addi    $t0, $t0, 1

    j Loop2

PrintPrompt:
    li      $t0, 0

Print:
    bge $t0, 10, End                    # while (i < 10) {

    mul $t1, $t0, 4                     #   calculate &numbers[i]
    la $t2, numbers                     #
    add $t3, $t1, $t2                   #
    lw $a0, ($t3)                       #   load numbers[i] into $a0
    li $v0, 1                           #   printf("%d", numbers[i])
    syscall

    li   $a0, '\n'                      #   printf("%c", '\n');
    li   $v0, 11
    syscall

    add $t0, $t0, 1                     #   i++
    b Print                             # }

End:

    jr $ra                              # return

.data

numbers:
    .word 0 0 0 0 0 0 0 0 0 0           # int numbers[10] = {0};

