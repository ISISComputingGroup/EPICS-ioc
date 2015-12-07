using System.Collections.Generic;
using System.Collections;

namespace Mk3Wrapper
{
    public interface IChopper
    {
        int GetActualFreq(uint channel, ref double result);
        int GetActualPhase(uint channel, ref uint result);
        int GetActualPhaseError(uint channel, ref int result);
        int GetAllowedFrequencies(uint channel, ref List<double> result);
        int GetBeamlineName(ref string result);
        int GetChangeDirectionEnabled(uint channel, ref bool result);
        int GetChannelsCurrentSettings(ref string result);
        int GetChopperName(uint channel, ref string result);
        int GetChopperType(uint channel, ref string result);
        int GetComputerMode(ref bool result);
        int GetFirmwareVersion(uint channel, ref int result);
        int GetMPPeriod(uint channel, ref int result);
        int GetNominalAngle(uint channel, ref double result);
        int GetNominalDirection(uint channel, ref bool result);
        int GetNominalFreq(uint channel, ref double result);
        int GetNominalPhase(uint channel, ref uint result);
        int GetNominalPhaseError(uint channel, ref uint result);
        int GetNumberChannels(ref int result);
        int GetNumberEnabledChannels(ref uint result);
        int GetSoftwareVersion(uint channel, ref int result);
        int GetStatusRegister(uint channel, ref List<bool> result);
        void Initialise();
        int PutNominalDirection(uint channel, bool cw, ref int result);
        int PutNominalFreq(uint channel, double speed, ref double result);
        int PutNominalPhase(uint channel, uint phase, ref uint result);
        int PutNominalPhaseErrorWindow(uint channel, uint error, ref uint result);
        string ResolveErrorCode(int code);
    }
}
