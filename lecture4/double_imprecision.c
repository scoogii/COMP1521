// The value 0.1 can not be precisely represented as a double
// As a result b != 0

#include <stdio.h>

int main(void) {
    double a, b;

    a = 0.1;
    b = 1 - (a + a + a + a + a + a + a + a + a + a);

    if (b != 0) {
        printf("1 != 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1\n");
    }

    printf("b = %g\n", b); // prints 1.11022e-16

    return 0;
}
