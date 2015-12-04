#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <math.h>
#include <iostream>

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
    
    m_interface = new mk3Interface(configFilePath, true);
    m_interface->initialise();
    
    createParam(P_ActualFreqString, asynParamInt32, &P_ActualFreq);
    createParam(P_ActualPhaseString, asynParamInt32, &P_ActualPhase);

    /* Set the initial values of some parameters */
    setIntegerParam(P_ActualFreq, 0);
    setIntegerParam(P_ActualPhase, 0);
}

/* Called when asyn clients call pasynInt32->write().*/
asynStatus mk3Driver::writeInt32(asynUser *pasynUser, epicsInt32 value)
{
    //printf("writeInt32 called");
    int function = pasynUser->reason; 
    static const char *functionName = "writeInt32"; 
    
    return(asynSuccess);
}

asynStatus mk3Driver::readFloat64(asynUser *pasynUser, epicsFloat64 *value)
{
    //printf("readFloat64 called");
    int function = pasynUser->reason;
    asynStatus status = asynSuccess;
    const char *paramName;
    static const char *functionName = "readFloat64"; 
    getParamName(function, &paramName);
    
    int errCode;
    
    if (function == P_ActualFreq)
    {
        double result;
        errCode = m_interface->getActualFreq(1, &result);
        *value = result;
        // Check error code (move to separate method)
        checkErrorCode(errCode);
        
        //std::cout << result << std::endl;
    }
    
    callParamCallbacks();
    
    return(asynSuccess);
}

void mk3Driver::checkErrorCode(int code)
{
    // 0 = no error
    if (code != 0)
    {
        char answer[50];
        m_interface->checkErrorCode(code, answer, 50);
        std::cout << answer << std::endl;
    }
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