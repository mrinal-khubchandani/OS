#include "global.h"

void Check(char** args,char *home_dir,int len,int time,int freq)
{   
    char back[20] = "&";
    char* str = args[0];
    char str1[20] = "cd"; 
    char str2[20] = "ls";
    char str3[20] = "echo";
    char str4[20] = "history";
    char str5[20] = "pwd";
    char str6[20] = "pinfo";
    char str7[20] = "nightswatch";
    char str8[20] = "quit";
    char str9[20] = "setenv";
    char str10[20] = "unsetenv";
    char str11[20] = "jobs";
    char str12[20] = "kjob";
    char str13[20] = "overkill";
    char str14[20] = "fg";
    char str15[20] = "bg";
    char str16[20] = "cronjob";
    if(args[1]!=NULL && !(strcmp(args[len-1],back)))
    {
        args[len-1][0] = '\0';
        flag_back=1;
        int fork_active = (fork());
        if(!fork_active)
        {
            setpgid(0,0);
            close(STDERR_FILENO);

            if(execvp(args[0],args)==-1)
                perror("Invalid command");

            exit(0);
        }
        else{
            printf("%d\n",fork_active);
            for(int i=0;i<=strlen(args[0]);i++){
                runn_proc[size].proc_name[i] = args[0][i];    
            }
            runn_proc[size].si = size+1;
            runn_proc[size].pid = fork_active;
            size++;
        }
    }
    if(strcmp(args[0],str1)==0)
    {
        cd_call(args,home_dir);
        return;
    }
    if(strcmp(args[0],str8) == 0){
        exit(0);
    }
    else if(strcmp(args[0],str2)==0)
    {
        ls_call(args,time,freq);
    }
    else if(strcmp(args[0],str3)==0)
    {
        echo_call(args,time,freq);
    }
    else if(strcmp(args[0],str4)==0)
    {
        history_call(args,home_dir);
    }
    else if(strcmp(args[0],str5)==0)
    {
        pwd_call(time,freq);
    }
    else if(strcmp(args[0],str6)==0)
    {
        pinfo_call(args);
    }
    else if(strcmp(args[0],str7)==0)
    {
        nightswatch_call(args);
    }
    else if(strcmp(args[0],str9) == 0){
        call_setenv(args,len,time,freq);
    }
    else if(strcmp(args[0],str10) == 0){
        call_unsetenv(args,len,time,freq);
    }
    else if(strcmp(args[0],str11) == 0){
        call_jobs(len,time,freq);
    }
    else if(strcmp(args[0],str12) == 0){
        call_kjob(args,len);
    }
    else if(strcmp(args[0],str13) == 0){
        call_overkill();
    }
    else if(strcmp(args[0],str14) == 0){
        call_fg(args);
    }
    else if(strcmp(args[0],str15) == 0){
        call_bg(args);
    }
    else if(strcmp(args[0],str15) == 0){
        call_cronjob(args,len,home_dir);
    }
    else
    {
        if(flag_back == 1){
            return;
        }
        int fork_active = fork();
        if(fork_active==0)
        {
            setpgid(0,0);
            val = execvp(args[0],args);
            if(val == -1){
                write(2,"Error:command not found\n",strlen("Error:command not found\n"));
            }
            exit(0);
        }
        else if(fork_active>0)
        {
            if(val!=-1){
                curr_fg_pid = fork_active;
                for(int i=0;i<=strlen(args[0]);i++){
                    curr_fg_proc_name[i] = args[0][i];
                }
            }
            ctrl_z_cond=1;
            ctrl_c_cond=1;
            int status;
            int x1 = ctrl_c_cond | ctrl_z_cond;
            waitpid(fork_active,&status,WUNTRACED);
            int x7 = ctrl_c_cond | ctrl_z_cond;
            ctrl_z_cond=0;
            ctrl_c_cond=0;
        }
    }
}