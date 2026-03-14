#ifndef ADMIN_H
#define ADMIN_H

#include "NetworkManager.h"
#include <iostream>
using namespace std;

class Admin {
public:
    void viewAllDevices(const NetworkManager& nm);
};

#endif
