using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mk3Wrapper
{
    public class MockChopper : IChopper
    {
        double freq = 10;
        uint phase = 100;
        uint phaseError = 5;
        bool[] status = new bool[] { true, true, true, true, true, true, true, true, true, true, true };

        public MockChopper(string configFile)
        {
        }

        public double GetActualFreq(uint channel)
        {
            return freq;
        }

        public uint GetActualPhase(uint channel)
        {
            return phase;
        }

        public int GetActualPhaseError(uint channel)
        {
            return (int) phaseError;
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
            return freq;
        }

        public uint GetNominalPhaseError(uint channel)
        {
            return phaseError;
        }

        public uint GetNominalPhase(uint channel)
        {
            return phase;
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
            return new bool[] { true, true, true, true, true, true, true, true, true, true, true };
        }

        public int GetNumberChannels()
        {
            return 1;
        }

        public int PutNominalDirection(uint channel, bool cw)
        {
            status[10] = cw;
            if (status[10])
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }

        public double PutNominalFreq(uint channel, double speed)
        {
            freq = speed;
            return freq;
        }

        public uint PutNominalPhaseErrorWindow(uint channel, uint error)
        {
            phaseError = error;
            return phaseError;
        }

        public uint PutNominalPhase(uint channel, uint phase)
        {
            this.phase = phase;
            return this.phase;
        }

        public bool GetChangeDirectionEnabled(uint channel)
        {
            return true;
        }
    }
}
