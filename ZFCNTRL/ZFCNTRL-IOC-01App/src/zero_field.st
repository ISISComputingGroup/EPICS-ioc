program zero_field("P")

#include "seqPVmacros.h"
%% #include "seq_snc.h"
%% #include "time.h"
%% #include "string.h"
%% #include "errlog.h"
%% #include "alarm.h"

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

/* Power supply currents */
PV(double, output_psu_x, "{P}OUTPUT:X", Monitor);
PV(double, output_psu_y, "{P}OUTPUT:Y", Monitor);
PV(double, output_psu_z, "{P}OUTPUT:Z", Monitor);
PV(int, output_psu_x_sevr, "{P}OUTPUT:X.SEVR", Monitor);
PV(int, output_psu_y_sevr, "{P}OUTPUT:Y.SEVR", Monitor);
PV(int, output_psu_z_sevr, "{P}OUTPUT:Z.SEVR", Monitor);

/* Power supply setpoints */
PV(double, output_psu_x_sp, "{P}OUTPUT:X:SP", Monitor);
PV(double, output_psu_y_sp, "{P}OUTPUT:Y:SP", Monitor);
PV(double, output_psu_z_sp, "{P}OUTPUT:Z:SP", Monitor);
PV(int, output_psu_x_sp_sevr, "{P}OUTPUT:X:SP.SEVR", Monitor);
PV(int, output_psu_y_sp_sevr, "{P}OUTPUT:Y:SP.SEVR", Monitor);
PV(int, output_psu_z_sp_sevr, "{P}OUTPUT:Z:SP.SEVR", Monitor);

/* Power supply setpoint limits */
PV(double, output_psu_x_sp_drvh, "{P}OUTPUT:X:SP.DRVH", Monitor);
PV(double, output_psu_y_sp_drvh, "{P}OUTPUT:Y:SP.DRVH", Monitor);
PV(double, output_psu_z_sp_drvh, "{P}OUTPUT:Z:SP.DRVH", Monitor);
PV(double, output_psu_x_sp_drvl, "{P}OUTPUT:X:SP.DRVL", Monitor);
PV(double, output_psu_y_sp_drvl, "{P}OUTPUT:Y:SP.DRVL", Monitor);
PV(double, output_psu_z_sp_drvl, "{P}OUTPUT:Z:SP.DRVL", Monitor);

/* Power supply setpoint readbacks */
PV(double, output_psu_x_sp_rbv, "{P}OUTPUT:X:SP:RBV", Monitor);
PV(double, output_psu_y_sp_rbv, "{P}OUTPUT:Y:SP:RBV", Monitor);
PV(double, output_psu_z_sp_rbv, "{P}OUTPUT:Z:SP:RBV", Monitor);
PV(int, output_psu_x_sp_rbv_sevr, "{P}OUTPUT:X:SP:RBV.SEVR", Monitor);
PV(int, output_psu_y_sp_rbv_sevr, "{P}OUTPUT:Y:SP:RBV.SEVR", Monitor);
PV(int, output_psu_z_sp_rbv_sevr, "{P}OUTPUT:Z:SP:RBV.SEVR", Monitor);

/* Proportional feedback factors and fiddle factors */
PV(double, p_x, "{P}P:X", Monitor);
PV(double, p_y, "{P}P:Y", Monitor);
PV(double, p_z, "{P}P:Z", Monitor);
PV(double, fiddle_factor, "{P}P:FIDDLE_FACTOR", Monitor);

/* Tolerance of (actual-setpoint) for field to be considered stable */
PV(double, tolerance, "{P}TOLERANCE", Monitor);

/* Statuses for feedback to OPI etc */
PV(string, statemachine_state, "{P}STATEMACHINE:STATE", NoMon);
PV(string, status, "{P}STATUS", Monitor);

/* Whether the field is "stable" or not */
PV(int, stable, "{P}STABLE", Monitor);

/* Whether new readings are available from the magnetometer */
PV(int, new_readings_available, "{P}_READINGS_READY", Monitor);
/* Trigger the magnetometer to take new readings */
PV(int, trigger_read, "{P}TRIGGER_MAGNETOMETER_READ", NoMon);

/* Whether the controller is in auto-feedback mode */
PV(int, auto_feedback_enabled, "{P}AUTOFEEDBACK", Monitor);

/* Statemachine debugging - e.g. logging of every state entry. Very verbose. */
PV(int, debug, "{P}DEBUG", Monitor);

/* Delay between statemachine loops. Adjustable by user, but adjusting it will
 * mean that "fiddle factor" will need to be adjusted accordingly.
 */
PV(double, loop_delay, "{P}STATEMACHINE:LOOP_DELAY", Monitor);


#define PROGRAM_NAME "zero_field.st"

/* This needs to be a macro as the call to pvIndex has to happen from SNL code, not C code. */
/* See https://www-csr.bessy.de/control/SoftDist/sequencer/EscapeToC.html?highlight=pvindex#calling-pv-functions-from-c */
#define TRANSITION_TO_STATE(x) state_transition(ssId, pVar, pvIndex(statemachine_state), (x))

%{
  /* Some necessary function forward-declarations - for implementations see end of file. */
  static void state_transition(SS_ID ssId, struct seqg_vars* const pVar, CH_ID index, const char* const new_state_name);
  static int power_supplies_invalid(struct seqg_vars* const pVar);
  static int isWithinTolerance(double setpoint, double readback, double tolerance);
  static double coerceToRange(double value, double low_limit, double high_limit);
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
      errlogSevPrintf(errlogMajor, "%s: Magnetometer inputs invalid. Inputs: (X=%f, Y=%f, Z=%f) Severities: (X=%d, Y=%d, Z=%d).\n", 
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
    
    when(new_readings_available && !(magnetometer_x_sevr == INVALID_ALARM || magnetometer_y_sevr == INVALID_ALARM || magnetometer_z_sevr == INVALID_ALARM)) {
      /* intentionally empty */
    } state check_corrected_field
    
    when(new_readings_available && (magnetometer_x_sevr == INVALID_ALARM || magnetometer_y_sevr == INVALID_ALARM || magnetometer_z_sevr == INVALID_ALARM)) {
      PVPUT(stable, 0);
      PVPUTSTR(status, "Magnetometer read error");
      errlogSevPrintf(errlogMajor, "%s: Magnetometer read error: new reading became available but severities were invalid.\n", PROGRAM_NAME);
    } state inputs_invalid
    
    when(delay(5)) {
      PVPUT(stable, 0);
      PVPUTSTR(status, "Magnetometer read error");
      errlogSevPrintf(errlogMajor, "%s: Magnetometer read error: new reading did not become available.\n", PROGRAM_NAME);
    } state inputs_invalid
    
    exit {
      /* Reset new readings back to unavailable no matter how we leave this state. */
      PVPUT(new_readings_available, 0);
    }
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
    } state trigger_mag_read
    
    when(!magnetometer_overloaded) {
      /* Intentionally empty */
    } state check_auto_feedback
  }
  
  state check_auto_feedback {
    entry {
      TRANSITION_TO_STATE("check_auto_feedback");
    }
    
    when(auto_feedback_enabled) {
      /* Intentionally empty */
    } state check_output_psu_state
        
    when(!auto_feedback_enabled) {
      /* If we get to this point, there is no error. Clear any previous error states. */
      PVPUTSTR(status, "No error");
    } state trigger_mag_read
  }
  
  state check_output_psu_state {
    entry {
      TRANSITION_TO_STATE("check_output_psu_state");
    }
    
    when(power_supplies_invalid(pVar)) {
      PVPUTSTR(status, "Power supply invalid");
    } state trigger_mag_read
    
    when(!power_supplies_invalid(pVar)) {
      /* Intentionally empty */
    } state write_to_psu
  }
  
  state write_to_psu {
    entry {
      TRANSITION_TO_STATE("write_to_psu");
    }
    
    when(1) {
      /* If setpoints are in INVALID alarm, this may be the first time around the 
       * loop or the output power supply ioc may have been rebooted.
       *
       * In this case, use the setpoint readback value instead.
       *
       * We don't always use the setpoint readback value as this loop may be updating faster than the
       * scan period of the setpoint readback, and we don't want to use a potentially out-of-date setpoint
       * as the basis for these calculations.
       */
      double existing_output_x = (output_psu_x_sp_sevr == INVALID_ALARM) ? output_psu_x_sp_rbv : output_psu_x_sp;
      double existing_output_y = (output_psu_y_sp_sevr == INVALID_ALARM) ? output_psu_y_sp_rbv : output_psu_y_sp;
      double existing_output_z = (output_psu_z_sp_sevr == INVALID_ALARM) ? output_psu_z_sp_rbv : output_psu_z_sp;
      
      double change_x = (magnetometer_x - existing_output_x) * p_x * fiddle_factor;
      double change_y = (magnetometer_y - existing_output_y) * p_y * fiddle_factor;
      double change_z = (magnetometer_z - existing_output_z) * p_z * fiddle_factor;
      
      double new_x = existing_output_x + change_x;
      double new_y = existing_output_y + change_y;
      double new_z = existing_output_z + change_z;
      
      double coerced_x = coerceToRange(new_x, output_psu_x_sp_drvl, output_psu_x_sp_drvh);
      double coerced_y = coerceToRange(new_y, output_psu_y_sp_drvl, output_psu_y_sp_drvh);
      double coerced_z = coerceToRange(new_z, output_psu_z_sp_drvl, output_psu_z_sp_drvh);
      
      int x_on_limit = (new_x == coerced_x);
      int y_on_limit = (new_y == coerced_y);
      int z_on_limit = (new_z == coerced_z);
      
      if (x_on_limit || y_on_limit || z_on_limit) {
        errlogSevPrintf(errlogMajor, "%s: power supply outputs on limits: X=%s, Y=%s, Z=%s (limits: X=%f, Y=%f, Z=%f)", 
          PROGRAM_NAME, x_on_limit ? "True" : "False", y_on_limit ? "True" : "False", z_on_limit ? "True" : "False", 
          coerced_x, coerced_y, coerced_z);
        PVPUTSTR(status, "Power supply on limits");
      } else {
        /* If we get here, there has been no error so clear error flags */
        PVPUTSTR(status, "No error");
      }
      
      PVPUT(output_psu_x_sp, coerced_x);
      PVPUT(output_psu_y_sp, coerced_y);
      PVPUT(output_psu_z_sp, coerced_z);
      
    } state loop_delay
  }
  
  state loop_delay {
    entry {
      TRANSITION_TO_STATE("loop_delay");
    }
    
    when(delay(loop_delay)) {
      PVPUTSTR(status, "No error");
    } state trigger_mag_read
  }
}


%{
  /**
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
  
  /**
   * Return 1 if any of the power supply readbacks or setpoint readbacks are invalid - else return 0.
   */
  static int power_supplies_invalid(struct seqg_vars* const pVar) {
    return pVar->output_psu_x_sevr == INVALID_ALARM 
        || pVar->output_psu_y_sevr == INVALID_ALARM 
        || pVar->output_psu_z_sevr == INVALID_ALARM 
        || pVar->output_psu_x_sp_rbv_sevr == INVALID_ALARM 
        || pVar->output_psu_y_sp_rbv_sevr == INVALID_ALARM 
        || pVar->output_psu_z_sp_rbv_sevr == INVALID_ALARM;
  }
  
  /**
   * Returns 1 if the first two arguments are within tolerance of each other, else 0.
   */
  static int isWithinTolerance(double setpoint, double readback, double tolerance) {
    return fabs(setpoint - readback) <= tolerance;
  }
  
  /**
   * Coerces a floating point number to be within given low and high limits.
   */
  static double coerceToRange(double value, double low_limit, double high_limit) {
    if (high_limit < low_limit) {
      errlogSevPrintf(errlogMajor, "%s: coerceToRange called with high < low. Returning value anyway.", PROGRAM_NAME);
      return value;
    }
    
    if (value >= high_limit) {
        return high_limit;
    } else if (value <= low_limit) {
        return low_limit;
    } else {
        return value;
    }
  }
}%
