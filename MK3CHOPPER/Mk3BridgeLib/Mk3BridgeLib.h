// Mk3BridgeLib.h

#pragma once

using namespace System;

namespace Mk3BridgeLib {

	public ref class Mk3Chopper
	{
	private:
		static Mk3Wrapper::IChopper^ chopper;
		static void StringToCharArray(String^ str, char* result, int size);
	public:
		static int Initialise(char* configFile, bool useMock);
		static int GetActualFreq(unsigned int channel, double* result);
        static int GetActualPhase(unsigned int channel, unsigned int* result);
        static int GetActualPhaseError(unsigned int channel, int* result);
        static int GetAllowedFrequencies(unsigned int channel, double* result, int size);
        static int GetBeamlineName(char* result, int size); 
        static int GetChannelsCurrentSettings(char* result, int size);
        static int GetChopperName(unsigned int channel, char* result, int size);
        static int GetChopperType(unsigned int channel, char* result, int size);
        static int GetComputerMode(bool* result);
        static int GetFirmwareVersion(unsigned int channel, int* result);
        static int GetMPPeriod(unsigned int channel, int* result);
        static int GetNominalAngle(unsigned int channel, double* result);
        static int GetNominalDirection(unsigned int channel, bool* result);
        static int GetNominalFreq(unsigned int channel, double* result);
        static int GetNominalPhaseError(unsigned int channel, unsigned int* result);
        static int GetNominalPhase(unsigned int channel, unsigned int* result);
        static int GetNumberEnabledChannels(unsigned int* result);
        static int GetSoftwareVersion(unsigned int channel, int* result);
        static int GetStatusRegister(unsigned int channel, bool* result, int size);
        static int GetNumberChannels(int* result);
        static int PutNominalDirection(unsigned int channel, bool cw, int* result);
        static int PutNominalFreq(unsigned int channel, double speed, double* result);
        static int PutNominalPhaseErrorWindow(unsigned int channel, unsigned int error, unsigned int* result);
        static int PutNominalPhase(unsigned int channel, unsigned int phase, unsigned int* result);
        static int GetChangeDirectionEnabled(unsigned int channel, bool* result);
		static void CheckErrorCode(int code, char* result, int size);
	};
}
