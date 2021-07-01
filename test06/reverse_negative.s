# Read numbers into an array until a negative number is entered
# then print the numbers in reverse order

# i in register $t0
# registers $t1, $t2 & $t3 used to hold temporary results

main:
    li        $t0, 0                        # i = 0
loop:
    bge       $t0, 1000, print              # while (i < 1000) {

    li        $v0, 5                        # scanf("%d", &numbers[i]);
    syscall             

loopIf:
    bgez      $v0, loopElse

    b         print

loopElse:
    mul       $t1, $t0, 4                   # calculate &numbers[i]
    la        $t2, numbers          
    add       $t3, $t1, $t2   
    sw        $v0, ($t3)                    # store entered number in array

    add       $t0, $t0, 1                   # i++;
    b         loop                          # }

print:
    blez      $t0, end

    addi      $t0, $t0, -1

    lw        $a0, ($t3)
    li        $v0, 1
    syscall

    li        $a0, '\n'
    li        $v0, 11
    syscall

    addi      $t3, $t3, -4
    b         print

end:
    li        $v0, 0                        # return 0
    jr        $31                    

.data
numbers:
    .space 4000
