#ifdef __cplusplus
extern "C" {
#endif


#ifndef LOG_WITH_TIMESTAMP
#define LOG_WITH_TIMESTAMP

#include "errlog.h"

extern void log_with_timestamp(errlogSevEnum severity, char* message);

#endif


#ifdef __cplusplus
}
#endif

