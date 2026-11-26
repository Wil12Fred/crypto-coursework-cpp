// "control" (Control/): rail fence -> route -> affine layer keyed by a string.
// Decrypting with the same key undoes all three layers.
#include <iostream>
#include <vector>
#include <cstring>
#include <string>
#include "../../Control/mate.h"
#include "../../Control/cesar.h"
#include "../../Control/vaya.h"
#include "../../Control/ruta.h"
#include "../../Control/arv.h"
#include "check.h"

int main() {
  const char *keys[] = {"holamundo", "abcdefghij", "WilberCutire", "zz",
                        "JonathanMollapazaApazaJimmy"};
  std::string m = "holamundo Hola Mundo";
  for (const char *k : keys) {
    for (int sc = 2; sc <= 8; sc++) {
      std::string tag = std::string(" key ") + k + " " + std::to_string(sc);
      arv A(k, sc);
      int a1 = a(k, sc), b1 = b(k, sc);
      if (gcd(a1, (ll)dic.size()) != 1) continue;  // no inverse for this key
      vaya V(dic, sc);
      ruta R(dic, sc);
      std::string v = V.encriptar(m);
      std::string enc = A.encriptar(R.encriptar(v), a1, b1);
      std::string des = R.desencriptar(A.desencriptar(enc));
      des.resize(v.size());
      des = V.desencriptar(des);
      CHECK_EQ(des.substr(0, m.size()), m, "round trip" + tag);
    }
  }
  return report("control");
}
