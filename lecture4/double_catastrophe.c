// Demonstrate approximate representation of reals producing error. 
// sometimes if we subtract two approximations which are very close together we can can get a large relative error
// correct answer if x == 0.000000011 (1 - cos(x)) / (x * x) is very close to 0.5 code prints 0.917540 which is wrong 
// by a factor of almost two

#include <stdio.h>
#include <math.h>

int main(void) {

    double x = 0.000000011;

    double y = (1 - cos(x)) / (x * x);

    printf("correct answer = ~0.5 but y = %lf\n", y);

    return 0;
}