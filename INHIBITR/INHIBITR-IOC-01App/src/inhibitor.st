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
  void print_status_of_motors()
  {
    printf("Detectors %d, motors %d.\n", motor1_state, motor2_state);
  } 
}%


ss inhibitor
{

  state unknown
  {
    when(motor1_state == 0 && motor2_state == 0)
	{	  
	  print_status_of_motors();
	} state det_off_motors_stationary
	
	when(motor1_state == 0 && motor2_state != 0)
	{
	  print_status_of_motors();
	} state det_off_motors_moving
	
	when(motor1_state != 0 && motor2_state == 0)
	{
	  print_status_of_motors();
	} state det_on_motors_stationary
	
	when(motor1_state != 0 && motor2_state != 0)
	{
	  print_status_of_motors();
	} state det_on_motors_moving
  }
  
  state det_off_motors_stationary
  {
    when(motor1_state != 0)
	{
	  print_status_of_motors();
	  motor2_disable = 1;
	  pvPut(motor2_disable);
	} state det_on_motors_stationary
	
	when(motor2_state != 0)
	{
	  motor1_disable = 1;
	  pvPut(motor1_disable);
	  print_status_of_motors();
	} state det_off_motors_moving
  }
  
  state det_on_motors_stationary
  {
	when(motor1_state == 0)
	{
	  motor2_disable = 0;
	  pvPut(motor2_disable);
	  print_status_of_motors();
	} state det_off_motors_stationary
	
	when(motor2_state != 0)
	{
	  print_status_of_motors();
	} state det_on_motors_moving
  }
  
  state det_off_motors_moving
  {
    when(motor1_state != 0)
	{
	  print_status_of_motors();
	} state det_on_motors_moving
	
	when(motor2_state == 0)
	{
	  motor1_disable = 0;
	  pvPut(motor1_disable);
	  print_status_of_motors();
	} state det_off_motors_stationary
  }
  
  state det_on_motors_moving
  {
    when(motor1_state == 0)
	{
	  motor2_disable = 0;
	  pvPut(motor2_disable);
	  print_status_of_motors();
	} state det_off_motors_moving
	
	when(motor2_state == 0)
	{
	  motor1_disable = 0;
	  pvPut(motor1_disable);
	  print_status_of_motors();
	} state det_on_motors_stationary
  }
}
