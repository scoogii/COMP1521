# x in register $t0
# i in register $t1
# n_seen in register $t2
# registers $t3 and $s0 used to hold temporary results
main:
    li        $t2, 0               # n_seen = 0;
    la        $s0, numbers         # addr of numbers

start:
    bge       $t2, 10, end         # while (n_seen < 10) {
    la        $a0, string0         # printf("Enter a number: ");
    li        $v0, 4
    syscall

    li        $v0, 5               # scanf("%d", &x);
    syscall

    move      $t0, $v0             # $t0 = x

loopReadPrompt:
    li        $t1, 0               # int i = 0;

loopRead:
    bge       $t1, $t2, checkEqual # if (i >= n_seen) goto checkEqual

checkSame:
    mul       $t3, $t1, 4          # calculate &numbers[i]
    add       $t3, $t3, $s0        # addr of numbers[i]
    lw        $t5, ($t3)           # $t5 = numbers[i]
    
    beq       $t0, $t5, checkEqual # if (x == numbers[i]) goto end;

    addi      $t1, $t1, 1
    b         loopRead

checkEqual:
    beq       $t1, $t2, store      # if (i == n_seen) goto store

    b         start

store:
    mul       $t3, $t2, 4          # calculate &numbers[n_seen]   
    add       $t3, $t3, $s0        # addr of numbers[n_seen]
    sw        $t0, ($t3)           # numbers[n_seen] = x

    add       $t2, $t2, 1          # n_seen++;
    b         start

end:
    la        $a0, string1         # printf("10th different number was: ");
    li        $v0, 4
    syscall

    move      $a0, $t0             # printf("%d", x)
    li        $v0, 1
    syscall

    li        $a0, '\n'            # printf("%c", '\n');
    li        $v0, 11
    syscall

    li        $v0, 0               # return 0
    jr        $31

    .data

numbers:
    .space 40                      # int numbers[10];

string0:
    .asciiz "Enter a number: "
string1:
    .asciiz "10th different number was: "
