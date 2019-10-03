#include"global.h"

void call_kjob(char **parsed,int len)
{
    if(len==3){
        int num1=0;
        for(int i=0;parsed[1][i]!='\0';i++){
            num1*=10;
            int x = parsed[1][i] - '0';
            num1+=x;
        }

        if(num1>size){
            write(2,"Error: No such job\n",strlen("Error: No such job\n"));
        }
            
        else
        {
            int num2=0;
            for(int i=0;parsed[1][i]!='\0';i++){
                num2*=10;
                int x = parsed[1][i] - '0';
                num2+=x;
            }

            printf("%d\n",runn_proc[num1-1].pid);
            kill(runn_proc[num1-1].pid,num2);
        }
    }
        
    else
    {
        write(2,"Error: invalid input\n",strlen("Error: invalid input\n"));
    }
}
