#include"global.h"

void call_unsetenv(char **parsed,int len,int time,int freq)
{
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

        if(len>2){
            // fprintf(stderr,"Error: Too many arguements\n");
            write(2,"Error: Too many arguements\n",strlen("Error: Too many arguements\n"));
        }
            
            
        else if(len<2){
            // fprintf(stderr,"Error: Too few arguements\n");
            write(2,"Error: Too few arguements\n",strlen("Error: Too few arguements\n"));
        }

        else if(unsetenv(parsed[1])!=0)
        {
            perror("Unable to unset the env variable");
        }

        if(freq-time*(i+1)>=time)
            continue;
            
        sleep(freq-time*(i+1));
    }
}
