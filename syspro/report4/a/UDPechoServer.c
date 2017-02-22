#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>


#define BUFSIZE 1024

int udpechoserver(int port_number)
{
		int sock;
		struct sockaddr_in addr;
		socklen_t recvlen = sizeof(addr);
		char buf[BUFSIZE];

		sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
		if(sock == -1){
				perror("socket in server");
				close(sock);
				return 1;
		}

		addr.sin_family = AF_INET;
		addr.sin_port = htons(port_number);
		addr.sin_addr.s_addr = INADDR_ANY;

		if(bind(sock, (struct sockaddr *)&addr, sizeof(addr)) == -1){
				perror("bind in server");
				close(sock);
				return 1;
		}

		memset(buf, 0, sizeof(buf));
		if(recvfrom(sock, buf, sizeof(buf), 0, (struct sockaddr *)&addr, &recvlen) < 0){
				perror("recvfrom in server");
				close(sock);
				return 1;
		}
		printf("%s\n", buf);
	    if(sendto(sock, buf, sizeof(buf), 0, (struct sockaddr *)&addr, sizeof(addr)) < 0){
				perror("sendto in server");
				close(sock);
				return 1;
		}

		close(sock);

		return 0;
}

int main(int argc, char *argv[])
{
		if(argc != 2){
				perror("number of argument");
				return 1;
		}

		while(1){
				udpechoserver(atoi(argv[1]));
		}

		return 0;
}

