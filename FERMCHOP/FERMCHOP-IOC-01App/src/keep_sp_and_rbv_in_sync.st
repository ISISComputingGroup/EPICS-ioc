program keep_sp_and_rbv_in_sync("SETPOINT,READBACK")

#include "seqPVmacros.h"

/* Turn on run-time debug messages */
option +d;

/* Make code reentrant. This is needed to run more than one instance of this program. */
option +r;

/* PV definitions */
PV(double, setpoint, "{SETPOINT}", Monitor);
PV(int, setpoint_proc, "{SETPOINT}.PROC", NoMon);
PV(int, setpoint_alarm, "{SETPOINT}.SEVR", Monitor);
PV(string, setpoint_description, "{SETPOINT}.DESC", Monitor);

PV(string, readback_description, "{READBACK}.DESC", Monitor);
PV(double, readback, "{READBACK}", Monitor);

%{

int notWithinTolerance(double setpoint, double readback) {
    return abs(setpoint - readback) > 1.0;
}

}%

ss keep_sp_and_rbv_in_sync
{
  /* Initial state. */
  state idle
  {
    when(notWithinTolerance(setpoint, readback) && setpoint_alarm == 0) /* setpoint alarm must be zero to avoid sending zero to device when first starting driver (SP will be UDF_alarm) */
	{
	  printf("Keep SP and RBV in sync: setpoint ('%s') not equal readback ('%s'). Reprocessing setpoint in 5 seconds if still not the same.\n", setpoint_description, readback_description);
	  epicsThreadSleep(5);
	  if (notWithinTolerance(setpoint, readback)) {
	      printf("Keep SP and RBV in sync: setpoint ('%s') not equal readback ('%s'). Reprocessing setpoint now.\n", setpoint_description, readback_description);
	      PVPUT(setpoint_proc, 1);
	  } else {
	      printf("Keep SP and RBV in sync: Not reprocessing setpoint ('%s') because readback is now in sync.\n", setpoint_description);
	  }
	} state wait
  }
  
  state wait
  {
    when(1)
	{
	  epicsThreadSleep(10);
	} state idle
  }
}
