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
	char* tmp;
	puts("IN ASUB FUNCTION");	
	
	puts("Asub: fermichopper: Input A");
	prec->vala = (epicsOldString*)(prec->a);
	tmp = *(epicsOldString*)(prec->a);
	
	int i;
	for(i=0; i<4; i++){
		tmp[i] = tmp[i+1];
	}
	// Null terminator
	tmp[4] = '\0';
	
	printf("Asub: fermichopper: Input A %s\n", tmp);
    return 0; /* process output links */
}

epicsRegisterFunction(fermichopper); /* must also be mentioned in asubFunctions.dbd */
