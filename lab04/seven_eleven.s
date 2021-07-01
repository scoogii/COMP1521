# Read a number and print positive multiples of 7 or 11 < n

main:                   # int main(void) {

    la   $a0, prompt    # printf("Enter a number: ");
    li   $v0, 4
    syscall

    li   $v0, 5         # scanf("%d", number);
    syscall                 

    move $s0, $v0       # $s0 <- $v0 = number   

    li   $t0, 1         # int i = 1;

loop:

    bge  $t0, $s0, end  # if (i >= number) goto end; 

    rem  $t1, $t0, 7    # $t1 = i % 7
    beq  $t1, 0, print  # if remainder = 0, print

    rem  $t2, $t0, 11
    beq  $t2, 0, print

    addi $t0, $t0, 1    # i++;

    j loop

print:

    move $a0, $t0       # load i into $a0 
    li   $v0, 1
    syscall

    li   $a0, '\n'      # printf("%c", '\n');
    li   $v0, 11
    syscall

    addi $t0, $t0, 1
    
    j loop

end:
    li   $v0, 0         
    jr   $ra            # return 0

    .data
prompt:
    .asciiz "Enter a number: "
