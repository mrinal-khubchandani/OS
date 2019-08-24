#include "global.h"

int getInput(char* s,char* home_dir)
{
    newline = readline("");
    if (newline[0] == '\0'){
        return 0;
    }
    add_history1(home_dir);
    strcpy(s, newline);
    return 1;
}