program inhibitor("MOTPV=xxx,MODE,AXIS")

#include "seqPVmacros.h"

/* Turn on run-time debug messages */
option +d;

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
    when (2==1)
    {
    } state init
	
  }
}
