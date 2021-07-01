# read a number n and print the integers 1..n one per line

main:                   # int main(void)
    la  $a0, prompt     # printf("Enter a number: ");
    li  $v0, 4
    syscall

    li  $v0, 5          # scanf("%d", number);
    syscall

    move $s1, $v0       # $s1 = $v0
    li $s0, 1           # let i = 1;

loop:
    bgt $s0, $s1, end   # if (i > number) goto end

    move $a0, $s0       
    li $v0, 1           
    syscall             # printf("%d", i);
    
    li   $a0, '\n'      # printf("%c", '\n');
    li   $v0, 11
    syscall

    add $s0, $s0, 1     # i++;

    j   loop            # goto loop;
    
end:
    li $v0, 0           
    jr  $ra             # return 0;

    .data
prompt:
    .asciiz "Enter a number: "
