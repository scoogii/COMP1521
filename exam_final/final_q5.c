// Take two names of environment variables
// if both are set to the same value, print 1
// Otherwise, print 0
// Christian Nguyen - z5310911
// Aug 19 2020


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    // get the env variables of both arguments
    // if returns returns NULL, print 0
    if (getenv(argv[1]) == NULL) {
        printf("0\n");
        return 1;
    }
    if (getenv(argv[2]) == NULL) {
        printf("0\n");
        return 1;
    }
    
    char *envV1 = getenv(argv[1]);
    char *envV2 = getenv(argv[2]);

    // If successful, check that they're set to the same value
    if (strcmp(envV1, envV2) == 0) {
        printf("1\n");
    } else {
        printf("0\n");
    }

    return 0;

}
