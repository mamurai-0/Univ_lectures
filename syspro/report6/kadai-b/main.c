#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include "parse.h"

void print_job_list(job*);

int main(int argc, char *argv[], char *envp[]) {
    char s[LINELEN];
    job *curr_job;
	int status;
	pid_t pid;

    while(get_line(s, LINELEN)) {
        if(!strcmp(s, "exit\n"))
            break;

        curr_job = parse_line(s);

		if((pid =fork()) == 0){
				execve((curr_job->process_list)->program_name, (curr_job->process_list)->argument_list, envp);
		}else{
				waitpid(pid,&status,WUNTRACED);
		}
        free_job(curr_job);
    }

    return 0;
}
