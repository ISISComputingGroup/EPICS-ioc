program inhibitor("PVONE,PVTWO,PVONE_DISP,PVTWO_DISP")

#include "seqPVmacros.h"

int pvone_disp, pvtwo_disp;

assign pvone_disp to "{PVONE_DISP}"; /* Index = 0 */
assign pvtwo_disp to "{PVTWO_DISP}"; /* Index = 1 */

/* Turn on run-time debug messages */
option +d;

/* PV definitions */
PV(int, pvone, "{PVONE}", Monitor);
PV(int, pvtwo, "{PVTWO}", Monitor);



foreign ssId;

ss inhibitor
{

  /* Initial state. Find the current state and move into it. */
  state unknown
  {
    when(pvone == 0 && pvtwo == 0)
	{	  
	  printf("boop!")
	} state pv_one_off_pv_two_off
	
	when(pvone == 0 && pvtwo != 0)
	{
	  printf("boop!")
	} state pv_one_off_pv_two_on
	
	when(pvone != 0 && pvtwo == 0)
	{
	  printf("boop!")
	} state pv_one_on_pv_two_off
	
	when(pvone != 0 && pvtwo != 0)
	{
	  printf("boop!")
	} state 
  }
  
  state pv_one_off_pv_two_off
  {
    when(pvone != 0)
	{
	  printf("boop!")
	} state pv_one_on_pv_two_off
	
	when(pvtwo != 0)
	{
	  printf("boop!")
	} state pv_one_off_pv_two_on
  }
  
  state pv_one_on_pv_two_off
  {
	when(pvone == 0)
	{
	  printf("boop!")
	} state pv_one_off_pv_two_off
	
	when(pvtwo != 0)
	{
	  /* This transition should not happen, pvtwo should have been disabled */
	  printf("boop!")
	} state pv_one_on_pv_two_on
  }
  
  state pv_one_off_pv_two_on
  {
    when(pvone != 0)
	{
	  /* This transition should not happen, pvone should have been disabled */
	  invalid_transition(ssId);
	} state pv_one_on_pv_two_on
	
	when(pvtwo == 0)
	{
	  set_pv_disabled(ssId, 0, 0);
	} state pv_one_off_pv_two_off
  }
  
  state pv_one_on_pv_two_on
  {
    /* 
	 * This state should only ever occur on startup. 
	 * It is assumed that if the inhibitor is started in this state then the instrument scientists know what they are doing.
	 * Therefore we dont need to do anything special in this state - just go back to one of the "normal" states when either PV goes back to zero.
	 */
    when(pvone == 0)
	{
	  set_pv_disabled(ssId, 0, 1);
	  set_pv_disabled(ssId, 1, 0);
	} state pv_one_off_pv_two_on
	
	when(pvtwo == 0)
	{
	  set_pv_disabled(ssId, 0, 0);
	  set_pv_disabled(ssId, 1, 1);
	} state pv_one_on_pv_two_off
  }
}
