// Print out last line of a given file
// Christian Nguyen - z5310911
// Jul 22, 2020

// The last byte doesnt really matter,
// And the greater aim is to find whether there is the existence of an '\n'
// If we read from the end, we satisfy BOTH scenarios and hence we can treat it as one case
// Therefore, it boils down to printing the entire file (if no '\n') or printing right after '\n'.

#include <stdio.h>

void searchNewLine(FILE *fd);
void printRemBytes(FILE *fd);

int main(int argc, char *argv[]) {
    FILE *fd = fopen(argv[1], "r");
    if (fd == NULL) {
        perror(argv[1]);
        return 1;
    }

    // Finds current position that is required
    searchNewLine(fd);
    // Print from current position to EOF
    printRemBytes(fd);

    fclose(fd);
    return 0;
}

// Searched for newline char, if none - returns NOT_EXIST, if there is - returns EXIST
void searchNewLine(FILE *fd) {
    // Set position at the end of file
    fseek(fd, 0, SEEK_END);
    int c = 0;
    // Loop and find '\n'
    while ((fseek(fd, -2, SEEK_CUR)) != -1) {
        c = fgetc(fd);
        // Sets the current position right AFTER '\n'
        if (c == '\n') {
            return;
        }
        // If sparse file, just set from beginning and print entire file
        if (c == 0) {
            fseek(fd, 0, SEEK_SET);
            return;
        }
    }
    // If can't find new line AND it's not a sparse file, print entire file
    fseek(fd, 0, SEEK_SET);
    return;
}

// Print out bytes from current position in file
void printRemBytes(FILE *fd) {
    int c = 0;
    while ((c = fgetc(fd)) != EOF) {
        printf("%c", c);
    }
}
