// Convert string of binary digits to 16-bit signed integer

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

#define N_BITS 16

int16_t sixteen_in(char *bits);

int main(int argc, char *argv[]) {

    for (int arg = 1; arg < argc; arg++) {
        printf("%d\n", sixteen_in(argv[arg]));
    }

    return 0;
}

//
// given a string of binary digits ('1' and '0')
// return the corresponding signed 16 bit integer
//
int16_t sixteen_in(char *bits) { // e.g. decimal "1001 1100 1101"
    int16_t decimal = 0; // "0000 0000 0000 0000"

    int bit = 0;

    for (int i = 0; i < N_BITS; i++) {
        // check i'th bit
        if (bits[i] == '0') {
            bit = 0; // "0000 0000 0000 0000"
        } else {
            bit = 1; // "0000 0000 0000 0001"
        }

        bit = bit << (N_BITS - i - 1); // "1000 0000 0000 0000"

        decimal = decimal | bit; // "1000 0000 0000 0000"
    }
    return decimal;
}

                
