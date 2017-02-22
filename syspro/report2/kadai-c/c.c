#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <sys/stat.h>

#define SIZE 1

int main(int argc, char *argv[])
{
		FILE *fr,*fw;
		char buf[SIZE];
		int rn;

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

		fr=fopen(argv[1], "rb+");
		fw=fopen(argv[2], "wb+");

		while(1){
				rn=fread(buf, sizeof(unsigned char), SIZE, fr);
				if(rn == 0){
						break;
				}
				fwrite(buf, sizeof(unsigned char), rn, fw);
		}

		fclose(fr);
		fclose(fw);

		return 0;
}
