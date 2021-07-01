// Print size and min and max values of floating point types

#include <stdio.h>
#include <float.h>

int main(void) {

    float f;
    printf("float       %2lu bytes  min=%-12g  max=%g\n", sizeof f, FLT_MIN, FLT_MAX);
    double d;
    printf("double      %2lu bytes  min=%-12g  max=%g\n", sizeof d, DBL_MIN, DBL_MAX);
    long double l;
    printf("long double %2lu bytes  min=%-12Lg  max=%Lg\n", sizeof l, LDBL_MIN, LDBL_MAX);

    return 0;
}
