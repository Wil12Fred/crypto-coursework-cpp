#include <iostream>
#include <vector>
#include <cstring>
#include <limits>
#include "mate.h"
#include "cesar.h"
#include "vaya.h"
#include "ruta.h"
#include "arv.h"

using namespace std;

int main(){
  arv A("JonathanMollapazaApazaJimmyJonathanMollapazaApazaJimmy",8);
  int i,j=1;
  cout << "1=encriptar\n2=desencriptar\n";
  cin >> i;
  while (j){
    if (i==1){
      string sdic;
      ll sc;
      cout << "a - b\n";
      cin >> sdic >> sc;
      //cesar Cesar(dic,sc);
      //sdic=Cesar.des(sdic);
      //sdic="Wilber Cutire Sivincha Wilber Cutire Sivincha";
      //sc=10;
      int a1=a(sdic,sc);
      int b1=b(sdic,sc);
      cout << a1 << " " << b1 << endl;
      string enc;
      vaya Vaya(dic,sc);
      ruta Ruta(dic,sc);
      enc=Vaya.encriptar("holamundoholamundoholamundoholamundoholamundo");
      cout << enc.size() << endl;
      enc=Ruta.encriptar(enc);
      enc=A.encriptar(enc,a1,b1);
      cout << enc << endl;
    }
    if (i==2){
      // Decrypt with the same key the message was encrypted with: the
      // key string and number give the affine pair (a, b) and the size
      // of the rail fence and route grids.
      string sdic;
      ll sc;
      cout << "a - b\n";
      cin >> sdic >> sc;
      arv K(sdic,sc);
      // The ciphertext alphabet contains ' ', so the ciphertext is read
      // as a whole line, and its length (before padding removal) after it.
      int tam;
      string enc;
      cin.ignore(numeric_limits<streamsize>::max(),'\n');
      getline(cin,enc);
      cin >> tam;
      string des;
      vaya Vaya(dic,sc);
      ruta Ruta(dic,sc);
      des=K.desencriptar(enc);
      des=Ruta.desencriptar(des);
      for (i=des.size();i!=tam;i=des.size()){
        des.erase(des.begin()+i-1);
      }
      des=Vaya.desencriptar(des);
      cout << des << endl;
    }
    cout << "1=encriptar\n2=desencriptar\n";
    if (!(cin >> i)) break;  // stop at end of input
  }
  return 0;
}
