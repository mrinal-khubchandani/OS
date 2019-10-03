#include"global.h"

int takeInput(char* s,char *home_dir)
{
    size_t bufsize = 1000;
    getline(&newline,&bufsize,stdin);    
    long int len = strlen(newline);

    int flag_up=0;
    if(newline[0] == 27 && newline[1] == 91 && newline[2] == 65){
        flag_up = 1;
    }
    else if(strlen(newline) != 0) 
    {
        strcpy(s, newline);

        int s_len = strlen(s);
        s[s_len-1]='\0';

        add_history1(home_dir); 

        return 0; 
    }
    else 
    {
        write(2,"Error: Invalid command\n",strlen("Error: Invalid command\n"));
        return 1;
    }

    if(flag_up==1)
    {
        char read_buf[100000];
        char temp_str[1000];
        long int len; 
        len = strlen(newline)-1;

        int no_of_ups = len/3;
        char name[100];
        sprintf(name,"%s/.hist",home_dir);
        int fd = open(name,O_RDONLY,0777);
        if(fd==-1)
            perror("not opened");

        else
        {
            int size_file = read(fd,read_buf,100000);
            int j=0;

            for(int i=size_file-1,lines=0;i>=0;i--)
            {
                if(read_buf[i]!='`'){
                    continue;
                }
                if(lines==no_of_ups)
                {
                    j=i+1;
                    break;
                }
                lines++;
            }

            int x=0;


            for(int k=j;k<size_file;k++)
            {
                if(read_buf[k] == '\n'){
                    continue;
                }
                if(read_buf[k]!='`')
                {
                    temp_str[x]=read_buf[k];
                    x++;
                    int x2 = k-j;
                    // printf("%d",x2);
                }
                else
                {
                    temp_str[x]=';';
                    x++;
                }
            }
        }
        int y = strlen(s);
        strcpy(s, temp_str);
        add_history1(home_dir); 
        return 0;
    }
    else
        return 1; 
}