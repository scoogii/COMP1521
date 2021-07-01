// Take in one argument, a filename and 
// print all sequences of length 4 or longer of consecutive byte values 
// corresponding to printable ASCII characters.

// program should read through the bytes of the file, 
// and if it finds 4 bytes in a row containing printable characters, 
// it should print those bytes, and any following bytes containing ASCII printable characters.

// Christian Nguyen - z5310911
// Jul 21, 2020

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#define SIZE 3

void findStrings(FILE *fd);
void printArray(int array[], int size);
// have to use isprint() somewhere
// 3 element array as a buffer?

int main(int argc, char *argv[]) {
    FILE *fd = fopen(argv[1], "r");
    if (fd == NULL) {
        perror(argv[1]);
        return 1;
    }

    findStrings(fd);

    return 0;
}

void findStrings(FILE *fd) {
    // Initialise 3 element array
    int buffer[SIZE];

    int i = 0;
    int c = 0;
    while ((c = fgetc(fd)) != EOF) {
        // If it is a printable ASCII 
        if (isprint(c)) {
            if (i == SIZE) {
                printArray(buffer, SIZE);
                printf("%c", c);
                // Check for consecutive 4+ bytes, then reset i
                while ((c = fgetc(fd)) != EOF && isprint(c) != 0) {
                    printf("%c", c);
                }
                // Print newLine after end of string, and reset i
                printf("\n");
                i = 0;
            // If i != SIZE, store into buffer
            } else {
                buffer[i] = c;
                i++;
            }
        // If not printable ASCII, reset i
        } else {
            i = 0;
        }
    }
    fclose(fd);
}

void printArray(int array[], int size) {
    for (int i = 0; i < size; i++) {
        printf("%c", array[i]);
    }
}




    