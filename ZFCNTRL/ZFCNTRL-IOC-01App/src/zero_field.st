program zero_field("MAGNETOMETER_X,MAGNETOMETER_Y,MAGNETOMETER_Z,STATE")

#include "seqPVmacros.h"
%% #include "seq_snc.h"
%% #include "time.h"
%% #include "string.h"
%% #include "errlog.h"

/* Turn on run-time debug messages */
option +d;
option +r;
option +s;

/* Field readings from magnetometer */
PV(double, magnetometer_x, "{MAGNETOMETER_X}", Monitor);
PV(double, magnetometer_y, "{MAGNETOMETER_Y}", Monitor);
PV(double, magnetometer_z, "{MAGNETOMETER_Z}", Monitor);

/* Severities from magnetometer */
PV(int, magnetometer_x_sevr, "{MAGNETOMETER_X}.SEVR", Monitor);
PV(int, magnetometer_y_sevr, "{MAGNETOMETER_Y}.SEVR", Monitor);
PV(int, magnetometer_z_sevr, "{MAGNETOMETER_Z}.SEVR", Monitor);

/* Statuses for feedback to OPI etc */
PV(string, statemachine_state, "{STATE}", NoMon);

/* Whether new readings are available from the magnetometer */
PV(int, new_readings_available, "{READINGS_READY}", Monitor);
/* Trigger the magnetometer to take new readings */
PV(int, trigger_read, "{TRIGGER_READ}", NoMon);


#define PROGRAM_NAME "zero_field.st"

/* This needs to be a macro as the call to pvIndex has to happen from SNL code, not C code. */
/* See https://www-csr.bessy.de/control/SoftDist/sequencer/EscapeToC.html?highlight=pvindex#calling-pv-functions-from-c */
#define TRANSITION_TO_STATE(x) state_transition(ssId, pVar, pvIndex(statemachine_state), (x))

%{
  static void state_transition(SS_ID ssId, struct seqg_vars* const pVar, CH_ID index, const char* const new_state_name);
}%

ss zero_field
{

  /* Initial state. */
  state initializing
  {
    entry {
      TRANSITION_TO_STATE("initializing");
    }
    when (){} state trigger_magnetometer_read
  }
  
  state inputs_invalid
  {
    entry {
      TRANSITION_TO_STATE("inputs_invalid");
      errlogSevPrintf(errlogMajor, "%s: Magnetometer inputs in invalid alarm. Statuses: X=%d, Y=%d, Z=%d\n", PROGRAM_NAME, magnetometer_x_sevr, magnetometer_y_sevr, magnetometer_z_sevr);
    }
    
    when(delay(60)) {
      errlogSevPrintf(errlogMajor, "%s: Magnetometer inputs still in invalid alarm. Statuses: X=%d, Y=%d, Z=%d\n", PROGRAM_NAME, magnetometer_x_sevr, magnetometer_y_sevr, magnetometer_z_sevr);
    } state inputs_invalid
    
  }
  
  state trigger_magnetometer_read
  {
    entry {
      TRANSITION_TO_STATE("trigger_magnetometer_read");
    }
    
    when() {
      PVPUT(trigger_read, 1);
    } state wait_for_magnetometer_reading
  }
  
  state wait_for_magnetometer_reading
  {
    entry {
      TRANSITION_TO_STATE("wait_for_magnetometer_reading");
    }
    
    when(new_readings_available) {
      /* Reset new readings back to unavailable */
      PVPUT(new_readings_available, 0);
    } state trigger_magnetometer_read
    
    when(delay(5)) {
      /* TODO: If we don't get a reading from the magnetometer within 5 seconds */
    } state inputs_invalid
  }
}


%{
  static void state_transition(SS_ID ssId, struct seqg_vars* const pVar, CH_ID index, const char* const new_state_name)
  {
    strncpy(pVar->statemachine_state, new_state_name, MAX_STRING_SIZE);
	seq_pvPut(ssId, index, SYNC);
	errlogSevPrintf(errlogInfo, "%s: Entering state %s", PROGRAM_NAME, new_state_name);
  }
  
}%
