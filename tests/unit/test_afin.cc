// Affine cipher (AFIN/): the constructor returns (it used to loop forever)
// and des(enc(m)) == m for many random keys.
#include <iostream>
#include <cstdlib>
#include <cstring>
#include <string>
#include "../../Control/mate.h"
#include "../../AFIN/afin.h"
#include "check.h"

int main() {
  std::string dic = "abcdefghijklmnopqrstuvwxyz";
  for (unsigned seed = 1; seed <= 200; seed++) {
    std::srand(seed);
    afin A(dic);
    std::string e = A.encriptar(dic);
    CHECK_EQ(A.desencriptar(e), dic, "round trip, seed " + std::to_string(seed));
  }
  // inv() from Control/mate.h is what decryption relies on.
  for (ll a = 1; a < 26; a++)
    if (gcd(a, 26) == 1)
      CHECK(mod(a * inv(a, 26), 26) == 1, "inverse of " + std::to_string(a));
  return report("afin");
}
