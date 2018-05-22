program cryomagnet("FIELD,FIELD_SETPOINT,FIELD_SETPOINT_RAW,FIELD_SETPOINT_READBACK,PERSISTENT,MAGNET_FIELD,HEATER_STATUS,HEATER_STATUS_SP,HEATER_WAIT_TIME,ACTIVITY,ACTIVITY_SP")

#include "seqPVmacros.h"

/* Turn on run-time debug messages */
option +d;

/* Make code reentrant. This is needed to run more than one instance of this program. */
option +r;

/* Field */
PV(double, field_setpoint, "{FIELD_SETPOINT}", Monitor);
PV(int, field_setpoint_alarm, "{FIELD_SETPOINT}.SEVR", Monitor);
PV(double, field_setpoint_readback, "{FIELD_SETPOINT_READBACK}", Monitor);
PV(double, field_setpoint_raw, "{FIELD_SETPOINT_RAW}", NoMon);
PV(double, psu_field, "{FIELD}", Monitor);
PV(int, psu_field_alarm, "{FIELD}.SEVR", Monitor);

PV(double, magnet_field, "{MAGNET_FIELD}", Monitor);
PV(int, magnet_field_alarm, "{MAGNET_FIELD}.SEVR", Monitor);

PV(int, persistent, "{PERSISTENT}", Monitor);
PV(int, persistent_alarm, "{PERSISTENT}.SEVR", Monitor);

PV(int, heater, "{HEATER_STATUS}", Monitor);
PV(int, heater_alarm, "{HEATER_STATUS}.SEVR", Monitor);
PV(int, heater_sp, "{HEATER_STATUS_SP}", NoMon);

PV(int, activity, "{ACTIVITY}", Monitor);
PV(int, activity_sp, "{ACTIVITY_SP}", NoMon);

PV(double, heater_delay_time, "{HEATER_WAIT_TIME}", Monitor);

/* If fields are the same within this tolerance, treat as the same */
double field_tolerance = 0.0001;

int ACTIVITY_TO_SP = 1;
int ACTIVITY_TO_ZERO = 2;

%{
void print_transition(char* old, char* new) {
    printf("cryomagnet.st: Moving from state %s to %s.\n", old, new);
}

int within_tolerance(float a, float b, float tolerance) {
    return fabs(a - b) < tolerance;
}
}%

ss cryomagnet
{
  /* Initial state. */
  state initial
  {
    when(psu_field_alarm == 0 && magnet_field_alarm == 0) 
    {
      print_transition("initial", "at_field");
    } state at_field    
  }
  
  state at_field
  {
    when(!within_tolerance(field_setpoint, field_setpoint_readback, field_tolerance))
    {
      printf("moving from at field: %f %f %f\n", field_setpoint, field_setpoint_readback, field_tolerance);
      print_transition("at_field", "set_psu_to_match_magnet");
    } state set_psu_to_match_magnet
  }
  
  state set_psu_to_match_magnet
  {
    entry
    {
      printf("Setting raw field setpoint to %f\n", magnet_field);
      PVPUT(field_setpoint_raw, magnet_field);
      PVPUT(activity_sp, ACTIVITY_TO_SP);
    } 

    when(within_tolerance(field_setpoint_readback, field_setpoint_raw, field_tolerance) && within_tolerance(psu_field, magnet_field, field_tolerance) && activity == ACTIVITY_TO_SP)
    {
      print_transition("set_psu_to_match_magnet", "turn_switch_heater_on_and_wait");
    } state turn_switch_heater_on_and_wait
  }
  
  state turn_switch_heater_on_and_wait
  {
    entry
    {
      PVPUT(heater_sp, 1);
    }

    when(heater == 1 && heater_alarm == 0)
    {
      epicsThreadSleep(heater_delay_time);
      print_transition("turn_switch_heater_on_and_wait", "set_psu_output");
    } state set_psu_output
  }
  
  state set_psu_output
  {
    entry
    {
      printf("Setting raw field setpoint to %f\n", field_setpoint);
      PVPUT(field_setpoint_raw, field_setpoint);
      PVPUT(activity_sp, ACTIVITY_TO_SP);
    }

    /* Set to persistent mode */
    when(within_tolerance(field_setpoint_readback, field_setpoint, field_tolerance) && within_tolerance(field_setpoint, psu_field, field_tolerance) && persistent == 1 && activity == ACTIVITY_TO_SP)
    {
      print_transition("set_psu_output", "switch_off_heater");
    } state switch_off_heater
    
    /* If not setting to persistent mode, skip ramping down the PSU and setting switch heater to OFF */
    when(within_tolerance(field_setpoint_readback, field_setpoint, field_tolerance) && within_tolerance(field_setpoint, psu_field, field_tolerance) && persistent == 0 && activity == ACTIVITY_TO_SP)
    {
      print_transition("set_psu_output", "at_field");
    } state at_field
    
  }
  
  state switch_off_heater
  {
    entry
    {
      PVPUT(heater_sp, 0);
    }

    when(heater == 0 && heater_alarm == 0)
    {
      epicsThreadSleep(heater_delay_time);
      print_transition("switch_off_heater", "ramp_down_psu");
    } state ramp_down_psu
  }
  
  state ramp_down_psu
  {
    entry
    {
      PVPUT(activity_sp, ACTIVITY_TO_ZERO);
    }

    when(fabs(psu_field) < field_tolerance && activity == ACTIVITY_TO_ZERO)
    {
      print_transition("wait_for_psu_to_be_at_zero", "at_field");
    } state at_field
  }
}
