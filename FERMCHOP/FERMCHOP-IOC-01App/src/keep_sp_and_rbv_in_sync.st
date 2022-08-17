program keep_sp_and_rbv_in_sync("SETPOINT,READBACK,TOLERANCE,DELAY")

#include "ibexSeqPVmacros.h"
%% #include "errlog.h"
%% #include <math.h>

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
PV(double, delay_time, "{DELAY}", Monitor);

double old_setpoint; /* keep track of setpoint prior to delay, so as not to accidentally reporcess a new setpoint */

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
      errlogSevPrintf(errlogMinor, "Keep SP and RBV in sync: setpoint %f ('%s') not equal readback %f ('%s'). Reprocessing setpoint in %f seconds if still not the same.\n", setpoint, setpoint_description, readback, readback_description, delay_time);
      old_setpoint = setpoint;
    } state checksp
  }

  state checksp
  {
    when(setpoint != old_setpoint)
    {
        errlogSevPrintf(errlogMinor, "Keep SP and RBV in sync: Not reprocessing setpoint ('%s') as now changed (%f -> %f).\n", setpoint_description, old_setpoint, setpoint);
    } state idle
    when(delay(delay_time))
    {
      if (notWithinTolerance(setpoint, readback, tolerance) && setpoint_alarm == 0) {
          errlogSevPrintf(errlogMinor, "Keep SP and RBV in sync: setpoint %f ('%s') not equal readback %f ('%s'). Reprocessing setpoint now.\n", setpoint, setpoint_description, readback, readback_description);
          PVPUT(setpoint_proc, 1);
      } else {
          errlogSevPrintf(errlogMinor, "Keep SP and RBV in sync: Not reprocessing setpoint %f ('%s') because readback ('%s') is now in sync.\n", setpoint, setpoint_description, readback_description);
      }
    } state wait
  }
  
  state wait
  {
    when(delay(delay_time))
    {
      ;
    } state idle
  }
}
