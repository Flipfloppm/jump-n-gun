#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <ifaddrs.h>
void get_network_info(char* ip_address, char* network_address) {
    struct hostent *host;
    char hostname[256];
    gethostname(hostname, sizeof(hostname));
    host = gethostbyname(hostname);

    if (host == NULL) {
        fprintf(stderr, "Error getting host information.\n");
        exit(EXIT_FAILURE);
    }

    // Get IP address
    strcpy(ip_address, inet_ntoa(*((struct in_addr*) host->h_addr_list[0])));

    // Get subnet mask
    struct ifaddrs *ifap, *ifa;
    struct sockaddr_in *sa;
    char *addr;

    getifaddrs (&ifap);
    for (ifa = ifap; ifa; ifa = ifa->ifa_next) {
        if (ifa->ifa_addr->sa_family==AF_INET && strcmp(ifa->ifa_name, "en0") == 0) {
            sa = (struct sockaddr_in *) ifa->ifa_netmask;
            addr = inet_ntoa(sa->sin_addr);
            // printf("Interface: %s\tAddress: %s\n", ifa->ifa_name, addr);
        }
    }

    struct in_addr subnet_mask;
    if (inet_pton(AF_INET, addr, &subnet_mask) != 1) {
        fprintf(stderr, "Error converting subnet mask to binary.\n");
        exit(EXIT_FAILURE);
    }

    // Convert IP address and subnet mask to binary
    struct in_addr ip_addr_binary, network_binary;
    if (inet_pton(AF_INET, ip_address, &ip_addr_binary) != 1) {
        fprintf(stderr, "Error converting IP address to binary.\n");
        exit(EXIT_FAILURE);
    }

    // Calculate network address using bitwise AND
    network_binary.s_addr = ip_addr_binary.s_addr |  ~subnet_mask.s_addr;

    // Convert network address back to dotted-decimal format
    strcpy(network_address, inet_ntoa(network_binary));
}

int main() {
    char ip_address[INET_ADDRSTRLEN];
    char network_address[INET_ADDRSTRLEN];

    get_network_info(ip_address, network_address);

    // printf("IP Address: %s\n", ip_address);
    // printf("Network broadcast Address: %s\n", network_address);
    printf("%s", network_address);

    return 0;
}
