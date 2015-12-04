using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mk3Wrapper
{
    public class MockChopper : IChopper
    {
        public MockChopper(string configFile)
        {
        }

        public double GetActualFreq(uint channel)
        {
            return 123;
        }

        public uint GetActualPhase(uint channel)
        {
            return 456;
        }

        public int GetActualPhaseError(uint channel)
        {
            return 10;
        }

        public double[] GetAllowedFrequencies(uint channel)
        {
            return new double[] { 1, 5, 10 };
        }

        public string GetBeamlineName()
        {
            return "TestBeamline";
        }

        public string GetChannelsCurrentSettings()
        {
            return "Test Chopper Current Settings";
        }

        public string GetChopperName(uint channel)
        {
            return "TestChopper";
        }

        public string GetChopperType(uint channel)
        {
            return "TestChopper";
        }

        public bool GetComputerMode()
        {
            return true;
        }

        public int GetFirmwareVersion(uint channel)
        {
            return 1;
        }

        public int GetMPPeriod(uint channel)
        {
            return 2;
        }

        public double GetNominalAngle(uint channel)
        {
            return 123;
        }

        public bool GetNominalDirection(uint channel)
        {
            return true;
        }

        public double GetNominalFreq(uint channel)
        {
            return 456;
        }

        public uint GetNominalPhaseError(uint channel)
        {
            return 10;
        }

        public uint GetNominalPhase(uint channel)
        {
            return 123;
        }

        public uint GetNumberEnabledChannels()
        {
            return 1;
        }

        public int GetSoftwareVersion(uint channel)
        {
            return 1;
        }

        public bool[] GetStatusRegister(uint channel)
        {
            return new bool[] { true, false, true, false };
        }

        public int GetNumberChannels()
        {
            return 1;
        }

        public int PutNominalDirection(uint channel, bool cw)
        {
            return 1;
        }

        public double PutNominalFreq(uint channel, double speed)
        {
            return speed;
        }

        public uint PutNominalPhaseErrorWindow(uint channel, uint error)
        {
            return error;
        }

        public uint PutNominalPhase(uint channel, uint phase)
        {
            return phase;
        }

        public bool GetChangeDirectionEnabled(uint channel)
        {
            return true;
        }
    }
}
