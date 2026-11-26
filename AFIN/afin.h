typedef long long ll;
using namespace std;

class afin{
  int a;
  int b;
  public:
    ll MOD;
    string m_dic;
    afin(string dic){
      m_dic=dic;
      MOD=dic.size();
      b=rand()%MOD;
      do {
        a=rand()%MOD;
      } while (gcd(MOD,a)!=1);
    }
    string encriptar(string mns){
      string enc;
      for (int i=0;i<mns.size();i++){
        int aux=m_dic.find(mns[i]);
        enc.push_back(m_dic[((aux*a)%MOD+b)%MOD]);
      }
      return enc;
    }
    string desencriptar(string enc){
      string mns;
      for (int i=0;i<enc.size();i++){
        int aux=m_dic.find(enc[i]);
        mns.push_back(m_dic[mod(mod(aux-b,MOD)*inv(a,MOD),MOD)]);
      }
      return mns;
    }
};
