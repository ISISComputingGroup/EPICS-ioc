#include <registryFunction.h>
#include <epicsExport.h>
#include "aSubRecord.h"
#include "stdlib.h"

static long my_asub_routine(aSubRecord *prec) {
    long i;
    double *a, *vala;
    prec->pact = 1;
    //Note: may be an array
    a = (double *)prec->a;
    for(i=0; i < (prec->noa); ++i)
    {
        ((double *)prec->vala)[i] = a[i] * 2.0f;
    }
    prec->pact = 0;
    //Debug message - prints to IOC
    //printf("my_asub_routine called");
    return 0;
}
epicsRegisterFunction(my_asub_routine);