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

astriumDriver::astriumDriver(const char *portName, const char *ip, bool mock) 
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
    
    if (mock) {
        std::cout << "Creating mock chopper" << std::endl;
    } else {
        std::cout << "*** Initialising Astrium Interface on IP " << ip << " ***" << std::endl;
    }
    m_interface = new astriumInterface(ip, mock);
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

bool astriumDriver::compareStringStart(const char* value, const char* expected) {
	return (strncmp(value, expected, strlen(expected)) == 0);
}

asynStatus astriumDriver::writeOctet(asynUser *pasynUser, const char *value, size_t maxChars, size_t *nActual) {
    int function = pasynUser->reason;
    int channel;
	std::string result = "";
	asynStatus status = asynSuccess;
    getAddress(pasynUser, &channel);

	*nActual = maxChars;
    if (compareStringStart(value, P_StatusString)) {
		result = m_interface->getStatus(channel);
        setStringParam(function, result); 
    } else if (compareStringStart(value, P_FreqString)) {
		std::string freq_string = std::string(value).substr(strlen(P_FreqString) + 1);
		result = m_interface->setFreq(channel, std::atoi(freq_string.c_str()));
	} else if (compareStringStart(value, P_PhaseString)) {
		std::string phas_string = std::string(value).substr(strlen(P_PhaseString) + 1);
		result = m_interface->setPhase(channel, std::atof(phas_string.c_str()));
	} else if (compareStringStart(value, P_BrakeString)) {
		result = m_interface->brake(channel);
	} else if (compareStringStart(value, P_CalibrateString)) {
		result = m_interface->calibrate();
	} else {
		*nActual = 0;
	}

    setStringParam(function, result);

    return status;
}

/* Configuration routine.  Called directly, or from the iocsh function below */

extern "C" {

// EPICS iocsh callable function to call constructor for the class.
int astriumDriverConfigure(const char *portName, const char *ip, bool mock)
{
	try
	{
		new astriumDriver(portName, ip, mock);
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
static const iocshArg initArg2 = { "mock", iocshArgInt};
static const iocshArg * const initArgs[] = {&initArg0, &initArg1, &initArg2};
static const iocshFuncDef initFuncDef = {"astriumDriverConfigure", 3, initArgs};
static void initCallFunc(const iocshArgBuf *args)
{
    astriumDriverConfigure(args[0].sval, args[1].sval, args[2].ival);
}

void astriumDriverRegister(void)
{
    iocshRegister(&initFuncDef, initCallFunc);
}

epicsExportRegistrar(astriumDriverRegister);

}