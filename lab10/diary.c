// C Program that appends 1 line to $HOME/.diary
// Christian Nguyen - z5310911
// 4 Aug, 2020

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    // Set new env variable value to '$HOME'
    char *env_value = getenv("HOME");
    
    // Construct pathname  
    char pathname[256];
    snprintf(pathname, sizeof pathname, "%s/.diary", env_value);
    
    // Create file .diary with append permissons
    FILE *appendToFile = fopen(pathname, "a");
    if (appendToFile == NULL) {
        perror(pathname);
        return 1;
    }
    
    for (int arg = 1; arg < argc; arg++) {
        fprintf(appendToFile, "%s ", argv[arg]);
    }
    fprintf(appendToFile, "\n");

    fclose(appendToFile);
    return 0;

}
