#ifndef ASTRIUM_DRIVER_H
#define ASTRIUM_DRIVER_H

#include "asynPortDriver.h"
#include "astriumInterface.h"

class astriumDriver : public asynPortDriver {
public:
    astriumDriver(const char *portName, const char *ip, bool mock);
                 
    /* These are the methods that we override from asynPortDriver */
    virtual asynStatus readOctet(asynUser *pasynUser, char *value, size_t maxChars, size_t *nActual, int *eomReason);
    virtual asynStatus writeOctet(asynUser *pasynUser, const char *value, size_t maxChars, size_t *nActual);
private:
    asynUser* pasynUser;
    astriumInterface* m_interface;

	bool compareStringStart(const char* value, const char* expected);

    int P_Status;               // string
    #define FIRST_ASTRIUM_PARAM P_Status
	#define LAST_ASTRIUM_PARAM P_Status
};

#define NUM_ASTRIUM_PARAMS ( &LAST_ASTRIUM_PARAM - &FIRST_ASTRIUM_PARAM + 1)

#define P_StatusString              "STATUS"
#define P_FreqString                "FREQ"
#define P_PhaseString               "PHAS"
#define P_BrakeString               "BRAKE"
#define P_CalibrateString           "CALIB"

#endif /* ASTRIUM_DRIVER_H */