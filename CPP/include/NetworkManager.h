#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <vector>
#include "Device.h"
using namespace std;

class NetworkManager {
private:
    vector<Device> devices;
    static int totalAssigned;
    string generateDynamicIP();
    bool isDuplicateIP(const string& ip) const;
    void logToFile(const Device& d) const;

public:
    void addDevice();
    void showDevices() const;
    
    friend class Admin;

};

#endif
