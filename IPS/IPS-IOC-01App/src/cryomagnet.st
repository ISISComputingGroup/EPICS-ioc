program cryomagnet("FIELD,FIELD_SETPOINT,FIELD_SETPOINT_ALARM,FIELD_SETPOINT_RAW,FIELD_SETPOINT_READBACK,PERSISTENT,MAGNET_FIELD,HEATER_STATUS,HEATER_STATUS_SP,HEATER_WAIT_TIME,ACTIVITY,ACTIVITY_SP,SWEEPMODE,SWEEPMODE_SP,SUPPLYVOLTAGE_STABLE,SWEEP_ACTIVE,STATEMACHINE")

#include "ibexSeqPVmacros.h"
%% #include <math.h>

/* Turn on run-time debug messages */
option +d;

/* Make code reentrant. This is needed to run more than one instance of this program. */
option +r;

/* Field */
PV(double, field_setpoint, "{FIELD_SETPOINT}", Monitor);
PV(int, field_setpoint_alarm, "{FIELD_SETPOINT_ALARM}", Monitor);
PV(double, field_setpoint_readback, "{FIELD_SETPOINT_READBACK}", Monitor);
PV(double, field_setpoint_raw, "{FIELD_SETPOINT_RAW}", Monitor);

PV(double, psu_field, "{FIELD}", Monitor);
PV(double, magnet_field, "{MAGNET_FIELD}", Monitor);

PV(int, persistent, "{PERSISTENT}", Monitor);

PV(int, heater, "{HEATER_STATUS}", Monitor);
PV(int, heater_sp, "{HEATER_STATUS_SP}", Monitor);

PV(int, activity, "{ACTIVITY}", Monitor);
PV(int, activity_sp, "{ACTIVITY_SP}", Monitor);

PV(int, sweepmode, "{SWEEPMODE}", Monitor);
PV(int, sweepmode_sp, "{SWEEPMODE_SP}", Monitor);

PV(double, heater_delay_time, "{HEATER_WAIT_TIME}", Monitor);

PV(int, supplyvoltage_stable, "{SUPPLYVOLTAGE_STABLE}", Monitor);

PV(int, sweep_active, "{SWEEP_ACTIVE}", Monitor);

PV(int, statemachine_pv, "{STATEMACHINE}", NoMon);

/* If fields are the same within this tolerance, treat as the same */
double field_tolerance = 0.0001;

int ACTIVITY_HOLD = 0;
int ACTIVITY_TO_SP = 1;
int ACTIVITY_TO_ZERO = 2;

/* The device varies which one it sends back but they both mean the same... */
int SWEEP_MODE = 3;
int SWEEP_MODE_ALT = 1;

%{
void print_transition(char* old, char* new) {
    printf("cryomagnet.st: Moving from state %s to %s.\n", old, new);
}

int within_tolerance(double a, double b, double tolerance) {
    return fabs(a - b) < tolerance;
}
}%

/*
 *
 * Documentation and further information about this state machine is available at https://github.com/ISISComputingGroup/ibex_developers_manual/wiki/OxfordInstrumentsIPS
 *
 */
ss cryomagnet
{

  state initial
  {
    entry {
      PVPUT(statemachine_pv, 0);
      epicsThreadSleep(1.0);
    }
  
    /* Dont do anything at all until the field setpoint is set to something & UDF_ALARM goes away. */
    when(field_setpoint_alarm == 0) {
      print_transition("initial", "at_field");
    } state at_field
  }

  state at_field
  {
  
    entry {
      PVPUT(statemachine_pv, 1);
      epicsThreadSleep(1.0);
    }
    
    when(
      !within_tolerance(field_setpoint, field_setpoint_readback, field_tolerance)
      && field_setpoint_alarm == 0
      )
    {
      print_transition("at_field", "set_psu_to_match_magnet");
    } state set_psu_to_match_magnet
  }
  
  state set_psu_to_match_magnet
  {
  
    /* Execute entry and exit blocks even if the next state is the same as the current state */
    option -e;
    option -x;
  
    entry
    {
      PVPUT(statemachine_pv, 2);
      epicsThreadSleep(1.0);
      printf("Setting raw field setpoint to %f\n", magnet_field);
      PVPUT(field_setpoint_raw, magnet_field);
      epicsThreadSleep(1.0);
      PVPUT(activity_sp, ACTIVITY_TO_SP);
      epicsThreadSleep(1.0);
      PVPUT(sweepmode_sp, SWEEP_MODE);
    } 

    when(
      within_tolerance(field_setpoint_readback, magnet_field, field_tolerance) 
      && within_tolerance(psu_field, magnet_field, field_tolerance) 
      && ((sweepmode == SWEEP_MODE) || (sweepmode == SWEEP_MODE_ALT))
      && (sweep_active == 0)
      )
    {
      print_transition("set_psu_to_match_magnet", "wait_for_voltage_to_stabilise");
    } state wait_for_voltage_to_stabilise
    
    /* If not succeeded, re-enter state which will resend all appropriate commands */
    when(delay(300)){
      print_transition("set_psu_to_match_magnet", "set_psu_to_match_magnet");
    } state set_psu_to_match_magnet
  }
  
  state wait_for_voltage_to_stabilise
  {

    /* Execute entry and exit blocks even if the next state is the same as the current state */
    option -e;
    option -x;
    
    entry {
      PVPUT(statemachine_pv, 3);
      epicsThreadSleep(1.0);
    }
  
    when(supplyvoltage_stable == 1) {
      print_transition("wait_for_voltage_to_stabilise", "turn_switch_heater_on_and_wait");
    } state turn_switch_heater_on_and_wait
    
    /* If the PSU current drifts outside of tolerance for some reason, go back to previous step */
    when(!within_tolerance(field_setpoint_readback, field_setpoint_raw, field_tolerance)) {
      print_transition("wait_for_voltage_to_stabilise", "set_psu_to_match_magnet");
    } state set_psu_to_match_magnet
    
    /* If not stable, re-set psu to magnet current (i.e. try again from state above) */
    when (delay(300)){
      print_transition("wait_for_voltage_to_stabilise", "set_psu_to_match_magnet");
    } state set_psu_to_match_magnet
  }
  
  state turn_switch_heater_on_and_wait
  {
  
    /* Execute entry and exit blocks even if the next state is the same as the current state */
    option -e;
    option -x;
  
    entry
    {
      PVPUT(statemachine_pv, 4);
      epicsThreadSleep(1.0);
      PVPUT(activity_sp, ACTIVITY_HOLD);
      epicsThreadSleep(1.0);
      PVPUT(heater_sp, 1);
    }

    when(activity == ACTIVITY_HOLD && heater == 1)
    {
      epicsThreadSleep(heater_delay_time);
      print_transition("turn_switch_heater_on_and_wait", "set_psu_output");
    } state set_psu_output
    
    /* If heater is not switched on within timeout, retry sending commands */
    when(delay(30)){
      print_transition("turn_switch_heater_on_and_wait", "turn_switch_heater_on_and_wait");
    } state turn_switch_heater_on_and_wait
  }
  
  state set_psu_output
  {
  
    /* Execute entry and exit blocks even if the next state is the same as the current state */
    option -e;
    option -x;
  
    entry
    {
      PVPUT(statemachine_pv, 5);
      epicsThreadSleep(1.0);
      printf("Setting raw field setpoint to %f\n", field_setpoint);
      PVPUT(field_setpoint_raw, field_setpoint);
      epicsThreadSleep(1.0);
      PVPUT(activity_sp, ACTIVITY_TO_SP);
    }

    /* Set to persistent mode */
    when(
      within_tolerance(field_setpoint_readback, field_setpoint, field_tolerance) 
      && within_tolerance(field_setpoint, psu_field, field_tolerance) 
      && persistent == 1 
      && (sweep_active == 0)
      )
    {
      print_transition("set_psu_output", "switch_off_heater");
    } state switch_off_heater
    
    /* If not setting to persistent mode, skip ramping down the PSU and setting switch heater to OFF */
    when(
      within_tolerance(field_setpoint_readback, field_setpoint, field_tolerance) 
      && within_tolerance(field_setpoint, psu_field, field_tolerance) 
      && persistent == 0 
      && (sweep_active == 0)
      )
    {
      print_transition("set_psu_output", "at_field");
    } state at_field
    
    /* If not succeeded, try resending setpoint */
    when(delay(300)){
      print_transition("set_psu_output", "set_psu_output");
    } state set_psu_output
    
  }
  
  state switch_off_heater
  {
  
    /* Execute entry and exit blocks even if the next state is the same as the current state */
    option -e;
    option -x;
  
    entry
    {
      PVPUT(statemachine_pv, 6);
      epicsThreadSleep(1.0);
      PVPUT(heater_sp, 0);
    }

    when(heater == 0 || heater == 2)
    {
      epicsThreadSleep(heater_delay_time);
      print_transition("switch_off_heater", "ramp_down_psu");
    } state ramp_down_psu
    
    /* If not succeeded, try resending setpoint */
    when(delay(30)){
      print_transition("switch_off_heater", "switch_off_heater");
    } state switch_off_heater
  }
  
  state ramp_down_psu
  {
  
    /* Execute entry and exit blocks even if the next state is the same as the current state */
    option -e;
    option -x;
  
    entry
    {
      PVPUT(statemachine_pv, 7);
      epicsThreadSleep(1.0);
      PVPUT(activity_sp, ACTIVITY_TO_ZERO);
    }

    when(
      within_tolerance(psu_field, 0, field_tolerance)
      && (sweep_active == 0)
      )
    {
      print_transition("ramp_down_psu", "at_field");
    } state at_field
    
    when(delay(300)){
      print_transition("ramp_down_psu", "ramp_down_psu");
    } state ramp_down_psu
  }
}
