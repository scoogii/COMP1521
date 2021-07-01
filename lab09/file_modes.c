// Write a C program, file_modes.c, which is given one or more pathnames as command line arguments. 
// It should print one line for each pathnames which gives the permissions of the file or directory.
// Christian Nguyen - z5310911
// July 26, 2020

#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define CHECK_FILE_BIT 15
#define OWN_OFFSET 6
#define GRP_OFFSET 3
#define READ_OFFSET 2
#define WRITE_OFFSET 1


void getPermissions(char *pathname);
void printPermissions(uint32_t permissions);

int main(int argc, char *argv[]) {
    for (int arg = 1; arg < argc; arg++) {
        getPermissions(argv[arg]);
        printf(" %s\n", argv[arg]);
    }
    
    return 0;
}

void getPermissions(char *pathname) {
    struct stat file;
    if (stat(pathname, &file) != 0) {
        perror(pathname);
        exit(1);
    }

    // Put file's mode into unsigned int 32 bits to be extracted
    uint32_t fileMode = file.st_mode;

    // Check if the argument is a file or directory
    if (((fileMode >> CHECK_FILE_BIT) & 1) == 1) {
        printf("-");
    } else {
        printf("d");
    }

    // Move owner permissions to last 3 bits to be extracted
    uint32_t ownerPerms = (fileMode >> OWN_OFFSET);
    printPermissions(ownerPerms);

    // Move group permissions to last 3 bits to be extracted
    uint32_t groupPerms = (fileMode >> GRP_OFFSET);
    printPermissions(groupPerms);

    // Move other permissions to last 3 bits to be extracted
    uint32_t otherPerms = fileMode;
    printPermissions(otherPerms);    
}

void printPermissions(uint32_t permissions) {
    // Read permissions
    if ((permissions >> READ_OFFSET) & 1) {
        printf("r");
    } else {
        printf("-");
    }
    // Write permissions
    if ((permissions >> WRITE_OFFSET) & 1) {
        printf("w");
    } else {
        printf("-");
    }
    // Execute permissions
    if (permissions & 1) {
        printf("x");
    } else {
        printf("-");
    }
}














