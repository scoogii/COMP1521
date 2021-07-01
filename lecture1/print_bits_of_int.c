// Printing out the bits of an int
// Christian Nguyen - z5301911
// June 11 - 2020

#include <stdio.h>
#include <stdint.h>
#include "print_bits.h"

int main(void) {

    int a = 0;
    printf("Enter an int: ");
    scanf("%d", &a);

    // sizeof returns number of bytes, a byte has 8 bits
    int n_bits = 8 * sizeof a;

    print_bits(a, n_bits);
    printf("\n");

    return 0;
}