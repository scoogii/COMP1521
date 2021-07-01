// swap pairs of bits of a 64-bit value, using bitwise operators

#include <assert.h>
#include <stdint.h>
#include <stdlib.h>

// return value with pairs of bits swapped
uint64_t bit_swap(uint64_t value) {
    
    uint64_t evenBits = (value & 0xAAAAAAAAAAAAAAAA);
    uint64_t oddBits = (value & 0x5555555555555555);

    evenBits >>= 1;
    oddBits <<= 1;

    uint64_t swapped = evenBits | oddBits;


    return swapped;
}
