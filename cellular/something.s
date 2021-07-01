## redoing run_gen since i don't like how it turned out

########################################################################
# run_generation function
    #
    # Given `world_size', `which_generation', and `rule', calculate
    # a new generation according to `rule' and store it in `cells'.
    #
    ### REGISTERS:
    #
    ## Arguments:
    # $a0 = $s0 = world_size (world_size)
    # $a1 = $s4 = g (which_generation)
    # $a2 = $s1 = rule (rule)
    #
    ## Registers saved and used:
    # $s0: used to calc. row index
    # $s1: used to calc. column index
    #
    ## Misc:
    # $s5 = addr of cells[0][0]
    # $t0: left neighbour cell & used as a constant value for calculations 
    # $t1: centre neighbour cell 
    # $t2: right neighbour cell
    # $t3: state of cell - used in array calculations - for calculating conditions
    # $t4: bit 
    # $t5: set
    # $t6: cells index (e.g. cells[which_generation - 1][x]
    # $t7: x loop counter

run_generation:            
    sw         $fp, -4($sp)                                # save original frame pointer
    sw         $s0, -8($sp)                                 # push $s0 onto stack (saving it so we can use reg.)
    sw         $s1, -12($sp)                                # push $s1 onto stack (saving it so we can use reg.)
    la         $fp, -4($sp)                                # set new $fp
    addiu     $sp, $sp, -20                                # set new $sp, making room for $s0 and $s1

    la      $s5, cells                                  # load addr of cells[0][0]
    li      $t7, 0                                      # let temp reg be 0 (int x = 0)

run_gen__loop:                                          # loop through & determine the state of cells
    bge     $t7, $a0, run_gen__epi                      # if (x >= world_size) goto run_gen__epi

run_gen__left:
    li      $t0, 0                                      # int left = 0;
    
    sub     $s0, $a1, 1                                 # $s0 = (which_generation - 1)
    mul     $s0, $s0, $a0                               # $s0 = (which_generation - 1)*(world_size)
    mul     $s0, $s0, 4                                 # $s0 has row offset for row 'which_generation - 1'
    sub     $s1, $t7, 1                                 # $s1 = (x - 1)
    mul     $s1, $s1, 4                                 # $s1 has col. offset for column 'x - 1'

    ble     $t7, 0, run_gen__centre                     # if (x <= 0) goto run_gen__centre    

    add     $t3, $s5, $s0                               # addr of cells[which_generation - 1]
    add     $t3, $t3, $s1                               # addr of cells[which_generation - 1][x - 1]

    lw      $t0, ($t3)                                  # left = cells[which_generation - 1][x - 1];

run_gen__centre:
    mul     $s1, $t7, 4                                 # $s1 has col. offset for column 'x'

    add     $t3, $s5, $s0                               # addr of cells[which_generation - 1]
    add     $t3, $t3, $s1                               # addr of cells[which_generation - 1][x]

    lw      $t1, ($t3)                                  # centre = cells[which_generation - 1][x];

run_gen__right:
    li      $t2, 0                                      # int right = 0;

    sub     $t3, $a0, 1                                 # $t3 = (world_size - 1)
    bge     $t7, $t3, run_gen__state                    # if (x >= world_size - 1) goto run_gen__state;

    addi    $s1, $t7, 1                                 # $s1 = (x + 1)         
    mul     $s1, $s1, 4                                 # $s1 has col. offset for column 'x+1'

    add     $t3, $s5, $s0                               # addr of cells[which_generation - 1]
    add     $t3, $t3, $s1                               # addr of cells[which_generation - 1][x + 1]

    lw      $t2, ($t3)                                  # right = cells[which_generation - 1][x + 1]

run_gen__state:
    sll     $t0, $t0, 2                                 # left <<= 2;
    sll     $t1, $t1, 1                                 # centre <<= 1;
    sll     $t2, $t2, 0                                 # right <<= 0;

    or      $t3, $t0, $t1                               # state = left | centre;
    or      $t3, $t3, $t2                               # state = state | right

run_gen__set:
    li      $t0, 1                              
    sllv    $t4, $t0, $t3                               # bit = 1 << state;
    and     $t5, $a2, $t4                               # set = rule & bit;

    mul     $s0, $a1, $a0                               # $s0 = (which_generation)*(world_size)
    mul     $s0, $s0, 4                                 # $s0 has row offset for row 'which_generation'
    mul     $s1, $t7, 4                                 # $s1 has col. offset for column 'x'

    add     $t3, $s5, $s0                               # addr of cells[which_generation]
    add     $t3, $t3, $s1                               # addr of cells[which_generation][x]

run_gen__setCond:
    beq     $t5, 0, run_gen__setFalse                   # if (set == 0) goto setFalse;

run_gen__setTrue:
    li      $t0, 1
    sw      $t0, ($t3)                                  # cells[which_generation][x] = 1;

    b       run_gen__loopStep

run_gen__setFalse:
    li      $t0, 0 
    sw      $t0, ($t3)                                  # cells[which_generation][x] = 0;

run_gen__loopStep:
    addi    $t7, $t7, 1                                 # x++;
    b       run_gen__loop

run_gen__epi:
    lw         $s1, -8($fp)                                 # restore $s0
    lw         $s0, -4($fp)                                # restore $s1
    la        $sp, 4($fp)                                    # set original $sp
    lw         $fp, ($fp)                                     # set original $fp

    jr        $ra