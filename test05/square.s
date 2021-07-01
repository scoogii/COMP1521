main:
    li $v0, 5           #   scanf("%d", &x);
    syscall             #
    move $t0, $v0

outerLoopInit:
    li      $s0, 0         # int i = 0;

outerLoop:
    bge     $s0, $t0, end 

    li      $s1, 0          # int j = 0;

nestedLoop:
    bge     $s1, $t0, outerLoopStep

    li      $a0, '*'
    li      $v0, 11
    syscall

    addi    $s1, $s1, 1

    b       nestedLoop

outerLoopStep:
    addi    $s0, $s0, 1
    
    li      $a0, '\n'
    li      $v0, 11
    syscall

    b       outerLoop

end:

    li $v0, 0           # return 0
    jr $31
