########################################################################
# COMP1521 20T2 --- assignment 1: a cellular automaton renderer        #    
#                                                                      #
# Written by Christian nguyen, July 2020.                              #
########################################################################

# Maximum and minimum values for the 3 parameters.

MIN_WORLD_SIZE    =    1
MAX_WORLD_SIZE    =  128
MIN_GENERATIONS    = -256
MAX_GENERATIONS    =  256
MIN_RULE    =    0
MAX_RULE    =  255

# Characters used to print alive/dead cells.

ALIVE_CHAR    = '#'
DEAD_CHAR    = '.'

# Maximum number of bytes needs to store all generations of cells.

MAX_CELLS_BYTES    = (MAX_GENERATIONS + 1) * MAX_WORLD_SIZE

    .data

# `cells' is used to store successive generations.  Each byte will be 1
# if the cell is alive in that generation, and 0 otherwise.

cells:    .space MAX_CELLS_BYTES

# Some strings you'll need to use:

prompt_world_size:    .asciiz "Enter world size: "
error_world_size:    .asciiz "Invalid world size\n"
prompt_rule:        .asciiz "Enter rule: "
error_rule:        .asciiz "Invalid rule\n"
prompt_n_generations:    .asciiz "Enter how many generations: "
error_n_generations:    .asciiz "Invalid number of generations\n"

    .text
    ########################################################################
    ### REGISTERS
    # Frame: $fp, $sp, $ra
    # Uses: $a0, $a1, $a2, $s0, $s1, $s2, $s3, $s4, $s5, $t0, $t1, $t2, $t3
    # Clobbers: $a0, $a1
    
    ### More Specifically...
    ## Pointers:
    #
    # $sp: points at the 'top' of the stack and moved whenever registers needed to be saved (e.g. $ra). Initially points at '7ffffb6c'  
    # $fp: points at the 'bottom' of the stack and helps restore registers saved to the stack. Initially points at '0'
    #
    ## Saved Registers:
    #
    # $s0: world_size, passed as an argument into run_generation and print_generation
    # $s1: rule, passed as an argument into run_generation to determine state of next gen's cells
    # $s2: n_generations, passed as an argument into print_generation to print n generations (normal or reverse depending on sign)
    # $s3: reverse, used to check whether to print generations in reverse or normally (negative being reverse printed)
    # $s4: g, a loop counter used in main's run_generation and print_generation loops
    # $s5: address of start of 2D array cells (cells[0][0]), used as reference to find other array indexes. Each element is is a byte in size
    #
    ## Temporary Registers:
    #
    # $t0: used to find row offset for 1st generation's cell
    # $t1: used to find col. offset for 1st generation's cell
    # $t2: holds array address of the 1st alive gen cell
    # $t3: is the value of the 1st alive gen cell, 1
    #
    ## Arguments:
    #
    # $a0: used for syscalls and passing registers to functions 
    # $a1: "    "
    # $a2: "    "
    # Max arguments passed to function(s) were 3 so no arguments were needed to be saved to the stack
    ########################################################################
                            
                                            

main:
########################################################################
# Main's Prologue - Move stack frame to save main's return address 
main__prol:
    sw        $fp, -4($sp)                                # save original frame pointer
    sw        $ra, -8($sp)                                # push $ra on stack
    la        $fp, -4($sp)                                # set new $fp
    addiu     $sp, $sp, -8                                # set new $sp, allocating room to store $fp and $ra

########################################################################
# Read 3 integer parameters - world_size, rule, n_generations
read_world_size:
    la        $a0, prompt_world_size
    li        $v0, 4
    syscall                                               # prints prompt_world_size string

    li        $v0, 5
    syscall                                               # reads world_size and stores in $v0

    blt       $v0, MIN_WORLD_SIZE, w_size_invalid         # pseudocode for if (world_size < MIN_WORLD_SIZE ||
    bgt       $v0, MAX_WORLD_SIZE, w_size_invalid         # world_size > MAX_WORLD_SIZE) goto w_size_invalid;

    move      $s0, $v0                                    # move world_size into $s0                                    

read_rule:
    la        $a0, prompt_rule                            
    li        $v0, 4
    syscall                                               # prints prompt_read_rule string
    
    li        $v0, 5
    syscall                                               # reads rule and stores in $v0

    blt       $v0, MIN_RULE, rule_invalid                 # pseudocode for if (rule < MIN_RULE ||
    bgt       $v0, MAX_RULE, rule_invalid                 # rule > MAX_RULE) goto rule_invalid;

    move      $s1, $v0                                    # move rule into $s1    

read_n_generations:
    la        $a0, prompt_n_generations
    li        $v0, 4
    syscall                                               # prints prompt_n_generations string

    li        $v0, 5
    syscall                                               # reads n_generations and stores in $v0

    blt       $v0, MIN_GENERATIONS, n_gens_invalid        # pseudocode for if (n_generations < MIN_GENERATIONS ||
    bgt       $v0, MAX_GENERATIONS, n_gens_invalid        # n_generations > MAX_GENERATIONS) goto n_gens_invalid;

    move      $s2, $v0                                    # move n_generations into $s2

########################################################################
# Checking whether the generation will be printed in reverse or as normal
check_negative_n_gens:
    li        $a0, '\n'        
    li        $v0, 11
    syscall                                               # putchar('\n');

    li        $s3, 0                                      # int reverse = 0;
    bltz      $s2, negative_gens                          # if (n_gens < 0) -> adjust accordingly

    b         set_1st_gen_cell                            # else go to next step - setting 1st gen cell

negative_gens:
    li        $s3, 1                                      # reverse = 1;
    mul       $s2, $s2, -1                                # n_generations = -n_generations

########################################################################
# Initialising the first generation cell 
set_1st_gen_cell:
    la        $s5, cells                                  # load addr of cells[0][0] into $s5

    li        $t0, 0                                      # $t0 holds row offset 0
    div       $t1, $s0, 2                                 # $t1 = world_size / 2
                             
    
    add       $t2, $s5, $t0                               # $t2 holds addr of cells[0]
    add       $t2, $t2, $t1                               # $t2 now holds addr of cells[0][world_size / 2] 

    li        $t3, 1                                      # set value of temp reg to 1
    sb        $t3, ($t2)                                  # cells[0][world_size / 2] = 1

########################################################################
# Steps to execute run_generation function - prompt, run 
run_gen_loop_prompt:
    li        $s4, 1                                      # int g = 1;

run_gen:
    bgt       $s4, $s2, check_gen_print                   # if (g > n_generations) goto print steps

    move      $a0, $s0                                    # load world_size into $a0
    move      $a1, $s4                                    # load g counter into $a1
    move      $a2, $s1                                    # load rule into $a2

    jal       run_generation                              # run_generation(world_size, g, rule)

    addi      $s4, $s4, 1                                 # g++;
    b         run_gen

########################################################################
# Steps to execute print_generation function - check reverse, prompt, print
check_gen_print:
    beq       $s3, 1, print_gen_rev_prompt                # if reverse = 1, goto print reverse steps

## Printing generation as normal
print_gen_prompt:
    li        $s4, 0                                      # int g = 0;

print_gen_normal:
    bgt       $s4, $s2, main__epi                         # if (g > n_generations) goto end;

    move      $a0, $s0                                    # load world_size into $a0
    move      $a1, $s4                                    # load g into $a1

    jal       print_generation                            # print_generation(world_size, g)

    addi      $s4, $s4, 1                                 # g++;
    b         print_gen_normal

## Printing generation in reverse
print_gen_rev_prompt:
    move      $s4, $s2                                    # g = n_generations

print_gen_rev:
    blt       $s4, 0, main__epi                           # if (g < 0) goto end;

    move      $a0, $s0                                    # load world_size into $a0                
    move      $a1, $s4                                    # load g into $a1

    jal       print_generation                            # print_generation(world_size, g)

    sub       $s4, $s4, 1                                 # g--;
    b         print_gen_rev    

########################################################################
# Invalid input prompts - world_size, rule and n_generations
w_size_invalid:
    la        $a0, error_world_size
    li        $v0, 4
    syscall
    
    b         main__epi

rule_invalid:
    la        $a0, error_rule    
    li        $v0, 4
    syscall

    b         main__epi

n_gens_invalid:
    la        $a0, error_n_generations
    li        $v0, 4
    syscall

    b         main__epi

########################################################################
# Main's Epilogue - Restore return address, pop stack and End
main__epi:
    lw        $ra, -4($fp)                                # recover main's $ra
    lw        $fp, ($fp)                                  # recover original $fp
    addiu     $sp, $sp, 8                                 # pop stack

    li        $v0, 0
    jr        $ra                                         # return 0;

########################################################################



 ######################################################################
  ######################## F U N C T I O N S #########################
 ######################################################################
    


########################################################################
# run_generation function
    #
    # Given `world_size', `which_generation', and `rule', calculate
    # a new generation according to `rule' and store it in `cells'.

    ########################################################################
    ### REGISTERS:
    # Frame: $sp, $fp, $ra, $s0, $s1
    # Uses: $a0, $a1, $a2, $s0, $s1, $t0, $t1, $t2, $t3, $t4, $t5, $t6, $t7
    # Clobbers: $t0, $t1, $t2, $t3, $t6, $t7

    ### More specifically
    ## Arguments:
    # $a0 = $s0 = world_size (world_size)
    # $a1 = $s4 = g (which_generation)
    # $a2 = $s1 = rule (rule)
    #
    ## Registers saved, used and restored:
    # $s0: used to calc. row index
    # $s1: used to calc. column index
    #
    ## Clobbers:
    # $t0: left neighbour cell & used as a constant value for calculations
    # $t1: centre neighbour cell 
    # $t2: right neighbour cell
    # $t3: state of cell & used in array calculations & for calculating conditions
    # $t6: cells index (e.g. cells[which_generation - 1][x]
    # $t7: x loop counter
    ## Misc:
    # $s5 = addr of cells[0][0] - we add on to this to access certain array values
    # $t4: bit - used in the process of setting cells to 0/1 (i.e. using a specific bit pattern) 
    # $t5: set - used to determine whether a cell is 0 or 1 (dead or alive)
    ########################################################################

run_generation:            
########################################################################
run_gen_prol:
    sw        $fp, -4($sp)                                # save original frame pointer
    sw        $ra, -8($sp)                                # push $ra of function onto stack (saving it)
    sw        $s0, -12($sp)                               # push $s0 onto stack (saving it so we can use reg.)
    sw        $s1, -16($sp)                               # push $s1 onto stack (saving it so we can use reg.)
    la        $fp, -4($sp)                                # set new $fp
    addiu     $sp, $sp, -16                               # set new $sp, allocating room for $fp, $ra, $s0 and $s1

run_gen_init:
    la        $s5, cells                                  # load addr of cells[0][0] (for good style and clarity)
    li        $t7, 0                                      # let temp reg be 0 (int x = 0)

run_gen_loop_cond:                                        # loop through & determine the state of cells
    bge       $t7, $a0, run_gen__epi                      # if (x >= world_size) goto run_gen__epi

run_gen_left:
    li        $t0, 0                                      # int left = 0;
    
    sub       $s0, $a1, 1                                 # $s0 = (which_generation - 1)
    mul       $s0, $s0, $a0                               # $s0 has row offset for row '(which_generation - 1) * (world_size)'
    sub       $s1, $t7, 1                                 # $s1 has col. offset for column '(x - 1)'

    blez      $t7, run_gen_centre                         # if (x <= 0) goto run_gen__centre    

    add       $t3, $s5, $s0                               # addr of cells[which_generation - 1]
    add       $t3, $t3, $s1                               # addr of cells[which_generation - 1][x - 1]

    lb        $t0, ($t3)                                  # left = cells[which_generation - 1][x - 1];

run_gen_centre:
    move      $s1, $t7                                    # $s1 has col. offset for column 'x'

    add       $t3, $s5, $s0                               # addr of cells[which_generation - 1]
    add       $t3, $t3, $s1                               # addr of cells[which_generation - 1][x]

    lb        $t1, ($t3)                                  # centre = cells[which_generation - 1][x];

run_gen_right:
    li        $t2, 0                                      # int right = 0;

    sub       $t3, $a0, 1                                 # $t3 = (world_size - 1)
    bge       $t7, $t3, run_gen_state                     # if (x >= world_size - 1) goto run_gen__state;

    addi      $s1, $t7, 1                                 # $s1 has col. offset for col '(x + 1)'         

    add       $t3, $s5, $s0                               # addr of cells[which_generation - 1]
    add       $t3, $t3, $s1                               # addr of cells[which_generation - 1][x + 1]

    lb        $t2, ($t3)                                  # right = cells[which_generation - 1][x + 1]

run_gen_state:
    sll       $t0, $t0, 2                                 # left <<= 2;
    sll       $t1, $t1, 1                                 # centre <<= 1;
    sll       $t2, $t2, 0                                 # right <<= 0;

    or        $t3, $t0, $t1                               # state = left | centre;
    or        $t3, $t3, $t2                               # state = state | right

run_gen_set:
    li        $t0, 1                              
    sllv      $t4, $t0, $t3                               # bit = 1 << state;
    and       $t5, $a2, $t4                               # set = rule & bit;

    mul       $s0, $a1, $a0                               # $s0 has row offset for row '(which_generation) * (world_size)' 
    move      $s1, $t7                                    # $s1 has col. offset for column 'x'

    add       $t3, $s5, $s0                               # addr of cells[which_generation]
    add       $t3, $t3, $s1                               # addr of cells[which_generation][x]

run_gen_setCond:
    beqz      $t5, run_gen_set_false                      # if (set == 0) goto setFalse;

run_gen_set_true:
    li        $t0, 1
    sb        $t0, ($t3)                                  # cells[which_generation][x] = 1;

    b         run_gen_loop_step

run_gen_set_false:
    li        $t0, 0 
    sb        $t0, ($t3)                                  # cells[which_generation][x] = 0;

run_gen_loop_step:
    addi      $t7, $t7, 1                                 # x++;
    b         run_gen_loop_cond

run_gen__epi:
    lw        $s1, -12($fp)                               # resrecovertore $s0
    lw        $s0, -8($fp)                                # recover $s1
    lw        $ra, -4($fp)                                # recover $ra of function run_generation
    lw        $fp, ($fp)                                  # recover original $fp
    addiu     $sp, $sp, 16                                # pop stack

    jr        $ra
########################################################################


########################################################################
# print_generation function
    #
    # Given `world_size', and `which_generation', print out the
    # specified generation.
    
    ########################################################################
    ### REGISTERS:
    # Frame: $sp, $fp, $ra
    # Uses: $a0, $a1, $s5, $t0, $t1, $t2, $t3, $t4, $t5, $t6
    # Clobbers: $a0

    ### More Specifically,
    ## Arguments: 
    # $a0 = $s0 = world_size
    # $a1 = $s4 = g (which_generation)
    #
    ## Registers saved, used, and restored:
    # N/A
    #
    ## Clobbers:
    # $t0: x loop counter 
    # $t1: used to calc. row index 
    # $t2: used to calc. col. index
    # $t3: used for cells indexing
    # $t6: access array value of cells
    #
    ## Misc: 
    # $s5: addr of of cells[0][0] - we add onto this to acces certain array values
    # $t4: world_size (moved from $a0 so we can use arguments in syscall)
    # $t5: g (moved it to keep it consistent with moving world_size arg)
    ########################################################################

print_generation:
########################################################################
print_gen_prol:
    sw        $fp, -4($sp)                                # save original frame pointer
    sw        $ra, -8($sp)                                # push $ra of function onto stack (saving it)
    la        $fp, -4($sp)                                # set new $fp
    addiu     $sp, $sp, -8                                # set new $sp, allocating room for $fp, $ra, $s0 and $s1

    move      $t4, $a0                                    # move world_size into $t4
    move      $t5, $a1                                    # move g (which_generation) into $t5

print_gen_init:
    move      $a0, $a1         
    li        $v0, 1                                      # printf("%d", which_generation) 
    syscall 

    li        $a0, '\t'
    li        $v0, 11
    syscall                                               # putchar('\t'), tab in horizontal space    

print_gen_loop_prompt:
    la        $s5, cells                                  # load addr of cells[0][0] (for good style and clarity)
    li        $t0, 0                                      # int x = 0;

print_gen_loop_init:
    mul       $t1, $t5, $t4                               # $t1 has row offset for row '(which_gen) * (world_size)'
    move      $t2, $t0                                    # $t2 has col. offset for column 'x'

    add       $t3, $s5, $t1                               # addr of cells[which_generation]
    add       $t3, $t3, $t2                               # addr of cells[which_generation][x]

    lb        $t6, ($t3)

print_gen_loop_cond:
    bge       $t0, $t4, print_gen__epi                    # if (x >= world_size) goto print_gen__epi;

print_gen_loop_cond_state:
    beqz      $t6, print_gen_cell_dead                    # if cells[which_generation][x] = 0 it's a dead cell

print_gen_cell_alive:
    li        $a0, ALIVE_CHAR
    li        $v0, 11
    syscall                                               # putchar(ALIVE_CHAR);

    b         print_gen_loop_step

print_gen_cell_dead:
    li        $a0, DEAD_CHAR
    li        $v0, 11
    syscall                                               # putchar(DEAD_CHAR);

print_gen_loop_step:
    addi      $t0, $t0, 1                                 # x++;

    b         print_gen_loop_init

print_gen__epi:
    lw        $ra, -4($fp)                                # recover $ra of function print_generation
    lw        $fp, ($fp)                                  # recover original $fp
    addiu     $sp, $sp, 8                                 # pop stack

    li        $a0, '\n'
    li        $v0, 11
    syscall                                               # putchar('\n');

    jr        $ra
########################################################################