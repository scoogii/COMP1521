// Compare 2 floats using bit operations only

#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#include "floats.h"

// separate out the 3 components of a float
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


// float_less is given the bits of 2 floats bits1, bits2 as a uint32_t
// and returns 1 if bits1 < bits2, 0 otherwise
// 0 is return if bits1 or bits2 is Nan
// only bit operations and integer comparisons are used
uint32_t float_less(uint32_t bits1, uint32_t bits2) {
    float_components_t number1 = float_bits(bits1);
    float_components_t number2 = float_bits(bits2);

    // Cases: 
    // Check nan
    if (is_nan(number1) == 1 || is_nan(number2) == 1) {
        return 0;
    }

    // SIGNS: Positive or Negative   
    // 1 Pos, 1 Neg - e.g. if number1 pos and number2 neg, return 0
    if (number1.sign < number2.sign) {
        return 0;
    }
    else if (number1.sign > number2.sign ) {
        return 1;
    } else {
        // If neither met, then we know both signs are equal
        // First, check for signs

        // 2 cases to branch: Pos or Neg
        if (number1.sign == 0 && number2.sign == 0) { // +
            // Exponents (more than, equal to, less than)
            if (number1.exponent > number2.exponent) { // >
                return 0;
            }
            else if (number1.exponent < number2.exponent) { // <
                return 1;
            } else { // == 
                if (number1.fraction >= number2.fraction) {
                    return 0;
                } else {
                    return 1;
                }
            }
        } 
        else if (number1.sign == 1 && number2.sign == 1) { // -
            // Exponents
            if (number1.exponent < number2.exponent) {
                return 0;
            }
            else if (number1.exponent > number2.exponent) {
                return 1;
            } else {
                if (number1.fraction <= number2.fraction) {
                    return 0;
                } else {
                    return 1;
                }
            }

        }

    }    
    return 0;
}
