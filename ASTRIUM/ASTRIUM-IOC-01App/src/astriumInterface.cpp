#include "astriumInterface.h"

astriumInterface::astriumInterface(const char* ip)
{
    this->ip = ip;
}

int astriumInterface::initialise()
{
    return Initialise(&ip[0]);
}

int astriumInterface::getStatus(unsigned int channel, char* result, int size)
{
    return GetStatus(channel, result, size);
}