#ifndef INIT_SOCKET_H
#define INIT_SOCKET_H
#include <netinet/in.h>

#define BACKLOG 20
#define PORT 7890

int init_socket(int *listen_fd, struct sockaddr_in *server_addr);

#endif
