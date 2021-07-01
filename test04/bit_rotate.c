#include "bit_rotate.h"
#define N_BITS 16

// return the value bits rotated left n_rotations
uint16_t bit_rotate(int n_rotations, uint16_t bits) {

    // Simplify number of rotations b/w -15 and 15 - 16 is equivalent to a full rotation
    n_rotations %= (N_BITS);

    // If negative, treat as a positive rotation
    while (n_rotations < 0) {
        n_rotations += 16;
    }

    // Rotate left incrementally by 1 bit 
    while (n_rotations > 0) {

        // Store the msb that is dropped
        uint16_t msb = (bits >> (N_BITS - 1)) & 1;

        // Left shift 1 bit and plug in msb where lsb was
        bits = (bits << 1) | msb;

        n_rotations--;
    }

    return bits;
}