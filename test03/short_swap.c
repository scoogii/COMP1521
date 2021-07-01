// Swap bytes of a short

#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#define BYTE 8

// given uint16_t value return the value with its bytes swapped
uint16_t short_swap(uint16_t value) {
    uint16_t num = 0;
    
    num = (value << BYTE) | (value >> BYTE);

    return num;
}
