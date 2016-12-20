#ifndef MK3_INTERFACE_H
#define MK3_INTERFACE_H

#include <string>

__declspec(dllimport) int Initialise(char* configFile, bool useMock);
__declspec(dllimport) int GetActualFreq(unsigned int channel, double* result);
// __declspec(dllimport) int GetChannelsCurrentSettings(char* result, int size);
__declspec(dllimport) void CheckErrorCode(int code, char* result, int size);
__declspec(dllimport) int GetAllowedFrequencies(unsigned int channel, double* result, int size);
// __declspec(dllimport) int GetBeamlineName(char* result, int size);
__declspec(dllimport) int GetActualPhase(unsigned int channel, unsigned int* result);
__declspec(dllimport) int GetActualPhaseError(unsigned int channel, int* result);
__declspec(dllimport) int GetChopperName(unsigned int channel, char* result, int size);
// __declspec(dllimport) int GetChopperType(unsigned int channel, char* result, int size);
// __declspec(dllimport) int GetComputerMode(bool* result);
// __declspec(dllimport) int GetFirmwareVersion(unsigned int channel, int* result);
// __declspec(dllimport) int GetMPPeriod(unsigned int channel, int* result);
// __declspec(dllimport) int GetNominalAngle(unsigned int channel, double* result);
__declspec(dllimport) int GetNominalDirection(unsigned int channel, bool* result);
__declspec(dllimport) int GetNominalFreq(unsigned int channel, double* result);
__declspec(dllimport) int GetNominalPhaseError(unsigned int channel, unsigned int* result);
__declspec(dllimport) int GetNominalPhase(unsigned int channel, unsigned int* result);
__declspec(dllimport) int GetNumberEnabledChannels(unsigned int* result);
// __declspec(dllimport) int GetSoftwareVersion(unsigned int channel, int* result);
// __declspec(dllimport) int GetNumberChannels(int* result);
__declspec(dllimport) int PutNominalDirection(unsigned int channel, bool cw, int* result);
__declspec(dllimport) int PutNominalFreq(unsigned int channel, double speed, double* result);
__declspec(dllimport) int PutNominalPhaseErrorWindow(unsigned int channel, unsigned int error, unsigned int* result);
__declspec(dllimport) int PutNominalPhase(unsigned int channel, unsigned int phase, unsigned int* result);
__declspec(dllimport) int GetChangeDirectionEnabled(unsigned int channel, bool* result);
__declspec(dllimport) int GetStatusRegister(unsigned int channel, bool* result, int size);

class mk3Interface
{
    private:
        std::string configFilePath;
        bool useMock;
    
    public:
        mk3Interface(const char* configFilePath, bool useMock);
        int initialise();
        int getActualFreq(int channel, double* result);
        int getNominalFreq(unsigned int channel, double* result);
        int getActualPhase(int channel, unsigned int* result);
        int getNominalPhase(unsigned int channel, unsigned int* result);
        int getActualPhaseError(unsigned int channel, int* result);
        int getNominalPhaseError(unsigned int channel, unsigned int* result);
        int getNominalDirection(unsigned int channel, bool* result);
        int getAllowedFrequencies(unsigned int channel, double* result, int size);   
        int getStatusRegister(unsigned int channel, bool* result, int size); 
        int getChopperName(unsigned int channel, char* result, int size);  
        int getChangeDirectionEnabled(unsigned int channel, bool* result); 
        int getNumberEnabledChannels(unsigned int* result); 
        int putNominalDirection(unsigned int channel, bool cw, int* result); 
        int putNominalFreq(unsigned int channel, double speed, double* result); 
        int putNominalPhaseErrorWindow(unsigned int channel, unsigned int error, unsigned int* result);
        int putNominalPhase(unsigned int channel, unsigned int phase, unsigned int* result);
        void checkErrorCode(int code, char* result, int size);
};

#endif /* MK3_INTERFACE_H */