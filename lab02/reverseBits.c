#include <stdio.h>
#include <assert.h>

#define NUM_BITS 32

typedef unsigned int Word;

Word reverseBits(Word input) {

    Word output = 0;

    for (unsigned int bit = 0; bit < NUM_BITS; bit++) {
        Word inputMask = 1u << (NUM_BITS - bit - 1);
        Word outputMask = 1u << bit; // unsigned 1 = u1
    
        if (input & inputMask) {
            output = output | outputMask;
        }

    }

    return output;
}