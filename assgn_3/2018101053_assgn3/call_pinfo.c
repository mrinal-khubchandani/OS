#include "global.h"

void pinfo_call(char **args)
{
    char str[100];
    if(args[1]==NULL)
    {

        int num = getpid();
        sprintf(str, "%d", num);    


        char path[100] = "/proc/";
        char path1[100];
        char n_1[100] = "/stat";
        char n_2[100] = "/exe";
        char buffer[5100];
        char buffer1[5100];
        for(int i=strlen(path),j=0;;i++,j++){
            path[i] = str[j];
            if(str[j] == '\0'){
                break;
            }
        }
        strcpy(path1,path);
        for(int i=strlen(path),j=0;;i++,j++){
            path[i] = n_1[j];
            if(n_1[j] == '\0'){
                break;
            }
        }
        for(int i=strlen(path1),j=0;;i++,j++){
            path1[i] = n_2[j];
            if(n_2[j] == '\0'){
                break;
            }
        }

        int fd = open(path,O_RDONLY);
        
        printf("%s\n",path1);
        printf("pid -- %d\n",num);

        read(fd,buffer,5100);
        int f=0;
        char *del = strtok(buffer," ");
        while(del!=NULL)
        {
            if(f == 2){
                printf("Process Status -- %s\n",del);
            }
            if(f == 22){
                printf("Memory -- %s\n",del);
            }
            f++;
            del = strtok(NULL," ");
        }
        printf("Executable Path -- %s\n",realpath(path1,buffer1));
        

    } 

    else
    {
        strcpy(str,args[1]);


        char path[100] = "/proc/";
        char path1[100];
        char buffer[5100];
        char buffer1[5100];
        char n_1[100] = "/stat";
        char n_2[100] = "/exe";
        
        for(int i=strlen(path),j=0;;i++,j++){
            path[i] = str[j];
            if(str[j] == '\0'){
                break;
            }
        }
        strcpy(path1,path);
        for(int i=strlen(path),j=0;;i++,j++){
            path[i] = n_1[j];
            if(n_1[j] == '\0'){
                break;
            }
        }
        for(int i=strlen(path1),j=0;;i++,j++){
            path1[i] = n_2[j];
            if(n_2[j] == '\0'){
                break;
            }
        }
        int fd = open(path,O_RDONLY);
        
        printf("%s\n",path1);
        printf("pid -- %s\n",str);

        read(fd,buffer,5100);
        int f=0;
        char *del = strtok(buffer," ");
        while(del!=NULL)
        {
            if(f == 2){
                printf("Process Status -- %s\n",del);
            }
            if(f == 22){
                printf("Memory -- %s\n",del);
            }
            f++;
            del = strtok(NULL," ");
        }
        realpath(path1,buffer1);
        printf("Executable Path -- %s\n",buffer1);
    } 
}