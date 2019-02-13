#include <stdlib.h>
#include <registryFunction.h>
#include <aSubRecord.h>
#include <epicsExport.h>

#include "fermichopper.h"

/**
 *  Parse the response from the chopper.
 */
static long fermichopper_merlin(aSubRecord *prec) 
{
	return fermi_merlin(prec);	
}

/**
 *  Parse the response from the chopper.
 */
static long fermichopper_maps(aSubRecord *prec) 
{
	return fermi_maps(prec);	
}

/**
 *  Send a speed setpoint to the device.
 */
static long speedSpSend_merlin(aSubRecord *prec) 
{
	return speedSetpointSend_merlin(prec);	
}

/**
 *  Send a speed setpoint to the device.
 */
static long speedSpSend_maps(aSubRecord *prec) 
{
	return speedSetpointSend_maps(prec);	
}

/**
 *  Checks whether a given command is allowed to be sent at this time.
 */
static long commandCheck(aSubRecord *prec) 
{
	return commandChecker(prec);	
}

epicsRegisterFunction(fermichopper_merlin); /* must also be mentioned in asubFunctions.dbd */
epicsRegisterFunction(fermichopper_maps); /* must also be mentioned in asubFunctions.dbd */
epicsRegisterFunction(speedSpSend_merlin); /* must also be mentioned in asubFunctions.dbd */
epicsRegisterFunction(speedSpSend_maps); /* must also be mentioned in asubFunctions.dbd */
epicsRegisterFunction(commandCheck); /* must also be mentioned in asubFunctions.dbd */
