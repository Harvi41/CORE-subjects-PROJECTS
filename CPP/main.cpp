#include "C:\Users\parij\OneDrive\Desktop\CPP Project\IP_Address_Manager\include\NetworkManager.h"
#include "C:\Users\parij\OneDrive\Desktop\CPP Project\IP_Address_Manager\include\Admin.h"
#include <iostream>
#include <stdexcept>
using namespace std;

int main() {
    NetworkManager nm;
    Admin admin;
    char more = 'y';

    while (more == 'y' || more == 'Y') {
        try {
            nm.addDevice();
        }
        catch (const invalid_argument& e) {
            cout << "❌ Error: " << e.what() << endl;
        }
        catch (const runtime_error& e) {
            cout << "⚠️ Warning: " << e.what() << endl;
        }
        cout << "Add another device? (y/n): ";
        cin >> more;
    }

    cout << "\n--- Normal Device List ---\n";
    nm.showDevices();

    cout << "\nDo you want Admin View? (y/n): ";
    char adminView;
    cin >> adminView;

    if (adminView == 'y' || adminView == 'Y') {
        admin.viewAllDevices(nm);
    }

    return 0;
}
