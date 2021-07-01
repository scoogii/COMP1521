############################################
# Calculating Arbitrarily Large Factorials #
############################################
# Christian Nguyen - z5310911
# July 13, 2020


## Text segment
    .text
    ## REGISTERS USED
    # $s0 is num
    # $s1 for address of start of res[]

########################################################################
main:

main__prol:
    sw        $ra, -4($sp)
    addiu     $sp, $sp, -4

displayPrompt:
    la        $a0, prompt
    li        $v0, 4
    syscall

readNum:
    li        $v0, 5
    syscall                 # read int

    move      $s0, $v0      # $s0 = num

    move      $a0, $s0
    li        $v0, 1
    syscall                 # %d

    la        $a0, factState
    li        $v0, 4
    syscall                 # %d! = 

callFact:
    move      $a0, $s0  
    jal       big_factorial 

main__epi:
    li        $a0, '\n'
    li        $v0, 11
    syscall

    addiu     $sp, $sp, 4
    lw        $ra, -4($sp)

    jr        $ra

########################################################################

big_factorial:
# $s0 = x
# $s1 for address of start of res[]
# $s2 = n
# $s3 = res_size

# $t0 = i

bf__prol:
    sw        $ra, -4($sp)
    sw        $s0, -8($sp)
    addiu     $sp, $sp, -8

    move      $s2, $a0

bf_init:
    la        $s1, res
    li        $t0, 1
    sb        $t0, ($s1)                  # res[0] = 1
  
    li        $s3, 1                      # res_size = 1
    li        $s0, 2                      # int x = 2

bf_loop1:
    bgt       $s0, $s2, bf_loop2Prompt

    move      $a0, $s0
    move      $a1, $s1
    move      $a2, $s3

    jal       multiply

    move      $s3, $v0                    # res_size = multiply(...)
    
    addi      $s0, $s0, 1
    b         bf_loop1

bf_loop2Prompt:
    sub       $t0, $s3, 1                 # i = res_size - 1

bf_loop2:
    bltz      $t0, bf__epi

    add       $t1, $s1, $t0               # addr of res[i]

    lb        $a0, ($t1)
    li        $v0, 1
    syscall                               # printf("%d", res[i]);

    sub       $t0, $t0, 1
    b         bf_loop2

bf__epi:
    addiu     $sp, $sp, 8
    lw        $ra, -4($sp)
    lw        $s0, -8($sp)

    jr        $ra

########################################################################

multiply:
# $a0 = x
# $a1 = res[]
# $a2 = res_size
# $s0 = i
# $s4 = carry 
# $s5 = prod

m__prol:
    sw        $ra, -4($sp)
    sw        $s0, -8($sp)
    addiu     $sp, $sp, -8

m_init:
    li        $s4, 0                       # int carry = 0;

m_loop1Prompt:
    li        $s0, 0                       # int i = 0;

m_loop1:
    bge       $s0, $a2, m_loop2

    add       $t0, $a1, $s0                # addr of res[i]
    lb        $t1, ($t0)                   # $t1 = res[i]

    mul       $s5, $t1, $a0                # prod = res[i] * x;
    add       $s5, $s5, $s4                # prod = " " + carry;

    li        $t2, 10
    rem       $t1, $s5, $t2                # $t1 = prod % 10
    sb        $t1, ($t0)                   # res[i] = prod % 10;

    div       $s4, $s5, $t2                # carry = prod / 10;

    addi      $s0, $s0, 1
    b         m_loop1

m_loop2:
    beqz      $s4, m__epi

    rem       $t1, $s4, $t2                # carry % 10

    add       $t3, $a1, $a2                # addr of res[res_size]
    sb        $t1, ($t3)
     
    div       $s4, $s4, $t2

    addi      $a2, $a2, 1
    b         m_loop2

m__epi:
    addiu     $sp, $sp, 8
    lw        $ra, -4($sp)
    lw        $s0, -8($sp)


    move      $v0, $a2
    jr        $ra



## Data
    .data
prompt:
    .asciiz "Enter n: "

res:
    .space 400

factState:
    .asciiz "! = "