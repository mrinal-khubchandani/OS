#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include<sys/types.h>
#include<sys/stat.h>
#include <fcntl.h>
#include<errno.h>
#include <unistd.h>

int main(int agrc,char** argv) {
	long long int dir = access(argv[3],F_OK);
	if(dir == 0){
		char out[100] = "Directory is created: Yes\n\n";
		write(1,out,strlen(out));
	}
	else{
		char out[100] = "Directory is created: No\n\n";
		write(1,out,strlen(out));
	}
	char text[1000000] = "";
	char reversed[1000000] = "";
	long long int size_text = 1000000;
	int f_oldFile = open(argv[1], O_RDONLY);
	if(f_oldFile < 0){
		perror("old file is not present");
		exit(0);
	}
	int f_newFile = open(argv[2], O_RDONLY);
	if(f_oldFile < 0){
		perror("new file is not present");
		exit(0);
	}
	long long int size_of_file = lseek(f_oldFile,0,SEEK_END);
	long long int final_store = size_of_file;
	long long int size_of_new_file = lseek(f_newFile,0,SEEK_END);
	lseek(f_newFile,0,SEEK_SET);
	if(size_of_file != size_of_new_file){
		char out[100] = "Whether file contents are reversed in newfile: No\n\n";
		write(1,out,strlen(out));
	}
	else {
		int flag = 1;
		if (size_of_file > size_text) {
			long long int n = 1;
			long long int count = 0;
			while (size_of_file > size_text) {
				if(flag == 0){
					break;
				}
				lseek(f_oldFile, 0, SEEK_END);
				lseek(f_oldFile, -1000000 * n, SEEK_END);
				read(f_oldFile, text, 1000000);
				read(f_newFile, reversed, 1000000);
				long long int end = 1000000 - 1;
				for (long long int i = 0; i < 1000000; i++) {
					if(reversed[i] != text[end]) {
						flag = 0;
						break;
					}
					end--;
				}
				size_of_file -= size_text;
				n++;
				count += 1000000;
			}
			if(flag == 1){
				lseek(f_oldFile, 0, SEEK_SET);
				read(f_oldFile, text, size_of_file);
				read(f_newFile, reversed, 1000000);
				long long int end = size_of_file - 1;
				for (long long int i = 0; i < size_of_file; i++) {
					if(reversed[i] != text[end]){
						flag = 0;
						break;
					}
					end--;
				}
				count = final_store;
			}
		} else {
			lseek(f_oldFile, 0, SEEK_SET);
			read(f_oldFile, text, 1000000);
			read(f_newFile, reversed, 1000000);
			long long int end = size_of_file - 1;
			for (long long int i = 0; i < size_of_file; i++) {
				if(reversed[i] != text[end]){
					flag = 0;
					break;
				}
				end--;
			}
			long long int count = final_store;
		}
		if(flag == 0){
			char out[100] = "Whether file contents are reversed in newfile: No\n\n";
			write(1,out,strlen(out));
		}
		else{
			char out[100] = "Whether file contents are reversed in newfile: Yes\n\n";
			write(1,out,strlen(out));
		}
	}
	close(f_oldFile);
	close(f_newFile);
	struct stat new_file_stat;
	struct stat old_file_stat;
	struct stat directory_stat;
	char file_permissions[11] = "";
	if(stat(argv[2],&new_file_stat) == 0) {
		mode_t permissions_of_file = new_file_stat.st_mode;
		(permissions_of_file & S_IRUSR) ? write(1,"User has read permissions on newfile: Yes\n",strlen("User has read permissions on newfile: Yes\n")) : write(1,"User has read permissions on newfile: No\n",strlen("User has read permissions on newfile: No\n"));
		(permissions_of_file & S_IWUSR) ? write(1,"User has write permissions on newfile: Yes\n",strlen("User has write permissions on newfile: Yes\n")) : write(1,"User has write permissions on newfile: No\n",strlen("User has write permissions on newfile: No\n"));
		(permissions_of_file & S_IXUSR) ? write(1,"User has execute permissions on newfile: Yes\n\n",strlen("User has execute permissions on newfile: Yes\n\n")) : write(1,"User has execute permissions on newfile: No\n\n",strlen("User has execute permissions on newfile: No\n\n"));
		(permissions_of_file & S_IRGRP) ? write(1,"Group has read permissions on newfile: Yes\n",strlen("Group has read permissions on newfile: Yes\n")) : write(1,"Group has read permissions on newfile: No\n",strlen("Group has read permissions on newfile: No\n"));
		(permissions_of_file & S_IWGRP) ? write(1,"Group has write permissions on newfile: Yes\n",strlen("Group has write permissions on newfile: Yes\n")) : write(1,"Group has write permissions on newfile: No\n",strlen("Group has write permissions on newfile: No\n"));
		(permissions_of_file & S_IXGRP) ? write(1,"Group has execute permissions on newfile: Yes\n\n",strlen("Group has execute permissions on newfile: Yes\n\n")) : write(1,"Group has execute permissions on newfile: No\n\n",strlen("Group has execute permissions on newfile: No\n\n"));
		(permissions_of_file & S_IROTH) ? write(1,"Others has read permissions on newfile: Yes\n",strlen("Others has read permissions on newfile: Yes\n")) : write(1,"Others has read permissions on newfile: No\n",strlen("Others has read permissions on newfile: No\n"));
		(permissions_of_file & S_IWOTH) ? write(1,"Others has write permissions on newfile: Yes\n",strlen("Others has write permissions on newfile: Yes\n")) : write(1,"Others has write permissions on newfile: No\n",strlen("Others has write permissions on newfile: No\n"));
		(permissions_of_file & S_IXOTH) ? write(1,"Others has execute permissions on newfile: Yes\n\n\n",strlen("Others has execute permissions on newfile: Yes\n\n\n")) : write(1,"Others has execute permissions on newfile: No\n\n\n",strlen("Others has execute permissions on newfile: No\n\n\n"));
	}
	if(stat(argv[1],&old_file_stat) == 0) {
		mode_t permissions_of_file = old_file_stat.st_mode;
		(permissions_of_file & S_IRUSR) ? write(1,"User has read permissions on oldfile: Yes\n",strlen("User has read permissions on oldfile: Yes\n")) : write(1,"User has read permissions on oldfile: No\n",strlen("User has read permissions on oldfile: No\n"));
		(permissions_of_file & S_IWUSR) ? write(1,"User has write permissions on oldfile: Yes\n",strlen("User has write permissions on oldfile: Yes\n")) : write(1,"User has write permissions on oldfile: No\n",strlen("User has write permissions on oldfile: No\n"));
		(permissions_of_file & S_IXUSR) ? write(1,"User has execute permissions on oldfile: Yes\n\n",strlen("User has execute permissions on oldfile: Yes\n\n")) : write(1,"User has execute permissions on oldfile: No\n\n",strlen("User has execute permissions on oldfile: No\n\n"));
		(permissions_of_file & S_IRGRP) ? write(1,"Group has read permissions on oldfile: Yes\n",strlen("Group has read permissions on oldfile: Yes\n")) : write(1,"Group has read permissions on oldfile: No\n",strlen("Group has read permissions on oldfile: No\n"));
		(permissions_of_file & S_IWGRP) ? write(1,"Group has write permissions on oldfile: Yes\n",strlen("Group has write permissions on oldfile: Yes\n")) : write(1,"Group has write permissions on oldfile: No\n",strlen("Group has write permissions on oldfile: No\n"));
		(permissions_of_file & S_IXGRP) ? write(1,"Group has execute permissions on oldfile: Yes\n\n",strlen("Group has execute permissions on oldfile: Yes\n\n")) : write(1,"Group has execute permissions on oldfile: No\n\n",strlen("Group has execute permissions on oldfile: No\n\n"));
		(permissions_of_file & S_IROTH) ? write(1,"Others has read permissions on oldfile: Yes\n",strlen("Others has read permissions on oldfile: Yes\n")) : write(1,"Others has read permissions on oldfile: No\n",strlen("Others has read permissions on oldfile: No\n"));
		(permissions_of_file & S_IWOTH) ? write(1,"Others has write permissions on oldfile: Yes\n",strlen("Others has write permissions on oldfile: Yes\n")) : write(1,"Others has write permissions on oldfile: No\n",strlen("Others has write permissions on oldfile: No\n"));
		(permissions_of_file & S_IXOTH) ? write(1,"Others has execute permissions on oldfile: Yes\n\n\n",strlen("Others has execute permissions on oldfile: Yes\n\n\n")) : write(1,"Others has execute permissions on oldfile: No\n\n\n",strlen("Others has execute permissions on oldfile: No\n\n\n"));
	}
	if(stat(argv[3],&directory_stat) == 0) {
		mode_t permissions_of_file = directory_stat.st_mode;
		(permissions_of_file & S_IRUSR) ? write(1,"User has read permissions on Directory: Yes\n",strlen("User has read permissions on Directory: Yes\n")) : write(1,"User has read permissions on Directory: No\n",strlen("User has read permissions on Directory: No\n"));
		(permissions_of_file & S_IWUSR) ? write(1,"User has write permissions on Directory: Yes\n",strlen("User has write permissions on Directory: Yes\n")) : write(1,"User has write permissions on Directory: No\n",strlen("User has write permissions on Directory: No\n"));
		(permissions_of_file & S_IXUSR) ? write(1,"User has execute permissions on Directory: Yes\n\n",strlen("User has execute permissions on Directory: Yes\n\n")) : write(1,"User has execute permissions on Directory: No\n\n",strlen("User has execute permissions on Directory: No\n\n"));
		(permissions_of_file & S_IRGRP) ? write(1,"Group has read permissions on Directory: Yes\n",strlen("Group has read permissions on Directory: Yes\n")) : write(1,"Group has read permissions on Directory: No\n",strlen("Group has read permissions on Directory: No\n"));
		(permissions_of_file & S_IWGRP) ? write(1,"Group has write permissions on Directory: Yes\n",strlen("Group has write permissions on Directory: Yes\n")) : write(1,"Group has write permissions on Directory: No\n",strlen("Group has write permissions on Directory: No\n"));
		(permissions_of_file & S_IXGRP) ? write(1,"Group has execute permissions on Directory: Yes\n\n",strlen("Group has execute permissions on Directory: Yes\n\n")) : write(1,"Group has execute permissions on Directory: No\n\n",strlen("Group has execute permissions on Directory: No\n\n"));
		(permissions_of_file & S_IROTH) ? write(1,"Others has read permissions on Directory: Yes\n",strlen("Others has read permissions on Directory: Yes\n")) : write(1,"Others has read permissions on Directory: No\n",strlen("Others has read permissions on Directory: No\n"));
		(permissions_of_file & S_IWOTH) ? write(1,"Others has write permissions on Directory: Yes\n",strlen("Others has write permissions on Directory: Yes\n")) : write(1,"Others has write permissions on Directory: No\n",strlen("Others has write permissions on Directory: No\n"));
		(permissions_of_file & S_IXOTH) ? write(1,"Others has execute permissions on Directory: Yes\n\n\n",strlen("Others has execute permissions on Directory: Yes\n\n\n")) : write(1,"Others has execute permissions on Directory: No\n\n\n",strlen("Others has execute permissions on Directory: No\n\n\n"));
	}
	return 0;
}
