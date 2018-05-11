program keep_sp_and_rbv_in_sync("SETPOINT,READBACK,TOLERANCE,DELAY")

#include "seqPVmacros.h"

/* Turn on run-time debug messages */
option +d;

/* Make code reentrant. This is needed to run more than one instance of this program. */
option +r;

/* Setpoint-related PVs */
PV(double, setpoint, "{SETPOINT}", Monitor);
PV(int, setpoint_proc, "{SETPOINT}.PROC", NoMon);
PV(int, setpoint_alarm, "{SETPOINT}.SEVR", Monitor);
PV(string, setpoint_description, "{SETPOINT}.DESC", Monitor);

/* Readback-related PVs */
PV(string, readback_description, "{READBACK}.DESC", Monitor);
PV(double, readback, "{READBACK}", Monitor);

/* system pvs */
PV(double, tolerance, "{TOLERANCE}", Monitor);
PV(double, delay, "{DELAY}", Monitor);

%{
int notWithinTolerance(double setpoint, double readback, double tolerance) {
    return fabs(setpoint - readback) > tolerance;
}
}%

ss keep_sp_and_rbv_in_sync
{
  /* Initial state. */
  state idle
  {
    /* setpoint alarm must be zero to avoid sending zero to device when first starting driver (SP will be UDF_alarm) */
    when(notWithinTolerance(setpoint, readback, tolerance) && setpoint_alarm == 0) 
	{
	  printf("Keep SP and RBV in sync: setpoint ('%s') not equal readback ('%s'). Reprocessing setpoint in %f seconds if still not the same.\n", setpoint_description, readback_description, delay);
	  
	  epicsThreadSleep(delay);
	  
	  if (notWithinTolerance(setpoint, readback, tolerance) && setpoint_alarm == 0) {
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
	  epicsThreadSleep(delay);
	} state idle
  }
}
