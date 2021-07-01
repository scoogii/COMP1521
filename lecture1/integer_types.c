#include <stdio.h>
#include <limits.h>

int main(void) {

    char c;
    printf("char               %lu bytes min=%20d, max=%20d\n", sizeof c, CHAR_MIN, CHAR_MAX);
    signed char sc;
    printf("signed char        %lu bytes min=%20d, max=%20d\n", sizeof sc, SCHAR_MIN, SCHAR_MAX);
    unsigned char uc;
    printf("unsigned char      %lu bytes min=%20d, max=%20d\n", sizeof uc, 0, UCHAR_MAX);

    short s;
    printf("short              %lu bytes min=%20d, max=%20d\n", sizeof s, SHRT_MIN, SHRT_MAX);
    unsigned short us;
    printf("unsigned short     %lu bytes min=%20d, max=%20d\n", sizeof us, 0, USHRT_MAX);

    int i;
    printf("int                %lu bytes min=%20d, max=%20d\n", sizeof i, INT_MIN, INT_MAX);
    unsigned int ui;
    printf("unsigned int       %lu bytes min=%20d, max=%20d\n", sizeof ui, 0, UINT_MAX);

    long l;
    printf("long               %lu bytes min=%20ld, max=%20ld\n", sizeof l, LONG_MIN, LONG_MAX);
    unsigned long ul;
    printf("unsigned long      %lu bytes min=%20d, max=%20lu\n", sizeof ul, 0, ULONG_MAX);

    long long ll;
    printf("long long          %lu bytes min=%20lld, max=%20lld\n", sizeof ll, LLONG_MIN, LLONG_MAX);
    unsigned long long ull;
    printf("unsigned long long %lu bytes min=%20d, max=%20llu\n", sizeof ull, 0, ULLONG_MAX);

    return 0;
}