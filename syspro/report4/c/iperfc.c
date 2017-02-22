#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define BUFSIZE 1000
#define NUM 32000

int iperfc(int port_number, char *host)
{
		int sock,i,ans1;
		double ans2;
		struct sockaddr_in addr;
		char buf[BUFSIZE];
		sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
		if(sock == -1){
				perror("sock in client");
				close(sock);
				return 1;
		}

		addr.sin_family = AF_INET;
		addr.sin_port = htons(port_number);
		addr.sin_addr.s_addr = inet_addr(host);
	    if(connect(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0){
				perror("connect");
				return 1;
		}

		memset(buf, 'a', BUFSIZE);

		for(i=0;i<NUM;i++){
				write(sock, buf, sizeof(buf));
		}
		
		read(sock, &ans1, sizeof(ans1));
		read(sock, &ans2, sizeof(ans2));

		double throughput = 8*(ans1/ans2)/1000000;

		printf("%d %f %f\n", ans1, ans2, throughput);

		close(sock);

		return 0;
}

int main(int argc, char *argv[])
{
		if(argc != 3){
				perror("number of argument");
				return 1;
		}

		iperfc(atoi(argv[1]), argv[2]);

		return 0;
}
