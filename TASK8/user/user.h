#ifndef  USER_H
#define  USER_H


#include "../include/types.h"

#define SBRK_ERROR ((char *)-1)
//syscall

int fork(void);
int exit(int) __attribute__((noreturn));
int wait(int*);
int getpid(void);
int write(int, const void*, int);
int read(int, void*, int);
int exec(const char *, char**);
int close(int);
int open(const char *, int);
int chdir(const char*);
int makenode(const char*, short, short);
int mkdir(const char*);
int unlink(const char*);
int duplicate(int);
int crash_arm(void);
char* sys_sbrk(int,int);


// printf.c
void fprintf(int, const char*, ...) __attribute__ ((format (printf, 2, 3)));
void printf(const char*, ...) __attribute__ ((format (printf, 1, 2)));


//ulib.c
void* memset(void*, int, uint);
unsigned int uptime(void);
char* gets(char*, int max);
uint strlen(const char*);
char* strchr(const char*, char c);
char* sbrk(int);
unsigned int get_time(void);
void make_filename(char *buf, const char *prefix, int num);
int strcmp(const char *p, const char *q);


//umalloc.c
void* malloc(uint);


#endif