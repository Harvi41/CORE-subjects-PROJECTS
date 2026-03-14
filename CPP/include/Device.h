// include/Device.h
#ifndef DEVICE_H
#define DEVICE_H

#include <string>
#include "IPAddress.h"
using namespace std;

class Device {
private:
    string name;
    string mac;
    IPAddress* ip;
public:
    Device(string n, string m, IPAddress* ipPtr);
    void display() const;
    string getMAC() const { return mac; }
    string getIP() const { return ip->getIP(); }
};

#endif
