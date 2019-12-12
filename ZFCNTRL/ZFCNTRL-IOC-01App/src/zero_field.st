program zero_field("P")

#include "seqPVmacros.h"
#include "zf_pv_definitions.h"
%% #include "seq_snc.h"
%% #include "time.h"
%% #include "string.h"
%% #include "errlog.h"
%% #include "alarm.h"

option +d;
option +r;
option +s;


%{
  static const char* const PROGRAM_NAME = "zero_field.st";

/* Define some error statuses. These should match the strings in $(P)STATUS */
  static const char* const ZF_STAT_NO_ERROR = "No error";
  static const char* const ZF_STAT_MAGNETOMETER_DATA_INVALID = "Magnetometer data invalid";
  static const char* const ZF_STAT_MAGNETOMETER_DATA_STALE = "No new magnetometer data";
  static const char* const ZF_STAT_MAGNETOMETER_OVERLOADED = "Magnetometer overloaded";
  static const char* const ZF_STAT_PSU_INVALID = "Power supply invalid";
  static const char* const ZF_STAT_PSU_ON_LIMITS = "Power supply on limits";
  static const char* const ZF_STAT_PSU_WRITE_FAILED = "Power supply write failed";
  
  static const int PSU_MODE_VOLTAGE = 0;  
  static const int PSU_MODE_CURRENT = 1;  
  
  static const int PSU_STATUS_OFF = 0;  
  static const int PSU_STATUS_ON = 1;  

  /* This needs to be a macro as the call to pvIndex has to happen from SNL code, not C code. */
  /* See https://www-csr.bessy.de/control/SoftDist/sequencer/EscapeToC.html?highlight=pvindex#calling-pv-functions-from-c */
  #define ZF_TRANSITION_TO_STATE(x) zf_state_transition(ssId, pVar, pvIndex(statemachine_state), (x))

  /* Some necessary function forward-declarations - for implementations see end of file. */
  static void zf_state_transition(SS_ID ssId, struct seqg_vars* const pVar, CH_ID index, const char* const new_state_name);
  static int power_supplies_invalid(struct seqg_vars* const pVar);
  static int magnetometer_invalid(struct seqg_vars* const pVar);
  static int is_within_tolerance(double setpoint, double readback, double tolerance);
  static int all_power_suppies_on(struct seqg_vars* const pVar);
  static int all_power_suppies_in_current_mode(struct seqg_vars* const pVar);
  static double coerce_to_range(double value, double low_limit, double high_limit);
  
  /* A timestamp from the last time we asked the magnetometer to take data. Used for loop time calculation. */
  clock_t _time_of_last_mag_read_trigger;
  
  /* flag to track whether power supply outputs were limited or not. Need this flag to be able to set correct errors. */
  int _output_on_limit = 0;
}%

ss zero_field
{

  /* Initial state. */
  state initializing
  {
    entry {
      ZF_TRANSITION_TO_STATE("initializing");
      _time_of_last_mag_read_trigger = clock();
    }
    when (){} state trigger_mag_read
  }
  
  state trigger_mag_read
  {
    entry {
      ZF_TRANSITION_TO_STATE("trigger_mag_read");
      
      /* inverts each time around the main statemachine loop, giving a flashing effect if everything is working correctly. */
      PVPUT(statemachine_activity, !statemachine_activity);
      %% clock_t new_time = clock();
      %% double time_taken = 1000.0 * (new_time - _time_of_last_mag_read_trigger) / CLOCKS_PER_SEC;
      PVPUT(statemachine_measured_loop_time, time_taken);
      
      if (debug) {
        errlogSevPrintf(errlogInfo, "%s: Loop took %f ms.\n", PROGRAM_NAME, time_taken);
      }
      
      _time_of_last_mag_read_trigger = new_time;
      
    }
    
    when() {
      PVPUT(trigger_read, 1);
    } state wait_for_mag_read
  }
  
  state wait_for_mag_read
  {
    entry {
      ZF_TRANSITION_TO_STATE("wait_for_mag_read");
    }
    
    when(new_readings_available && !magnetometer_invalid(pVar)) {
      /* intentionally empty */
    } state check_corrected_field
    
    when(new_readings_available && magnetometer_invalid(pVar)) {
      PVPUT(stable, 0);
      PVPUTSTR(status, ZF_STAT_MAGNETOMETER_DATA_INVALID);
      errlogSevPrintf(errlogMajor, "%s: Magnetometer read error: new reading became available but severities were invalid.\n", PROGRAM_NAME);
    } state loop_delay
    
    when(delay(read_timeout)) {
      PVPUT(stable, 0);
      PVPUTSTR(status, ZF_STAT_MAGNETOMETER_DATA_STALE);
      errlogSevPrintf(errlogMajor, "%s: Magnetometer read error: new reading did not become available.\n", PROGRAM_NAME);
      /* After this state go straight to trigger_mag_read rather than loop_delay as we have already waited 5 seconds */
    } state trigger_mag_read
    
    exit {
      /* Reset new readings back to unavailable no matter how we leave this state. */
      PVPUT(new_readings_available, 0);
    }
  }
  
  state check_corrected_field {
    entry {
      ZF_TRANSITION_TO_STATE("check_corrected_field");
    }
    
    when() {
      int within_tolerance = is_within_tolerance(setpoint_x, magnetometer_x, tolerance) && 
          is_within_tolerance(setpoint_y, magnetometer_y, tolerance) && 
          is_within_tolerance(setpoint_z, magnetometer_z, tolerance);
          
      PVPUT(stable, within_tolerance);
      
      if (debug) {
        errlogSevPrintf(errlogInfo, "%s: Magnetometer within tolerance: %s\n", PROGRAM_NAME, within_tolerance ? "True" : "False");
      }
      
    } state check_raw_field
  }
  
  state check_raw_field {
    entry {
      ZF_TRANSITION_TO_STATE("check_raw_field");
    }
    
    when(magnetometer_overloaded) {
      PVPUTSTR(status, ZF_STAT_MAGNETOMETER_OVERLOADED);
      if (debug) {
        errlogSevPrintf(errlogInfo, "%s: Magnetometer overloaded - skipping PSU writes\n", PROGRAM_NAME);
      }
    } state loop_delay
    
    when(!magnetometer_overloaded) {
      /* Intentionally empty */
    } state check_auto_feedback
  }
  
  state check_auto_feedback {
    entry {
      ZF_TRANSITION_TO_STATE("check_auto_feedback");
    }
    
    when(auto_feedback_enabled) {
      /* Intentionally empty */
    } state check_output_psu_state
        
    when(!auto_feedback_enabled) {
      /* If we get to this point, there is no error. Clear any previous error states. */
      PVPUTSTR(status, ZF_STAT_NO_ERROR);
      if (debug) {
        errlogSevPrintf(errlogMajor, "%s: Auto-feedback disabled - skipping PSU writes\n", PROGRAM_NAME);
      }
    } state loop_delay
  }
  
  state check_output_psu_state {
    entry {
      ZF_TRANSITION_TO_STATE("check_output_psu_state");
    }
    
    when(power_supplies_invalid(pVar)) {
      PVPUTSTR(status, ZF_STAT_PSU_INVALID);
      errlogSevPrintf(errlogMajor, "%s: Power supply is in invalid alarm. Not writing to power supplies.\n", PROGRAM_NAME);
    } state loop_delay
    
    when(!power_supplies_invalid(pVar)) {
      /* Intentionally empty */
    } state ensure_mode_current
  }
  
  state ensure_mode_current {
    entry {
      ZF_TRANSITION_TO_STATE("ensure_mode_current");
    } 
    
    when (all_power_suppies_in_current_mode(pVar)) {
      /* outputs already in correct mode, nothing to do here */
    } state ensure_outputs_on
    
    when (!all_power_suppies_in_current_mode(pVar)) {
      PVPUT(output_psu_x_mode_sp, PSU_MODE_CURRENT);
      PVPUT(output_psu_y_mode_sp, PSU_MODE_CURRENT);
      PVPUT(output_psu_z_mode_sp, PSU_MODE_CURRENT);
    } state wait_for_mode_current
  }
  
  state wait_for_mode_current {
    entry {
      ZF_TRANSITION_TO_STATE("wait_for_mode_current");
    }
    
    when (all_power_suppies_in_current_mode(pVar)) {
      /* modes are now correct */
      errlogSevPrintf(errlogInfo, "%s: Power supply outputs switched on successfully.\n", PROGRAM_NAME);
    } state ensure_outputs_on
    
    when (delay(read_timeout)) {
      errlogSevPrintf(errlogMajor, "%s: Cannot get power supply into current mode.\n", PROGRAM_NAME);
      PVPUTSTR(status, ZF_STAT_PSU_WRITE_FAILED);   
    } state trigger_mag_read
  }
  
  state ensure_outputs_on {
    entry {
      ZF_TRANSITION_TO_STATE("ensure_outputs_on");
    } 
    
    when (all_power_suppies_on(pVar)) {
      /* outputs already on, nothing to do here */
    } state write_to_psu
    
    when (!all_power_suppies_on(pVar)) {
      PVPUT(output_psu_x_on_sp, PSU_STATUS_ON);
      PVPUT(output_psu_y_on_sp, PSU_STATUS_ON);
      PVPUT(output_psu_z_on_sp, PSU_STATUS_ON);
    } state wait_for_outputs_on
  }
  
  state wait_for_outputs_on {
    entry {
      ZF_TRANSITION_TO_STATE("wait_for_outputs_on");
    }
    
    when (all_power_suppies_on(pVar)) {
      /* outputs have now turned on */
      errlogSevPrintf(errlogInfo, "%s: Power supply outputs switched on successfully.\n", PROGRAM_NAME);
    } state write_to_psu
    
    when (delay(read_timeout)) {
      errlogSevPrintf(errlogMajor, "%s: Cannot turn power supplies on.\n", PROGRAM_NAME);
      PVPUTSTR(status, ZF_STAT_PSU_WRITE_FAILED);   
    } state trigger_mag_read
  }
  
  state write_to_psu {
    entry {
      ZF_TRANSITION_TO_STATE("write_to_psu");
    }
    
    when() {
      double new_x = output_psu_x_sp_rbv + ((setpoint_x - magnetometer_x) * amps_per_mg_x * feedback);
      double new_y = output_psu_y_sp_rbv + ((setpoint_y - magnetometer_y) * amps_per_mg_y * feedback);
      double new_z = output_psu_z_sp_rbv + ((setpoint_z - magnetometer_z) * amps_per_mg_z * feedback);
      
      double coerced_x = coerce_to_range(new_x, output_psu_x_sp_drvl, output_psu_x_sp_drvh);
      double coerced_y = coerce_to_range(new_y, output_psu_y_sp_drvl, output_psu_y_sp_drvh);
      double coerced_z = coerce_to_range(new_z, output_psu_z_sp_drvl, output_psu_z_sp_drvh);
      
      int x_on_limit = (new_x != coerced_x);
      int y_on_limit = (new_y != coerced_y);
      int z_on_limit = (new_z != coerced_z);
      
      if (x_on_limit || y_on_limit || z_on_limit) {
        errlogSevPrintf(errlogMajor, "%s: power supply outputs on limits. Attempted to set (X=%f, Y=%f, Z=%f) but instead set (X=%f, Y=%f, Z=%f)\n", 
          PROGRAM_NAME, new_x, new_y, new_z, coerced_x, coerced_y, coerced_z);
          
        /* error set in check_psu_writes based on this flag */
        _output_on_limit = 1;
      } else {
        _output_on_limit = 0;
      }
      
      if (debug) {
        errlogSevPrintf(errlogInfo, "%s: Writing to power supplies X=%f, Y=%f, Z=%f", PROGRAM_NAME, coerced_x, coerced_y, coerced_z); 
      }
      PVPUT(output_psu_x_sp, coerced_x);
      PVPUT(output_psu_y_sp, coerced_y);
      PVPUT(output_psu_z_sp, coerced_z);
      
    } state check_psu_writes
  }
  
  state check_psu_writes {
      entry {
        ZF_TRANSITION_TO_STATE("check_psu_writes"); 
      }
      
      when(
        is_within_tolerance(output_psu_x_sp, output_psu_x_sp_rbv, output_psu_tolerance) &&
        is_within_tolerance(output_psu_y_sp, output_psu_y_sp_rbv, output_psu_tolerance) &&
        is_within_tolerance(output_psu_z_sp, output_psu_z_sp_rbv, output_psu_tolerance)
      ) {
                
        if (_output_on_limit) {
          PVPUTSTR(status, ZF_STAT_PSU_ON_LIMITS);
        } else {
          /* If we get to this state, there has been no error */
          PVPUTSTR(status, ZF_STAT_NO_ERROR);   
        }
        
        if (debug) {
          errlogSevPrintf(errlogInfo, "%s: power supply writes successful\n", PROGRAM_NAME);
        }
      } state loop_delay
      
      when(delay(read_timeout)) {
        PVPUTSTR(status, ZF_STAT_PSU_WRITE_FAILED);
        errlogSevPrintf(errlogMajor, "%s: Power supply writes failed to get within tolerance. Setpoints = (X=%f, Y=%f, Z=%f), setpoint readbacks = (X=%f, Y=%f, Z=%f). Tolerance=%f\n", 
          PROGRAM_NAME, output_psu_x_sp, output_psu_y_sp, output_psu_z_sp, output_psu_x_sp_rbv, output_psu_y_sp_rbv, output_psu_z_sp_rbv, output_psu_tolerance); 
          
        /* don't go to loop_delay in this case as we have already waited 5 seconds */
      } state trigger_mag_read
  }
  
  state loop_delay {
    entry {
      ZF_TRANSITION_TO_STATE("loop_delay");
    }
    
    when(delay(loop_delay/1000.0)) { } state trigger_mag_read
  }
}


%{
  /**
   * Called on any state transitions that occur in the state machine - primarily for debugging.
   */
  static void zf_state_transition(SS_ID ssId, struct seqg_vars* const pVar, CH_ID index, const char* const new_state_name)
  {
    strncpy(pVar->statemachine_state, new_state_name, MAX_STRING_SIZE);
	seq_pvPut(ssId, index, SYNC);
    if (pVar->debug) {
	  errlogSevPrintf(errlogInfo, "%s: Entering state %s\n", PROGRAM_NAME, new_state_name);
    }
  }
  
  /**
   * Return 1 if any of the power supply readbacks or setpoint readbacks are invalid - else return 0.
   */
  static int power_supplies_invalid(struct seqg_vars* const pVar) {
    return pVar->output_psu_x_sevr == INVALID_ALARM 
        || pVar->output_psu_y_sevr == INVALID_ALARM 
        || pVar->output_psu_z_sevr == INVALID_ALARM 
        || pVar->output_psu_x_on_sevr == INVALID_ALARM 
        || pVar->output_psu_x_on_sevr == INVALID_ALARM 
        || pVar->output_psu_x_on_sevr == INVALID_ALARM 
        || pVar->output_psu_x_mode_sevr == INVALID_ALARM 
        || pVar->output_psu_y_mode_sevr == INVALID_ALARM 
        || pVar->output_psu_z_mode_sevr == INVALID_ALARM
        || pVar->output_psu_x_sp_rbv_sevr == INVALID_ALARM 
        || pVar->output_psu_y_sp_rbv_sevr == INVALID_ALARM 
        || pVar->output_psu_z_sp_rbv_sevr == INVALID_ALARM;
  }
  
  /**
   * Return 1 if any of the magnetometer readbacks are invalid - else return 0.
   */
  static int magnetometer_invalid(struct seqg_vars* const pVar) {
    return pVar->magnetometer_x_sevr == INVALID_ALARM 
        || pVar->magnetometer_y_sevr == INVALID_ALARM 
        || pVar->magnetometer_z_sevr == INVALID_ALARM;
  }
  
  /**
   * Returns 1 if the first two arguments are within tolerance of each other, else 0.
   */
  static int is_within_tolerance(double setpoint, double readback, double tolerance) {
    return fabs(setpoint - readback) <= tolerance;
  }
  
  /**
   * Coerces a floating point number to be within given low and high limits.
   */
  static double coerce_to_range(double value, double low_limit, double high_limit) {
    if (high_limit < low_limit) {
      errlogSevPrintf(errlogMajor, "%s: coerce_to_range called with high < low. Returning value anyway.", PROGRAM_NAME);
      return value;
    }
    
    if (value > high_limit) {
        return high_limit;
    } else if (value < low_limit) {
        return low_limit;
    } else {
        return value;
    }
  }
  
  static int all_power_suppies_on(struct seqg_vars* const pVar) {
      return pVar->output_psu_x_on == PSU_STATUS_ON
          && pVar->output_psu_y_on == PSU_STATUS_ON
          && pVar->output_psu_z_on == PSU_STATUS_ON;
  }
  
  static int all_power_suppies_in_current_mode(struct seqg_vars* const pVar) {
      return pVar->output_psu_x_mode == PSU_MODE_CURRENT
          && pVar->output_psu_y_mode == PSU_MODE_CURRENT
          && pVar->output_psu_z_mode == PSU_MODE_CURRENT;
  }
}%
