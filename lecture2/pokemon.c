// Represent a small set of possible values using bits

int main(void) {

    // give our pokemon 3 types
    int pokemon_type = BUG_TYPE | POISON_TYPE | FAIRY_TYPE;

    printf("0x%04xd\n", pokemon_type);

    if (pokemon_type & POISON_TYPE) {
        printf("Danger poisonous\n"); // prints
    }

    if (pokemon_type & GHOST_TYPE) {
        printf("Scary\n"); // does not print
    }

    return 0;
}