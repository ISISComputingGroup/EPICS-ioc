/* OERCONE-IOC-01Main.cpp */
/* Author:  Marty Kraimer Date:    17MAR2000 */

#include <stddef.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#include <stdio.h>
#include <iostream>
#include <fstream>

#include "epicsExit.h"
#include "epicsThread.h"
#include "iocsh.h"
#include "luaShell.h"


// Taken from https://www.geeksforgeeks.org/c-program-replace-word-text-another-given-word/
// Function to replace a string with another 
// string 
char *replaceWord(const char *s, const char *oldW, 
                                 const char *newW) 
{ 
    char *result; 
    int i, cnt = 0; 
    int newWlen = strlen(newW); 
    int oldWlen = strlen(oldW); 
  
    // Counting the number of times old word 
    // occur in the string 
    for (i = 0; s[i] != '\0'; i++) 
    { 
        if (strstr(&s[i], oldW) == &s[i]) 
        { 
            cnt++; 
  
            // Jumping to index after the old word. 
            i += oldWlen - 1; 
        } 
    } 
  
    // Making new string of enough length 
    result = (char *)malloc(i + cnt * (newWlen - oldWlen) + 1); 
  
    i = 0; 
    while (*s) 
    { 
        // compare the substring with the result 
        if (strstr(s, oldW) == s) 
        { 
            strcpy(&result[i], newW); 
            i += newWlen; 
            s += oldWlen; 
        } 
        else
            result[i++] = *s++; 
    } 
  
    result[i] = '\0'; 
    return result; 
} 

int main(int argc,char *argv[])
{
    if(argc>=2) {
        // char *arg1 = NULL;
        // arg1 = replaceWord(argv[1], "cmd", "lua");
        // printf("Argv[1] %s", arg1);
        // luash(arg1);
        iocsh(argv[1]);
        epicsThreadSleep(.2);
    }
    // luash(NULL);
    iocsh(NULL);
    epicsExit(0);
    return(0);
}
