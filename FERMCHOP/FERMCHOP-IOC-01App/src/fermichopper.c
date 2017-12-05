#include <stdlib.h>
#include <registryFunction.h>
#include <aSubRecord.h>
#include <epicsExport.h>

#include "fermichopper.h"

/**
 *  	Do stuff.
 */
static long fermichopper(aSubRecord *prec) 
{
	return fermi(prec);	
}

/**
 *  	Do stuff.
 */
static long speedSpSend(aSubRecord *prec) 
{
	return speedSetpointSend(prec);	
}

epicsRegisterFunction(fermichopper); /* must also be mentioned in asubFunctions.dbd */
epicsRegisterFunction(speedSpSend); /* must also be mentioned in asubFunctions.dbd */
