// Sieve of Eratosthenes

#include <stdio.h>
#include <stdint.h>

uint8_t prime[1000];

int main(void) {

    int i = 0;

Loop1:
    if (i >= 1000) goto Loop2Prompt;
        prime[i] = 1;
        i++;

    goto Loop1;

Loop2Prompt:
    i = 2;

OuterLoop2:
    if (i >= 1000) goto End;
        if (prime[i] != 0) {
            printf("%d", i);
            printf("\n");
        }

NestedLoop2:
    int j = 2 * i;

    if  (j >= 1000) goto Loop2Step;
        prime[j] = 0;
        j = j + i;

    goto NestedLoop2;

Loop2Step:
    i++;

    goto OuterLoop2;

End:
    return 0;
}