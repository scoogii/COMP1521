// Testing stuff

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    int number = atoi(argv[1]);

    printf("Number is %d\nShifted is %d\n", number, (number << 1));

    return 0;
}