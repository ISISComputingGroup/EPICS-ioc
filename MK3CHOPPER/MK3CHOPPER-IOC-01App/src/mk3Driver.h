#ifndef MK3_INTERFACE_H
#define MK3_INTERFACE_H

#include "asynPortDriver.h"

class mk3Driver : public asynPortDriver {
public:
    mk3Driver(const char *portName, const char *configFilePath);
                 
    /* These are the methods that we override from asynPortDriver */
    virtual asynStatus writeInt32(asynUser *pasynUser, epicsInt32 value);
    virtual asynStatus readInt32(asynUser *pasynUser, epicsInt32 *value);
    
private:
    asynUser* pasynUser;

    int P_ActualFreq;
    int P_ActualPhase;
    #define FIRST_MK3_PARAM P_ActualFreq
	#define LAST_MK3_PARAM P_ActualPhase
};

#define NUM_MK3_PARAMS ( &LAST_MK3_PARAM - &FIRST_MK3_PARAM + 1)

#define P_ActualFreqString           "FREQ"                  
#define P_ActualPhaseString          "PHASE"           
    
    
#endif /* MK3_INTERFACE_H */