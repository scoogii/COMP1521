// Checks if env var is a non-empty string
// If so, print 1, else print 0
// Christian Nguyen - z5310911
// Aug 13, 2020
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (getenv(argv[1]) == NULL || *getenv(argv[1]) == '\0') {
        printf("0\n");
    } else {
        printf("1\n");
    }

    return 0;
}
