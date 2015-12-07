// This is the main DLL file.

#include "stdafx.h"
#include <iostream>

#include "Mk3BridgeLib.h"

using namespace System::Collections::Generic;

namespace Mk3BridgeLib
{
	int Mk3Chopper::Initialise(char* configFile, bool useMock)
	{
		if (useMock)
		{
			chopper = gcnew Mk3Wrapper::MockChopper(gcnew System::String(configFile));
		}
		else
		{
			chopper = gcnew Mk3Wrapper::Chopper(gcnew System::String(configFile));
		}

		return 0;
	}

	int Mk3Chopper::GetActualFreq(unsigned int channel, double* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::Double temp;

		int err = chopper->GetActualFreq(channel, temp);
		if (err != 0)
		{
			return err;
		}

		*result = double(temp);
		return 0;
	}

	int Mk3Chopper::GetChannelsCurrentSettings(char* result, int size)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::String^ ans = "";
		
		int err = chopper->GetChannelsCurrentSettings(ans);
		if (err != 0)
		{
			return err;
		}

		StringToCharArray(ans, result, size);

		return 0;
	}

	int Mk3Chopper::GetActualPhase(unsigned int channel, unsigned int* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::UInt32 temp;

		int err = chopper->GetActualPhase(channel, temp);
		if (err != 0)
		{
			return err;
		}

		*result = unsigned int(temp);
		return 0;
	}

    int Mk3Chopper::GetActualPhaseError(unsigned int channel, int* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::Int32 temp;

		int err = chopper->GetActualPhaseError(channel, temp);
		if (err != 0)
		{
			return err;
		}

		*result = int(temp);
		return 0;
	}

	int Mk3Chopper::GetAllowedFrequencies(unsigned int channel, double* result, int size)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		List<double>^ allowed = gcnew List<double>();
		
		int err = chopper->GetAllowedFrequencies(channel, allowed);

		if (err != 0)
		{
			return err;
		}

		if (size < allowed->Count)
		{
			return -2;
		}

		for(int i = 0; i < size; ++i)
		{
			if (i < allowed->Count)
			{
				result[i] = allowed[i];
			}
			else
			{
				// Zero pad if size is too high
				result[i] = 0;
			}
		}

		return 0;
	}

    int Mk3Chopper::GetBeamlineName(char* result, int size)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::String^ ans = "";
		
		int err = chopper->GetBeamlineName(ans);
		if (err != 0)
		{
			return err;
		}

		StringToCharArray(ans, result, size);

		return 0;
	}

	int Mk3Chopper::GetChopperName(unsigned int channel, char* result, int size)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::String^ ans = "";
		
		int err = chopper->GetChopperName(channel, ans);
		if (err != 0)
		{
			return err;
		}

		StringToCharArray(ans, result, size);

		return 0;
	}

    int Mk3Chopper::GetChopperType(unsigned int channel, char* result, int size)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::String^ ans = "";
		
		int err = chopper->GetChopperType(channel, ans);
		if (err != 0)
		{
			return err;
		}

		StringToCharArray(ans, result, size);

		return 0;
	}

    int Mk3Chopper::GetComputerMode(bool* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::Boolean temp;

		int err = chopper->GetComputerMode(temp);
		if (err != 0)
		{
			return err;
		}

		*result = bool(temp);
		return 0;
	}

	int Mk3Chopper::GetFirmwareVersion(unsigned int channel, int* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::Int32 temp;

		int err = chopper->GetFirmwareVersion(channel, temp);
		if (err != 0)
		{
			return err;
		}

		*result = int(temp);
		return 0;
	}

    int Mk3Chopper::GetMPPeriod(unsigned int channel, int* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}
		
		System::Int32 temp;

		int err = chopper->GetMPPeriod(channel, temp);
		if (err != 0)
		{
			return err;
		}

		*result = int(temp);
		return 0;
	}

    int Mk3Chopper::GetNominalAngle(unsigned int channel, double* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::Double temp;

		int err = chopper->GetNominalAngle(channel, temp);
		if (err != 0)
		{
			return err;
		}

		*result = double(temp);
		return 0;
	}

	int Mk3Chopper::GetNominalDirection(unsigned int channel, bool* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::Boolean temp;

		int err = chopper->GetNominalDirection(channel, temp);
		if (err != 0)
		{
			return err;
		}

		*result = bool(temp);
		return 0;
	}

    int Mk3Chopper::GetNominalFreq(unsigned int channel, double* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::Double temp;

		int err = chopper->GetNominalFreq(channel, temp);
		if (err != 0)
		{
			return err;
		}

		*result = double(temp);
		return 0;
	}

    int Mk3Chopper::GetNominalPhaseError(unsigned int channel, unsigned int* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::UInt32 temp;

		int err = chopper->GetNominalPhaseError(channel, temp);
		if (err != 0)
		{
			return err;
		}

		*result = unsigned int(temp);
		return 0;
	}

	int Mk3Chopper::GetNominalPhase(unsigned int channel, unsigned int* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::UInt32 temp;

		int err = chopper->GetNominalPhase(channel, temp);
		if (err != 0)
		{
			return err;
		}

		*result = unsigned int(temp);
		return 0;
	}

    int Mk3Chopper::GetNumberEnabledChannels(unsigned int* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::UInt32 temp;

		int err = chopper->GetNumberEnabledChannels(temp);
		if (err != 0)
		{
			return err;
		}

		*result = unsigned int(temp);
		return 0;
	}

    int Mk3Chopper::GetSoftwareVersion(unsigned int channel, int* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::Int32 temp;

		int err = chopper->GetSoftwareVersion(channel, temp);
		if (err != 0)
		{
			return err;
		}

		*result = int(temp);
		return 0;
	}

    int Mk3Chopper::GetNumberChannels(int* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::Int32 temp;

		int err = chopper->GetNumberChannels(temp);
		if (err != 0)
		{
			return err;
		}

		*result = int(temp);
		return 0;
	}

	int Mk3Chopper::PutNominalDirection(unsigned int channel, bool cw, int* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::Int32 temp;

		int err = chopper->PutNominalDirection(channel, cw, temp);
		if (err != 0)
		{
			return err;
		}

		*result = int(temp);
		return 0;
	}

    int Mk3Chopper::PutNominalFreq(unsigned int channel, double speed, double* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::Double temp;

		int err = chopper->PutNominalFreq(channel, speed, temp);
		if (err != 0)
		{
			return err;
		}

		*result = double(temp);
		return 0;
	}

    int Mk3Chopper::PutNominalPhaseErrorWindow(unsigned int channel, unsigned int error, unsigned int* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::UInt32 temp;

		int err = chopper->PutNominalPhaseErrorWindow(channel, error, temp);
		if (err != 0)
		{
			return err;
		}

		*result = unsigned int(temp);
		return 0;
	}

	int Mk3Chopper::PutNominalPhase(unsigned int channel, unsigned int phase, unsigned int* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::UInt32 temp;

		int err = chopper->PutNominalPhase(channel, phase, temp);
		if (err != 0)
		{
			return err;
		}

		*result = unsigned int(temp);
		return 0;
	}

	int Mk3Chopper::GetChangeDirectionEnabled(unsigned int channel, bool* result)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		System::Boolean temp;

		int err = chopper->GetChangeDirectionEnabled(channel, temp);
		if (err != 0)
		{
			return err;
		}

		*result = bool(temp);
		return 0;
	}

	int Mk3Chopper::GetStatusRegister(unsigned int channel, bool* result, int size)
	{
		if (chopper == nullptr)
		{
			return -1;
		}

		List<bool>^ allowed = gcnew List<bool>();
		int err = chopper->GetStatusRegister(channel, allowed);
		if (err != 0)
		{
			return err;
		}

		if (size < allowed->Count)
		{
			return -2;
		}

		for(int i = 0; i < size; ++i)
		{
			if (i < allowed->Count)
			{
				result[i] = allowed[i];
			}
			else
			{
				// False pad if size is too high
				result[i] = false;
			}
		}

		return 0;
	}

	void Mk3Chopper::CheckErrorCode(int code, char* result, int size)
	{
		if (code <= 0)
		{
			// Error code supplied by wrapper
			switch(code)
			{
				case 0  :
					StringToCharArray("OK", result, size);
					break; 
				case -1  :
					StringToCharArray("Chopper connection not initialised", result, size);
					break; 
				case -2  :
					StringToCharArray("Specified array size too small", result, size);
					break; 
				case -3  :
					StringToCharArray("Remoting timeout", result, size);
					break; 
				case -4  :
					StringToCharArray("Unknown .NET error", result, size);
					break; 

				default : 
					StringToCharArray("Unknown error", result, size);
			}
		}
		else
		{
			// Error code supplied by underlying MK3Chopper software/hardware
			System::String^ errorMsg = chopper->ResolveErrorCode(code);
			StringToCharArray(errorMsg, result, size);
		}
	}

	void Mk3Chopper::StringToCharArray(String^ str, char* result, int size)
	{
		using namespace Runtime::InteropServices;

		// If size is less than 50 don't bother
		if (size < 50)
		{
			return;
		}

		IntPtr p = Marshal::StringToHGlobalAnsi(str);
		strcpy(result, static_cast<char*>(p.ToPointer()));
		Marshal::FreeHGlobal(p);

		return;
	}
}

__declspec(dllexport) int Initialise(char* configFile, bool useMock)
{
    return Mk3BridgeLib::Mk3Chopper::Initialise(configFile, useMock);       
}

__declspec(dllexport) int GetActualFreq(unsigned int channel, double* result)
{
    return Mk3BridgeLib::Mk3Chopper::GetActualFreq(channel, result);    
}

__declspec(dllexport) int GetChannelsCurrentSettings(char* result, int size)
{
    return Mk3BridgeLib::Mk3Chopper::GetChannelsCurrentSettings(result, size);    
}

__declspec(dllexport) int GetActualPhase(unsigned int channel, unsigned int* result)
{
	return Mk3BridgeLib::Mk3Chopper::GetActualPhase(channel, result);
}

__declspec(dllexport) int GetActualPhaseError(unsigned int channel, int* result)
{
	return Mk3BridgeLib::Mk3Chopper::GetActualPhaseError(channel, result);
}

__declspec(dllexport) int GetAllowedFrequencies(unsigned int channel, double* result, int size)
{
    return Mk3BridgeLib::Mk3Chopper::GetAllowedFrequencies(channel, result, size);
}

__declspec(dllexport) int GetBeamlineName(char* result, int size)
{
	return Mk3BridgeLib::Mk3Chopper::GetBeamlineName(result, size);
}

__declspec(dllexport) int GetChopperName(unsigned int channel, char* result, int size)
{
	return Mk3BridgeLib::Mk3Chopper::GetChopperName(channel, result, size);  
}

__declspec(dllexport) int GetChopperType(unsigned int channel, char* result, int size)
{
	return Mk3BridgeLib::Mk3Chopper::GetChopperType(channel, result, size);  
}

__declspec(dllexport) int GetComputerMode(bool* result)
{
	return Mk3BridgeLib::Mk3Chopper::GetComputerMode(result);
}

__declspec(dllexport) int GetFirmwareVersion(unsigned int channel, int* result)
{
	return Mk3BridgeLib::Mk3Chopper::GetFirmwareVersion(channel, result);
}

__declspec(dllexport) int GetMPPeriod(unsigned int channel, int* result)
{
	return Mk3BridgeLib::Mk3Chopper::GetMPPeriod(channel, result);
}

__declspec(dllexport) int GetNominalAngle(unsigned int channel, double* result)
{
	return Mk3BridgeLib::Mk3Chopper::GetNominalAngle(channel, result);
}

__declspec(dllexport) int GetNominalDirection(unsigned int channel, bool* result)
{
	return Mk3BridgeLib::Mk3Chopper::GetNominalDirection(channel, result);
}

__declspec(dllexport) int GetNominalFreq(unsigned int channel, double* result)
{
	return Mk3BridgeLib::Mk3Chopper::GetNominalFreq(channel, result);
}

__declspec(dllexport) int GetNominalPhaseError(unsigned int channel, unsigned int* result)
{
	return Mk3BridgeLib::Mk3Chopper::GetNominalPhaseError(channel, result);
}

__declspec(dllexport) int GetNominalPhase(unsigned int channel, unsigned int* result)
{
	return Mk3BridgeLib::Mk3Chopper::GetNominalPhase(channel, result);
}

__declspec(dllexport) int GetNumberEnabledChannels(unsigned int* result)
{
	return Mk3BridgeLib::Mk3Chopper::GetNumberEnabledChannels(result);
}

__declspec(dllexport) int GetSoftwareVersion(unsigned int channel, int* result)
{
	return Mk3BridgeLib::Mk3Chopper::GetSoftwareVersion(channel, result);
}

__declspec(dllexport) int GetNumberChannels(int* result)
{
	return Mk3BridgeLib::Mk3Chopper::GetNumberChannels(result);
}

__declspec(dllexport) int PutNominalDirection(unsigned int channel, bool cw, int* result)
{
	return Mk3BridgeLib::Mk3Chopper::PutNominalDirection(channel, cw, result);
}

__declspec(dllexport) int PutNominalFreq(unsigned int channel, double speed, double* result)
{
	return Mk3BridgeLib::Mk3Chopper::PutNominalFreq(channel, speed, result);
}

__declspec(dllexport) int PutNominalPhaseErrorWindow(unsigned int channel, unsigned int error, unsigned int* result)
{
	return Mk3BridgeLib::Mk3Chopper::PutNominalPhaseErrorWindow(channel, error, result);
}

__declspec(dllexport) int PutNominalPhase(unsigned int channel, unsigned int phase, unsigned int* result)
{
	return Mk3BridgeLib::Mk3Chopper::PutNominalPhase(channel, phase, result);
}

__declspec(dllexport) int GetChangeDirectionEnabled(unsigned int channel, bool* result)
{
	return Mk3BridgeLib::Mk3Chopper::GetChangeDirectionEnabled(channel, result);
}

__declspec(dllexport) int GetStatusRegister(unsigned int channel, bool* result, int size)
{
	return Mk3BridgeLib::Mk3Chopper::GetStatusRegister(channel, result, size);
}

__declspec(dllexport) void CheckErrorCode(int code, char* result, int size)
{
    return Mk3BridgeLib::Mk3Chopper::CheckErrorCode(code, result, size);
}

