// Compare the bytes of a file - 3 cases:
// Files are identical
// EOF on one of the files
// Files differ at certain byte
// Christian Nguyen - z5310911
// Jul 28, 2020

#include <stdio.h>

int main(int argc, char *argv[]) {   
    FILE *f1 = fopen(argv[1], "r");
    FILE *f2 = fopen(argv[2], "r");
    
    int byte1 = 0;
    int byte2 = 0;    
    int i = 0;
    while ((byte1 = fgetc(f1)) == (byte2 = fgetc(f2))) { 
        // If identical
        if (byte1 ==  EOF && byte2 == EOF) {
            printf("Files are identical\n");
            return 0;
        }
        i++;
    }
    // EOF cases 
    if (byte1 == EOF && byte2 != EOF) {
        printf("EOF on %s\n", argv[1]);
    }
    else if (byte2 == EOF && byte1 != EOF) {
        printf("EOF on %s\n", argv[2]);
    } 
    else if (byte1 != EOF && byte2 != EOF) {
       // If loop breaks, specify which byte was not equal
        printf("Files differ at byte %d\n", i);
    }
    return 0;
}
