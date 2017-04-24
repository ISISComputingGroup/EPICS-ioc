program inhibitor("PVONE,PVTWO,PVONE_DISP,PVTWO_DISP")

#include "seqPVmacros.h"

int motor1_disp, motor2_disp;

assign motor1_disp to "{PVONE_DISP}"; /* Index = 0 */
assign motor2_disp to "{PVTWO_DISP}"; /* Index = 1 */

/* Turn on run-time debug messages */
option +d;

/* PV definitions */
PV(int, motor1_state, "{PVONE}", Monitor);
PV(int, motor2_state, "{PVTWO}", Monitor);

%{

  /*
   * Prints the current values of the two PVs this inhibitor is looking at.
   */
  static void print_status()
  {
    printf("Detectors %d, motors %d.\n", motor1_state, motor2_state);
  } 
  
  /*
   * Enables or disables puts to the PV by setting its DISP field.
   *
   * This could happen in theory if both values get pvPuts before the inhibitor 
   * manages to set the .DISP field
   *
   * In this case we just print a warning and ensure both motors get enabled so that * users can always get out of this state.
   *
   * Args: ssId - The ID of the calling state set.
   *       index - The zero-based index of the motor to change (this is defined by the order of the 'assign' statements above)
   *       disabled - 1 if the motor should be disabled, 0 if the motor should be enabled.
   */
  static void set_motor_disabled(SS_ID ssId, int index, int disabled)
  {
    print_status();
	
    if (index == 0)
	{
	  motor1_disp = disabled;
	}
	else if(index == 1)
	{
	  motor2_disp = disabled;
	}
	else 
	{
	  /* The inhibitor only looks at two PVs. If an index out of range is given, print a warning and do nothing. */
	  puts("Invalid argument for set_motor_enabled: expected 0 or 1");
	  return;
	}
	
	seq_pvPut(ssId, index, SYNC);
	printf("Assigned a value of %i to DISP pv with index %i.\n", disabled, index);
  }
  
  /*
   * This function is called if an invalid transition occurs 
   * (one which should not have been possible). 
   *
   * This could happen in theory if both values get pvPuts before the inhibitor 
   * manages to set the .DISP field
   *
   * In this case we just print a warning and ensure both motors get enabled so that * users can always get out of this state.
   *
   * Args: ssId - The ID of the calling state set.
   */
  static void invalid_transition(SS_ID ssId)
  {
    print_status();
    puts("WARNING: A transition occured that should not have been possible.");
	
	set_motor_disabled(ssId, 0, 0);
	set_motor_disabled(ssId, 1, 0);
  }
  
}%

foreign ssId;

ss inhibitor
{

  /* Initial state. Find the current state and move into it. */
  state unknown
  {
    when(motor1_state == 0 && motor2_state == 0)
	{	  
	  print_status();
	} state pv_one_off_pv_two_off
	
	when(motor1_state == 0 && motor2_state != 0)
	{
	  print_status();
	} state pv_one_off_pv_two_on
	
	when(motor1_state != 0 && motor2_state == 0)
	{
	  print_status();
	} state pv_one_on_pv_two_off
	
	when(motor1_state != 0 && motor2_state != 0)
	{
	  print_status();
	} state pv_one_on_pv_two_on
  }
  
  state pv_one_off_pv_two_off
  {
    when(motor1_state != 0)
	{
	  set_motor_disabled(ssId, 1, 1);
	} state pv_one_on_pv_two_off
	
	when(motor2_state != 0)
	{
	  set_motor_disabled(ssId, 0, 1);
	} state pv_one_off_pv_two_on
  }
  
  state pv_one_on_pv_two_off
  {
	when(motor1_state == 0)
	{
	  set_motor_disabled(ssId, 1, 0);
	} state pv_one_off_pv_two_off
	
	when(motor2_state != 0)
	{
	  /* This transition should not happen, motor2 should have been disabled */
	  invalid_transition(ssId);
	} state pv_one_on_pv_two_on
  }
  
  state pv_one_off_pv_two_on
  {
    when(motor1_state != 0)
	{
	  /* This transition should not happen, motor1 should have been disabled */
	  invalid_transition(ssId);
	} state pv_one_on_pv_two_on
	
	when(motor2_state == 0)
	{
	  set_motor_disabled(ssId, 0, 0);
	} state pv_one_off_pv_two_off
  }
  
  state pv_one_on_pv_two_on
  {
    /* 
	 * This state should only ever occur on startup. 
	 * It is assumed that if the inhibitor is started in this state then the instrument scientists know what they are doing.
	 * Therefore we dont need to do anything special in this state - just go back to one of the "normal" states when either the detectors or the motors stop.
	 */
    when(motor1_state == 0)
	{
	  set_motor_disabled(ssId, 1, 0);
	} state pv_one_off_pv_two_on
	
	when(motor2_state == 0)
	{
	  set_motor_disabled(ssId, 0, 0);
	} state pv_one_on_pv_two_off
  }
}
