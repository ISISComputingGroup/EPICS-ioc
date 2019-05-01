program error_logger("INPUT_PV,OFF_STR,ON_STR")

#include "seqPVmacros.h"
%% #include "time.h"
%% #include "string.h"
%% #include "errlog.h"

/* Turn on run-time debug messages */
option +d;

/* Make code reentrant. This is needed to run more than one instance of this program. */
option +r;

/* Input PV to monitor for changes */
PV(int, input, "{INPUT_PV}", Monitor);

%{

void logMess(char* mess) {
    char mess_without_underscores[1000] = {0};
    int i;
    
    for (i=0; i<strlen(mess); ++i) {
        if (mess[i] == '_') {
            mess_without_underscores[i] = ' ';
        } else {
            mess_without_underscores[i] = mess[i];
        }
    }
    errlogSevPrintf(errlogMajor, "Chopper status: %s\n", mess_without_underscores);
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
