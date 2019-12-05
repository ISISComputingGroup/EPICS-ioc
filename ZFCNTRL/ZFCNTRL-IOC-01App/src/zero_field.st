program zero_field("P")

#include "seqPVmacros.h"
%% #include "seq_snc.h"
%% #include "time.h"
%% #include "string.h"
%% #include "errlog.h"
%% #include "alarm.h"

/* Turn on run-time debug messages */
option +d;
option +r;
option +s;

/* Field readings from magnetometer */
PV(double, magnetometer_x, "{P}MAGNETOMETER:X", Monitor);
PV(double, magnetometer_y, "{P}MAGNETOMETER:Y", Monitor);
PV(double, magnetometer_z, "{P}MAGNETOMETER:Z", Monitor);

/* Severities from magnetometer */
PV(int, magnetometer_x_sevr, "{P}MAGNETOMETER:X.SEVR", Monitor);
PV(int, magnetometer_y_sevr, "{P}MAGNETOMETER:Y.SEVR", Monitor);
PV(int, magnetometer_z_sevr, "{P}MAGNETOMETER:Z.SEVR", Monitor);

/* Magnetometer overload */
PV(int, magnetometer_overloaded, "{P}MAGNETOMETER:OVERLOAD", Monitor);

/* Field setpoints */
PV(double, setpoint_x, "{P}FIELD:X:SP", Monitor);
PV(double, setpoint_y, "{P}FIELD:Y:SP", Monitor);
PV(double, setpoint_z, "{P}FIELD:Z:SP", Monitor);

/* Tolerance of (actual-setpoint) for field to be considered stable */
PV(double, tolerance, "{P}TOLERANCE", Monitor);

/* Statuses for feedback to OPI etc */
PV(string, statemachine_state, "{P}STATEMACHINE", NoMon);
PV(string, status, "{P}STATUS", Monitor);

/* Whether new readings are available from the magnetometer */
PV(int, new_readings_available, "{P}_READINGS_READY", Monitor);
/* Trigger the magnetometer to take new readings */
PV(int, trigger_read, "{P}TRIGGER_MAGNETOMETER_READ", NoMon);

/* Whether the field is "stable" or not */
PV(int, stable, "{P}STABLE", Monitor);

/* Whether the controller is in auto-feedback mode */
PV(int, auto_feedback_enabled, "{P}AUTOFEEDBACK", Monitor);

PV(int, debug, "{P}DEBUG", Monitor);



#define PROGRAM_NAME "zero_field.st"

/* This needs to be a macro as the call to pvIndex has to happen from SNL code, not C code. */
/* See https://www-csr.bessy.de/control/SoftDist/sequencer/EscapeToC.html?highlight=pvindex#calling-pv-functions-from-c */
#define TRANSITION_TO_STATE(x) state_transition(ssId, pVar, pvIndex(statemachine_state), (x))

%{
    
  static void state_transition(SS_ID ssId, struct seqg_vars* const pVar, CH_ID index, const char* const new_state_name);
  
  int isWithinTolerance(double setpoint, double readback, double tolerance) {
    return fabs(setpoint - readback) <= tolerance;
  }
}%

ss zero_field
{

  /* Initial state. */
  state initializing
  {
    entry {
      TRANSITION_TO_STATE("initializing");
    }
    when (){} state trigger_mag_read
  }
  
  state inputs_invalid
  {
    entry {
      TRANSITION_TO_STATE("inputs_invalid");
      errlogSevPrintf(errlogMajor, "%s: Magnetometer inputs invalid. Inputs: (X=%d, Y=%d, Z=%d) Severities: (X=%d, Y=%d, Z=%d)\n", 
          PROGRAM_NAME, magnetometer_x, magnetometer_y, magnetometer_z, magnetometer_x_sevr, magnetometer_y_sevr, magnetometer_z_sevr);
    }
    
    when(delay(10)) {
      /* Retry getting values from magnetometer every 10 seconds */
    } state trigger_mag_read
    
  }
  
  state trigger_mag_read
  {
    entry {
      TRANSITION_TO_STATE("trigger_mag_read");
    }
    
    when() {
      PVPUT(trigger_read, 1);
    } state wait_for_mag_read
  }
  
  state wait_for_mag_read
  {
    entry {
      TRANSITION_TO_STATE("wait_for_mag_read");
    }
    
    when(new_readings_available) {
      /* Reset new readings back to unavailable */
      PVPUT(new_readings_available, 0);
    } state check_corrected_field
    
    when(delay(5)) {
      PVPUT(stable, 0);
      PVPUTSTR(status, "Magnetometer read error");
    } state inputs_invalid
  }
  
  state check_corrected_field {
    entry {
      TRANSITION_TO_STATE("check_corrected_field");
    }
    
    when() {
      int within_tolerance = isWithinTolerance(setpoint_x, magnetometer_x, tolerance) && 
          isWithinTolerance(setpoint_y, magnetometer_y, tolerance) && 
          isWithinTolerance(setpoint_z, magnetometer_z, tolerance);
          
      PVPUT(stable, within_tolerance);
      
    } state check_raw_field
  }
  
  state check_raw_field {
    entry {
      TRANSITION_TO_STATE("check_raw_field");
    }
    
    when(magnetometer_overloaded) {
      PVPUTSTR(status, "Magnetometer overloaded");
      PVPUT(auto_feedback_enabled, 0);
    } state trigger_mag_read
    
    when(!magnetometer_overloaded) {
      /* TODO: what else do we need to do here? */
    } state check_auto_feedback
  }
  
  state check_auto_feedback {
    entry {
      TRANSITION_TO_STATE("check_auto_feedback");
    }
    
    when(auto_feedback_enabled) {
      
    } state everything_else
        
    when(!auto_feedback_enabled) {
      /* If we get to this point, there is no error. Clear any previous error states. */
      PVPUTSTR(status, "No error");
    } state trigger_mag_read
  }
  
  state everything_else {
    entry {
      TRANSITION_TO_STATE("everything_else");
    }
    
    when(delay(1)) {
      PVPUTSTR(status, "No error");
    } state trigger_mag_read
  }
}


%{
  /*
   * Called on any state transitions that occur in the state machine - primarily for debugging.
   */
  static void state_transition(SS_ID ssId, struct seqg_vars* const pVar, CH_ID index, const char* const new_state_name)
  {
    strncpy(pVar->statemachine_state, new_state_name, MAX_STRING_SIZE);
	seq_pvPut(ssId, index, SYNC);
    if (pVar->debug) {
	  errlogSevPrintf(errlogInfo, "%s: Entering state %s", PROGRAM_NAME, new_state_name);
    }
  }
}%
