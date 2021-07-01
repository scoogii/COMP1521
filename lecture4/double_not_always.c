
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

int main(int argc, char *argv[]) {
    assert(argc == 2);

    double d = strtod(argv[1], NULL);

    if (d == d) {
        printf("This should be always executed\n");
    } else {
        // will be executed if d is a NaN
        printf("This should never executed\n");
    }

    printf("d=%g\n", d);

    return 0;
}