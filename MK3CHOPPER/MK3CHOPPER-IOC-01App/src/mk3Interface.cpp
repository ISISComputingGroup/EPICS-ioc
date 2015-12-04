#include "mk3Interface.h"

mk3Interface::mk3Interface(const char* configFilePath, bool useMock)
{
    this->configFilePath = configFilePath;
    this->useMock = useMock;
}

int mk3Interface::initialise()
{
    return Initialise(&configFilePath[0], useMock);
}

int mk3Interface::getActualFreq(int channel, double* result)
{
    return GetActualFreq(channel, result);
}

void mk3Interface::checkErrorCode(int code, char* result, int size)
{
    CheckErrorCode(code, result, size);
}
