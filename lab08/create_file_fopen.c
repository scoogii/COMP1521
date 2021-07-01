// Simple example of file creation creates file "hello.txt" containing 1 line ("Hello, Andrew!\n")
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    FILE *output_stream = fopen("hello.txt", "w");
    if (output_stream == NULL) {
        perror("hello.txt");
        return 1;
    }

    fprintf(output_stream, "Hello!\n");

    fclose(output_stream);

    return 0;
}