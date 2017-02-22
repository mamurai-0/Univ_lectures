#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <sys/stat.h>

#define SIZE 1

int main(int argc, char *argv[])
{
		int fd1,fd2;
		char buf[SIZE],*bufp;
		int rsize,wsize;
		struct stat stat_of_read;

		if(argc != 3){
				char err_message[]="指定すべきファイルの数が正しくありません。\n";
				write(2, err_message, strlen(err_message));
				return 1;
		}

		if(strcmp(argv[1], argv[2])==0){
				char err_message[]="cp: file1 and file1 are identical (not copied).";
				write(2, err_message, strlen(err_message));
				write(2, "\n", 1);
				return 1;
		}


		argv[0]="mycp";
		fd1 = open(argv[1], O_RDONLY);

		if(fd1 < 0){
				char err_message[]="ファイルが開けません";
				write(2, err_message, strlen(err_message));
				write(2, strerror(errno), strlen(strerror(errno)));
				write(2, "\n", 1);
				return 1;
		}

		fd2 = open(argv[2], O_WRONLY|O_CREAT|O_TRUNC, 0666);

		if(fd2 < 0){
				char err_message[]="ファイルが開けません";
				write(2, err_message, strlen(err_message));
				write(2, strerror(errno), strlen(strerror(errno)));
				write(2, "\n", 1);
				return 1;
		}

		stat(argv[1], &stat_of_read);
		chmod(argv[2], stat_of_read.st_mode);

		while(1){
				bufp = buf;
				rsize = read(fd1, bufp, SIZE);
				
				if(rsize == -1){
						if(errno == EINTR){
								continue;
						}
						char err_message[] = "読み込みエラーが発生しました";
						write(2, err_message, strlen(err_message));
						write(2, strerror(errno), strlen(strerror(errno)));
						write(2, "\n", 1);
						return 1;
				}

				if(rsize == 0){
						break;
				}

				while(1){
						wsize = write(fd2, bufp, rsize);

						if(wsize == -1){
								if(errno == EINTR){
										continue;
								}
								char err_message[] = "書き込みエラーが発生しました";
								write(2, err_message, strlen(err_message));
								write(2, strerror(errno), strlen(strerror(errno)));
								write(2, "\n", 1);
								return 1;
						}

						bufp += wsize;
						rsize -= wsize;

						if(rsize == 0){
								break;
						}
				}
		}

		while(1){
				int close1 = close(fd1);

				if(close1 == -1){
						perror(NULL);
				}else{
						break;
				}
		}
		while(1){
				int close2 = close(fd2);

				if(close2 == -1){
						perror(NULL);
				}else{
						break;
				}
		}

		return 0;
}
