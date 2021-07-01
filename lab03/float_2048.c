// Multiply a float by 2048 using bit operations only

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "floats.h"

#define BIAS 127
#define NUMBITS 32

float_components_t float_bits(uint32_t f) {
    float_components_t number;

    // sign - shift right 31
    number.sign = (f >> 31) & 1; 
    // exp - shift right 24 and take only the right most 8 bits
    number.exponent = (f >> 23) & 0xFF;
    // fraction - take the right most 23 bits
    number.fraction = f & 0x7FFFFF;

    return number;
}

// given the 3 components of a float
// return 1 if it is NaN, 0 otherwise
int is_nan(float_components_t f) {
    if ((f.exponent & 0xFF) == 0xFF && f.fraction == 0x400000) {
        return 1;
    } else {
        return 0;
    }
}

// given the 3 components of a float
// return 1 if it is inf, 0 otherwise
int is_positive_infinity(float_components_t f) {
    if (f.sign == 0 && f.exponent == 0xFF && f.fraction == 0) {
        return 1;
    } else {
        return 0;
    }
}

// given the 3 components of a float
// return 1 if it is -inf, 0 otherwise
int is_negative_infinity(float_components_t f) {
    if (f.sign == 1 && f.exponent == 0xFF && f.fraction == 0) {
        return 1;
    } else {
        return 0;
    }
}

// given the 3 components of a float
// return 1 if it is 0 or -0, 0 otherwise
int is_zero(float_components_t f) {  
    if (f.exponent == 0 && f.fraction == 0) {
        return 1;
    } else {
        return 0;
    }
}

// Check the cases for f
uint32_t checkCases(float_components_t f) {
    if (is_zero(f) == 1) {
        return 1;
    }

    if (is_positive_infinity(f) == 1) {
        return 1;
    }

    if (is_positive_infinity(f) == 1) {
        return 1;
    }

    if (is_nan(f) == 1) {
        return 1;
    }

    return 0;
}

// Puts all the pieces back together from IEEE754 format
uint32_t combine(float_components_t f) {
    uint32_t number = 0;
    number |= (f.sign << (NUMBITS - 1));
    number |= (f.exponent << 23);
    number |= (f.fraction);

    return number;
}

// float_2048 is given the bits of a float f as a uint32_t
// it uses bit operations and + to calculate f * 2048
// and returns the bits of this value as a uint32_t
//
// if the result is too large to be represented as a float +inf or -inf is returned
//
// if f is +0, -0, +inf or -int, or Nan it is returned unchanged
//
// float_2048 assumes f is not a denormal number
//
uint32_t float_2048(uint32_t f) {
    // get bit pattern of f
    float_components_t number = float_bits(f);

    // Check cases
    if (checkCases(number) == 1) {
        return f;
    }

    // If all not met, check exponent (max exponent is 255)
    if (number.exponent + 11 < 0xFF) { 
        // add to exponent 
        number.exponent += 11;
    } else {
        // make number inf, combine will let decimal return inf
        number.exponent = 0xFF;
        number.fraction = 0x000000;
    }

    uint32_t decimal = combine(number);
    return decimal;
}
