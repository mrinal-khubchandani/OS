#include"global.h"

void call_fg(char **parsed)
{
    int pg,num=0,status;
    for(int i=0;parsed[1][i]!='\0';i++){
        num*=10;
        int x = parsed[1][i]-'0';
        num+=x;
    }

    if(num>size)
    {
        write(2,"Error: Given job number does not exist\n",strlen("Error: Given job number does not exist\n"));
        // fprintf(stderr,"Error: Given job number does not exist\n");
        return;
    }

    pg = runn_proc[num-1].pid;
    printf("%d\n",pg);

    if(pg==-1){
        // fprintf(stderr,"Error: Given job number does not exist\n");
        write(2,"Error: Given job number does not exist\n",strlen("Error: Given job number does not exist\n"));
    }
        

    else
    {
        printf("%s\n",runn_proc[num-1].proc_name);
        kill(pg, 18);
        for(int i=0;runn_proc[num-1].proc_name[i]!='\0';i++){
            curr_fg_proc_name[i] = runn_proc[num-1].proc_name[i];
        }
        ctrl_z_cond=1;
        curr_fg_pid = pg;
        waitpid(pg, &status, WUNTRACED);
        ctrl_z_cond=0;
    }
}
