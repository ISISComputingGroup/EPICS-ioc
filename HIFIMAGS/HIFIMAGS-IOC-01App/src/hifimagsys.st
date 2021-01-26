program hifimagsys("PVONE")

#include "seqPVmacros.h"
%% #include "errlog.h"

/* Turn on run-time debug messages */
option +d;

/* Make code reentrant. This is needed to run more than one instance of this program. */
option +r;

/* Constants */

/* Variables */

/* Environment Variables */
char *prefix;

/* PVs */
int all_off;
assign all_off to "${P}MAGNETS:OFF:SP";
monitor all_off;
PV(int, pvone, "{PVONE}", Monitor)

/* STATE SETS */

/* Magnets Off - Ramp all magnets to 0 */
ss off {
  state waiting {
    when (all_off == 1 || pvone == 1) {
      printf ("Magnet Off requested")
    }
  }
}
