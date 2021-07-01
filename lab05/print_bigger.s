# Read 10 numbers into an array
# then print the numbers which are
# larger than the last number read.

# i in register $t0
# registers $t1, $t2 & $t3 used to hold temporary results

main:

    li $t0, 0                   # i = 0
read:
    bge $t0, 10, printPrompt    # while (i < 10) {

    li $v0, 5                   # scanf("%d", &numbers[i]);
    syscall                     #

    mul $t1, $t0, 4             # calculate &numbers[i]
    la $t2, numbers                
    add $t3, $t1, $t2  
             
    sw $v0, ($t3)               # store entered number in array
    move $s0, $v0


    add $t0, $t0, 1             # i++;
    b read                      # }

printPrompt:
    li $t0, 0                   # i = 0

printLoop:
    bge $t0, 10, end            # while (i < 10) {

    mul $t1, $t0, 4             # calculate &numbers[i]
    la  $t2, numbers            # load array
    add $t3, $t1, $t2           # offset

    lw   $s1, ($t3)             # load array value into $s1
    move $a0, $s1               # pass array value into argument    

    bge $s1, $s0, validPrint    # if (numbers[i] >= last_number) goto validPrint

    add $t0, $t0, 1             # i++
    b printLoop                 # }

validPrint:
    li $v0, 1                   # print out array value
    syscall

    li   $a0, '\n'              # printf("%c", '\n');
    li   $v0, 11
    syscall

    addi $t0, $t0, 1

    b printLoop

end:
    jr $31                      # return


.data

numbers:
    .word 0 0 0 0 0 0 0 0 0 0  # int numbers[10] = {0};

