#ifndef ASTRIUM_INTERFACE_H
#define ASTRIUM_INTERFACE_H
#include <boost/bind.hpp>
#include <boost/function.hpp>
#include <string>

__declspec(dllimport) int Initialise(const char* ip, bool mock);
__declspec(dllimport) int Calibrate(char* result, int size);
__declspec(dllimport) int GetStatus(unsigned int channel, char* result, int size);
__declspec(dllimport) int SetFreq(unsigned int channel, int speed, char* result, int size);
__declspec(dllimport) int SetPhase(unsigned int channel, double phase, char* result, int size);
__declspec(dllimport) int Resume(unsigned int channel, char* result, int size);
__declspec(dllimport) int Brake(unsigned int channel, char* result, int size);

class astriumInterface
{    
    public:
        astriumInterface(const char* ip, bool mock);
		std::string calibrate();
        std::string getStatus(unsigned int channel);
		std::string setFreq(unsigned int channel, int speed);
		std::string setPhase(unsigned int channel, double phase);
		std::string brake(unsigned int channel);
		std::string resume(unsigned int channel);
	private:
        std::string doCommand(boost::function<void(char * result, int size)> func);
		std::string formatString(const char* str);
};

#endif /* ASTRIUM_INTERFACE_H */