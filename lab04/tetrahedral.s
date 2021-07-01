# Read a number n and print the first n tetrahedral numbers
# https://en.wikipedia.org/wiki/Tetrahedral_number

main:                           # int main(void) {
    la   $a0, prompt            # printf("Enter how many: ");
    li   $v0, 4
    syscall

    li   $v0, 5                 # scanf("%d", how_many);
    syscall

    move $s0, $v0               # $s0 <- $v0 = how_many

    li $t0, 1                   # int n = 1;

start_loop1:
    bgt  $t0, $s0, end          # if (n > how_many) goto end;  

    li   $s1, 0                 # int total = 0;     
    li   $t1, 1                 # int j = 1;        

start_loop2:
    bgt  $t1, $t0, end_loop2    # if (j > n) goto end_loop2

    li   $t2, 1                 # int i = 1;

start_loop3:
    bgt  $t2, $t1, end_loop3    # if (i > j) goto end_loop3

    add  $s1, $s1, $t2          # total = total + i;
    addi $t2, $t2, 1            # i = i + 1;

    j start_loop3


end_loop3:
    addi $t1, 1                 # j = j + 1;

    j start_loop2

end_loop2:
    move $a0, $s1               # load total into $a0
    li   $v0, 1                 
    syscall                     # printf("%d", total);      

    li   $a0, '\n'              # printf("%c", '\n');
    li   $v0, 11
    syscall

    addi $t0, $t0, 1            # n = n + 1;

    j start_loop1

end:
    li   $v0, 0
    jr   $ra                    # return 0

    .data
prompt:
    .asciiz "Enter how many: "
