// Christian Nguyen - z5310911
// Aug 19 2020

#include <assert.h>
#include <stdint.h>
#include <stdlib.h>

// given a uint32_t value,
// return 1 iff the least significant (bottom) byte
// is equal to the 2nd least significant byte; and
// return 0 otherwise

#define LAST_BYTE_MASK 0xFF     
#define SIZE_BYTE 8

int final_q2(uint32_t value) {
    uint8_t lsb = value & LAST_BYTE_MASK;
    uint8_t slsb = (value >> SIZE_BYTE) & LAST_BYTE_MASK;
    
    if (lsb == slsb) {
        return 1;
    } 
    return 0;
}
