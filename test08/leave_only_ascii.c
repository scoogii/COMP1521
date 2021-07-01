// After running a file, make sure it only has ASCII bytes left
// Christian Nguyen - z5310911
// Jul 28, 2020

#include <stdio.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    FILE *f = fopen(argv[1], "r"); 
    FILE *tmp = fopen("tmp.txt", "w+");

    int c = 0;
    // Write all the ascii bytes into tmp file
    while ((c = fgetc(f)) != EOF) {
        // If ASCII
        if (c < 128 || c > 255) {
            // Chuck ASCII byte into tmp file
            fputc(c, tmp);          
        }
    }
    f = fopen(argv[1], "w"); 
    fseek(tmp, 0, SEEK_SET);
    // Now, rewrite f file with tmp's ascii file    
    while ((c = fgetc(tmp)) != EOF) {
        fputc(c, f);
    }
    fclose(f);
    return 0;
}
