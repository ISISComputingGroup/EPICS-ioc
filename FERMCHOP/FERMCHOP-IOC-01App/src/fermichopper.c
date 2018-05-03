#include <stdlib.h>
#include <registryFunction.h>
#include <aSubRecord.h>
#include <epicsExport.h>

#include "fermichopper.h"

/**
 *  Parse the response from the chopper.
 */
static long fermichopper(aSubRecord *prec) 
{
	return fermi(prec);	
}

/**
 *  Send a speed setpoint to the device.
 */
static long speedSpSend(aSubRecord *prec) 
{
	return speedSetpointSend(prec);	
}

/**
 *  Checks whether a given command is allowed to be sent at this time.
 */
static long commandCheck(aSubRecord *prec) 
{
	return commandChecker(prec);	
}

epicsRegisterFunction(fermichopper); /* must also be mentioned in asubFunctions.dbd */
epicsRegisterFunction(speedSpSend); /* must also be mentioned in asubFunctions.dbd */
epicsRegisterFunction(commandCheck); /* must also be mentioned in asubFunctions.dbd */
