#include "astriumInterface.h"
#include <algorithm>

std::string astriumInterface::doCommand(boost::function<void(char * result, int size)> func) {
    static const int BUFFER_SIZE = 255; //Messages from the driver are in general not longer than 255 chars. If they are the AstriumBridge will ensure that we do not overflow.
    char result[BUFFER_SIZE];
    func(result, BUFFER_SIZE);
    return formatString(result);
}

astriumInterface::astriumInterface(const char* ip, bool mock)
{
	Initialise(&ip[0], mock);
}

std::string astriumInterface::calibrate()
{
    return doCommand(boost::bind<void>(Calibrate, _1, _2));
}

std::string astriumInterface::getStatus(unsigned int channel)
{
    return doCommand(boost::bind<void>(GetStatus, channel, _1, _2));
}

std::string astriumInterface::setFreq(unsigned int channel, int speed)
{
    return doCommand(boost::bind<void>(SetFreq, channel, speed, _1, _2));
}

std::string astriumInterface::setPhase(unsigned int channel, double phase)
{
    return doCommand(boost::bind<void>(SetPhase, channel, phase, _1, _2));
}

std::string astriumInterface::brake(unsigned int channel)
{
    return doCommand(boost::bind<void>(Brake, channel, _1, _2));
}

std::string astriumInterface::formatString(const char* str)
{
	std::string result = std::string(str) + "\n";
	std::replace(result.begin(), result.end(), ',', '.');
	return result;
}