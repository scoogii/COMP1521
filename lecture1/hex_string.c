// Converting decimal/hex to print decimal and hex
// Christian Nguyen - z5310911
// June 4, 2020

#include <stdio.h>
#include <stdint.h>

void print_bits(uint32_t value);
int get_nth_bit(uint32_t value, int n);

int main(int argc, char *argv[]) {
    char *hex_string = argv[1];
    uint32_t i = 0;
    
    for (int pos = 0; hex_string[pos] != 0; pos++) {
        int ascii_digit = hex_string[pos];
        int digit_as_int;
        // For one digit
        if (ascii_digit >= '0' && ascii_digit <= '9') {
            digit_as_int = ascii_digit - '0';
        // For 2 digit numbers (A - F)
        } else if (ascii_digit >= 'A' && ascii_digit <= 'F') {
            digit_as_int = 10 + (ascii_digit - 'A'); // 10 + character position
        } else {
            fprintf(stderr, "Bad digit '%c'\n", ascii_digit);

            return 1;
        }
        i = i << 4;
        i = i | digit_as_int;
    }
    
    printf("i = %d in decimal and %x in hex\n", i, i);

    return 0;
}