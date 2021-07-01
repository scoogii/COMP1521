// Testing strtol
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    int n = strtol(argv[1], NULL, 0);
    int m = strtol(argv[2], NULL, 0);
    
    printf("n is a long integer with the value \033[0;36m %d \033[0m and m has a value of \033[0;36m %d \033[0m \n", n, m);
    return 0;
}