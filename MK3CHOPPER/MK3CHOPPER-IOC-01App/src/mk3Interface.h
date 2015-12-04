#ifndef MK3_INTERFACE_H
#define MK3_INTERFACE_H

#include <string>

class mk3Interface
{
    private:
        std::string confFilePath;
        bool useMock;
    
    public:
        mk3Interface(const char* configFilePath, bool useMock);
        int getActualFreq(int channel, double* result);
}

#endif /* MK3_INTERFACE_H */