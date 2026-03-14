// include/IPv4.h
#ifndef IPV4_H
#define IPV4_H

#include "IPAddress.h"
#include <regex>

class IPv4 : public IPAddress {
public:
    IPv4(string ip){
      ipAddress = ip;
    }
    bool validateIP() override;
};

#endif
