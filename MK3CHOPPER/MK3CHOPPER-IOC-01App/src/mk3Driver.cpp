#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <math.h>

#include <epicsTypes.h>
#include <epicsTime.h>
#include <epicsThread.h>
#include <epicsString.h>
#include <epicsTimer.h>
#include <epicsMutex.h>
#include <epicsEvent.h>
#include <iocsh.h>

#include "mk3Driver.h"
#include <epicsExport.h>
#include <asynOctetSyncIO.h>


static const char *driverName="mk3Driver";

mk3Driver::mk3Driver(const char *portName, const char *configFilePath) 
   : asynPortDriver(portName, 
                    1, /* maxAddr */ 
                    (int)NUM_MK3_PARAMS,
                    asynInt32Mask | asynFloat64Mask | asynFloat64ArrayMask | asynEnumMask | asynDrvUserMask, /* Interface mask */
                    asynInt32Mask | asynFloat64Mask | asynFloat64ArrayMask | asynEnumMask,  /* Interrupt mask */
                    0, /* asynFlags.  This driver does not block and it is not multi-device, so flag is 0 */
                    1, /* Autoconnect */
                    0, /* Default priority */
                    0) /* Default stack size*/    
{
    const char *functionName = "mk3Driver";
    
    createParam(P_ActualFreqString, asynParamInt32, &P_ActualFreq);
    createParam(P_ActualPhaseString, asynParamInt32, &P_ActualPhase);

    /* Set the initial values of some parameters */
    setIntegerParam(P_ActualFreq, 123);
    setIntegerParam(P_ActualPhase, 246);
}

/* Called when asyn clients call pasynInt32->write().*/
asynStatus mk3Driver::writeInt32(asynUser *pasynUser, epicsInt32 value)
{
    printf("writeInt32 called");
    int function = pasynUser->reason; 
    static const char *functionName = "writeInt32"; 
    
    return(asynSuccess);
}

asynStatus mk3Driver::readInt32(asynUser *pasynUser, epicsInt32 *value)
{
    printf("readInt32 called");
    int function = pasynUser->reason;
    static const char *functionName = "readInt32"; 
    
    return(asynSuccess);
}

/* Configuration routine.  Called directly, or from the iocsh function below */

extern "C" {

// EPICS iocsh callable function to call constructor for the class.
int mk3DriverConfigure(const char *portName, const char *configFilePath)
{
    new mk3Driver(portName, configFilePath);
    return(asynSuccess);
}


/* EPICS iocsh shell commands */
static const iocshArg initArg0 = { "portName", iocshArgString};
static const iocshArg initArg1 = { "configFilePath", iocshArgString};
static const iocshArg * const initArgs[] = {&initArg0, &initArg1};
static const iocshFuncDef initFuncDef = {"mk3DriverConfigure", 2, initArgs};
static void initCallFunc(const iocshArgBuf *args)
{
    mk3DriverConfigure(args[0].sval, args[1].sval);
}

void mk3DriverRegister(void)
{
    iocshRegister(&initFuncDef, initCallFunc);
}

epicsExportRegistrar(mk3DriverRegister);

}