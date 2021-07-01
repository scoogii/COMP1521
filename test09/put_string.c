#include <stdio.h>

#include "put_string.h"

// print s to stdout with a new line appended using fputc (only)

void put_string(char *s) {
    int i = 0;
    while (s[i] != '\0') {
        fputc(s[i], stdout);
        i++;
    }
    s[i] = '\n';
    fputc(s[i], stdout);
}
