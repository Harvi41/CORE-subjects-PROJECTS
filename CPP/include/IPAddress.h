// include/IPAddress.h
#ifndef IPADDRESS_H
#define IPADDRESS_H
#include<string>
using namespace std;

class IPAddress{
protected:
  string ipAddress;
public:
  IPAddress(){}
  IPAddress(string ip){
    ipAddress = ip;
  }
  virtual bool validateIP() = 0;

  string getIP(){
    return ipAddress;
  }
  void setIP(string ip){
    ipAddress = ip;
  }
  virtual ~IPAddress() {}
};
#endif