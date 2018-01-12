program riken_port_changeover("OK_TO_RUN_PSUS,ALLOW_PORT_CHANGEOVER,PSU_DISABLE,PSU_POWER")

#include "seqPVmacros.h"

/* Turn on run-time debug messages */
option +d;

/* PV definitions */
PV(int, allow_port_changeover, "{ALLOW_PORT_CHANGEOVER}", NoMon);
PV(int, ok_to_run_psus, "{OK_TO_RUN_PSUS}", Monitor);
PV(int, psu_disable, "{PSU_DISABLE}", NoMon);
PV(int, psu_power, "{PSU_POWER}", Monitor);

ss riken_port_changeover
{
  /* Initial state. */
  state ready
  {
    when(ok_to_run_psus == 0)
	{
	  puts("Changeover sequence initiated");
	} state check_psus_off
  }
  
  state check_psus_off
  {
    when(psu_power == 0)
	{
	  puts("Disabling PSUs");
	  PVPUT(psu_disable, 1);
	  PVPUT(allow_port_changeover, 1);
	} state changing_over
	
	when(ok_to_run_psus == 1)
	{
	  puts("Changeover sequence cancelled by PLC before all PSUs were switched off.");
	} state ready
  }
  
  state changing_over
  {
    when(ok_to_run_psus == 1)
	{
	  PVPUT(psu_disable, 0);
	  PVPUT(allow_port_changeover, 0);
	  puts("Enabling PSUs");
	} state ready
  }
}
