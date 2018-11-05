program error_logger("INPUT_PV,OFF_STR,ON_STR")

#include "seqPVmacros.h"
%% #include "time.h"

/* Turn on run-time debug messages */
option +d;

/* Make code reentrant. This is needed to run more than one instance of this program. */
option +r;

/* Input PV to monitor for changes */
PV(int, input, "{INPUT_PV}", Monitor);

%{

void logMess(char* mess) {

    int i;
    
    time_t t = time(NULL);
    struct tm tm = *localtime(&t);
    
    char logMessage[1000];
    sprintf(logMessage, "[%04d-%02d-%02d %02d:%02d:%02d] Chopper status: %s\n", tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec, mess);
    
    for(i = 0; i<strlen(logMessage); ++i) {
      if (logMessage[i] == "_") {
        logMessage[i] = " ";
      }
    }
    
    char filename[1000];
    sprintf(filename, "C:\\Instrument\\var\\logs\\ioc\\FERMCHOP-DIAGNOSTICS-%04d-%02d-%02d.log", tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday);
    
    // Write to a log file
    FILE* logFile;
    logFile = fopen(filename, "a");
    fprintf(logFile, logMessage);
    fflush(logFile);
    fclose(logFile);
    
    // Also put the same message into the main IOC log.
    printf(logMessage);
    
}

}%

ss monitor_errors
{
  /* Initial state. */
  state off
  {
    when(input != 0) 
	{
	  logMess(macValueGet("ON_STR"));
	} state on
  }
  
  state on
  {
    when(input == 0)
	{
      logMess(macValueGet("OFF_STR"));
	} state off
  }
}
