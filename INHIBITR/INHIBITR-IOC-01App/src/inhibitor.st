program inhibitor

#include "seqPVmacros.h"

int motor1_disable, motor2_disable;
assign motor1_disable to "TE:NDW1298:MOT:MTR0407.DISP";
assign motor2_disable to "TE:NDW1298:MOT:MTR0408.DISP";

/* Turn on run-time debug messages */
option +d;

/* PV definitions */
PV(int, motor1_state, "TE:NDW1298:MOT:MTR0407", Monitor);
PV(int, motor2_state, "TE:NDW1298:MOT:MTR0408", Monitor);

%{
  void print_status()
  {
    printf("Detectors %d, motors %d.\n", motor1_state, motor2_state);
  } 
  
  void print_invalid_transition_warning()
  {
    printf("WARNING: A transition occured that should not have been possible.");
  }
}%


ss inhibitor
{

  /* Initial state. Find the current state and move into it. */
  state unknown
  {
    when(motor1_state == 0 && motor2_state == 0)
	{	  
	  print_status();
	} state det_off_motors_stationary
	
	when(motor1_state == 0 && motor2_state != 0)
	{
	  print_status();
	} state det_off_motors_moving
	
	when(motor1_state != 0 && motor2_state == 0)
	{
	  print_status();
	} state det_on_motors_stationary
	
	when(motor1_state != 0 && motor2_state != 0)
	{
	  print_status();
	} state det_on_motors_moving
  }
  
  state det_off_motors_stationary
  {
    when(motor1_state != 0)
	{
	  print_status();
	  motor2_disable = 1;
	  pvPut(motor2_disable);
	} state det_on_motors_stationary
	
	when(motor2_state != 0)
	{
	  motor1_disable = 1;
	  pvPut(motor1_disable);
	  print_status();
	} state det_off_motors_moving
  }
  
  state det_on_motors_stationary
  {
	when(motor1_state == 0)
	{
	  motor2_disable = 0;
	  pvPut(motor2_disable);
	  print_status();
	} state det_off_motors_stationary
	
	when(motor2_state != 0)
	{
	  /* This transition should not happen, motor2 should have been disabled */
	  print_status();
	  print_invalid_transition_warning();
	} state det_on_motors_moving
  }
  
  state det_off_motors_moving
  {
    when(motor1_state != 0)
	{
	  /* This transition should not happen, motor1 should have been disabled */
	  print_status();
	  print_invalid_transition_warning();
	} state det_on_motors_moving
	
	when(motor2_state == 0)
	{
	  motor1_disable = 0;
	  pvPut(motor1_disable);
	  print_status();
	} state det_off_motors_stationary
  }
  
  state det_on_motors_moving
  {
    /* 
	 * This state should only ever occur on startup. 
	 * It is assumed that if the inhibitor is started in this state then the instrument scientists know what they are doing.
	 * Therefore we dont need to do anything special in this state - just go back to one of the "normal" states when either the detectors or the motors stop.
	 */
    when(motor1_state == 0)
	{
	  motor2_disable = 0;
	  pvPut(motor2_disable);
	  print_status();
	} state det_off_motors_moving
	
	when(motor2_state == 0)
	{
	  motor1_disable = 0;
	  pvPut(motor1_disable);
	  print_status();
	} state det_on_motors_stationary
  }
}
