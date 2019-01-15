#include <stdlib.h>
#include <string.h>
#include <sstream>
#include <algorithm>
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
static const int BUFFER_SIZE = 255;

astriumDriver::astriumDriver(const char *portName, const char *ip) 
   : asynPortDriver(portName, 
                    3, /* maxAddr */ 
                    (int)NUM_ASTRIUM_PARAMS,
                    asynOctetMask | asynDrvUserMask, /* Interface mask */
                    asynOctetMask,  /* Interrupt mask */
                    ASYN_MULTIDEVICE | ASYN_CANBLOCK,
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
    int function = pasynUser->reason;    
    std::string result;
	asynStatus status = getStringParam(function, result);
    if (result.size()) {
		*nActual = std::min(maxChars, result.size());
        strncpy(value, result.c_str(), *nActual);
        status = setStringParam(function, result.substr(*nActual)); //Stream device will keep reading until no characters are left
    } else {
		status = asynError;
	}

    return status;
}

asynStatus astriumDriver::writeOctet(asynUser *pasynUser, const char *value, size_t maxChars, size_t *nActual) {
    int function = pasynUser->reason;
    int channel;
    getAddress(pasynUser, &channel);

    if (strcmp(value, P_StatusString) == 0)
    {
		const int size = BUFFER_SIZE;
        char result[size];// = "#NCS016#ACCEPT CH=0# State= INACTIVE#ASPEED= 0#RSPEED= 0#APHASE= 0#RPHASE= 0#AVETO = 0#DIR   = CCW#MONIT = er#FLOWR = 3,81325301204819#WTEMP = 17#MTEMP = 22#MVIBR = 0#MVACU = 0,000546822026457275#DATE  = 15.01.2019#TIME";
		int errCode = m_interface->getStatus(channel, result, size);
        if (errCode) {
            return asynError;
        }
		std::string result_str = std::string(result) + "\n";
		std::replace(result_str.begin(), result_str.end(), ',', '.');
        setStringParam(function, result_str); 
        *nActual = maxChars;
    }
    
    return asynSuccess;
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