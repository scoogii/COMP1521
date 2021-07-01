// Creates a file of chosen name containing the specified integers
// 1. A filename
// 2. The beginning of a range of integers
// 3. The end of a range of integers

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    // Check for correct arguments
    if (argc != 4) {
        fprintf(stderr, "Usage: %s <source file> <destination file>\n", argv[0]);
        return 1;
    }
    
    // Beginning of a range of ints
    int i = atoi(argv[2]);
    int end = atoi(argv[3]);

    // Create file with specified name
    FILE *output_stream = fopen(argv[1], "w");
    if (output_stream == NULL) {
    perror(argv[1]);
    return 1;
    }

    // Loop and print into file
    while (i <= end) {
        fprintf(output_stream, "%d\n", i);
        i++;
    }

    fclose(output_stream);

    return 0;
}