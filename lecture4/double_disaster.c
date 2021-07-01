// 9007199254740993 is smallest integer which can not be represented exactly as a double

// The closest double to 9007199254740993 is 9007199254740992.0
// As a result loop never terminates
// 9007199254740992 is 2 to the power of 53
// It can not be represented by a int32_t,
// It can be represented by int64_t

#include <stdio.h>

int main(void) {

    double d = 9007199254740992;

    while (d < 9007199254740999) {
        printf("%lf\n", d); // prints 9007199254740992.000000
        d = d + 1;
    }

    return 0;
}