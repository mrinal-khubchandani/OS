#include"global.h"

void call_setenv(char **parsed,int len,int time,int freq)
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
        if(len>3){
            // fprintf(stderr,"Error: Too many arguements\n");
            write(2,"Error: Too many arguements\n",strlen("Error: Too many arguements\n"));
        }
            
        else if(len<2){
            // fprintf(stderr,"Error: Too few arguements\n");
            write(2,"Error: Too few arguements\n",strlen("Error: Too few arguements\n"));
        }
            

        else 
        {
            char s[100] = "";
            if(parsed[2] != NULL){
                for(int i=0;parsed[2][i]!='\0';i++){
                    s[i] = parsed[2][i];
                }
            }
            setenv(parsed[1],s,1);
        }

        if(freq-time*(i+1)>=time)
            continue;
            
        sleep(freq-time*(i+1));
    }
}
