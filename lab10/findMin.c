// Finding minimum value in an array


#include <stdio.h>

int main(void) {
    int array[5] = {1, 3, 4, 2, 1};
    
    int min = array[0];
    for (int i = 0; i < 5; i++) {
        if (min > array[i]) {
            min = array[i];
        }
    }

    printf("The minimum value in the array is %d\n", min);

    return 0;
}
