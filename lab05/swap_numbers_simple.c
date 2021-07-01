// Read 10 numbers into an array
// swap any pair of numbers which are out of order
// then print the array

#include <stdio.h>

int main(void) {
    
    int numbers[10] = { 0 };

    int i = 0;

Loop0:
    if (i >= 10) goto Loop1Prompt;

        scanf("%d", &numbers[i]);
        i++;

    goto Loop0;

Loop1Prompt:
    i = 1;

Loop1:
    if (i >= 10) goto beforePrint;

        int x = numbers[i];
        int y = numbers[i-1];

        if (x < y) goto Swap;

        i++;

        goto Loop1;
    
Swap:
    numbers[i] = y;
    numbers[i - 1] = x;
    
    i++;

    goto Loop1;

beforePrint:
    i = 0;
    
Print:
    if (i >= 10) goto End;
        printf("%d", numbers[i]);
        printf("\n");
        i++;
    
    goto Print;

End:
    return 0;

}