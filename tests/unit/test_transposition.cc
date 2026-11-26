// Route (ruta/) and rail-fence (vaya/) transposition ciphers: decrypting the
// ciphertext gives the plaintext back followed only by the 'x' padding.
#include <iostream>
#include <string>
#include <vector>
#include "../../vaya/mate.h"
#include "../../vaya/vaya.h"
#include "../../ruta/ruta.h"
#include "check.h"

static bool is_padded(const std::string &got, const std::string &m) {
  if (got.compare(0, m.size(), m) != 0) return false;
  for (size_t i = m.size(); i < got.size(); i++)
    if (got[i] != 'x') return false;
  return true;
}

int main() {
  std::string al = "abcdefghijklmnopqrstuvwyz";  // no 'x', so padding is visible
  for (int k = 2; k <= 9; k++) {
    for (int len = 1; len <= 60; len++) {
      std::string m;
      for (int i = 0; i < len; i++) m.push_back(al[(i * 7 + k) % al.size()]);
      std::string tag = " key " + std::to_string(k) + " len " + std::to_string(len);

      ruta R(al, k);
      std::string e = R.encriptar(m);
      CHECK(e.size() % k == 0, "ruta ciphertext fills the grid" + tag);
      CHECK(is_padded(R.desencriptar(e), m), "ruta round trip" + tag);

      vaya V(al, k);
      e = V.encriptar(m);
      CHECK(is_padded(V.desencriptar(e), m), "vaya round trip" + tag);
    }
  }
  return report("transposition");
}
