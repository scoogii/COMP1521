// Checks if pathname exists and is a directory
// Print 1 if so, print 0 otherwise
// Christian Nguyen - z5310911
// Aug 13, 2020

#include <stdio.h>
#include <dirent.h>

int main(int argc, char *argv[]) {
    DIR *dirp = opendir(argv[1]);

    if (dirp == NULL) {
        printf("0\n");
        return 1;
    } else {
        printf("1\n");
    }
    closedir(dirp);

}
