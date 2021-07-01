# Sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes

# $s0, $s1 are loop counters
# $t0 addr of start of array prime
# $t1 and $t2 used for calculations

MAX = 1000

main:
    li      $s0, 0                          # int i = 0;

Loop1:
    bge     $s0, 1000, Loop2Prompt          # if (i >= 1000) goto Loop2Prompt;

    la      $t0, prime                      # addr of prime[0]
    add     $t1, $t0, $s0                   # $t1 = prime[i]

    li      $t2, 1
    sb      $t2, ($t1)                      # prime[i] = 1;      

    addi    $s0, $s0, 1
    
    b       Loop1 

Loop2Prompt:
    li      $s0, 2                          # i = 2;
    
Loop2Outer:
    bge     $s0, 1000, End                  # if (i >= 1000) goto End;

    add     $t1, $t0, $s0                   # addr of prime[i]
    lb      $t2, ($t1)                      # $t2 = prime[i] 

    mul     $s1, $s0, 2                     # int j = 2 * i

    bnez    $t2, printNum                   # if (prime[i] != 0) goto printNum;

Loop2Nested:
    bge     $s1, 1000, Loop2Step            # if (j >= 1000) goto Loop2Step;

    add     $t1, $t0, $s1
    li      $t2, 0
    sb      $t2, ($t1)                      # prime[j] = 0;

    add     $s1, $s1, $s0                   # j = j + i;

    b       Loop2Nested

Loop2Step:
    addi    $s0, $s0, 1

    b       Loop2Outer

printNum:
    move    $a0, $s0
    li      $v0, 1
    syscall

    li      $a0, '\n'
    li      $v0, 11
    syscall

    b       Loop2Nested

End:
    li      $v0, 0                          # return 0
    jr      $31

.data
prime:
    .space MAX