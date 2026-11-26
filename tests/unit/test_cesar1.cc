// Reflected Caesar variant (Cesar.1/): enc is an involution, des(enc(m)) == m.
#include <iostream>
#include <string>
#include "../../Cesar.1/mate.h"
#include "../../Cesar.1/cesar.h"
#include "check.h"

int main() {
  std::string dic = "abcdefghijklmnopqrstuvwxyz .;-";  // as in Cesar.1/main.cc
  for (int k = 0; k <= 90; k++) {
    cesar A(dic, k);
    CHECK_EQ(A.des(A.enc(dic)), dic, "round trip, key " + std::to_string(k));
  }
  return report("cesar1");
}
