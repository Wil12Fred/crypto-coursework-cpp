// Caesar cipher (Cesar/): des(enc(m)) == m for every key and every symbol.
#include <iostream>
#include <string>
#include "../../Cesar/mate.h"
#include "../../Cesar/cesar.h"
#include "check.h"

int main() {
  // Same alphabet as Cesar/main.cc.
  std::string dic = "abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ\n";
  for (int k = -60; k <= 120; k++) {
    cesar A(dic, k);
    std::string e = A.enc(dic);
    CHECK_EQ(A.des(e), dic, "round trip, key " + std::to_string(k));
  }
  cesar A(dic, 3);
  CHECK_EQ(A.enc("abc"), std::string("def"), "known answer, key 3");
  return report("cesar");
}
