// Sample solution for COMP1521 lab exercises
//
// generate the opcode for an addi instruction

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "addi.h"

#define ADDI_OP 8
#define REG_BITS 5
#define IMM_BITS 16 

// return the MIPS opcode for addi $t,$s, i
uint32_t addi(int t, int s, int i) {
    // Initialise opcode with the instruction bit pattern "001000" = 8
    uint32_t opcode = ADDI_OP;

    // Shift left 5 bits, place in the bit pattern of the source register
    opcode <<= REG_BITS;
    opcode |= s;

    // Shift left another 5, place in the destination register 
    opcode <<= REG_BITS;
    opcode |= t;

    // Shift left 16, placing in the immediate (16-bit signed number)
    // Have to convert to unsigned, hence we typecast
    opcode <<= IMM_BITS;
    opcode |= (uint16_t)i;

    return opcode;

}
