#include"global.h"

int parseSpace(char* str, char** parsed) 
{ 
    int i; 
    int j;
    for (i = 0; i < 1000; i++) { 
        parsed[i] = strsep(&str, " "); 
        j = i;
        if (parsed[i] == NULL) 
            break; 
        if (strlen(parsed[i]) == 0) 
            i--; 
    } 
    return i;
}
