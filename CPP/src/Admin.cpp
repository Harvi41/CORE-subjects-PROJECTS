#include "C:\Users\parij\OneDrive\Desktop\CPP Project\IP_Address_Manager\include\Admin.h"

void Admin::viewAllDevices(const NetworkManager& nm) {
    cout << "\n===== ADMIN VIEW =====\n";
    if (nm.devices.empty()) {
        cout << "No devices in the network.\n";
        return;
    }

    for (const auto& d : nm.devices) {
        d.display();
    }

    cout << "------------------------\n";
    cout << "Total IPs Assigned: " << nm.totalAssigned << endl;
    cout << "========================\n";
}
