// Read 10 numbers into an array
// Print 0 if they are in non-decreasing order
// Print 1 otherwise

#include <stdio.h>

int condition;

int main(void) {
    
    int numbers[10] = { 0 };

    int i = 0;

loop0Start:
    if (i >= 10) goto loop1Prompt;

        scanf("%d", &numbers[i]);

        i++;

    goto loop0Start;

loop1Prompt:
    condition = 0;
    i = 1;

loop1Start:
    if (i >= 10) goto end;

    int x = numbers[i];
    int y = numbers[i - 1];

    if (x < y) goto fail;

    i++;
    goto loop1Start;

fail:
    condition = 1;

end:
    printf("%d", condition);
    printf("\n");

    return 0;

}