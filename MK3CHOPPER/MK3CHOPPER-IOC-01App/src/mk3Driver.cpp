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

#include "mk3Driver.h"
#include <epicsExport.h>
#include <asynOctetSyncIO.h>


static const char *driverName="mk3Driver";

mk3Driver::mk3Driver(const char *portName, const char *configFilePath) 
   : asynPortDriver(portName, 
                    1, /* maxAddr */ 
                    (int)NUM_MK3_PARAMS,
                    asynInt32Mask | asynFloat64Mask | asynFloat64ArrayMask | asynEnumMask | asynOctetMask | asynDrvUserMask, /* Interface mask */
                    asynInt32Mask | asynFloat64Mask | asynFloat64ArrayMask | asynEnumMask  | asynOctetMask,  /* Interrupt mask */
                    0, /* asynFlags.  This driver does not block and it is not multi-device, so flag is 0 */
                    1, /* Autoconnect */
                    0, /* Default priority */
                    0) /* Default stack size*/    
{
    const char *functionName = "mk3Driver";
    
    m_interface = new mk3Interface(configFilePath, true);
    m_interface->initialise();
    
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
    
    int errCode;
    
    if (function == P_ActualFreq)
    {
        double result;
        errCode = m_interface->getActualFreq(1, &result);
        *value = result;
        checkErrorCode(errCode);
    }
    else if (function == P_ActualPhase)
    {
        unsigned int result;
        errCode = m_interface->getActualPhase(1, &result);
        *value = result;
        checkErrorCode(errCode);
    }
    else if (function == P_ActualPhaseError)
    {
        int result;
        errCode = m_interface->getActualPhaseError(1, &result);
        *value = result;
        checkErrorCode(errCode);
    }
    else if (function == P_NominalFreq)
    {
        double result;
        errCode = m_interface->getNominalFreq(1, &result);
        *value = result;
        checkErrorCode(errCode);
    }
    else if (function == P_NominalPhaseError)
    {
        unsigned int result;
        errCode = m_interface->getNominalPhaseError(1, &result);
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
    
    int errCode;
    
    if (function == P_ValidFreqs)
    {
        const int size = 10;
        double result[size];
        errCode = m_interface->getAllowedFrequencies(1, result, size);
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
        errCode = m_interface->getChopperName(1, result, size);
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
    
    int errCode;
    
    if (function == P_Direction)
    {
        // Need to obtain the status register first       
        bool result[32];
        errCode = m_interface->getStatusRegister(1, result, 32); 
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
        errCode = m_interface->getNominalDirection(1, &result);
        
        *value = (int) result;
        checkErrorCode(errCode);
    }
    else if (function == P_DirectionEnabled)
    {
        bool result;
        errCode = m_interface->getChangeDirectionEnabled(1, &result);
        
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
    
    int errCode;
    
    if (function == P_NominalDirection)
    {
        int result;
        errCode = m_interface->putNominalDirection(1, (bool) value, &result);
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
    
    int errCode;
    
    if (function == P_NominalFreq)
    {
        double result;
        errCode = m_interface->putNominalFreq(1, (double) value, &result);
        checkErrorCode(errCode);
    }
    else if (function == P_NominalPhase)
    {
        unsigned int result;
        errCode = m_interface->putNominalPhase(1, (unsigned int) value, &result);
        checkErrorCode(errCode);
    }
    else if (function == P_NominalPhaseError)
    {
        unsigned int result;
        errCode = m_interface->putNominalPhaseErrorWindow(1, (unsigned int) value, &result);
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