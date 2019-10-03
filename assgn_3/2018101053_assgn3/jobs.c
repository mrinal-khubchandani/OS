#include"global.h"

void call_jobs(int len,int time,int freq)
{
    if(len!=1)
    {
        write(2,"Error: Invalid arguements\n",strlen("Error: Invalid arguements\n"));
        return;
    }
    int y;
    if(time!=-1 && freq!=-1)
    {
        y = (freq/time);
    }
    else{
        time=0;
        freq=0;
        y=1;
    }

    for(int i=0;i<y;i++)
    {
        sleep(time);
        for(int d=0;d<size;d++)
        {
            char pat[100]="/proc/";
            char pat2[100] ="/status";
            if(runn_proc[d].pid!=-1)
            {
                char pid_str[100];
                char stat_buffer[2000];
                sprintf(pid_str,"%d",runn_proc[d].pid); 
                for(int i=strlen(pat),j=0;j<=strlen(pid_str);i++,j++){
                    pat[i] = pid_str[j];
                }
                for(int i=strlen(pat),j=0;j<=strlen(pat2);i++,j++){
                    pat[i] = pat2[j];
                }

                int  fdd = open(pat,O_RDONLY);
                read(fdd,stat_buffer,2000);

                char *args = strtok(stat_buffer,"\n");

                int v=0;
                char status[40];
                int idx1,idx2;
                int g=0;
                while(args!=NULL)
                {
                    if(g==2){
                        for(int n=0;n<strlen(args);n++)
                        {
                            if(args[n]=='(')
                                idx1=n;
                            else if(args[n]==')')
                                idx2=n;
                        }
                        
                        for(int n=idx1+1;n<idx2;n++,v++)
                        {
                            status[v] = args[n];
                        }
                        status[v]='\0';
                    }
                    g++;
                    args = strtok(NULL,"\n");
                }

                printf("[%d]",runn_proc[d].si);
                printf("%s ",status);
                printf("%s",runn_proc[d].proc_name);
                printf("[%d]\n",runn_proc[d].pid);
            }
        }
        if(freq-time*(i+1)>=time){
            continue;
        }
        sleep(freq-time*(i+1));
    }
}
