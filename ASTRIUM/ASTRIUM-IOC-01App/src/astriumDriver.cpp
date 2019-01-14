#include <stdlib.h>
#include <string.h>
#include <sstream>
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
#include "envDefs.h"
#include <iocsh.h>
#include "errlog.h"
#include "astriumDriver.h"
#include <epicsExport.h>
#include <asynOctetSyncIO.h>


static const char *driverName="astriumDriver";
static const int BUFFER_SIZE = 100;

astriumDriver::astriumDriver(const char *portName, const char *ip) 
   : asynPortDriver(portName, 
                    1, /* maxAddr */ 
                    (int)NUM_ASTRIUM_PARAMS,
                    asynOctetMask | asynDrvUserMask, /* Interface mask */
                    asynOctetMask,  /* Interrupt mask */
                    ASYN_MULTIDEVICE,
                    1, /* Autoconnect */
                    0, /* Default priority */
                    0) /* Default stack size*/    
{
    const char *functionName = "astriumDriver";

    std::cout << "*** Initialising Astrium Interface on IP " << ip << " ***" << std::endl;
    
    m_interface = new astriumInterface(ip);
    
    int errCode = m_interface->initialise();
    
    createParam(P_StatusString, asynParamOctet, &P_Status);
}

asynStatus astriumDriver::readOctet(asynUser *pasynUser, char *value, size_t maxChars, size_t *nActual, int *eomReason)
{
    std::cout << "readOctet" << std::endl;
    int function = pasynUser->reason;
    asynStatus status = asynSuccess;
    const char *paramName;
    static const char *functionName = "readOctet"; 
    getParamName(function, &paramName);
    
    int channel;
    getAddress(pasynUser, &channel);
    
    int errCode;
    
    if (function == P_Status)
    {
        const int size = BUFFER_SIZE;
        char result[size];
        errCode = m_interface->getStatus(channel, result, size);
        
        if (errCode == 0)
        {
            std::string temp(result);
            
            if (temp.size() > maxChars) // More than we have space for?
            {
                *nActual = maxChars;
            }
            else
            {
                *nActual = temp.size();
            }
            
            strncpy(value, temp.c_str(), maxChars); // maxChars will NULL pad if possible, change to *nActual if we do not want this
        }
        else
        {
            *nActual = maxChars;
            strncpy(value, "UNKNOWN", maxChars);
        }
    }
    
    return status;
}

/* Configuration routine.  Called directly, or from the iocsh function below */

extern "C" {

// EPICS iocsh callable function to call constructor for the class.
int astriumDriverConfigure(const char *portName, const char *ip)
{
	try
	{
		new astriumDriver(portName, ip);
		return(asynSuccess);
	}
	catch(const std::exception& ex)
	{
		std::cerr << "astriumDriver failed: " << ex.what() << std::endl;
		return(asynError);
	}
}


/* EPICS iocsh shell commands */
static const iocshArg initArg0 = { "portName", iocshArgString};
static const iocshArg initArg1 = { "ip", iocshArgString};
static const iocshArg * const initArgs[] = {&initArg0, &initArg1};
static const iocshFuncDef initFuncDef = {"astriumDriverConfigure", 2, initArgs};
static void initCallFunc(const iocshArgBuf *args)
{
    astriumDriverConfigure(args[0].sval, args[1].sval);
}

void astriumDriverRegister(void)
{
    iocshRegister(&initFuncDef, initCallFunc);
}

epicsExportRegistrar(astriumDriverRegister);

}