#include "mk3Interface.h"

mk3Interface::mk3Interface(const char* configFilePath, bool useMock)
{
    confFilePath = new std::string(configFilePath);
    this->useMock = useMock;
}

int mk3Interface::getActualFreq(int channel, double* result)
{
    return 0;
}
