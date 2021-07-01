// Count the number of UTF-8 characters in a file, 
// and check that the file contains only valid UTF-8
// Christian Nguyen - z5310911
// Aug 19 2020


#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define UTF_LAST_2 0x2
#define UTF_2_BYTES_MASK 0x6
#define UTF_3_BYTES_MASK 0xE
#define UTF_4_BYTES_MASK 0x1E 

// If not UTF-8 read, then stop and print error message
// If end of file reach before completing UTF-8 reading,
// stop and print error message
// fprintf(stderr, "");

int checkFirstByte(int character, int successRead, char *fileName);
int checkConsecutive(int character, int successRead, int remaining, char *fileName);

int main(int argc, char *argv[]) {
    // Open file to be read
    FILE *f = fopen(argv[1], "r");

    int read = 0;
    int c = 0;
    int new = 0;
    while ((c = fgetc(f)) != EOF) {
        if (new == 0) {
            if ((new = checkFirstByte(c, read, argv[1])) == 0) {
                read++;
            }
        } else {
            if ((new = checkConsecutive(c, read, new, argv[1])) == 0) {
                read++;
            }
        }
    }
    
    if (c == EOF && new != 0) {
        printf("%s: invalid UTF-8 after %d valid UTF-8 characters\n", argv[1], read);
        return 1;
    }

    printf("%s: %d UTF-8 characters\n", argv[1], read);
    fclose(f);

    return 0;
}

// Checks the first byte of possible UTF-8 character
// Returns the number of bytes in the UTF-8 character
// That should be consecutively read
// If none are matched, then invalid UTF-8
int checkFirstByte(int character, int successRead, char *fileName) {
    // Bit mask and check if the most significant 3 bytes
    // were '0', '110', '1110', '11110'
    
    // '0'
    if ((character >> 7) == 0) {
        return 0;
    }

    // '110'
    else if (((character >> 5) | UTF_2_BYTES_MASK) == UTF_2_BYTES_MASK) {
        return 1;
    }

    // '1110'
    else if (((character >> 4) | UTF_3_BYTES_MASK) == UTF_3_BYTES_MASK) {
        return 2;
    }

    // '11110'
    else if (((character >> 3) | UTF_4_BYTES_MASK) == UTF_4_BYTES_MASK) {
        return 3;
    }
    
    // Otherwise, invalid UTF-8
    printf("%s: invalid UTF-8 after %d valid UTF-8 characters\n", fileName, successRead);
    exit(1);
    
}

// Checks that the consecutive bytes of UTF-8 character 
// are consistent 
int checkConsecutive(int character, int successRead, int remaining, char *fileName) {
    // Bit mask and check if the most significant 2 bytes
    // are '10'
    int msBits = character >> 6;

    // If not '10', print to stderr and return 
    if ((msBits & UTF_LAST_2) != UTF_LAST_2) {
        printf("%s: invalid UTF-8 after %d valid UTF-8 characters\n", fileName, successRead);
        exit(1);
    }    

    return (remaining - 1);
}
