# Christian Nguyen - z5310911
# Aug 19 2020
# this code reads 1 integer and prints it
# change it to read integers until their sum is >= 42
# and then print theintgers read in reverse order

main:

# '#defines'
CONDITION = 42

init:
    li   $t0, 0        # int i = 0;
    li   $s0, 0        # int sum = 0;

loop0:
    bge  $s0, CONDITION, loop1

    li   $v0, 5        #   scanf("%d", &x);
    syscall            #
    
    move $t1, $v0      #   $t1 = x

    la   $t9, numbers  #   $t9 = &numbers
    mul  $t2, $t0, 4   #   offset = i * SIZE_INT
    add  $t3, $t9, $t2 #   $t3 = &numbers[i] 
    sw   $t1, ($t3)    #   numbers[i] = x;

    addi $t0, $t0, 1   #   i++;
    add  $s0, $s0, $t1 #   sum += x;
        
    b    loop0

loop1:
    ble  $t0, 0, end
    
    addi $t0, $t0, -1  # i--;

    mul  $t2, $t0, 4   # offset = i * SIZE_INT
    add  $t3, $t9, $t2 # $t3 = &numbers[i]

    lw   $a0, ($t3)    # $a0 = numbers[i]
    li   $v0, 1
    syscall

    li   $a0, '\n'     #   printf("%c", '\n');
    li   $v0, 11
    syscall

    b loop1

end:
    li   $v0, 0        # return 0
    jr   $ra

.data

numbers:
    .space 1000
