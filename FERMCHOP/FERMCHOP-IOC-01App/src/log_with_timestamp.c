#include "errlog.h"
#include "time.h"
#include "log_with_timestamp.h"

void log_with_timestamp(errlogSevEnum severity, char* message) {
    time_t t = time(NULL);
    struct tm tm = *localtime(&t);
    
    errlogSevPrintf(severity, "[%04d-%02d-%02d %02d:%02d:%02d]: %s\n", tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec, message);
}
