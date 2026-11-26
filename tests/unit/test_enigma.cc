// Enigma simulator (EnigmaSimulator/): with a symmetric reflector the machine
// is its own inverse, so enc(enc(m)) == m, and no letter maps to itself.
#define main enigma_main
#include "../../EnigmaSimulator/enigma.cc"
#undef main
#include "check.h"

int main() {
  std::string m;
  for (int r = 0; r < 4; r++) m += dic;  // 104 letters: every rotor offset
  m += "HOLAMUNDOIJKIJKIJK";
  std::string e = encriptar(m);
  CHECK_EQ(encriptar(e), m, "decrypting the ciphertext gives the plaintext");
  for (size_t i = 0; i < m.size(); i++)
    CHECK(e[i] != m[i] && dic.find(e[i]) != std::string::npos,
          "position " + std::to_string(i) + " maps to a different letter");
  return report("enigma");
}
