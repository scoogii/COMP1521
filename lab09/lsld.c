// Replicate output of `ls -ld`
// Christian Nguyen - z5310911
// Jul 30, 2020

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <grp.h>
#include <pwd.h>

void pseudoFunction(char *pathname);
void getPermissions(struct stat file);
void printPermissions(uint32_t permissions);
void getNumLinks(struct stat file);
void getID(struct stat file);
void getSize(struct stat file);
void getTime(struct stat file);

#define CHECK_FILE_BIT 15
#define OWN_OFFSET 6
#define GRP_OFFSET 3
#define READ_OFFSET 2
#define WRITE_OFFSET 1

int main(int argc, char *argv[]) {
    // If no argument, assume "."
    if (argc == 1) {
        pseudoFunction(".");
    }

    for (int arg = 1; arg < argc; arg++) {
        pseudoFunction(argv[arg]);        
    }
    return 0;
}

void pseudoFunction(char *pathname) {
    struct stat file;
    if (stat(pathname, &file) != 0) {
        perror(pathname);
        exit(1);
    }

    getPermissions(file);
    getNumLinks(file);
    getID(file);
    getSize(file);
    getTime(file);
    printf(" %s\n", pathname); 
}

void getPermissions(struct stat file) {
    // Put file's mode into unsigned 32 bit int to be extracted
    uint32_t fileMode = file.st_mode;

    // Check if the argument is a file or directory
    if (((fileMode >> CHECK_FILE_BIT) & 1) == 1) {
        printf("-");
    } else {
        printf("d");
    }

    // Move owner permission to last 3 bytes to be extracted
    uint32_t ownerPerms = (fileMode >> OWN_OFFSET);
    printPermissions(ownerPerms);
    
    // Move group permissions to last 3 bits to be extracted
    uint32_t groupPerms = (fileMode >> GRP_OFFSET);
    printPermissions(groupPerms);
    
    // Move other permissions to last 3 bytes to be extracted
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

void getNumLinks(struct stat file) {
    printf(" %ld", (long)file.st_nlink);
}

void getID(struct stat file) {
    // Stack overflow help    
    struct group *grp;
    struct passwd *pwd;

    grp = getgrgid(file.st_gid);
    pwd = getpwuid(file.st_uid);

    printf(" %s", grp->gr_name);
    printf(" %s", pwd->pw_name);   
}
void getTime(struct stat file) {
    // Stack overflow help
    time_t t = (long)file.st_mtime;
    struct tm *tm;
    char buf[200];
    /* convert time_t to broken-down time representation */
    tm = localtime(&t);
    /* format time days.month.year hour:minute:seconds */
    strftime(buf, sizeof(buf), " %b %d %H:%M", tm);
    printf("%6s", buf);
}

void getSize(struct stat file) {     
    printf(" %ld", file.st_size);
}















