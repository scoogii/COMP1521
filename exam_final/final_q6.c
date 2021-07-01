// Count the number of ASCII bytes in files
// Christian Nguyen - z5310911
// Aug 19 2020

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    FILE *f = fopen(argv[1], "r");

    int c = 0;
    int asciiBytes = 0;
    while ((c = fgetc(f)) != EOF) {
        if (0 <= c && c<= 127) {
            asciiBytes++;
        }
    }

    printf("%s contains %d ASCII bytes\n", argv[1], asciiBytes);
    
    fclose(f);
    return 0;

}
