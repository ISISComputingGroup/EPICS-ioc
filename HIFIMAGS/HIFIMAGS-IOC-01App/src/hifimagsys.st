program hifimagsys("P")

#include "seqPVmacros.h"
%% #include "errlog.h"

/* Turn on run-time debug messages */
option +d;

/* Make code reentrant. This is needed to run more than one instance of this program. */
option +r;

/* Constants */

/* Variables */
int prev_opmode = -1;

/* Environment Variables */

/* PVs */
/* Magnets Off */
PV(int, magoff, "{P}MAGNETS:OFF:SP", Monitor);
PV(double, xtarget, "{P}X:TARGET:SP", NoMon);
PV(int, xset, "{P}X:SET:SP", NoMon);
PV(double, ytarget, "{P}Y:TARGET:SP", NoMon);
PV(int, yset, "{P}Y:SET:SP", NoMon);
PV(double, ztarget, "{P}Z:TARGET:SP", NoMon);
PV(int, zset, "{P}Z:SET:SP", NoMon);
PV(double, mtarget, "{P}M:TARGET:SP", NoMon);
PV(int, mset, "{P}M:SET:SP", NoMon);

/* Opmode Changes */
PV(int, opmode, "{P}OPMODE:SP", Monitor);
PV(int, xdis, "{P}X:DIS", NoMon);
PV(int, ydis, "{P}Y:DIS", NoMon);
PV(int, zdis, "{P}Z:DIS", NoMon);
PV(int, mdis, "{P}M:DIS", NoMon);
PV(int, mextradis, "{P}M:EXTRAS:DIS", NoMon);
PV(int, zswitchdis, "{P}Z:SWITCH:DIS", NoMon);

/* STATE SETS */

/* Magnets Off - Ramp all magnets to 0 */
ss working {
  state waiting {
    when (magoff == 1) {
      PVPUT(magoff, 0);
      puts ("Magnet Off requested");
      PVPUT(xdis, 0);
      PVPUT(xtarget, 0);
      PVPUT(xset, 1);
      PVPUT(xdis, 1);
      PVPUT(ydis, 0);
      PVPUT(ytarget, 0);
      PVPUT(yset, 1);
      PVPUT(ydis, 1);
      PVPUT(zdis, 0);
      PVPUT(ztarget, 0);
      PVPUT(zset, 1);
      PVPUT(zdis, 1);
      PVPUT(mdis, 0);
      PVPUT(mtarget, 0);
      PVPUT(mset, 1);
      PVPUT(mdis, 1);
    } state waiting
    when (){
      if (opmode != prev_opmode){
        puts ("Looking at the opmode");
        prev_opmode = opmode;
        if (opmode == 0) {
          puts ("Idle Mode");
          PVPUT(xdis, 1);
          PVPUT(ydis, 1);
          PVPUT(zdis, 1);
          PVPUT(mdis, 1);
          PVPUT(mextradis, 1);
          PVPUT(zswitchdis, 1);
        }
      }
    } state waiting
  }
}
