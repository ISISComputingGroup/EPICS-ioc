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

int mk3Interface::getActualPhase(int channel, unsigned int* result)
{
    return GetActualPhase(channel, result);
}

int mk3Interface::getAllowedFrequencies(unsigned int channel, double* result, int size)
{
    return GetAllowedFrequencies(channel, result, size);
}

int mk3Interface::getActualPhaseError(unsigned int channel, int* result)
{
    return GetActualPhaseError(channel, result);
}

int mk3Interface::getNominalDirection(unsigned int channel, bool* result)
{
    return GetNominalDirection(channel, result);
}

int mk3Interface::getStatusRegister(unsigned int channel, bool* result, int size)
{
    return GetStatusRegister(channel, result, size);
}

int mk3Interface::getChopperName(unsigned int channel, char* result, int size)
{
    return GetChopperName(channel, result, size);
}

int mk3Interface::getNominalFreq(unsigned int channel, double* result)
{
    return GetNominalFreq(channel, result);
}

int mk3Interface::getNominalPhase(unsigned int channel, unsigned int* result)
{
    return GetNominalPhase(channel, result);
}

int mk3Interface::getNominalPhaseError(unsigned int channel, unsigned int* result)
{
    return GetNominalPhaseError(channel, result);
}

int mk3Interface::getChangeDirectionEnabled(unsigned int channel, bool* result)
{
    return GetChangeDirectionEnabled(channel, result);
}

int mk3Interface::getNumberEnabledChannels(unsigned int* result)
{
    return GetNumberEnabledChannels(result);
}

int mk3Interface::putNominalDirection(unsigned int channel, bool cw, int* result)
{
    return PutNominalDirection(channel, cw, result);
}

int mk3Interface::putNominalFreq(unsigned int channel, double speed, double* result)
{
    return PutNominalFreq(channel, speed, result);
}

int mk3Interface::putNominalPhaseErrorWindow(unsigned int channel, unsigned int error, unsigned int* result)
{
    return PutNominalPhaseErrorWindow(channel, error, result);
}

int mk3Interface::putNominalPhase(unsigned int channel, unsigned int phase, unsigned int* result)
{
    return PutNominalPhase(channel, phase, result);
}

void mk3Interface::checkErrorCode(int code, char* result, int size)
{
    CheckErrorCode(code, result, size);
}
