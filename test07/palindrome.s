# read a line and print whether it is a palindrom

main:
    la   $a0, str0       # printf("Enter a line of input: ");
    li   $v0, 4
    syscall

    la   $a0, line
    la   $a1, 256
    li   $v0, 8          # fgets(buffer, 256, stdin)
    syscall              #

    move $s0, $a0        # $s0 holds addr of start of line[]

getLengthPrompt:
    li   $t0, 0          # int i = 0;
    add  $s1, $s0, $t0   # $s1 holds addr of line[i]
    lb   $s2, ($s1)      # $s2 = line[i]

getStringLength:
    beqz $s2, loopCheckPrompt

    addi $t0, $t0, 1
    add  $s1, $s0, $t0
    lb   $s2, ($s1)

    b    getStringLength

loopCheckPrompt:
    li   $t1, 0          # int j = 0;
    sub  $t2, $t0, 2     # int k = i - 2;

loopCheck:
    bge  $t1, $t2, isPalindrome

    add  $s3, $s0, $t1   # addr of line[j]
    add  $s4, $s0, $t2   # addr of line[k]

    lb   $t3, ($s3)      # line[j]
    lb   $t4, ($s4)      # line[k]

    bne  $t3, $t4, notPalindrome

    addi $t1, $t1, 1
    sub  $t2, $t2, 1

    b    loopCheck

notPalindrome:
    la   $a0, not_palindrome
    li   $v0, 4
    syscall

    b    end

isPalindrome:
    la   $a0, palindrome
    li   $v0, 4
    syscall

end:
    li   $v0, 0          # return 0
    jr   $31


.data
str0:
    .asciiz "Enter a line of input: "
palindrome:
    .asciiz "palindrome\n"
not_palindrome:
    .asciiz "not palindrome\n"


# line of input stored here
line:
    .space 256

