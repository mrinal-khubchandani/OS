#include "global.h"

int main() 
{ 
    char name_buffer[256]; 
    if(gethostname(name_buffer, sizeof(name_buffer)) == -1){
        perror("gethostname");
        return 1;
    }

    if(gethostbyname(name_buffer) == NULL){
        perror("gethostbyname");
        return 1;
    }
    
    char* input_lines[256]; 

    getcwd(previous_dir,5000);
    char home_dir[100];
    getcwd(home_dir,sizeof(home_dir));

    while(1)
    {
        char inputString[5000];

        char *username = getenv("USER");
        printf("%s@",username); 
        printf("%s:", name_buffer); 

        print_Dir(home_dir);
        printf("  ");
        
        input_lines[0] = NULL;
        input_lines[1] = input_lines[0];
        input_lines[2] = input_lines[1];
        
        
        if(getInput(inputString,home_dir) == 1){   
        

            char* arg = strtok(inputString,";");

            while(arg!=NULL)
            {
                int i = 0;
                while(i<5000) { 
                    char * temp = input_lines[i];
                    input_lines[i] = strsep(&arg, " ");
                    if (input_lines[i] == NULL) 
                        break; 
                    if (input_lines[i][0] == '\0') 
                        i--;
                    i++; 
                }
                Check(input_lines,home_dir,i);
                arg = strtok(NULL,";");
            }
        }
    }

    return 0; 
}
