#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <math.h>
#include <exception>
#include <iostream>
#include <sstream>
#include <fstream>
#include <sys/stat.h>

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

static const char *driverName="instetcDriver";

/// Constructor for the lvDCOMDriver class.
/// Calls constructor for the asynPortDriver base class.
/// \param[in] dcomint DCOM interface pointer created by lvDCOMConfigure()
/// \param[in] portName @copydoc initArg0
instetcDriver::instetcDriver(const char *portName, const char* filePath, const int lineCount, const double pollingPeriod) 
   : file_mod(0), filePath(filePath), lineCount(lineCount), pollingPeriod(pollingPeriod), asynPortDriver(portName, 
                    0, /* maxAddr */ 
                    NUM_INSTETC_PARAMS,
                    asynInt32Mask | asynFloat64Mask | asynOctetMask | asynDrvUserMask, /* Interface mask */
                    asynInt32Mask | asynFloat64Mask | asynOctetMask,  /* Interrupt mask */
                    ASYN_CANBLOCK, /* asynFlags.  This driver can block but it is not multi-device */
                    1, /* Autoconnect */
                    0, /* Default priority */
                    0)	/* Default stack size*/
{
	const char *functionName = "instetcDriver";
	createParam(P_TextString, asynParamOctet, &P_Text);
	
    // Create the thread for background tasks (not used at present, could be used for I/O intr scanning) 
    if (epicsThreadCreate("instetcPoller",
                          epicsThreadPriorityMedium,
                          epicsThreadGetStackSize(epicsThreadStackMedium),
                          (EPICSTHREADFUNC)pollerThreadC, this) == 0)
    {
		printf("%s:%s: epicsThreadCreate failure\n", driverName, functionName);
        return;
    }
}

// -1 if file does not exist, 0 if no change to file content, 1 if new lines
int instetcDriver::getLastLines(std::string& the_lines)
{
    size_t const granularity = 100 * lineCount;
    char filePathEx[1024];
    time_t now;
    struct tm now_tm;
    struct stat stat_struct;
    time(&now);
    memcpy(&now_tm, localtime(&now), sizeof(struct tm));
    if ( 0 == strftime(filePathEx, sizeof(filePathEx)-1, filePath.c_str(), &now_tm) )
    {
        strncpy(filePathEx, filePath.c_str(), sizeof(filePathEx)-1);
    }
    filePathEx[sizeof(filePathEx)-1] = '\0';
    if (stat(filePathEx, &stat_struct) != 0)
    {
        if (file_mod == 0)
        {
            the_lines = std::string("File \"") + filePathEx + "\" does not exist";
            file_mod = 1; // just so we do not continue to update with same message
            return -1;
        }
        // file does not exist, but it used to -> assume it was date rotated
        return 0; 
    }
    if (stat_struct.st_mtime == file_mod)
    {
        return 0;
    }
    file_mod = stat_struct.st_mtime;
    std::ifstream source(filePathEx, std::ios_base::binary);
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
        newlineCount = static_cast<int>(std::count(buffer.begin(), buffer.end(), '\n'));
    }

    std::vector<char>::iterator start = buffer.begin();
    while (newlineCount > lineCount) 
	{
        start = std::find(start, buffer.end(), '\n') + 1;
        --newlineCount;
    }

    std::vector<char>::iterator end = std::remove(start, buffer.end(), '\r');
    the_lines = std::string(start, end);
    return 1;
}

void instetcDriver::pollerThreadC(void* arg)
{ 
    instetcDriver* driver = (instetcDriver*)arg; 
	driver->pollerThread(driver->filePath, driver->lineCount, driver->pollingPeriod);
}

#define LEN_BUFFER 10024 /* needs to match size if char waveform in DB file */

void instetcDriver::pollerThread(const std::string& filePath, int lineCount, double pollingPeriod)
{
	std::string lines;
	updateText("");
	while (true)
	{
        if (getLastLines(lines) != 0)
        {
		    updateText(lines.substr(0, LEN_BUFFER));
        }
		epicsThreadSleep(3.0);
	}
}	 

void instetcDriver::updateText(const std::string& text)
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

