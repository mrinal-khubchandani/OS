#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h> 
#include <errno.h> 
#include <netdb.h> 
#include <sys/types.h> 
#include <sys/stat.h> 
#include <sys/socket.h> 
#include<string.h> 
#include<sys/wait.h> 
#include<readline/readline.h> 
#include<readline/history.h> 
#include<fcntl.h> 
#include<dirent.h> 
#include <pwd.h>
#include <ncurses.h>
#include <time.h>
#include <grp.h>
#include<curses.h>

int flag_back;
char previous_dir[5000];
char* newline;

void add_history1(char* home_dir);
void print_Dir(char *fixed);
int getInput(char* s,char* home_dir);
void cd_call(char **args,char *home_dir);
void pwd_call();
void echo_call(char **args);
void ls_call(char **args);
void pinfo_call(char **args);
void nightswatch_call(char **args);
int number(char **args);
void history_call(char **args,char * home_dir);
void Check(char** args,char *home_dir,int len);