#ifndef ASTRIUM_INTERFACE_H
#define ASTRIUM_INTERFACE_H

#include <string>

__declspec(dllimport) int Initialise(char* ip);
__declspec(dllimport) int GetStatus(unsigned int channel, char* result, int size);

class astriumInterface
{
    private:
        std::string ip;
    
    public:
        astriumInterface(const char* ip);
        int initialise();
        int getStatus(unsigned int channel, char* result, int size);  
};

#endif /* ASTRIUM_INTERFACE_H */