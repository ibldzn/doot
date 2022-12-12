#include <gmp.h>
#include <stdio.h>
#include <stdlib.h>

void fibonacci(const mpz_t n, mpz_t out)
{
    mpz_set_ui(out, 0);

    if (mpz_cmp_ui(n, 1) == 0) {
        mpz_set_ui(out, 1);
        return;
    }

    mpz_t iterator, last, curr;
    mpz_init_set_ui(iterator, 1);
    mpz_init_set_ui(last, 0);
    mpz_init_set_ui(curr, 1);

    for (; mpz_cmp(iterator, n) < 0; mpz_add_ui(iterator, iterator, 1)) {
        mpz_add(out, last, curr);
        mpz_set(last, curr);
        mpz_set(curr, out);
    }

    mpz_clear(curr);
    mpz_clear(last);
    mpz_clear(iterator);
}

int main(int argc, char** argv)
{
    if (argc != 2) {
        fprintf(stderr, "Usage: %s [base 10 int]\n", argv[0]);
        return 1;
    }

    mpz_t n, hasil;
    if (mpz_init_set_str(n, argv[1], 10) == -1) {
        printf("%s is not a valid base 10 int!\n", argv[1]);
        return 1;
    }

    mpz_init(hasil);
    fibonacci(n, hasil);

    char* hasil_str = mpz_get_str(NULL, 10, hasil);
    puts(hasil_str);
    free(hasil_str);

    mpz_clear(hasil);
    mpz_clear(n);
}
