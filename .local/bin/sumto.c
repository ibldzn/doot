#include <gmp.h>
#include <stdio.h>
#include <stdlib.h>

void sum_to(const mpz_t n, mpz_t out) {
  mpz_t v;
  mpz_init(v);

  mpz_add_ui(v, n, 1);
  mpz_mul(out, n, v);
  mpz_divexact_ui(out, out, 2);

  mpz_clear(v);
}

int main(int argc, char **argv) {
  if (argc < 2) {
    printf("Usage: %s [base 10 int]\n", argv[0]);
    return 1;
  }

  mpz_t n;
  if (mpz_init_set_str(n, argv[1], 10) == -1) {
    printf("%s is not a valid base 10 int!\n", argv[1]);
    return 1;
  }

  mpz_t res;
  mpz_init(res);

  sum_to(n, res);

  char *res_str = mpz_get_str(NULL, 10, res);
  puts(res_str);

  free(res_str);
  mpz_clear(res);
  mpz_clear(n);
}