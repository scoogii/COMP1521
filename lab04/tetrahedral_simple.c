// Simpler version of printing the first n tetrahedral numbers

#include <stdio.h>

int main(void) {
    int i;
    int j;
    int n;
    int total;
    int how_many;

    printf("Enter how many: ");

    scanf("%d", &how_many);

    n = 1;

start_loop1:
    if (n > how_many) goto end;

    total = 0;
    j = 1;

start_loop2:
    if (j > n) goto end_loop2;

    i = 1;

start_loop3:
    if (i > j) goto end_loop3;
     
    total = total + i;
    i = i + 1;

    goto start_loop3;

end_loop3:
    j = j + 1;
    
    goto start_loop2;

end_loop2:
    printf("%d", total);
    printf("\n");

    n = n + 1;
    
    goto start_loop1;

end:
    return 0;

}
