// takes at least one argument: a filename, and subsequently, 
// integers in the range 0...255 inclusive specifying byte values. 
// It should create a file of the specified name, containing the specified bytes.

// Christian Nguyen - z5310911
// Jul 21, 2020

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 1) {
    fprintf(stderr, "Usage: %s <source file> <destination file>\n", argv[0]);
    return 1;
    }

    // Create file with specified name
    FILE *output_stream = fopen(argv[1], "wb");
    if (output_stream == NULL) {
        perror(argv[1]);
        return 1;
    }

    // Putting integers into file with specified byte values
    for (int i = 2; i < (argc); i++) {
        int byte = atoi(argv[i]);
        fputc(byte, output_stream);
    }

    fclose(output_stream);

    return 0;
}