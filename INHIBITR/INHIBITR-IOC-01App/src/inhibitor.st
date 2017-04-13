program inhibitor

#include "seqPVmacros.h"

int cba;
assign cba to "TE:NDW1298:MOT:MTR0201";

/* Turn on run-time debug messages */
option +d;

/* PV definitions */
PV(int, abc, "TE:NDW1298:MOT:MTR0201", Monitor);

ss inhibitor
{
  state init
  {
	when ()
	{
	  printf("Sequencer starting");
	} state ready
  }

  state ready
  {	
    when (abc == 2)
    {
	  printf("hi");
	  cba = 0;
	  pvPut(cba);
    } state init
	
  }
}
