#include <string.h>
#include <stdlib.h>
#include <registryFunction.h>
#include <aSubRecord.h>
#include <menuFtype.h>
#include <errlog.h>
#include <epicsString.h>

#include <epicsExport.h>
/**
 *  Do stuff.
 */
static long fermichopper(aSubRecord *prec) 
{
	puts("IN ASUB FUNCTION");	
	
	puts("Asub: fermichopper: Input A");
	prec->vala = prec->a;
	
    return 0; /* process output links */
}

epicsRegisterFunction(fermichopper); /* must also be mentioned in asubFunctions.dbd */
