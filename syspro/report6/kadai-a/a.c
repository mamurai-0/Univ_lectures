#include <unistd.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[], char *envp[])
{
		int status;
		pid_t pid;
		
		argv[argc] = malloc(sizeof(char) * 5);
		argv[argc] = "NULL";
		if((pid = fork()) == 0){
				execve(argv[1],(argv+2),envp);
		}else{
				waitpid(pid,&status,WUNTRACED);
		}
		return 0;
}
