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
        List<bool> status = new List<bool> { true, true, true, true, true, true, true, true, true, true, true };

        public MockChopper(string configFile)
        {
        }

        public void Initialise()
        {
        }

        public int GetActualFreq(uint channel, ref double result)
        {
            result = freq;
            return 0;
        }

        public int GetActualPhase(uint channel, ref uint result)
        {
            result = phase;
            return 0;
        }

        public int GetActualPhaseError(uint channel, ref int result)
        {
            result = (int)phaseError;
            return 0;
        }

        public int GetAllowedFrequencies(uint channel, ref List<double> result)
        {
            result = new List<double> { 1, 5, 10 };
            return 0;
        }

        public int GetBeamlineName(ref string result)
        {
            result = "TestBeamline";
            return 0;
        }

        public int GetChannelsCurrentSettings(ref string result)
        {
            result = "Test Chopper Current Settings";
            return 0;
        }

        public int GetChopperName(uint channel, ref string result)
        {
            result = "TestChopper";
            return 0;
        }

        public int GetChopperType(uint channel, ref string result)
        {
            result = "TestChopper";
            return 0;
        }

        public int GetComputerMode(ref bool result)
        {
            result = true;
            return 0;
        }

        public int GetFirmwareVersion(uint channel, ref int result)
        {
            result = 1;
            return 0;
        }

        public int GetMPPeriod(uint channel, ref int result)
        {
            result = 2;
            return 0;
        }

        public int GetNominalAngle(uint channel, ref double result)
        {
            result = 123;
            return 0;
        }

        public int GetNominalDirection(uint channel, ref bool result)
        {
            result = true;
            return 0;
        }

        public int GetNominalFreq(uint channel, ref double result)
        {
            result = freq;
            return 0;
        }

        public int GetNominalPhaseError(uint channel, ref uint result)
        {
            result = phaseError;
            return 0;
        }

        public int GetNominalPhase(uint channel, ref uint result)
        {
            result = phase;
            return 0;
        }

        public int GetNumberEnabledChannels(ref uint result)
        {
            result = 1;
            return 0;
        }

        public int GetSoftwareVersion(uint channel, ref int result)
        {
            result = 1;
            return 0;
        }

        public int GetStatusRegister(uint channel, ref List<bool> result)
        {
            result = status;
            return 0;
        }

        public int GetNumberChannels(ref int result)
        {
            result = 1;
            return 0;
        }

        public int PutNominalDirection(uint channel, bool cw, ref int result)
        {
            status[10] = cw;
            if (status[10])
            {
                result = 1;
            }
            else
            {
                result = 0;
            }
            return 0;
        }

        public int PutNominalFreq(uint channel, double speed, ref double result)
        {
            freq = speed;
            result = freq;
            return 0;
        }

        public int PutNominalPhaseErrorWindow(uint channel, uint error, ref uint result)
        {
            phaseError = error;
            result = phaseError;
            return 0;
        }

        public int PutNominalPhase(uint channel, uint phase, ref uint result)
        {
            this.phase = phase;
            result = this.phase;
            return 0;
        }

        public int GetChangeDirectionEnabled(uint channel, ref bool result)
        {
            result = true;
            return 0;
        }

        public string ResolveErrorCode(int code)
        {
            return "OK";
        }

    }
}
