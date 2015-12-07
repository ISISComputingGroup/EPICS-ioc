#ifndef MK3_DRIVER_H
#define MK3_DRIVER_H

#include "asynPortDriver.h"
#include "mk3Interface.h"

class mk3Driver : public asynPortDriver {
public:
    mk3Driver(const char *portName, const char *configFilePath);
                 
    /* These are the methods that we override from asynPortDriver */
    virtual asynStatus readFloat64(asynUser *pasynUser, epicsFloat64 *value);
    virtual asynStatus readOctet(asynUser *pasynUser, char *value, size_t maxChars, size_t *nActual, int *eomReason);
    virtual asynStatus readInt32(asynUser *pasynUser, epicsInt32 *value);
    virtual asynStatus writeInt32(asynUser *pasynUser, epicsInt32 value);
    virtual asynStatus writeFloat64(asynUser *pasynUser, epicsFloat64 value);
    
private:
    asynUser* pasynUser;
    mk3Interface* m_interface;
    void checkErrorCode(int code);

    int P_ActualFreq;           // double
    int P_NominalFreq;          // double
    int P_ValidFreqs;           // string
    int P_ChopperName;          // string
    int P_ActualPhaseError;     // int
    int P_NominalPhaseError;    // int
    int P_Direction;            // bool
    int P_NominalDirection;     // bool
    int P_DirectionEnabled;     // bool
    int P_Veto;                 // bool
    int P_Ready;                // bool
    int P_InSync;               // bool
    int P_NumChannels;          // int
    int P_NominalPhase;         // int
    int P_ActualPhase;          // int
    #define FIRST_MK3_PARAM P_ActualFreq
	#define LAST_MK3_PARAM P_ActualPhase
};

#define NUM_MK3_PARAMS ( &LAST_MK3_PARAM - &FIRST_MK3_PARAM + 1)

#define P_ActualFreqString          "FREQ" 
#define P_NominalFreqString         "NOMFREQ"  
#define P_ValidFreqsString          "VALIDFREQS" 
#define P_ChopperNameString         "CHOPNAME"  
#define P_ActualPhaseErrorString    "PHASEERROR"
#define P_NominalPhaseErrorString   "NOMPHASEERROR"
#define P_DirectionString           "DIR"
#define P_NominalDirectionString    "NOMDIR"
#define P_DirectionEnabledString    "DIRENABLED"
#define P_VetoString                "VETO" 
#define P_ReadyString               "READY" 
#define P_InSyncString              "INSYNC"
#define P_NumChannelsString         "CHANNELS"   
#define P_NominalPhaseString        "NOMPHASE"                 
#define P_ActualPhaseString         "PHASE"          
    
    
#endif /* MK3_DRIVER_H */