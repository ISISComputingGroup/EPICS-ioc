#include <string.h>
#include <stdlib.h>
#include <registryFunction.h>
#include <aSubRecord.h>
#include <menuFtype.h>
#include <errlog.h>
#include <epicsString.h>

#include <epicsExport.h>


/**
  *  	Strips out the leading byte from the given input.
  *
  *		The input data is modified so that it no longer contains the first character.
  */
static char parseInput(char* input)
{
	char firstChar = input[0];
	int i;
	for(i=0; i<4; i++){
		input[i] = input[i+1];
	}
	// Null terminator
	input[4] = '\0';
	return firstChar;
}

static void outputToPv(aSubRecord *prec, int firstChar, epicsOldString* data)
{
	if (firstChar == 49) prec->vala = *(epicsOldString*) data;
}

/**
 *  Do stuff.
 */
static long fermichopper(aSubRecord *prec) 
{
	char* tmp;
	puts("IN ASUB FUNCTION");	
	
	puts("Asub: fermichopper: Input A");
	prec->vala = (epicsOldString*)(prec->a);
	
	char firstCharInpA = parseInput(*(epicsOldString*)(prec->a));
	
	outputToPv(prec, firstCharInpA, (epicsOldString*)(prec->a));
	
	printf("Asub: fermichopper: Parsed output %i %s\n", firstCharInpA, *(epicsOldString*)(prec->vala));
    return 0; /* process output links */
}

epicsRegisterFunction(fermichopper); /* must also be mentioned in asubFunctions.dbd */
