program riken_port_changeover("OK_TO_RUN_PSUS,ALLOW_PORT_CHANGEOVER")

#include "seqPVmacros.h"
  
int allow_port_changeover;
assign allow_port_changeover to "{ALLOW_PORT_CHANGEOVER}";

/* Turn on run-time debug messages */
option +d;

/* PV definitions */
PV(int, ok_to_run_psus, "{OK_TO_RUN_PSUS}", Monitor);

ss riken_port_changeover
{
  /* Initial state. */
  state ready
  {
    when(ok_to_run_psus == 0)
	{
	  puts("Disabling PSUs");
	  PVPUT(allow_port_changeover, 1);
	} state changing_over
  }
  
  state changing_over
  {
    when(ok_to_run_psus == 1)
	{
	  PVPUT(allow_port_changeover, 0);
	  puts("Enabling PSUs");
	} state ready
  }
}
