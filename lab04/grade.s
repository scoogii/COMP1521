# read a mark and print the corresponding UNSW grade

main:
    la $a0, prompt      # printf("Enter a mark: ");
    li $v0, 4
    syscall

    li $v0, 5           # scanf("%d", mark);
    syscall

    blt $v0, 50, FL     # if mark < 50, goto FL
    blt $v0, 65, PS     # if mark < 65, goto PS         
    blt $v0, 75, CR     # if mark < 75, goto CR
    blt $v0, 85, DN     # if mark < 85, goto DN
    j HD                # else, goto HD

FL:
    la $a0, fl          # get addr of fl
    li $v0, 4           # printf("%s", 'FL\n')
    syscall
    j end

PS:
    la $a0, ps
    li $v0, 4
    syscall
    j end

CR:
    la $a0, cr
    li $v0, 4
    syscall
    j end

DN:
    la $a0, dn
    li $v0, 4
    syscall
    j end

HD:
    la $a0, hd
    li $v0, 4
    syscall
    j end

end:
    li $v0, 0   
    jr $ra              # return 0

    .data
prompt:
    .asciiz "Enter a mark: "
fl:
    .asciiz "FL\n"
ps:
    .asciiz "PS\n"
cr:
    .asciiz "CR\n"
dn:
    .asciiz "DN\n"
hd:
    .asciiz "HD\n"
