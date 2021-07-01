// count bits in a uint64_t

#include <assert.h>
#include <stdint.h>
#include <stdlib.h>

// return how many 1 bits value contains
int bit_count(uint64_t value) {
    
    int counter = 0;

    for (counter = 0; value != 0; value >>= 1) {
        
        counter += (value & 1);

    }

    return counter;
}
