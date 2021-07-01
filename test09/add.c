#include <stdio.h>
#include <stdint.h>
#include <assert.h>

#include "add.h"

#define ADD_OP 32
#define REG_BITS 5

// return the MIPS opcode for add $d, $s, $t
uint32_t add(uint32_t d, uint32_t s, uint32_t t) {
    // Initialise opcode with the instruction bit pattern "000000" and last "00000100000"
    uint32_t opcode = 0;
    
    // Shift left 5 bits, insert source register
    opcode <<= REG_BITS;
    opcode |= s;

    // Shift left 5 bits, insert other source register
    opcode <<=  REG_BITS;
    opcode |= t;

    // Shift left 5 bits, insert destination register
    opcode <<= REG_BITS;
    opcode |= d;

    // Shift left 11, insert the ending 11 bits of add opcode
    opcode <<= 11;
    opcode |= ADD_OP;

    return opcode; 

}
