
int main(void) {
    // common C bug
    //
    // char may be signed (e.g. x86) or unsigned (powerpc)
    //
    // if char is signed (-128..127)
    // loop will incorrect exit for a byte containing 0xFF
    //
    // if char is unsigned (0..255)
    // loop will never exit
    //
    // fix bug by making c int
    //

    char c;
    while ((c = getchar()) != EOF) {
        putchar(c);
    }

    return 0;
}