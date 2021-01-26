program hifimagsys("PVONE,XTARGET,XSET,P")

#include "seqPVmacros.h"
%% #include "errlog.h"

/* Turn on run-time debug messages */
option +d;

/* Make code reentrant. This is needed to run more than one instance of this program. */
option +r;

/* Constants */

/* Variables */

/* Environment Variables */

/* PVs */
PV(int, pvone, "{PVONE}", Monitor);


/* STATE SETS */

/* Magnets Off - Ramp all magnets to 0 */
ss off {
  state waiting {
    when (pvone == 1) {
      PVPUT(pvone, 0);
      puts ("Magnet Off requested");
    } state waiting
  }
}
