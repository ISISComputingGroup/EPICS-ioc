program inhibitor

#include "seqPVmacros.h"

int motor1, motor2;
assign motor1 to "TE:NDW1298:MOT:MTR0201";
assign motor2 to "TE:NDW1298:MOT:MTR0202";

/* Turn on run-time debug messages */
option +d;

/* PV definitions */
PV(int, motor1pv, "TE:NDW1298:MOT:MTR0201", Monitor);
PV(int, motor2pv, "TE:NDW1298:MOT:MTR0202", Monitor);

ss inhibitor
{
  state init
  {
	when ()
	{
	  printf("Sequencer started successfully.\n");
	} state unknown
  }

  state unknown
  {
    when(motor1pv == 0 && motor2pv == 0)
	{	  
	  printf("Detectors off, motors stationary.\n");
	} state det_off_motors_stationary
	
	when(motor1pv == 0 && motor2pv != 0)
	{
	  printf("Detectors off, motors moving.\n");
	} state det_off_motors_moving
	
	when(motor1pv != 0 && motor2pv == 0)
	{
	  printf("Detectors on, motors stationary.\n");
	} state det_on_motors_stationary
	
	when(motor1pv != 0 && motor2pv != 0)
	{
	  printf("Detectors on, motors moving.\n");
	} state det_on_motors_moving
  }
  
  state det_off_motors_stationary
  {
    when(motor1pv != 0)
	{
	  printf("Detectors on, motors stationary.\n");
	} state det_on_motors_stationary
	
	when(motor2pv != 0)
	{
	  printf("Detectors off, motors moving.\n");
	} state det_off_motors_moving
  }
  
  state det_on_motors_stationary
  {
	when(motor1pv == 0)
	{
	  printf("Detectors off, motors stationary.\n");
	} state det_off_motors_stationary
	
	when(motor2pv != 0)
	{
	  printf("Detectors on, motors moving.\n");
	} state det_on_motors_moving
  }
  
  state det_off_motors_moving
  {
    when()
	{
	} state unknown
  }
  
  state det_on_motors_moving
  {
    when()
	{
	} state unknown
  }
}
