########################################################################
# COMP1521 20T2 --- assignment 1: a cellular automaton renderer
#
# Written by Christian nguyen, July 2020.


# Maximum and minimum values for the 3 parameters.

MIN_WORLD_SIZE	=    1
MAX_WORLD_SIZE	=  128
MIN_GENERATIONS	= -256
MAX_GENERATIONS	=  256
MIN_RULE	=    0
MAX_RULE	=  255

# Characters used to print alive/dead cells.

ALIVE_CHAR	= '#'
DEAD_CHAR	= '.'

# Maximum number of bytes needs to store all generations of cells.

MAX_CELLS_BYTES	= (MAX_GENERATIONS + 1) * MAX_WORLD_SIZE

	.data

# `cells' is used to store successive generations.  Each byte will be 1
# if the cell is alive in that generation, and 0 otherwise.

cells:	.space MAX_CELLS_BYTES


# Some strings you'll need to use:

prompt_world_size:	.asciiz "Enter world size: "
error_world_size:	.asciiz "Invalid world size\n"
prompt_rule:		.asciiz "Enter rule: "
error_rule:		.asciiz "Invalid rule\n"
prompt_n_generations:	.asciiz "Enter how many generations: "
error_n_generations:	.asciiz "Invalid number of generations\n"

	.text

	#
	# REPLACE THIS COMMENT WITH A LIST OF THE REGISTERS USED IN
	# `main', AND THE PURPOSES THEY ARE ARE USED FOR
	#

	# LIST OF REGISTERS USED:


	# YOU SHOULD ALSO NOTE WHICH REGISTERS DO NOT HAVE THEIR
	# ORIGINAL VALUE WHEN `run_generation' FINISHES
	#

main:

# Read 3 integer parameters - world_size, rule, n_generations
read_world_size:
	la		$a0, prompt_world_size					# load world size prompt into $a0
	li		$v0, 5									# scanf("%d", &world_size);
	syscall											# world_size goes into $v0

	blt		$v0, MIN_WORLD_SIZE, w_size_invalid		# pseudo instructions for c 'if' statement
	bgt		$v0, MAX_WORLD_SIZE, w_size_invalid		# if invalid size, goto corresponding prompt

	move	$t0, $v0								# if valid, store world_size in $t0	

read_rule:
	la		$a0, prompt_rule						# load rule prompt into $a0
	li		$v0, 5									# scanf("%d", &rule);
	syscall											# rule goes into $v0

	blt		$v0, MIN_RULE, rule_invalid				# if invalid rule value, 
	bgt		$v0, MAX_RULE, rule_invalid				# goto corresponding invalid prompt

	move	$s1, $v0								# store rule in $s1

read_n_generations:
	la		$a0, prompt_n_generations				# load n_generations prompt into $a0
	li		$v0, 5									# scanf("%d", &n_generations);
	syscall

	blt     $v0, MIN_GENERATIONS, n_gens_invalid	# if invalid value for n_generations
	bgt		$v0, MAX_GENERATIONS, n_gens_invalid	# goto corresponding invalid prompt

	move	$s2, $v0								# store n_generations in $s2

check_negative_n_gens:								# check if negative n_gens - if so, show in reverse
	li		$t0, 0									# int reverse = 0;
	blt		$s2, 0, negative_gens	  				# if (n_generations < 0) goto negative_gens

	b 		init_cells

negative_gens:
	li		$t0, 1									# reverse = 1;
	mul		$s2, $s2, -1							# n_generations = -n_generations;

set_1st_gen_cell:									# set first gen cell cells[0][world_size / 2] = 1
	la		$s3, cells								# load address of cells[] into $s3

	li		$t1, 0									# $t1 holds row index 0
	div		$t2, $t0, 2								# $t2 <- world_size / 2 
	mul		$t2, $t2, 4								# $t2 holds the column index for (world_size / 2)
	add		$t3, $t1, $t2							# $t3 = cells[0][world_size / 2] 

	li		$t1, 1									# set $t1 = 1 
	sw		$t1, ($t3)								# cells[0][world_size / 2] = 1

run_gen_loop_prompt:
	li		$t1, 1									# int g = 1;

run_gen:											# loops through every generation and determines state of cells
	bgt		$t1, $s2, check_gen_print				# if (g > n_generations) goto ...

	#### DONT KNOW ABOUT DIS - saving properly?
	move	$a0, $t0								# load world_size in $a0 to be passed into r_g
	move 	$a1, $t1								# load g into $a1
	move	$a2, $s1 								# load rule into $a2

	sw 		$fp, -4($sp)							# save original frame pointer 
	la 		$fp, -4($sp)							# load new $fp 
	sw 		$ra, -8($fp)							# push $ra on stack
	addiu	$sp, $sp, -8							# make room to store $fp and $ra

	jal 	run_generation 							# run_generation(world_size, g, rule)

	lw 		$ra, -4($fp) 							# restore main's $ra
	lw 		$fp, ($fp)								# reclaim original $fp
	addiu	$sp, $sp, 8								# pop stack

	addi	$t1, $t1, 1								# g++;
	b 		run_gen


check_gen_print:									# check whether to print normal or reverse gens
	beq		$t0, 1, print_gen_rev_prompt			# if reverse = 1, goto gen reverse print prompt


print_gen_prompt:
	li		$t1, 0									# int g = 0;

print_gen:											# printing generations as normal
	bgt		$t1, $s2, end							# if (g > n_generations) goto end; (i.e. finished)
	
	#### DONT KNOW ABOUT DIS - saving properly?
	move 	$a0, $t0								# load world_size into $a0
	move 	$a1, $t1								# load g into $a1

	sw 		$fp, -4($sp)							# save original frame pointer 
	la 		$fp, -4($sp)							# load new $fp 
	sw 		$ra, -8($fp)							# push $ra on stack
	addiu	$sp, $sp, -8							# make room to store $fp and $ra

	jal		print_generation						# print_generation(world_size, g)

	lw 		$ra, -4($fp) 							# restore main's $ra
	lw 		$fp, ($fp)								# reclaim original $fp
	addiu	$sp, $sp, 8								# pop stack

	addi	$t1, $t1, 1								# g++;
	b		print_gen

print_gen_rev_prompt:
	move 	$t1, $s2								# g = n_generations

print_gen_rev:										# printing generations in reverse
	blt		$t1, 0, end								# if (g < 0) goto end;

	#### DONT KNOW ABOUT DIS - saving properly?
	move 	$a0, $t0 								# load world_size into $a0
	move 	$a1, $t1 								# load g into $a1

	sw 		$fp, -4($sp)							# save original frame pointer 
	la 		$fp, -4($sp)							# load new $fp 
	sw 		$ra, -8($fp)							# push $ra on stack
	addiu	$sp, $sp, -8							# make room to store $fp and $ra

	jal 	print_generation						# print_generation(world_size, g)

	lw 		$ra, -4($fp) 							# restore main's $ra
	lw 		$fp, ($fp)								# reclaim original $fp
	addiu	$sp, $sp, 8								# pop stack

	sub		$t1, $t1, 1								# g--;
	b 		print_gen_rev_loop

w_size_invalid:
	la		$a0, error_world_size					# load invalid world_size statement into $a0	
	li		$v0, 4									# printf("%s", error_world_size);
	syscall 

	b 		end

rule_invalid:
	la		$a0, error_rule							# load invalid rule statement into $a0
	li		$v0, 4									# printf("%s", error_rule);
	syscall

	b		end

n_gens_invalid:
	la		$a0, error_n_generations				# load invalid n_gens statement into $a0
	li		$v0, 4									# printf("%s", error_n_generations);
	syscall

	b		end

end:
	# replace the syscall below with
	#
	# li	$v0, 0
	# jr	$ra
	#
	# if your code for `main' preserves $ra by saving it on the
	# stack, and restoring it after calling `print_world' and
	# `run_generation'.  [ there are style marks for this ]

	li		$v0, 10
	syscall



	#
	# Given `world_size', `which_generation', and `rule', calculate
	# a new generation according to `rule' and store it in `cells'.
	#

	#
	# REPLACE THIS COMMENT WITH A LIST OF THE REGISTERS USED IN
	# `run_generation', AND THE PURPOSES THEY ARE ARE USED FOR
	#
	# YOU SHOULD ALSO NOTE WHICH REGISTERS DO NOT HAVE THEIR
	# ORIGINAL VALUE WHEN `run_generation' FINISHES
	#

run_generation:										# has arguments $a0 ($t0), $a1 ($t1), $a2 ($s1)
	
	li		$t1, 0									# int x = 0;

run_gen_loop:										# get values of left/right neighbour cells
	li 		$t2, 0 									# int left = 0;
	bgt 	$t0, 0, run_gen__set_left


	b 		run_gen__loop

	

	

run_gen__epi:
	jr		$ra


	#
	# Given `world_size', and `which_generation', print out the
	# specified generation.
	#

	#
	# REPLACE THIS COMMENT WITH A LIST OF THE REGISTERS USED IN
	# `print_generation', AND THE PURPOSES THEY ARE ARE USED FOR
	#
	# YOU SHOULD ALSO NOTE WHICH REGISTERS DO NOT HAVE THEIR
	# ORIGINAL VALUE WHEN `print_generation' FINISHES
	#

print_generation:

	#
	# REPLACE THIS COMMENT WITH YOUR CODE FOR `print_generation'.
	#

	jr	$ra