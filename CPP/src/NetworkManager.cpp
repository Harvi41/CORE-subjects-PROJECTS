// src/NetworkManager.cpp
#include "C:\Users\parij\OneDrive\Desktop\CPP Project\IP_Address_Manager\include\NetworkManager.h"
#include "C:\Users\parij\OneDrive\Desktop\CPP Project\IP_Address_Manager\include\IPv4.h"
#include <iostream>
#include <sstream>
using namespace std;

int NetworkManager::totalAssigned = 0;

string NetworkManager::generateDynamicIP() {
    int base = 10 + totalAssigned;
    stringstream ss;
    ss << "192.168.0." << base;
    return ss.str();
}

void NetworkManager::addDevice() {
    string name, mac, ip, type;
    cout << "Enter device name: ";
    cin >> name;
    cout << "Enter MAC address: ";
    cin >> mac;
    cout << "Static or Dynamic IP? (s/d): ";
    cin >> type;

    if (type == "s") {
        cout << "Enter IPv4 address: ";
        cin >> ip;
    } else {
        ip = generateDynamicIP();
    }

    IPv4* ipObj = new IPv4(ip);
    if (!ipObj->validateIP()) {
        cout << "❌ Invalid IP format!\n";
        delete ipObj;
        throw invalid_argument("Invalid IP format!");
    }
      if (isDuplicateIP(ip)) {
        cout << "⚠️ Duplicate IP detected! Device not added.\n";
        delete ipObj;
        throw runtime_error("Duplicate IP detected!");
    }

    Device d(name, mac, ipObj);
    devices.push_back(d);
    totalAssigned++;
    cout << "✅ Device added successfully.\n";
    logToFile(d);
}

void NetworkManager::showDevices() const {
    if (devices.empty()) {
        cout << "No devices found.\n";
        return;
    }

    cout << "\n--- Device List ---\n";
    for (const auto& d : devices) {
        d.display();
    }
    cout << "-------------------\n";
}
bool NetworkManager::isDuplicateIP(const string& ip) const {
    for (const auto& d : devices) {
        if (d.getIP() == ip)
            return true;
    }
    return false;
}
#include <fstream>   // for file handling

void NetworkManager::logToFile(const Device& d) const {
    ofstream file("logs/assigned_ips.txt", ios::app); // append mode
    if (file.is_open()) {
        file << "Device: " << d.getMAC()
             << " | IP: " << d.getIP() << endl;
        file.close();
    } else {
        cout << "⚠️ Could not open log file!" << endl;
    }
}


