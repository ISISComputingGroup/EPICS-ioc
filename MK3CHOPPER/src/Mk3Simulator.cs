using System;
using System.Collections.Generic;
using CaSharpServer;

namespace Server
{
    class Mk3Simulator : Mk3Wrapper.IChopper, IGetPvInfo
    {
        public static uint NumEnabledChannels = 0;

        double _actualFreq = 0.0;
        double _nomFreq = 0.0;
        uint _actualPhas = 0;
        uint _nomPhas = 0;
        uint _nomPhasErr = 0;
        int _actualPhasErr = 0;
        double _nomAngle = 0.0;
        bool _nomDirection = false;

        Random _rand = new Random();

        CAIntRecord NumEnabledChannelsRb;

        List<PVInfo> _PVs = new List<PVInfo>();

        public Mk3Simulator(CAServer server, String prefix)
        {
            if (prefix.EndsWith(":")) prefix = prefix.Substring(0, prefix.Length - 1);

            NumEnabledChannelsRb = server.CreateRecord<CAIntRecord>(prefix + ":NUM_ENABLED");
            _PVs.Add(new PVInfo(NumEnabledChannelsRb.Name, "ai", "MEDIUM"));
            NumEnabledChannelsRb.PrepareRecord += new EventHandler(NumEnabledChannelsRb_PrepareRecord);
            NumEnabledChannelsRb.Scan = CaSharpServer.Constants.ScanAlgorithm.SEC10;
        }

        public List<PVInfo> GetPvInfo()
        {
            return _PVs;
        }

        void NumEnabledChannelsRb_PrepareRecord(object sender, EventArgs e)
        {
            NumEnabledChannelsRb.Value = (int) this.GetNumberEnabledChannels();
        }

        public double GetActualFreq(uint channel)
        {
            return _actualFreq + _rand.NextDouble()/4;
        }

        public uint GetActualPhase(uint channel)
        {
            return _actualPhas + (uint) _rand.Next(2);
        }

        public int GetActualPhaseError(uint channel)
        {
            return _actualPhasErr + _rand.Next(2);
        }

        public double[] GetAllowedFrequencies(uint channel)
        {
            return new double[] { 0, 10 + channel, 50 + channel, 100 + channel };
        }

        public string GetBeamlineName()
        {
            return "TEST BEAMLINE";
        }

        public string GetChannelsCurrentSettings()
        {
            return "TEST SETTINGS";
        }

        public string GetChopperName(uint channel)
        {
            return "TEST CHOPPER_" + channel;
        }

        public string GetChopperType(uint channel)
        {
            return "MK3ChopperServer.TS2DiscChopper";
        }

        public bool GetChangeDirectionEnabled(uint channel)
        {
            return true;
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
            return 1;
        }

        public double GetNominalAngle(uint channel)
        {
            return _nomAngle;
        }

        public bool GetNominalDirection(uint channel)
        {
            return _nomDirection;
        }

        public double GetNominalFreq(uint channel)
        {
            return _nomFreq;
        }

        public uint GetNominalPhaseError(uint channel)
        {
            return _nomPhasErr;
        }

        public uint GetNominalPhase(uint channel)
        {
            return _nomPhas;
        }

        public uint GetNumberEnabledChannels()
        {
            return NumEnabledChannels;
        }

        public int GetSoftwareVersion(uint channel)
        {
            return 1;
        }

        public System.Collections.BitArray GetStatusRegister(uint channel)
        {
            System.Collections.BitArray status = new System.Collections.BitArray(11);

            status[5] = false;   //Veto
            status[3] = true; //Ready
            status[6] = true; //Insync
            status[10] = _nomDirection; //Direction
            return status;
        }

        public int GetNumberChannels()
        {
            return 1;
        }

        public int PutNominalAngle(uint channel, double angle)
        {
            _nomAngle = angle;
            return 0;
        }

        public int PutNominalDirection(uint channel, bool cw)
        {
            _nomDirection = cw;
            return 0;
        }

        public double PutNominalFreq(uint channel, double speed)
        {
            _nomFreq = speed;
            _actualFreq = speed;
            return 0;
        }

        public uint PutNominalPhaseErrorWindow(uint channel, uint error)
        {
            _nomPhasErr = error;
            _actualPhasErr = (int) error;
            return 0;
        }

        public uint PutNominalPhase(uint channel, uint phase)
        {
            _nomPhas = phase;
            _actualPhas = phase;
            return 0;
        }
    }
}
