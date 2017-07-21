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

epicsRegisterFunction(fermichopper); /* must also be mentioned in asubFunctions.dbd */
