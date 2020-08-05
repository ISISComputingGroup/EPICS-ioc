program inhibitor("PVONE,PVTWO,PVONE_DISP,PVTWO_DISP")

#include "seqPVmacros.h"
%% #include "errlog.h"

/* Turn on run-time debug messages */
option +d;

/* Make code reentrant. This is needed to run more than one instance of this program. */
option +r;

/* PV definitions */
PV(double, pvone, "{PVONE}", Monitor);
PV(double, pvtwo, "{PVTWO}", Monitor);

PV(int, pvone_disp, "{PVONE_DISP}", NoMon);
PV(int, pvtwo_disp, "{PVTWO_DISP}", NoMon);

ss inhibitor
{

  /* Initial state. Find the current state and move into it. */
  state unknown
  {
    when(pvone == 0 && pvtwo == 0) {} state pv_one_off_pv_two_off
	when(pvone == 0 && pvtwo != 0) {} state pv_one_off_pv_two_on
	when(pvone != 0 && pvtwo == 0) {} state pv_one_on_pv_two_off
	when(pvone != 0 && pvtwo != 0) {} state pv_one_on_pv_two_on
  }
  
  state pv_one_off_pv_two_off
  {
    entry {
      errlogSevPrintf(errlogInfo, "Entering state pv_one_off_pv_two_off");
      PVPUT(pvone_disp, 0, SYNC);
      PVPUT(pvtwo_disp, 0, SYNC);
    }
  
    when(pvone != 0) {} state pv_one_on_pv_two_off
	when(pvtwo != 0) {} state pv_one_off_pv_two_on
  }
  
  state pv_one_on_pv_two_off
  {
    entry {
      errlogSevPrintf(errlogInfo, "Entering state pv_one_on_pv_two_off");
      PVPUT(pvone_disp, 0, SYNC);
      PVPUT(pvtwo_disp, 1, SYNC);
    }
  
	when(pvone == 0) {} state pv_one_off_pv_two_off
	when(pvtwo != 0) {} state pv_one_on_pv_two_on
  }
  
  state pv_one_off_pv_two_on
  {
    entry {
      errlogSevPrintf(errlogInfo, "Entering state pv_one_off_pv_two_on");
      PVPUT(pvone_disp, 1, SYNC);
      PVPUT(pvtwo_disp, 0, SYNC);
    }
    
    when(pvone != 0) {} state pv_one_on_pv_two_on
	when(pvtwo == 0) {} state pv_one_off_pv_two_off
  }
  
  state pv_one_on_pv_two_on
  {
    entry {
      errlogSevPrintf(errlogInfo, "Entering state pv_one_on_pv_two_on");
      errlogSevPrintf(errlogMajor, "WARNING: A transition occured that should not have been possible.");
      PVPUT(pvone_disp, 0, SYNC);
      PVPUT(pvtwo_disp, 0, SYNC);
    }
  
    /* 
	 * This state should only ever occur on startup. 
	 * It is assumed that if the inhibitor is started in this state then the instrument scientists know what they are doing.
	 * Therefore we dont need to do anything special in this state - just go back to one of the "normal" states when either PV goes back to zero.
	 */
    when(pvone == 0) {} state pv_one_off_pv_two_on
	when(pvtwo == 0) {} state pv_one_on_pv_two_off
  }
}
