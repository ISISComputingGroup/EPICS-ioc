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
#include <iocsh.h>
#include "errlog.h"
#include "mk3Driver.h"
#include <epicsExport.h>
#include <asynOctetSyncIO.h>


static const char *driverName="mk3Driver";

mk3Driver::mk3Driver(const char *portName, const char *configFilePath, int mockChopper) 
   : asynPortDriver(portName, 
                    6, /* maxAddr */ 
                    (int)NUM_MK3_PARAMS,
                    asynInt32Mask | asynFloat64Mask | asynFloat64ArrayMask | asynEnumMask | asynOctetMask | asynDrvUserMask, /* Interface mask */
                    asynInt32Mask | asynFloat64Mask | asynFloat64ArrayMask | asynEnumMask  | asynOctetMask,  /* Interrupt mask */
                    ASYN_MULTIDEVICE,
                    1, /* Autoconnect */
                    0, /* Default priority */
                    0) /* Default stack size*/    
{
    const char *functionName = "mk3Driver";
    
    //epicsPrintf?
    std::cout << "*** Initialising MK3 Interface ***" << std::endl;
    
    if (mockChopper != 0)
    {
        std::cout << "Using mock chopper" << std::endl;
        m_interface = new mk3Interface(configFilePath, true);
    }
    else
    {
        std::cout << "Using real chopper" << std::endl;
        std::cout << "Config file = " << configFilePath << std::endl;
        m_interface = new mk3Interface(configFilePath, false);
    }
    
    int errCode = m_interface->initialise();
    checkErrorCode(errCode);
    
    createParam(P_ActualFreqString, asynParamFloat64, &P_ActualFreq);
    createParam(P_ValidFreqsString, asynParamOctet, &P_ValidFreqs);
    createParam(P_ActualPhaseErrorString, asynParamFloat64, &P_ActualPhaseError);
    createParam(P_ActualPhaseString, asynParamFloat64, &P_ActualPhase);
    createParam(P_DirectionString, asynParamInt32, &P_Direction);
    createParam(P_NominalDirectionString, asynParamInt32, &P_NominalDirection);
    createParam(P_VetoString, asynParamInt32, &P_Veto);
    createParam(P_ReadyString, asynParamInt32, &P_Ready);
    createParam(P_InSyncString, asynParamInt32, &P_InSync);
    createParam(P_ChopperNameString, asynParamOctet, &P_ChopperName);
    createParam(P_NominalFreqString, asynParamFloat64, &P_NominalFreq);
    createParam(P_NominalPhaseString, asynParamFloat64, &P_NominalPhase);
    createParam(P_NominalPhaseErrorString, asynParamFloat64, &P_NominalPhaseError);
    createParam(P_DirectionEnabledString, asynParamInt32, &P_DirectionEnabled);
    createParam(P_NumChannelsString, asynParamInt32, &P_NumChannels);
}

asynStatus mk3Driver::readFloat64(asynUser *pasynUser, epicsFloat64 *value)
{
    //std::cout << "readFloat64" << std::endl;
    int function = pasynUser->reason;
    asynStatus status = asynSuccess;
    const char *paramName;
    static const char *functionName = "readFloat64"; 
    getParamName(function, &paramName);
    
    int channel;
    getAddress(pasynUser, &channel);

    int errCode;
    
    if (function == P_ActualFreq)
    {
        double result;
        errCode = m_interface->getActualFreq(channel, &result);
        *value = result;
        checkErrorCode(errCode);
    }
    else if (function == P_ActualPhase)
    {
        unsigned int result;
        errCode = m_interface->getActualPhase(channel, &result);
        *value = result;
        checkErrorCode(errCode);
    }
    else if (function == P_ActualPhaseError)
    {
        int result;
        errCode = m_interface->getActualPhaseError(channel, &result);
        *value = result;
        checkErrorCode(errCode);
    }
    else if (function == P_NominalFreq)
    {
        double result;
        errCode = m_interface->getNominalFreq(channel, &result);
        *value = result;
        checkErrorCode(errCode);
    }
    else if (function == P_NominalPhaseError)
    {
        unsigned int result;
        errCode = m_interface->getNominalPhaseError(channel, &result);
        *value = result;
        checkErrorCode(errCode);
    }
    
    return status;
}

asynStatus mk3Driver::readOctet(asynUser *pasynUser, char *value, size_t maxChars, size_t *nActual, int *eomReason)
{
    //std::cout << "readOctet" << std::endl;
    int function = pasynUser->reason;
    asynStatus status = asynSuccess;
    const char *paramName;
    static const char *functionName = "readOctet"; 
    getParamName(function, &paramName);
    
    int channel;
    getAddress(pasynUser, &channel);
    
    int errCode;
    
    if (function == P_ValidFreqs)
    {
        const int size = 10;
        double result[size];
        errCode = m_interface->getAllowedFrequencies(channel, result, size);
        checkErrorCode(errCode);
        
        if (errCode == 0)
        {
            std::ostringstream oss;
            for(int i=0; i < size; i++)
            {
                // Only the first value is allowed to be zero.
                // Later ones are padding.
                if (i > 0 && result[i] == 0) break;
                
                if (i == 0)
                {
                    oss << result[i];
                }
                else
                {
                    oss << "|" << result[i];
                }
            }
            
            std::string temp = oss.str();
            
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
    else if (function == P_ChopperName)
    {
        const int size = 50;
        char result[size];
        errCode = m_interface->getChopperName(channel, result, size);
        checkErrorCode(errCode);
        
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

asynStatus mk3Driver::readInt32(asynUser *pasynUser, epicsInt32 *value)
{
    //std::cout << "readInt32" << std::endl;
    int function = pasynUser->reason;
    asynStatus status = asynSuccess;
    const char *paramName;
    static const char *functionName = "readInt32"; 
    getParamName(function, &paramName);
    
    int channel;
    getAddress(pasynUser, &channel);
    
    int errCode;
    
    if (function == P_Direction)
    {
        // Need to obtain the status register first       
        bool result[32];
        errCode = m_interface->getStatusRegister(channel, result, 32); 
        checkErrorCode(errCode);       
        *value = (int) result[10];
        
        // Update everything else that depends on the register
        setIntegerParam(P_Veto, (int) result[5]);
        setIntegerParam(P_Ready, (int) result[3]);
        setIntegerParam(P_InSync, (int) result[6]);
        callParamCallbacks();
    }
    else if (function == P_NominalDirection)
    {
        bool result;
        errCode = m_interface->getNominalDirection(channel, &result);
        
        *value = (int) result;
        checkErrorCode(errCode);
    }
    else if (function == P_DirectionEnabled)
    {
        bool result;
        errCode = m_interface->getChangeDirectionEnabled(channel, &result);
        
        *value = (int) result;
        checkErrorCode(errCode);
    }
    else if (function == P_NumChannels)
    {
        int result;
        errCode = m_interface->getNumberChannels(&result);
        
        *value = result;
        checkErrorCode(errCode);
    }

    return status;
}


asynStatus mk3Driver::writeInt32(asynUser *pasynUser, epicsInt32 value)
{
    //std::cout << "writeInt32" << std::endl;
    int function = pasynUser->reason;
    asynStatus status = asynSuccess;
    const char *paramName;
    static const char *functionName = "writeInt32"; 
    getParamName(function, &paramName);
    
    int channel;
    getAddress(pasynUser, &channel);
    
    int errCode;
    
    if (function == P_NominalDirection)
    {
        int result;
        errCode = m_interface->putNominalDirection(channel, (bool) value, &result);
        checkErrorCode(errCode);
    }
    
    return status;
}

asynStatus mk3Driver::writeFloat64(asynUser *pasynUser, epicsFloat64 value)
{
    //std::cout << "writeFloat64" << std::endl;
    int function = pasynUser->reason;
    asynStatus status = asynSuccess;
    const char *paramName;
    static const char *functionName = "writeFloat64"; 
    getParamName(function, &paramName);
    
    int channel;
    getAddress(pasynUser, &channel);
    
    int errCode;
    
    if (function == P_NominalFreq)
    {
        double result;
        errCode = m_interface->putNominalFreq(channel, (double) value, &result);
        checkErrorCode(errCode);
    }
    else if (function == P_NominalPhase)
    {
        unsigned int result;
        errCode = m_interface->putNominalPhase(channel, (unsigned int) value, &result);
        checkErrorCode(errCode);
    }
    else if (function == P_NominalPhaseError)
    {
        unsigned int result;
        errCode = m_interface->putNominalPhaseErrorWindow(channel, (unsigned int) value, &result);
        checkErrorCode(errCode);
    }
    
    return status;
}

void mk3Driver::checkErrorCode(int code)
{
    // 0 = no error
    if (code != 0)
    {
        char answer[50];
        m_interface->checkErrorCode(code, answer, 50);
        errlogSevPrintf(errlogMajor, "%s", answer);
        
        // If .net timout try to re-intialise
        if (code == -3)
        {
            errlogSevPrintf(errlogMajor, "%s","Trying to re-establish .NET connection");
            m_interface->initialise();
        }
    }
}

/* Configuration routine.  Called directly, or from the iocsh function below */

extern "C" {

// EPICS iocsh callable function to call constructor for the class.
int mk3DriverConfigure(const char *portName, const char *configFilePath, int mockChopper)
{
    new mk3Driver(portName, configFilePath, mockChopper);
    return(asynSuccess);
}


/* EPICS iocsh shell commands */
static const iocshArg initArg0 = { "portName", iocshArgString};
static const iocshArg initArg1 = { "configFilePath", iocshArgString};
static const iocshArg initArg2 = { "mockChopper", iocshArgInt};
static const iocshArg * const initArgs[] = {&initArg0, &initArg1, &initArg2};
static const iocshFuncDef initFuncDef = {"mk3DriverConfigure", 3, initArgs};
static void initCallFunc(const iocshArgBuf *args)
{
    mk3DriverConfigure(args[0].sval, args[1].sval, args[2].ival);
}

void mk3DriverRegister(void)
{
    iocshRegister(&initFuncDef, initCallFunc);
}

epicsExportRegistrar(mk3DriverRegister);

}