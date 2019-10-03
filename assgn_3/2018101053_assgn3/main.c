#include"global.h"

void sigintHandler1(int sig_num) 
{
    if(ctrl_z_cond == 0){
        return;
    }
    int ff=0;
    signal(SIGTSTP, sigintHandler1);
    printf("%s\n",curr_fg_proc_name);

    for(int l=0;l<size;l++)
    {
        int x = strcmp(runn_proc[l].proc_name,curr_fg_proc_name);
        if(x || runn_proc[l].pid == -1){
            continue;
        }
        ff=1;
        break;
    }

    if(ff==0)
    {
        runn_proc[size].si=size+1;
        for(int i=0;i<=strlen(curr_fg_proc_name);i++){
            runn_proc[size].proc_name[i] = curr_fg_proc_name[i];
        }
        runn_proc[size].pid=curr_fg_pid;
        size++;
    }

    printf("%d\n",curr_fg_pid);
    kill(curr_fg_pid,SIGTSTP);
}

void sigintHandler(int sig_num) 
{ 
    if(ctrl_c_cond == 0){
        return;
    }
    signal(SIGINT, sigintHandler); 
    int get_idx=-1;

    for(int l=0;l<size;l++)
    {
        int x1 = strcmp(runn_proc[l].proc_name,curr_fg_proc_name);
        if(x1 || runn_proc[l].pid==-1)
        {
            continue;
        }
        get_idx=l;
        break;
    }

    kill(curr_fg_pid,SIGINT);
    if(get_idx<0 || get_idx>=size) 
    {
        return;
    }
    runn_proc[get_idx].pid=-1;
    printf("\n");
}

int main() 
{
    char **wow;
    int xxx = 0;
    if(fork()==0)
        execvp("clear",wow);
    else
        wait(NULL);
    char* parsedArgs[256];
    struct hostent *host_entry;
    int len; 

    char name_buffer[256]; 
    if(gethostname(name_buffer, sizeof(name_buffer)) == -1){
        perror("gethostname");
        return 1;
    }

    if(gethostbyname(name_buffer) == NULL){
        perror("gethostbyname");
        return 1;
    }

    getcwd(previous_dir,1000);
    char dir[100];
    getcwd(dir,sizeof(dir));
    signal(SIGINT,sigintHandler);   
    signal(SIGTSTP,sigintHandler1);

    while(1)
    {
        flag_back=0;
        val=0;
        char inputString[1000];

        printf("%s@%s",getenv("USER"),name_buffer);
        print_Dir(dir);
        printf("$ ");

        int pid,pid_status;
        for(int i=0;i<3;i++){
            parsedArgs[i] = NULL;
        }
        while((pid = waitpid(-1, &pid_status, WNOHANG | WUNTRACED)) > 0){
            char *proc_name;
            int x1 = WIFEXITED(pid_status);
            int x2 = WIFSIGNALED(pid_status); 
            if(x1)
            {
                for(int i=0;i<size;i++)
                {
                    if(runn_proc[i].pid != pid){
                        continue;
                    }
                    proc_name = runn_proc[i].proc_name;
                    runn_proc[i].pid=-1;
                    char string_print[1000];
                    sprintf(string_print,"%s with pid %d exited normally.\n",runn_proc[i].proc_name,(int)pid);
                    write(2,string_print,strlen(string_print));
                    break;
                }
            }

            else if(x2)
            {
                for(int i=0;i<size;i++)
                {
                    if(runn_proc[i].pid != pid){
                        continue;
                    }
                    proc_name = runn_proc[i].proc_name;
                    runn_proc[i].pid = -1;
                    char string_print[1000];
                    sprintf(string_print,"%s with pid %d exited normally.\n",runn_proc[i].proc_name,(int)pid);
                    write(2,string_print,strlen(string_print));
                    break;
                }

            }
        }

        if(takeInput(inputString,dir))
            continue;   

        int k=0;
        xxx++;
        char* store[1000];

        char* arg = strtok(inputString,";");

        while(arg!=NULL)
        {
            store[k++]=arg;
            if(arg == NULL){
                break;
            }
            arg = strtok(NULL,";");
        }

        int i=0;

        while(1)
        {
            if(i==k){
                break;
            }
            char* piped_args[1000];
            int it,redir,m;
            it=0;
            redir=0;
            m=0;
            char* token = strtok(store[i],"|");
            int fd10 = open(".tkns",O_CREAT|O_WRONLY,0777);
            while(token!=NULL)
            {
                piped_args[m++]=token;
                write(fd10,token,strlen(token));
                token= strtok(NULL,"|");
            }   
            close(fd10);
            int z=0;
            if(m==1)
            {
                len = parseSpace(store[i],parsedArgs);

                while(it<len)
                {
                    int cmp1 = strcmp(parsedArgs[it],">");
                    int cmp2 = strcmp(parsedArgs[it],"<");
                    int cmp3 = strcmp(parsedArgs[it],">>");
                    it++;
                    if(cmp1 && cmp2 && cmp3){
                        continue;
                    }
                    redir=1;
                }

                if(redir==1)
                {
                    i++;
                    int diff = k-i;
                    call_redirection(parsedArgs,len);
                }

                else
                {
                    i++;
                    int diff = k-i;
                    Check(parsedArgs,dir,len,-1,-1);
                }
            }
            else
            {
                int std_in_fd = dup(0),std_out_fd = dup(1);

                while(1)
                {
                    if(z==m){
                        break;
                    }
                    len = parseSpace(piped_args[z],parsedArgs);
                    int status,pipe_pid,fdd[2];

                    if(z==0)
                    {
                        pipe(fdd);
                        std_out_fd = dup(1);

                        if(dup2(fdd[1],1)==-1){
                            write(2,"Error: dup2 failed",strlen("Error: dup2 failed"));
                        }
                            
                    }

                    else if(z==m-1)
                    {
                        close(fdd[1]);
                        std_in_fd=dup(0);
                        int diff = m-i;
                        if(dup2(fdd[0],0)==-1){
                            write(2,"Error: dup2 failed",strlen("Error: dup2 failed"));
                        }
                        close(fdd[0]);
                    }

                    else
                    {
                        close(fdd[1]);
                        std_in_fd=dup(0);

                        if(dup2(fdd[0],0)==-1){
                            write(2,"Error: dup2 failed",strlen("Error: dup2 failed"));
                        }
                        int fd12 = open(".pipe.txt",O_CREAT|O_WRONLY,0777);
                        write(fd12,"piping",strlen("piping"));
                        close(fdd[0]);

                        pipe(fdd);
                        std_out_fd = dup(1);

                        if(dup2(fdd[1],1)==-1){
                            write(2,"Error: dup2 failed",strlen("Error: dup2 failed"));
                        }
                    } 
                    pipe_pid = fork();

                    if(pipe_pid==0)
                    {
                        it=0,redir=0;

                        while(it<len)
                        {
                            int cmp1 = strcmp(parsedArgs[it],">");
                            int cmp2 = strcmp(parsedArgs[it],"<");
                            int cmp3 = strcmp(parsedArgs[it],">>");
                            it++;
                            if(cmp1 && cmp2 && cmp3){
                                continue;
                            }
                            redir=1;
                        }

                        if(redir==1)
                        {
                            i++;
                            call_redirection(parsedArgs,len);
                        }

                        else
                        {
                            Check(parsedArgs,dir,len,-1,-1);
                        }
                        exit(0);
                    }

                    else
                    {
                        waitpid(pipe_pid,&status,WUNTRACED);
                        int printer = status;
                        dup2(std_in_fd,0);
                        dup2(std_out_fd,1);
                    }
                    int diff1 = z-m;
                    z++;
                }
                i++;
            }
        }
    }
    return 0; 
}
