# Christian Nguyen - z530911
# Aug 19 2020
# this code reads a line of input and prints 42
# change it to evaluate the arithmetic expression

main:
# $s0 = &line[]
# $s1 = s 
##########################################################################
main_prol:
    sw        $fp, -4($sp)
    sw        $ra, -8($sp)
    la        $fp, -4($sp)
    addiu     $sp, $sp, -8

main_init:
    la        $a0, line
    la        $a1, 10000
    li        $v0, 8          # fgets(buffer, 10000, stdin)
    syscall                   #
      
    move      $s0, $a0        # $s0 = &line[]
    la        $s1, line       # s = line 
    
    jal       expression
    
    move      $a0, $v0       
    li        $v0, 1
    syscall                   # printf("%d", expression());
    
    li        $a0, '\n'       # printf("%c", '\n');
    li        $v0, 11
    syscall

main_epi:
    lw        $ra, -4($fp)
    lw        $fp, ($fp)  
    li        $v0, 0          # return 0
    jr        $31


.data
line:
    .space 10000



##########################################################################
#    F       U       N       C       T       I       O       N       S   #
##########################################################################

expression:
##########################################################################
exp_prol:
    sw        $fp, -4($sp)
    sw        $ra, -8($sp)
    la        $fp, -4($sp)
    addiu     $sp, $sp, -8

exp_main:
    jal       term
    
    move      $t1, $v0        # int left = term();

exp_condition:
    bne       ($s1), '+', returnRight

returnLeft:
    add       $v0, $v0, $0
    b         exp_epi

returnRight:
    addi      $s1, $s1, 4    # s++;
        

exp_epi:
    lw        $ra, -4($fp)
    lw        $fp, ($fp) 
##########################################################################



term:
##########################################################################
term_prol:
    sw        $fp, -4($sp)
    sw        $ra, -8($sp)
    la        $fp, -4($sp)
    addiu     $sp, $sp, -8

term_main:
    jal       number

term_epi:
    lw        $ra, -4($fp)
    lw        $fp, ($fp)    
##########################################################################



number:
##########################################################################
number_prol:
    sw        $fp, -4($sp)
    sw        $ra, -8($sp)
    la        $fp, -4($sp)
    addiu     $sp, $sp, -8

number_main:
    li        

number_epi:
    lw        $ra, -4($fp)
    lw        $fp, ($fp)    
