// src/Device.cpp
#include "C:\Users\parij\OneDrive\Desktop\CPP Project\IP_Address_Manager\include\Device.h"
#include <iostream>
using namespace std;

Device::Device(string n, string m, IPAddress* ipPtr)
    : name(n), mac(m), ip(ipPtr) {}

void Device::display() const {
    cout << "Device: " << name << " | MAC: " << mac
         << " | IP: " << ip->getIP() << endl;
}
