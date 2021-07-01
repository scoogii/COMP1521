// Read 10 numbers into an array
// bubblesort them
// then print them

#include <stdio.h>

int swapped;

int main(void) {
    int numbers[10] = { 0 };

    int i = 0;

Scan:
    if (i >= 10) goto Loop1Prompt;   

        scanf("%d", &numbers[i]);
        i++;

    goto Scan;

Loop1Prompt:
    swapped = 1;

Loop1:
    if (swapped == 0) goto PrintPrompt;

        swapped = 0;
        i = 1;
    
    goto Loop2;

Loop2:
    if (i >= 10) goto Loop1;
        int x = numbers[i];
        int y = numbers[i-1];
        
        if (x < y) goto Swap;

        i++;
    goto Loop2;

Swap:
    numbers[i] = y;
    numbers[i-1] = x;
    swapped = 1;
    
    i++;
    goto Loop2;


PrintPrompt:
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