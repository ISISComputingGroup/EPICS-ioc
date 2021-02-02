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
int prev_xdis;
int prev_ydis;
int prev_zdis;
int prev_mdis;

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
PV(float, xzero, "{P}X:ZERO", Monitor);
PV(float, yzero, "{P}Y:ZERO", Monitor);
PV(float, zzero, "{P}Z:ZERO", Monitor);
PV(float, mzero, "{P}M:ZERO", Monitor);
PV(float, xzerofield, "{P}X:ZEROFIELD", Monitor);
PV(float, yzerofield, "{P}Y:ZEROFIELD", Monitor);
PV(float, zzerofield, "{P}Z:ZEROFIELD", Monitor);
PV(int, mramp, "{P}M:RAMP:LEADS:SP", NoMon);
PV(int, mpersist, "{P}M:PERSIST:SP", NoMon);

/* Quench Checks */
PV(int, xquench, "{P}X:QUENCH", Monitor);
PV(int, yquench, "{P}Y:QUENCH", Monitor);
PV(int, zquench, "{P}Z:QUENCH", Monitor);
PV(int, mquench, "{P}M:QUENCH", Monitor);


/* STATE SETS */

/* Magnets Off - Ramp all magnets to 0 */
ss working {
  state waiting {
    when (magoff == 1) {
      PVPUT(magoff, 0);
      puts ("Magnet Off requested");
      
      prev_xdis = 0;
      if (xdis == 1) {
        PVPUT(xdis, 0);
        prev_xdis = 1;
      }
      PVPUT(xtarget, 0);
      PVPUT(xset, 1);
      PVPUT(xdis, prev_xdis);
      
      prev_ydis = 0;
      if (ydis == 1){
        PVPUT(ydis, 0);
        prev_ydis = 1;
      }
      PVPUT(ytarget, 0);
      PVPUT(yset, 1);
      PVPUT(ydis, prev_ydis);
      
      prev_zdis = 0;
      if (zdis == 1){
        PVPUT(zdis, 0);
        prev_zdis = 1;
      }
      PVPUT(ztarget, 0);
      PVPUT(zset, 1);
      PVPUT(zdis, prev_zdis);
      
      prev_mdis = 0;
      if (mdis == 1){
        PVPUT(mdis, 0);
        prev_mdis = 1;
      }
      PVPUT(mtarget, 0);
      PVPUT(mset, 1);
      PVPUT(mdis, prev_mdis);

    } state waiting

    when (){
      if (xquench == 1 || yquench == 1 || zquench == 1 || mquench == 1){
        PVPUT(opmode, 0);
      }
    
      if (opmode != prev_opmode){
        prev_opmode = opmode;
        if (opmode == 0) {
          /*Idle Mode*/
          PVPUT(xdis, 1);
          PVPUT(ydis, 1);
          PVPUT(zdis, 1);
          PVPUT(mdis, 1);
          PVPUT(mextradis, 1);
          PVPUT(zswitchdis, 1);
        }
        if (opmode == 1) {
          /*High Field Mode*/
          PVPUT(xdis, 0);
          PVPUT(ydis, 0);
          PVPUT(zdis, 0);
          PVPUT(mdis, 0);
          PVPUT(mextradis, 0);
          PVPUT(zswitchdis, 1);
          PVPUT(xtarget, xzero);
          PVPUT(ytarget, yzero);
          PVPUT(ztarget, zzero);
          PVPUT(xset, 1);
          PVPUT(yset, 1);
          PVPUT(zset, 1);
          PVPUT(mset, 1);
          PVPUT(xdis, 1);
          PVPUT(ydis, 1);
        }
        if (opmode == 2){
          /*Low Field Mode*/
          PVPUT(xdis, 0);
          PVPUT(ydis, 0);
          PVPUT(zdis, 0);
          PVPUT(mdis, 0);
          PVPUT(mextradis, 0);
          PVPUT(zswitchdis, 1);
          PVPUT(xtarget, xzerofield);
          PVPUT(ytarget, yzerofield);
          PVPUT(ztarget, zzerofield);
          PVPUT(mtarget, mzero);
          PVPUT(xset, 1);
          PVPUT(yset, 1);
          PVPUT(zset, 1);
          PVPUT(mset, 1);
          PVPUT(mramp, 1);
          PVPUT(mpersist, 0);
          PVPUT(mdis, 1);
        }
        if (opmode == 3) {
          /*Z Switching Mode*/
          PVPUT(xdis, 0);
          PVPUT(ydis, 0);
          PVPUT(zdis, 0);
          PVPUT(mdis, 0);
          PVPUT(mextradis, 0);
          PVPUT(zswitchdis, 0);
          PVPUT(xtarget, xzero);
          PVPUT(ytarget, yzero);
          PVPUT(xset, 1);
          PVPUT(yset, 1);
          PVPUT(xdis, 1);
          PVPUT(ydis, 1);
          PVPUT(zdis, 1);
        }
      }
    } state waiting
  }
}
