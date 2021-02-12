program hifimagsys("P")

#include "seqPVmacros.h"
%% #include "errlog.h"

/* Turn on run-time debug messages */
option +d;

/* Make code reentrant. This is needed to run more than one instance of this program. */
option +r;

/* Variables */
int prev_opmode = -1;
int i;
int length;
string pvName;
int prevdis;
int quench_message_printed = 0;

int setmag;
double target;
int disable;
float val;
/* Initial assignment to empty PVs so that they can be reassigned on the fly later */
assign setmag to "";
assign target to "";
assign disable to "";
assign val to "";

char mags[4] = {'X', 'Y', 'Z', 'M'};
char inactive_in_high[2] = {'X', 'Y'};
char zero_in_high[3] = {'X', 'Y', 'Z'};
char set_zerofield[3] = {'X', 'Y', 'Z'};
char zero_in_switching[2] = {'X', 'Y'};
char inactive_in_switching[3] = {'X', 'Y', 'Z'};

/* Environment Variables */
string *prefix;

/* PVs */
PV(int, magoff, "{P}MAGNETS:OFF:SP", Monitor);
PV(int, opmode, "{P}OPMODE", Monitor);
PV(int, setopmode, "{P}OPMODE:SP", NoMon);
PV(int, xquench, "{P}X:QUENCH", Monitor);
PV(int, yquench, "{P}Y:QUENCH", Monitor);
PV(int, zquench, "{P}Z:QUENCH", Monitor);
PV(int, mquench, "{P}M:QUENCH", Monitor);
PV(int, mextradis, "{P}M:EXTRAS:DIS", NoMon);
PV(int, zswitchdis, "{P}Z:SWITCH:DIS", NoMon);
PV(int, mramp, "{P}M:RAMP:LEADS:SP", NoMon);
PV(int, mpersist, "{P}M:PERSIST:SP", NoMon);

/* STATE SETS */

/* Magnets Off - Ramp all magnets to 0 */
ss systemManager {

  state init {
    when () {
      prefix = macValueGet("P");
    } state monitoring
  }

  state monitoring {
    when (xquench == 1 || yquench == 1 || zquench == 1 || mquench == 1){
      if (quench_message_printed == 0) {
        printf("QUENCH seen, quench values in following states (1 = quenched): x=%d, y=%d, z=%d, m=%d\r\n", xquench, yquench, zquench, mquench);
        quench_message_printed = 1;
      }
    } state quench
    when (magoff == 1) {
    } state turnmagoff
    when (opmode != prev_opmode) {
      prev_opmode = opmode;
      quench_message_printed = 0;
    } state opmode
    when (opmode == prev_opmode) { 
    } state monitoring
  }
  
  state quench {
    when (xquench == 1 || yquench == 1 || zquench == 1 || mquench == 1){
        PVPUT(setopmode, 0);
        prev_opmode = -1;
    } state monitoring
  }
  
  state turnmagoff {
    when (magoff == 1){
      PVPUT(magoff, 0);
      length = sizeof(mags)/sizeof(mags[0]);
      for (i = 0; i < length; i++) {
        sprintf (pvName, "%s%c:DIS", prefix, mags[i]);
        pvAssign (disable, pvName);
        sprintf (pvName, "%s%c:TARGET:SP", prefix, mags[i]);
        pvAssign (target, pvName);
        sprintf (pvName, "%s%c:SET:SP", prefix, mags[i]);
        pvAssign (setmag, pvName);
        
        pvGet(disable);
        prevdis = 0;
        if (disable == 1) {
          disable = 0;
          pvPut(disable);
          prevdis = 1;
        }
        target = 0;
        pvPut(target);
        setmag = 1;
        pvPut(setmag);
        disable = prevdis;
        pvPut(disable);
      }
    } state monitoring
  }
  
  state opmode {
    when (opmode == 0) {
    } state idlemode
    when (opmode == 1) {
    } state highfieldmode
    when (opmode == 2) {
    } state lowfieldmode
    when (opmode == 3) {
    } state zswitchmode
  }
  
  state idlemode {
    when () {
      length = sizeof(mags)/sizeof(mags[0]);
      for (i = 0; i < length; i++) {
        sprintf (pvName, "%s%c:DIS", prefix, mags[i]);
        pvAssign (disable, pvName);
        
        disable = 1;
        pvPut (disable);
      }
      PVPUT(mextradis, 1);
      PVPUT(zswitchdis, 1);
    } state monitoring
  }
  
  state highfieldmode {
    when () {
      length = sizeof(mags)/sizeof(mags[0]);
      for (i = 0; i < length; i++) {
        sprintf (pvName, "%s%c:DIS", prefix, mags[i]);
        pvAssign (disable, pvName);
        disable = 0;
        pvPut (disable);
      }
      
      length = sizeof(zero_in_high)/sizeof(zero_in_high[0]);
      for (i = 0; i < length; i++){
        sprintf (pvName, "%s%c:TARGET:SP", prefix, zero_in_high[i]);
        pvAssign (target, pvName);
        sprintf (pvName, "%s%c:SET:SP", prefix, zero_in_high[i]);
        pvAssign (setmag, pvName);
        sprintf (pvName, "%s%c:ZERO", prefix, zero_in_high[i]);
        pvAssign (val, pvName);
        
        pvGet(val);
        target = val;
        pvPut (target);
        setmag = 1;
        pvPut (setmag);
      }

      length = sizeof(inactive_in_high)/sizeof(inactive_in_high[0]);
      for (i = 0; i < length; i++){
        sprintf (pvName, "%s%c:DIS", prefix, inactive_in_high[i]);
        pvAssign (disable, pvName);
        disable = 1;
        pvPut (disable);
      }
      
      PVPUT(mextradis, 0);
      PVPUT(zswitchdis, 1);

    } state monitoring
  }

  state lowfieldmode {
    when () {

      length = sizeof(set_zerofield)/sizeof(set_zerofield[0]);
      for (i = 0; i < length; i++){
        sprintf (pvName, "%s%c:TARGET:SP", prefix, set_zerofield[i]);
        pvAssign (target, pvName);
        sprintf (pvName, "%s%c:SET:SP", prefix, set_zerofield[i]);
        pvAssign (setmag, pvName);
        sprintf (pvName, "%s%c:ZEROFIELD", prefix, set_zerofield[i]);
        pvAssign (val, pvName);
        sprintf (pvName, "%s%c:DIS", prefix, set_zerofield[i]);
        pvAssign (disable, pvName);
        
        disable = 0;
        pvPut(disable);
        pvGet(val);
        target = val;
        pvPut (target);
        setmag = 1;
        pvPut (setmag);
      }
      
      sprintf (pvName, "%sM:DIS", prefix);
      pvAssign (disable, pvName);
      sprintf (pvName, "%sM:TARGET:SP", prefix);
      pvAssign (target, pvName);
      sprintf (pvName, "%sM:SET:SP", prefix);
      pvAssign (setmag, pvName);
      sprintf (pvName, "%sM:ZERO", prefix);
      pvAssign (val, pvName);
      disable = 0;
      pvPut (disable);
      pvGet(val);
      target = val;
      pvPut (target);
      setmag = 1;
      pvPut (setmag);
      disable = 1;
      pvPut (disable);
      
      PVPUT(mramp, 1);
      PVPUT(mpersist, 0);
      PVPUT(mextradis, 0);
      PVPUT(zswitchdis, 1);
    } state monitoring
  }  
  
  state zswitchmode {
    when () {
    
      length = sizeof(zero_in_switching)/sizeof(zero_in_switching[0]);
      for (i = 0; i < length; i++){
        sprintf (pvName, "%s%c:DIS", prefix, zero_in_switching[i]);
        pvAssign (disable, pvName);
        sprintf (pvName, "%s%c:TARGET:SP", prefix, zero_in_switching[i]);
        pvAssign (target, pvName);
        sprintf (pvName, "%s%c:SET:SP", prefix, zero_in_switching[i]);
        pvAssign (setmag, pvName);
        sprintf (pvName, "%s%c:ZERO", prefix, zero_in_switching[i]);
        pvAssign (val, pvName);
        
        disable = 0;
        pvPut (disable);
        pvGet(val);
        target = val;
        pvPut (target);
        setmag = 1;
        pvPut (setmag);
      }

      length = sizeof(inactive_in_switching)/sizeof(inactive_in_switching[0]);
      for (i = 0; i < length; i++){
        sprintf (pvName, "%s%c:DIS", prefix, inactive_in_switching[i]);
        pvAssign (disable, pvName);
        disable = 1;
        pvPut (disable);
      }
      
      sprintf (pvName, "%sM:DIS", prefix);
      pvAssign (disable, pvName);
      disable = 0;
      pvPut (disable);
      
      PVPUT(mextradis, 0);
      PVPUT(zswitchdis, 0);
    } state monitoring
  }
}
