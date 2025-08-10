#include "pcg_basic.h"
#include "randombytes.h"
#include "uECC.h"
#include <stdint.h>

int main(void) {
  const uint64_t initstate = 0x01234567; // Will be overwritten in fault-finder
  const uint64_t initseq = 0x89abcdef;   // Will be overwritten in fault-finder
  pcg32_srandom(initstate, initseq);
  uECC_set_rng(&myrandombytes);
  const struct uECC_Curve_t *curve = uECC_secp256k1();
  const uint8_t public_key[64];
  const uint8_t private_key[32];
  uint8_t result[32];
  uECC_shared_secret(public_key, private_key, result, curve);
  return 0;
}
