#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h> 
#include <errno.h> 
#include <netdb.h> 
#include <sys/types.h> 
#include <sys/stat.h> 
#include <sys/socket.h> 
#include <string.h> 
#include <sys/wait.h> 
#include <readline/readline.h> 
#include <readline/history.h> 
#include <fcntl.h> 
#include <dirent.h> 
#include <pwd.h>
#include <time.h>
#include <grp.h>
#include <curses.h>
#include <ncurses.h>
#include <time.h>

struct P{
    char proc_name[128];
    int pid;
    int si;
}proc;

char bbuffer[100000];
int ctrl_z_cond;
int curr_fg_pid;
int ctrl_c_cond;
struct P runn_proc[2048];
int val;
int size;
char curr_fg_proc_name[400];

int flag_back;
char previous_dir[5000];
char* newline;

void add_history1(char* home_dir);
void print_Dir(char *fixed);
void pwd_call(int time,int freq);
int getInput(char* s,char* home_dir);
void echo_call(char **args,int time,int freq);
void ls_call(char **args,int time,int freq);
void pinfo_call(char **args);
void cd_call(char **args,char *home_dir);
int parseSpace(char* str, char** parsed);
void nightswatch_call(char **args);
void call_setenv(char **parsed,int len,int time,int freq);
int add_hi(char* home_dir);
void history_call(char **args,char * home_dir);
void Check(char** parsed,char *dir,int len,int time,int freq);
void call_overkill();
void call_unsetenv(char **parsed,int len,int time,int freq);
int takeInput(char* s,char *home_dir);
void call_redirection(char **parsed,int len);
void call_kjob(char **parsed,int len);
int number(char **args);
void call_bg(char **parsed);
void call_fg(char **parsed);
void call_cronjob(char** parsed,int len,char *dir);
void call_jobs(int len,int time,int freq);
void print_list(DIR *dir,int len,char *con);