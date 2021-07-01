# Reads instructions as signed decimal integers 
# until it reads the value 1
main:
    
    la   $a0, prompt_start
    li   $v0, 4
    syscall   

    la   $t0, dynamic_code          # loading address with 4096 bytes

read:
    li   $v0, 5
    syscall                         # scanf instruction into $v0

    beq  $v0, -1, before_execute    # when -1, stop reading

    sw   $v0, ($t0)                 # store input into ith index of array
    addi $t0, $t0, 4
    
    j read
                    
before_execute:
    li   $v0, 65011720              # same instruction as jr $ra
    sw   $v0, ($t0)                 # return instruction as last element

    la   $a0, prompt_execute    
    li   $v0, 4
    syscall

    move $s0, $ra                   # save addr to use after jal 

    la	 $t0, dynamic_code          # start from beginning of array
    
start_execute:
    jal  $t0

end:
    la   $a0, finish               
    li   $v0, 4
    syscall

    li   $v0, 0                     # return saved addr
    jr   $s0

dynamic_code:
    .space 4096


    .data
prompt_start:
    .asciiz "Enter mips instructions as integers, -1 to finish:\n"

prompt_execute:
    .asciiz "Starting executing instructions\n"   

finish:
    .asciiz "Finished executing instructions\n"
