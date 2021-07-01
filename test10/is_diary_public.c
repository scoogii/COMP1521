// Checks if diary is publically readable
// Prints 1 if $HOME/.diary exists and is publically readable
// Otherwise print 0
// Christian Nguyen - z5310911
// Aug 13, 2020

#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>

#define READ_BITS 2

void checkPublicRead(char *pathname);

int main(void) {
    // Set new env variable value to $HOME
    char *env_value = getenv("HOME");
    
    // Construct pathname
    char pathname[256];
    snprintf(pathname, sizeof pathname, "%s/.diary", env_value);

    checkPublicRead(pathname);

    return 0;
}

void checkPublicRead(char *pathname) {
    // First, stat file and see if it exists 
    struct stat file;
    if (stat(pathname, &file) != 0) {
        printf("0\n");
        return;
    }    
    // Put filemode into 32 bits to be extracted
    uint32_t fileMode = file.st_mode;
    
    // Bit mask so that we get last 3 bits only
    uint32_t otherPerms = fileMode & 0b111;
    
    // Bitwise op. to check if perms incl. public read
    if ((otherPerms >> READ_BITS) & 1) {
        printf("1\n");
    } else {
        printf("0\n");
    }
}
