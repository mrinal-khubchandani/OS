#include "global.h"

void Check(char** args,char *home_dir,int len)
{   
    if(args[1]!=NULL)
    {
        char back[20] = "&";
        if(strcmp(args[len-1],back) == 0)
        {
            args[len-1][0] = '\0';
            flag_back=1;
            int fork_active = !(fork());
            if(fork_active)
            {
                setpgid(0,0);
                close(STDERR_FILENO);

                if(execvp(args[0],args)==-1)
                    perror("Invalid command");

                exit(0);
            }
        } 
    }

    char* str = args[0];
    char str1[20] = "cd"; 
    char str2[20] = "ls";
    char str3[20] = "echo";
    char str4[20] = "history";
    char str5[20] = "pwd";
    char str6[20] = "pinfo";
    char str7[20] = "nightswatch";
    char str8[20] = "exit";
    if(strcmp(args[0],str1)==0)
    {
        cd_call(args,home_dir);
    }
    if(strcmp(args[0],str8) == 0){
        exit(0);
    }
    else if(strcmp(args[0],str2)==0)
    {
        ls_call(args);
    }
    else if(strcmp(args[0],str3)==0)
    {
        echo_call(args);
    }
    else if(strcmp(args[0],str4)==0)
    {
        history_call(args,home_dir);
    }
    else if(strcmp(args[0],str5)==0)
    {
        pwd_call();
    }
    else if(strcmp(args[0],str6)==0)
    {
        pinfo_call(args);
    }
    else if(strcmp(args[0],str7)==0)
    {
        nightswatch_call(args);
    }
    else
    {
        if(flag_back!=1)
        {
            int fork_active = fork();
            if(fork_active==0)
            {
                execvp(args[0],args);
                exit(0);
            }
            else if(fork_active>0)
            {
                int status;
                waitpid(fork_active,&status,WUNTRACED);
            }
        }
    }
}