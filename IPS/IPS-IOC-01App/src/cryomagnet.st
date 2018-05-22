program cryomagnet("FIELD,FIELD_SETPOINT,FIELD_SETPOINT_RAW,PERSISTENT,MAGNET_FIELD,HEATER_STATUS,HEATER_STATUS_SP,HEATER_WAIT_TIME")

#include "seqPVmacros.h"

/* Turn on run-time debug messages */
option +d;

/* Make code reentrant. This is needed to run more than one instance of this program. */
option +r;

/* Field */
PV(double, field_setpoint, "{FIELD_SETPOINT}", Monitor);
PV(int, field_setpoint_alarm, "{FIELD_SETPOINT}.SEVR", Monitor);
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

PV(double, heater_delay_time, "{HEATER_WAIT_TIME}", Monitor);

/* If fields are the same within this tolerance, treat as the same */
double field_tolerance = 0.0001;

%{
void print_transition(char* old, char* new) {
    printf("cryomagnet.st: Moving from state %s to %s.\n", old, new);
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
    when(fabs(field_setpoint - magnet_field) > field_tolerance)
    {
      print_transition("at_field", "set_psu_to_match_magnet");
    } state set_psu_to_match_magnet
  }
  
  state set_psu_to_match_magnet
  {
    when(1)
    {
      PVPUT(field_setpoint_raw, magnet_field);
      print_transition("set_psu_to_match_magnet", "waiting_for_psu_current_to_match_magnet");
    } state waiting_for_psu_current_to_match_magnet
  }
  
  state waiting_for_psu_current_to_match_magnet
  {
    when(fabs(psu_field - magnet_field) < field_tolerance)
    {
      print_transition("waiting_for_psu_current_to_match_magnet", "turn_switch_heater_on");
    } state turn_switch_heater_on
  }
  
  state turn_switch_heater_on
  {
    when(1)
    {
      PVPUT(heater_sp, 1);
      print_transition("turn_switch_heater_on", "wait_for_heater_to_be_on");
    } state wait_for_heater_to_be_on
  }
  
  state wait_for_heater_to_be_on
  {
    when(heater == 1)
    {
      epicsThreadSleep(heater_delay_time);
      print_transition("wait_for_heater_to_be_on", "set_psu_output");
    } state set_psu_output
  }
  
  state set_psu_output
  {
    when(1)
    {
      PVPUT(field_setpoint_raw, field_setpoint)
      print_transition("set_psu_output", "wait_for_field_to_be_reached");
    } state wait_for_field_to_be_reached
  }
  
  state wait_for_field_to_be_reached
  {
    /* Set to persistent mode */
    when(fabs(field_setpoint - psu_field) < field_tolerance && persistent == 1)
    {
      print_transition("wait_for_field_to_be_reached", "switch_off_heater");
    } state switch_off_heater
    
    /* If not setting to persistent mode, skip ramping down the PSU and setting switch heater to OFF */
    when(fabs(field_setpoint - psu_field) < field_tolerance && persistent == 0)
    {
      print_transition("wait_for_field_to_be_reached", "at_field");
    } state at_field
    
  }
  
  state switch_off_heater
  {
    when(1)
    {
      PVPUT(heater_sp, 0)
      print_transition("switch_off_heater", "wait_for_heater_to_be_off");
    } state wait_for_heater_to_be_off
  }
  
  state wait_for_heater_to_be_off
  {
    when(heater == 0 && heater_alarm == 0)
    {
      epicsThreadSleep(heater_delay_time);
      print_transition("wait_for_heater_to_be_off", "ramp_down_psu");
    } state ramp_down_psu
  }
  
  state ramp_down_psu
  {
    when(1)
    {
      PVPUT(field_setpoint_raw, 0)
      print_transition("ramp_down_psu", "wait_for_psu_to_be_at_zero");
    } state wait_for_psu_to_be_at_zero
  }
  
  state wait_for_psu_to_be_at_zero
  {
    when(psu_field == 0)
    {
      print_transition("wait_for_psu_to_be_at_zero", "at_field");
    } state at_field
  }
}
