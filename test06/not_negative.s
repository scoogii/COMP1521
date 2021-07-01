#  read numbers until a non-negative number entered
# x in $t0
main:

init:
    li        $s0, 1
    li        $s1, 1
loopCond:
    beq       $s0, $s1, loop

loop:
    la        $a0, str0         # printf("Enter a number: ");
    li        $v0, 4
    syscall

    li        $v0, 5            # scanf("%d", &x);
    syscall              
    move      $t0, $v0

loopIf:
    bgez      $t0, loopElse

    la        $a0, strNeg
    li        $v0, 4
    syscall
    
    b         loop

loopElse:
    la        $a0, str1         # printf("You entered: ");
    li        $v0, 4
    syscall

    move      $a0, $t0          # printf("%d", x);
    li        $v0, 1

    syscall
    li        $a0, '\n'         # printf("%c", '\n');
    li        $v0, 11

    b         end 

end:
    syscall
    li        $v0, 0            # return 0
    jr        $31

.data
str0:
    .asciiz "Enter a number: "
str1:
    .asciiz "You entered: "
strNeg:
    .asciiz "Enter a positive number\n"