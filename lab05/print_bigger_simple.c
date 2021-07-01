// Read 10 numbers into an array
// Then print the numbers which are
// larger than the last number read

#include <stdio.h>

int main(void) {
    int i, last_number;
    int numbers[10] = { 0 };

    i = 0;

read:
    if (i >= 10) goto printPrompt;

        scanf("%d", &numbers[i]);
        
        last_number = numbers[i];

        i++;
    goto read;
    
printPrompt:
    i = 0;

printLoop:
   
    if (i >= 10) goto end;
    if (numbers[i] >= last_number) goto validPrint;

    i++;
    goto printLoop;

validPrint:
    printf("%d\n", numbers[i]);        
    
    i++;

    goto printLoop;

end:
    return 0;
}