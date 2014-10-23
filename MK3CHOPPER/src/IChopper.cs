using System.Collections.Generic;
using System.Collections;

namespace Server
{
    public interface IChopper
    {
        double GetActualFreq(uint channel);
        uint GetActualPhase(uint channel);
        int GetActualPhaseError(uint channel);
        double[] GetAllowedFrequencies(uint channel);
        string GetBeamlineName();
        string GetChannelsCurrentSettings();
        string GetChopperName(uint channel);
        string GetChopperType(uint channel);
        bool GetComputerMode();
        int GetFirmwareVersion(uint channel);
        int GetMPPeriod(uint channel);
        double GetNominalAngle(uint channel);
        bool GetNominalDirection(uint channel);
        double GetNominalFreq(uint channel);
        uint GetNominalPhaseError(uint channel);
        uint GetNominalPhase(uint channel);
        uint GetNumberEnabledChannels();
        int GetSoftwareVersion(uint channel);
        BitArray GetStatusRegister(uint channel);
        int GetNumberChannels();
        // int PutNominalAngle(uint channel, double angle);
        int PutNominalDirection(uint channel, bool cw);
        double PutNominalFreq(uint channel, double speed);
        uint PutNominalPhaseErrorWindow(uint channel, uint error);
        uint PutNominalPhase(uint channel, uint phase);
        List<PVInfo> GetPvInfo();
        bool GetChangeDirectionEnabled(uint channel);
    }
}
