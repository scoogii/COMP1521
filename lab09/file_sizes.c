// Check the size of files that were given from command line(in bytes)
// Christian Nguyen - z5310911
// July 26, 2020

#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>

long long get_size(char *pathname);

int main(int argc, char *argv[]) {
    long long totalBytes = 0;
    for (int arg = 1; arg < argc; arg++) {
        totalBytes = (totalBytes) + (get_size(argv[arg]));   
    }
    printf("Total: %lld bytes\n", totalBytes);
    return 0;
}

long long get_size(char *pathname) {
    struct stat file;

    printf("%s: ", pathname);

    if (stat(pathname, &file) != 0) {
        perror(pathname);
        exit(1);
    }

    printf("%ld bytes\n", file.st_size);

    return file.st_size;
}





