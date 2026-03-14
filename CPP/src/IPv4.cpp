// src/IPv4.cpp
#include "C:\Users\parij\OneDrive\Desktop\CPP Project\IP_Address_Manager\include\IPv4.h"

bool IPv4::validateIP() {
    regex ipv4Pattern("^(\\d{1,3}\\.){3}\\d{1,3}$");
    return regex_match(ipAddress, ipv4Pattern);
}
