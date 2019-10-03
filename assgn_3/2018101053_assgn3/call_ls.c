#include "global.h"

void ls_call(char **args,int time,int freq)
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
        char cur[1024];
        getcwd(cur,sizeof(cur));

        //simple ls
        if(args[1]==NULL && args[2]==NULL)
        {

            char *pointer=cur;

            DIR *dp;
            struct dirent *sd=NULL;
            dp=opendir((char*)pointer);

            while(1)
            {
                if((sd=readdir(dp))==NULL){
                    break;
                }

                if(sd->d_name[0]=='.')
                    continue;
                char* f_name = sd->d_name;
                printf("%s\n",f_name);
            }
        }

        else if(args[1]!=NULL && args[2]==NULL)
        {
            char * arg = args[1];
            int la_check = strcmp(arg,"-la") & strcmp(arg,"-al");
            int l_check = strcmp(arg,"-l");
            int a_check = strcmp(arg,"-a");
            
            //simple ls -l
            if(l_check == 0)
            {   
                struct dirent *thefile;
                struct passwd *tf;
                struct stat thestat; 
                struct group *gf;
                DIR *thedirectory = opendir(cur);

                char buf[512];

                thedirectory = opendir(cur);

                while(1) 
                {   
                    thefile = readdir(thedirectory);
                    if(thefile == NULL){
                        break;
                    }
                    char first_char = thefile->d_name[0];
                    if(first_char =='.'){
                        continue;
                    }
                    
                    sprintf(buf, "%s/%s", cur, thefile->d_name);
                    stat(buf, &thestat);

                    int perm = thestat.st_mode;
                    int ur = S_IRUSR ,gr = S_IRGRP,or = S_IROTH,uw= S_IWUSR,gw= S_IWGRP,ow=S_IWOTH,ux=S_IXUSR,gx=S_IXGRP,ox=S_IXOTH;
                    char print_string[100];
                    int len = 0;
                    int x = perm&__S_IFMT;

                    //for the first byte
                    if((x) == S_IFBLK){
                        print_string[len++] = 'b';
                    }

                    else if((x) == S_IFDIR){
                        print_string[len++] = 'd';
                    }

                    else if((x) == S_IFCHR){
                        print_string[len++] = 'c';
                    }

                    else if((x) == S_IFIFO){
                        print_string[len++] = 'p';
                    }

                    else if((x) == S_IFBLK){
                        print_string[len++] = 'l';
                    }

                    else if((x) == S_IFBLK){
                        print_string[len++] = 's';
                    }

                    else{
                        print_string[len++] = '-';
                    }


                    tf = getpwuid(thestat.st_uid);
                    gf = getgrgid(thestat.st_gid);
                    
                    //for the rest of the permissions
                    if(perm & ur){
                        print_string[len++] = 'r';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & uw){
                        print_string[len++] = 'w';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & ux){
                        print_string[len++] = 'x';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & gr){
                        print_string[len++] = 'r';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & gw){
                        print_string[len++] = 'w';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & gx){
                        print_string[len++] = 'x';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & or){
                        print_string[len++] = 'r';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & ow){
                        print_string[len++] = 'w';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & ox){
                        print_string[len++] = 'x';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    print_string[len++] = '\0';

                    printf("%s\t%lu \t%s %zu %s %s",print_string,thestat.st_nlink,tf->pw_name,thestat.st_size,thefile->d_name,ctime(&thestat.st_mtime));

                }
                    closedir(thedirectory);
            }

            //simple ls -la
            else if(la_check == 0)
            {   
                struct dirent *thefile;
                struct passwd *tf;
                struct stat thestat; 
                struct group *gf;
                DIR *thedirectory = opendir(cur);
                char buf[512];

                while(1) 
                {   
                    thefile = readdir(thedirectory);
                    if(thefile == NULL){
                        break;
                    }
                    char first_char = thefile->d_name[0];
                    
                    sprintf(buf, "%s/%s", cur, thefile->d_name);
                    stat(buf, &thestat);

                    int perm = thestat.st_mode;
                    int ur = S_IRUSR ,gr = S_IRGRP,or = S_IROTH,uw= S_IWUSR,gw= S_IWGRP,ow=S_IWOTH,ux=S_IXUSR,gx=S_IXGRP,ox=S_IXOTH;
                    char print_string[100];
                    int len = 0;
                    int x = perm&__S_IFMT;

                    //for the first byte
                    if((x) == S_IFBLK){
                        print_string[len++] = 'b';
                    }

                    else if((x) == S_IFDIR){
                        print_string[len++] = 'd';
                    }

                    else if((x) == S_IFCHR){
                        print_string[len++] = 'c';
                    }

                    else if((x) == S_IFIFO){
                        print_string[len++] = 'p';
                    }

                    else if((x) == S_IFBLK){
                        print_string[len++] = 'l';
                    }

                    else if((x) == S_IFBLK){
                        print_string[len++] = 's';
                    }

                    else{
                        print_string[len++] = '-';
                    }
                    
                    tf = getpwuid(thestat.st_uid);
                    gf = getgrgid(thestat.st_gid);
                    

                    //for the rest of the permissions
                    if(perm & S_IRUSR){
                        print_string[len++] = 'r';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IWUSR){
                        print_string[len++] = 'w';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IXUSR){
                        print_string[len++] = 'x';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IRGRP){
                        print_string[len++] = 'r';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IWGRP){
                        print_string[len++] = 'w';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IXGRP){
                        print_string[len++] = 'x';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IROTH){
                        print_string[len++] = 'r';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IWOTH){
                        print_string[len++] = 'w';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IXOTH){
                        print_string[len++] = 'x';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    print_string[len++] = '\0';

                    printf("%s\t%lu \t%s %zu %s %s",print_string,thestat.st_nlink,tf->pw_name,thestat.st_size,thefile->d_name,ctime(&thestat.st_mtime));

                }
                    closedir(thedirectory);
            }

            //simple ls -a
            else if(a_check == 0)
            {
                DIR *thedirectory = opendir(cur);
                struct dirent *thefile;
                struct stat thestat;

                char buf[512];


                while(1) 
                {   
                    thefile = readdir(thedirectory);
                    if(thefile == NULL){
                        break;
                    }
                    char * f_name = thefile->d_name;
                    sprintf(buf, "%s/%s", cur, f_name);
                    stat(buf, &thestat);

                    printf("%s\n", f_name);
                }
                closedir(thedirectory);
            }

            //ls dir/
            else
            {
                struct dirent *sd=NULL;
                DIR *dp=opendir((char*)arg);

                while(1)
                {
                    sd=readdir(dp);
                    if(sd == NULL){
                        break;
                    }
                    char first_char = sd->d_name[0];
                    if(first_char == '.'){
                        continue;
                    }
                    printf("%s\n",sd->d_name);
                }
            }

        }

        else if(args[1]!=NULL && args[2]!=NULL)
        {
            char * arg = args[1];
            int la_check = strcmp(arg,"-la") & strcmp(arg,"-al");
            int l_check = strcmp(arg,"-l");
            int a_check = strcmp(arg,"-a");
            
            //ls -l dir/
            if(l_check == 0)
            {   
                struct dirent *thefile;
                struct passwd *tf;
                struct stat thestat; 
                struct group *gf;
                DIR *thedirectory = opendir(args[2]);
                char buf[512];

                while(1) 
                {   
                    thefile = readdir(thedirectory);
                    if(thefile == NULL){
                        break;
                    }
                    char first_char = thefile->d_name[0];
                    if(first_char =='.'){
                        continue;
                    }
                    
                    sprintf(buf, "%s/%s", cur, thefile->d_name);
                    stat(buf, &thestat);

                    int perm = thestat.st_mode;
                    int ur = S_IRUSR ,gr = S_IRGRP,or = S_IROTH,uw= S_IWUSR,gw= S_IWGRP,ow=S_IWOTH,ux=S_IXUSR,gx=S_IXGRP,ox=S_IXOTH;
                    char print_string[100];
                    int len = 0;
                    int x = perm&__S_IFMT;
                    
                    //for the first byte
                    if((x) == S_IFBLK){
                        print_string[len++] = 'b';
                    }

                    else if((x) == S_IFDIR){
                        print_string[len++] = 'd';
                    }

                    else if((x) == S_IFCHR){
                        print_string[len++] = 'c';
                    }

                    else if((x) == S_IFIFO){
                        print_string[len++] = 'p';
                    }

                    else if((x) == S_IFBLK){
                        print_string[len++] = 'l';
                    }

                    else if((x) == S_IFBLK){
                        print_string[len++] = 's';
                    }

                    else{
                        print_string[len++] = '-';
                    }


                    tf = getpwuid(thestat.st_uid);
                    gf = getgrgid(thestat.st_gid);
                    

                    //for the rest of the permissions
                    if(perm & ur){
                        print_string[len++] = 'r';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & uw){
                        print_string[len++] = 'w';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & ux){
                        print_string[len++] = 'x';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & gr){
                        print_string[len++] = 'r';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & gw){
                        print_string[len++] = 'w';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & gx){
                        print_string[len++] = 'x';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & or){
                        print_string[len++] = 'r';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & ow){
                        print_string[len++] = 'w';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & ox){
                        print_string[len++] = 'x';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    print_string[len++] = '\0';

                    printf("%s\t%lu \t%s %zu %s %s",print_string,thestat.st_nlink,tf->pw_name,thestat.st_size,thefile->d_name,ctime(&thestat.st_mtime));

                }
                    closedir(thedirectory);
            }

            //ls -la dir/
            else if(la_check == 0)
            {   
                struct dirent *thefile;
                struct passwd *tf;
                struct stat thestat; 
                struct group *gf;
                DIR *thedirectory = opendir(args[2]);
                char buf[512];

                while(1) 
                {   
                    thefile = readdir(thedirectory);
                    if(thefile == NULL){
                        break;
                    }
                    char first_char = thefile->d_name[0];
                    
                    sprintf(buf, "%s/%s", cur, thefile->d_name);
                    stat(buf, &thestat);

                    int perm = thestat.st_mode;
                    int ur = S_IRUSR ,gr = S_IRGRP,or = S_IROTH,uw= S_IWUSR,gw= S_IWGRP,ow=S_IWOTH,ux=S_IXUSR,gx=S_IXGRP,ox=S_IXOTH;
                    char print_string[100];
                    int len = 0;
                    int x = perm&__S_IFMT;

                    //for the first byte
                    if((x) == S_IFBLK){
                        print_string[len++] = 'b';
                    }

                    else if((x) == S_IFDIR){
                        print_string[len++] = 'd';
                    }

                    else if((x) == S_IFCHR){
                        print_string[len++] = 'c';
                    }

                    else if((x) == S_IFIFO){
                        print_string[len++] = 'p';
                    }

                    else if((x) == S_IFBLK){
                        print_string[len++] = 'l';
                    }

                    else if((x) == S_IFBLK){
                        print_string[len++] = 's';
                    }

                    else{
                        print_string[len++] = '-';
                    }
                    
                    tf = getpwuid(thestat.st_uid);
                    gf = getgrgid(thestat.st_gid);
                    

                    //for the permissions
                    if(perm & S_IRUSR){
                        print_string[len++] = 'r';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IWUSR){
                        print_string[len++] = 'w';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IXUSR){
                        print_string[len++] = 'x';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IRGRP){
                        print_string[len++] = 'r';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IWGRP){
                        print_string[len++] = 'w';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IXGRP){
                        print_string[len++] = 'x';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IROTH){
                        print_string[len++] = 'r';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IWOTH){
                        print_string[len++] = 'w';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    if(perm & S_IXOTH){
                        print_string[len++] = 'x';
                    }
                    else{
                        print_string[len++] = '-';
                    }

                    print_string[len++] = '\0';

                    printf("%s\t%lu \t%s %zu %s %s",print_string,thestat.st_nlink,tf->pw_name,thestat.st_size,thefile->d_name,ctime(&thestat.st_mtime));

                }
                closedir(thedirectory);
            }

            //ls -a dir/
            else if(!strcmp(args[1],"-a"))
            {
                char * next = args[2];
                DIR *thedirectory = opendir(next);
                struct dirent *thefile;
                char buf[512];
                struct stat thestat;

                while(1) 
                {   
                    thefile = readdir(thedirectory);
                    if(thefile == NULL){
                        break;
                    }
                    sprintf(buf, "%s/%s", next, thefile->d_name);
                    stat(buf, &thestat);

                    printf("%s\n", thefile->d_name);
                }
                closedir(thedirectory);
            }
        }
        printf("\n");if(freq-time*(i+1)>=time){
            continue;
        }
        sleep(freq-time*(i+1));
    }
}