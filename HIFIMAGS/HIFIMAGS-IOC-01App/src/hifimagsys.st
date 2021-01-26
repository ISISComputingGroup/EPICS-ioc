program hifimagsys("P")

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
PV(int, magoff, "{P}MAGNETS:OFF:SP", Monitor);
PV(double, xtarget, "{P}X:TARGET:SP", Monitor);
PV(int, xset, "{P}X:SET:SP", Monitor);
PV(double, ytarget, "{P}Y:TARGET:SP", Monitor);
PV(int, yset, "{P}Y:SET:SP", Monitor);
PV(double, ztarget, "{P}Z:TARGET:SP", Monitor);
PV(int, zset, "{P}Z:SET:SP", Monitor);
PV(double, mtarget, "{P}M:TARGET:SP", Monitor);
PV(int, mset, "{P}M:SET:SP", Monitor);

/* STATE SETS */

/* Magnets Off - Ramp all magnets to 0 */
ss working {
  state waiting {
    when (magoff == 1) {
      PVPUT(magoff, 0);
      puts ("Magnet Off requested");
      PVPUT(xtarget, 0);
      PVPUT(xset, 1);
      PVPUT(ytarget, 0);
      PVPUT(yset, 1);
      PVPUT(ztarget, 0);
      PVPUT(zset, 1);
      PVPUT(mtarget, 0);
      PVPUT(mset, 1);
    } state waiting
  }
}
