#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include<sys/types.h>
#include<sys/stat.h>
#include <fcntl.h>
#include<errno.h>
#include <unistd.h>

int main(int argc,char** argv) {
	char name_read[100] = "";
	char output[100]="Assignment/";

	int l=strlen(argv[1])-1;
	while(l>=0 && argv[1][l]!='/'){
		l--;
	}
	l++;
	int c=11;
	while(l!=strlen(argv[1])){
		output[c++]=argv[1][l++];
	}
	char text[1000000] = "";
	char reversed[1000000] = "";
	long long int size_text = 1000000;
	long long int f_read = open(argv[1], O_RDONLY);
	if(f_read<0){
		perror("file not present");
		exit(0);
	}
	long long int direc = mkdir("Assignment",0700);
	if(direc< 0){
		perror("Directory already present");
	}
	long long int f_write = open(output, O_WRONLY|O_CREAT, 0600);
	long long int size_of_file = lseek(f_read,0,SEEK_END);
	long long int final_store = size_of_file;
	if(size_of_file > size_text) {
		long long int n = 1;
		long long int count = 0;
		while(size_of_file > size_text) {
			lseek(f_read,0,SEEK_END);
			lseek(f_read,-1000000*n,SEEK_END);
			read(f_read,text,1000000);
			long long int end = 1000000 - 1 ;
			for(long long int i=0;i<1000000;i++) {
				reversed[i] = text[end];
				end--;
			}
			write(f_write,reversed,1000000);
			size_of_file-=size_text;
			n++;
			count+=1000000;
			long long int per = count*100/final_store,len;
			char buf[10] = "";
			if(per < 10) {
				len = 1;
			}
			else if(per < 100) {
				len = 2;
			}
			else if(per == 100){
				len = 3;
			}
			sprintf(buf, "%lld",per);
			buf[len++]='%';
			buf[len++]='\r';
			write(1,buf,len);
		}
		lseek(f_read,0,SEEK_SET);
		read(f_read,text,size_of_file);
		long long int end = size_of_file -1 ;
		for(long long int i=0;i<size_of_file;i++) {
			reversed[i] = text[end];
			end--;
		}
		write(f_write,reversed,size_of_file);
		count = final_store;
		long long int per = count*100/final_store,len;
		char buf[10] = "";
		if(per < 10) {
			len = 1;
		}
		else if(per < 100) {
			len = 2;
		}
		else if(per == 100){
			len = 3;
		}
		sprintf(buf, "%lld",per);
		buf[len++]='%';
		buf[len++]='\r';
		write(1,buf,len);
	}
	else{
		lseek(f_read,0,SEEK_SET);
		read(f_read,text,1000000);
		long long int end = strlen(text) -1 ;
		for(long long int i=0;i<strlen(text);i++) {
			reversed[i] = text[end];
			end--;
		}
		write(f_write,reversed,strlen(reversed));
		long long int count = final_store;
		long long int per = count*100/final_store,len;
		char buf[10] = "";
		if(per < 10) {
			len = 1;
		}
		else if(per < 100) {
			len = 2;
		}
		else if(per == 100){
			len = 3;
		}
		sprintf(buf, "%lld",per);
		buf[len++]='%';
		buf[len++]='\r';
		write(1,buf,len);
	}
	close(f_read);
	close(f_write);
	return 0;
}
