# Recursive factorial function
# n < 1 yields n! = 1
# $s0 is used for n
# we use an s register because the convention is their value
# is preserved across function calls
# f is in $t0

# DO NOT CHANGE THE CODE IN MAIN

main:
    addi $sp, $sp, -8  # create stack frame
    sw   $ra, 4($sp)   # save return address
    sw   $s0, 0($sp)   # save $s0

    li   $s0, 0
    la   $a0, msg1
    li   $v0, 4
    syscall            # printf(Enter n: ")

    li    $v0, 5
    syscall            # scanf("%d", &n)
    move  $s0, $v0

    move  $a0, $s0     # factorial(n)
    jal   factorial    #
    move  $t0, $v0     #

    move  $a0, $s0
    li    $v0, 1
    syscall            # printf ("%d", n)

    la    $a0, msg2
    li    $v0, 4
    syscall            # printf("! = ")

    move  $a0, $t0
    li    $v0, 1
    syscall            # printf ("%d", f)

    li   $a0, '\n'     # printf("%c", '\n');
    li   $v0, 11
    syscall

                       # clean up stack frame
    lw   $s0, 0($sp)   # restore $s0
    lw   $ra, 4($sp)   # restore $ra
    addi $sp, $sp, 8   # restore sp

    li  $v0, 0         # return 0
    jr  $ra

    .data
msg1:   .asciiz "Enter n: "
msg2:   .asciiz "! = "


# DO NOT CHANGE CODE ABOVE HERE
    .text
    # $s0 is n
factorial:

f__prol:
	sw 		$fp, -4($sp)
    sw      $s0, -12($sp)							
	sw 		$ra, -8($sp)							
	la 		$fp, -4($sp)								
	addiu 	$sp, $sp, -12

f_cond:
    ble     $a0, 1, f_resultElse        # if (n <= 1) goto else statement

f_recursion:
    move    $s0, $a0                    # $s0 = n, n - 1...etc.        
    sub     $a0, $a0, 1                 # $a0 = (n - 1), (n - 2)...etc.

    jal     factorial                   # factorial(n-1)...etc.
 
    mul     $v0, $s0, $v0               # result = n * factorial(n - 1)

    b       f__epi

f_resultElse:
    li      $v0, 1                      # result = 1 when n <= 1

f__epi:
    lw      $s0, -8($fp)
    lw 		$ra, -4($fp) 								
	lw 		$fp, ($fp) 								
	addiu 	$sp, $sp, 12		

    jr  $ra
