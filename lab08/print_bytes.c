// Print one line for each byte of a file with some details of the byte
// Christian Nguyen - z5310911
// Jul 20, 2020

// printf format should be "byte %4ld: %3d 0x%02x '%c'"

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    // If incorrect arguments
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <source file> <destination file>\n", argv[0]);
        return 1;
    }
    // Open file or create file of specified name from argument
    FILE *output_stream = fopen(argv[1], "r");

    int c;
    long i = 0;
    while ((c = fgetc(output_stream)) != EOF) {
        printf("byte %4ld: %3d 0x%02x ", i, c, c);
        
        if (isprint(c) != 0) {
            printf("'%c'\n", c);
        } else {
            printf(" \n");
        }

        i++;
    }

    fclose(output_stream);

    return 0;
}