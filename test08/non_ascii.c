// Check if a file is ASCII or non-ASCII
// If non-ASCII, state at which byte it was
// Christian Nguyen - z5310911
// Jul 29, 2020

#include <stdio.h>
#include <ctype.h>

int main(int argc, char *argv[]) {
    FILE *f = fopen(argv[1], "r");

    int c = 0;
    int i = 0;
    while ((c = fgetc(f)) != EOF) {
        if (128 <= c && c <= 255) {
            printf("%s: byte %d is non-ASCII\n", argv[1], i);
            return 1;
        }
        i++;
    }
    printf("%s is all ASCII\n", argv[1]);
    return 0;
}
