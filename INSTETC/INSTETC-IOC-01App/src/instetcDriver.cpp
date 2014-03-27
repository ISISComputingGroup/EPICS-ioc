#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <math.h>
#include <exception>
#include <iostream>
#include <sstream>
#include <fstream>

#include <list>
#include <algorithm>
#include <iterator>
#include <vector>

#include <epicsTypes.h>
#include <epicsTime.h>
#include <epicsThread.h>
#include <epicsString.h>
#include <epicsTimer.h>
#include <epicsMutex.h>
#include <epicsEvent.h>
#include <iocsh.h>

#include "instetcDriver.h"

#include <macLib.h>
#include <epicsGuard.h>

#include <epicsExport.h>

static epicsThreadOnceId onceId = EPICS_THREAD_ONCE_INIT;


static void initCOM(void*)
{
//	CoInitializeEx(NULL, COINIT_MULTITHREADED);
}

static const char *driverName="instetcDriver";

/// Constructor for the lvDCOMDriver class.
/// Calls constructor for the asynPortDriver base class.
/// \param[in] dcomint DCOM interface pointer created by lvDCOMConfigure()
/// \param[in] portName @copydoc initArg0
instetcDriver::instetcDriver(const char *portName, const char* filePath, const int lineCount, const double pollingPeriod) 
   : filePath(filePath), lineCount(lineCount), pollingPeriod(pollingPeriod), asynPortDriver(portName, 
                    0, /* maxAddr */ 
                    NUM_INSTETC_PARAMS,
                    asynInt32Mask | asynFloat64Mask | asynOctetMask | asynDrvUserMask, /* Interface mask */
                    asynInt32Mask | asynFloat64Mask | asynOctetMask,  /* Interrupt mask */
                    ASYN_CANBLOCK, /* asynFlags.  This driver can block but it is not multi-device */
                    1, /* Autoconnect */
                    0, /* Default priority */
                    0)	/* Default stack size*/
{
	epicsThreadOnce(&onceId, initCOM, NULL);
	
	createParam(P_TextString, asynParamOctet, &P_Text);
	
    // Create the thread for background tasks (not used at present, could be used for I/O intr scanning) 
    if (epicsThreadCreate("instetcPoller",
                          epicsThreadPriorityMedium,
                          epicsThreadGetStackSize(epicsThreadStackMedium),
                          (EPICSTHREADFUNC)pollerThreadC, this) == 0)
    {
		const char *functionName = "instetcDriver";
		printf("%s:%s: epicsThreadCreate failure\n", driverName, functionName);
        return;
    }
}


std::string getLastLines(std::string const& filename, int lineCount)
{
    size_t const granularity = 100 * lineCount;
    std::ifstream source(filename.c_str(), std::ios_base::binary);
    source.seekg(0, std::ios_base::end);
    size_t size = static_cast<size_t>(source.tellg());
    std::vector<char> buffer;
    
	int newlineCount = 0;
    while (source 
           && buffer.size() != size
           && newlineCount < lineCount ) 
	{
        buffer.resize(std::min(buffer.size() + granularity, size));
        source.seekg(-static_cast<std::streamoff>(buffer.size()), std::ios_base::end);
        source.read(buffer.data(), buffer.size());
        newlineCount = std::count(buffer.begin(), buffer.end(), '\n');
    }

    std::vector<char>::iterator start = buffer.begin();
    while (newlineCount > lineCount) 
	{
        start = std::find(start, buffer.end(), '\n') + 1;
        -- newlineCount;
    }

    std::vector<char>::iterator end = remove(start, buffer.end(), '\r');
    return std::string(start, end);
}

asynStatus instetcDriver::readFloat64(asynUser *pasynUser, epicsFloat64 *value)
{
    return asynPortDriver::readFloat64(pasynUser, value);
}

void instetcDriver::pollerThreadC(void* arg)
{ 
    instetcDriver* driver = (instetcDriver*)arg; 
	driver->pollerThread(driver->filePath, driver->lineCount, driver->pollingPeriod);
}

#define LEN_BUFFER 10024

void instetcDriver::pollerThread(std::string filePath, int lineCount, double pollingPeriod)
{
	updateText("");

	while (true)
	{
		std::string lines = getLastLines(filePath, lineCount);
		lines = lines.substr(0, LEN_BUFFER);
		updateText(lines);
		
		epicsThreadSleep(3.0);
	}
}	 

void instetcDriver::updateText(std::string text)
{
	lock();
	setStringParam(P_Text, text.c_str());
	callParamCallbacks();
	unlock();
}


extern "C" {
	/// EPICS iocsh callable function to call constructor of lvDCOMInterface().
	/// \param[in] portName @copydoc initArg0
	static int instetcConfigure(const char *portName, const char* logFilePath, const int lineCount, const double pollingPeriod)
	{
		try
		{
			new instetcDriver(portName, logFilePath, lineCount, pollingPeriod);
			return(asynSuccess);
		}
		catch(const std::exception& ex)
		{
			std::cerr << "instetcDriver failed: " << ex.what() << std::endl;
			return(asynError);
		}
	}

	// EPICS iocsh shell commands 

	static const iocshArg initArg0 = { "portName", iocshArgString};			///< The name of the asyn driver port we will create
	static const iocshArg initArg1 = { "logFilePath", iocshArgString};	    ///< The path to the file we will monitor
	static const iocshArg initArg2 = { "lineCount", iocshArgInt};	        ///< The number of log file lines to broadcast
	static const iocshArg initArg3 = { "pollingPeriod", iocshArgDouble};	///< The number of seconds between file reads

	static const iocshArg * const initArgs[] = { &initArg0, &initArg1, &initArg2, &initArg3 };

	static const iocshFuncDef initFuncDef = {"instetcConfigure", sizeof(initArgs) / sizeof(iocshArg*), initArgs};

	static void initCallFunc(const iocshArgBuf *args)
	{
		instetcConfigure(args[0].sval, args[1].sval, args[2].ival, args[3].dval);
	}

	static void instetcRegister(void)
	{
		iocshRegister(&initFuncDef, initCallFunc);
	}

	epicsExportRegistrar(instetcRegister);
}

