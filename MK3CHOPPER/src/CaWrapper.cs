using System;
using System.Collections;
using System.Collections.Generic;
using CaSharpServer;
using CaSharpServer.Constants;

namespace Server
{
    class CaWrapper
    {
        static Mk3Wrapper.IChopper _chopper = null;
        uint _chanNum = 1;

        CADoubleRecord FreqRb;
        CADoubleRecord FreqSpRb;
        CADoubleRecord FreqSp;

        CAIntRecord PhaseRb;
        CAIntRecord PhaseSpRb;
        CAIntRecord PhaseSp;
        CAIntRecord PhaseErrRb;
        CAIntRecord PhaseErrSpRb;
        CAIntRecord PhaseErrSp;

        CAStringRecord DirectionRb;
        CAStringRecord DirectionSpRb;
        CAStringRecord DirectionSp;
        CAIntRecord DirectionEnabledRb;   //bool

        CAIntRecord VetoRb;     //bool
        CAIntRecord ReadyRb;    //bool
        CAIntRecord InsyncRb;   //bool

        CAStringRecord ChopperNameRb;

        CAStringRecord ValidFreqs;

        public List<PVInfo> PVs { get; private set; }

        public CaWrapper(CAServer server, String prefix, uint channel, Mk3Wrapper.IChopper chopper)
        {
            // Only do once - not for each channel
            if (_chopper == null) _chopper = chopper;

            PVs = new List<PVInfo>();

            _chanNum = channel;

            if (prefix.EndsWith(":")) prefix = prefix.Substring(0, prefix.Length - 1);

            prefix += "_" + channel.ToString() + ":";

            FreqRb = server.CreateRecord<CADoubleRecord>(prefix + "FREQ");
            PVs.Add(new PVInfo(FreqRb.Name, "ai", "HIGH"));
            FreqRb.PrepareRecord += new EventHandler(Freq_PrepareRecords);
            FreqRb.Scan = CaSharpServer.Constants.ScanAlgorithm.SEC5;

            FreqSpRb = server.CreateRecord<CADoubleRecord>(prefix + "FREQ:SP:RBV");
            PVs.Add(new PVInfo(FreqSpRb.Name, "ai", "HIGH"));

            FreqSp = server.CreateRecord<CADoubleRecord>(prefix + "FREQ:SP");
            PVs.Add(new PVInfo(FreqSp.Name, "ao", "HIGH"));
            FreqSp.PropertySet += new EventHandler<PropertyDelegateEventArgs>(FreqSp_PropertySet);

            PhaseRb = server.CreateRecord<CAIntRecord>(prefix + "PHAS");
            PVs.Add(new PVInfo(PhaseRb.Name, "ai", "HIGH"));
            PhaseRb.PrepareRecord += new EventHandler(Phase_PrepareRecords);
            PhaseRb.Scan = CaSharpServer.Constants.ScanAlgorithm.SEC5;

            PhaseSpRb = server.CreateRecord<CAIntRecord>(prefix + "PHAS:SP:RBV");
            PVs.Add(new PVInfo(PhaseSpRb.Name, "ai", "HIGH"));

            PhaseSp = server.CreateRecord<CAIntRecord>(prefix + "PHAS:SP");
            PVs.Add(new PVInfo(PhaseSp.Name, "ao", "HIGH"));
            PhaseSp.PropertySet += new EventHandler<PropertyDelegateEventArgs>(PhaseSp_PropertySet);

            PhaseErrRb = server.CreateRecord<CAIntRecord>(prefix + "PHAS_ERR");
            PVs.Add(new PVInfo(PhaseErrRb.Name, "ai", "HIGH"));

            PhaseErrSpRb = server.CreateRecord<CAIntRecord>(prefix + "PHAS_ERR:SP:RBV");
            PVs.Add(new PVInfo(PhaseErrSpRb.Name, "ai", "HIGH"));

            PhaseErrSp = server.CreateRecord<CAIntRecord>(prefix + "PHAS_ERR:SP");
            PVs.Add(new PVInfo(PhaseErrSp.Name, "ao", "HIGH"));
            PhaseErrSp.PropertySet += new EventHandler<PropertyDelegateEventArgs>(PhaseErrSp_PropertySet);

            DirectionRb = server.CreateRecord<CAStringRecord>(prefix + "DIR");
            PVs.Add(new PVInfo(DirectionRb.Name, "stringin", "HIGH"));
            DirectionRb.PrepareRecord += new EventHandler(DirectionRb_PrepareRecords);
            DirectionRb.Scan = CaSharpServer.Constants.ScanAlgorithm.SEC5;

            DirectionEnabledRb = server.CreateRecord<CAIntRecord>(prefix + "DIR:ENABLED");
            PVs.Add(new PVInfo(DirectionEnabledRb.Name, "ai", "HIGH"));

            DirectionSpRb = server.CreateRecord<CAStringRecord>(prefix + "DIR:SP:RBV");
            PVs.Add(new PVInfo(DirectionSpRb.Name, "stringin", "HIGH"));

            DirectionSp = server.CreateRecord<CAStringRecord>(prefix + "DIR:SP");
            PVs.Add(new PVInfo(DirectionSp.Name, "stringout", "HIGH"));
            DirectionSp.PropertySet += new EventHandler<PropertyDelegateEventArgs>(DirectionSp_PropertySet);

            VetoRb = server.CreateRecord<CAIntRecord>(prefix + "VETO");
            PVs.Add(new PVInfo(VetoRb.Name, "ai", "HIGH"));
            VetoRb.PrepareRecord += new EventHandler(Status_PrepareRecords);
            VetoRb.Scan = CaSharpServer.Constants.ScanAlgorithm.SEC5;

            ReadyRb = server.CreateRecord<CAIntRecord>(prefix + "READY");
            PVs.Add(new PVInfo(ReadyRb.Name, "ai", "HIGH"));

            InsyncRb = server.CreateRecord<CAIntRecord>(prefix + "INSYNC");
            PVs.Add(new PVInfo(InsyncRb.Name, "ai", "HIGH"));

            ChopperNameRb = server.CreateRecord<CAStringRecord>(prefix + "NAME");
            PVs.Add(new PVInfo(ChopperNameRb.Name, "stringin", "HIGH"));
            ChopperNameRb.PrepareRecord += new EventHandler(ChopperNameRb_PrepareRecord);
            ChopperNameRb.Scan = CaSharpServer.Constants.ScanAlgorithm.SEC5;

            ValidFreqs = server.CreateRecord<CAStringRecord>(prefix + "VALIDFREQS");
            PVs.Add(new PVInfo(ValidFreqs.Name, "stringin", "HIGH"));
            ValidFreqs.PrepareRecord += new EventHandler(ValidFreqs_PrepareRecord);
            ValidFreqs.Scan = CaSharpServer.Constants.ScanAlgorithm.SEC5;

            if (chopper.GetType() == typeof(Mk3Simulator))
            {
                // Every time the constructor is called on a simulated chopper 
                // add one to the number of enabled channels.
                Mk3Simulator.NumEnabledChannels += 1;
            }
        }

        void ChopperNameRb_PrepareRecord(object sender, EventArgs e)
        {
            try
            {
                ChopperNameRb.Value = _chopper.GetChopperName(_chanNum);
                ChopperNameRb.AlarmStatus = AlarmStatus.NO_ALARM;
            }
            catch (Exception err)
            {
                Console.WriteLine("Error: could not get chopper name");
                Console.WriteLine(err.Message);
                ChopperNameRb.AlarmStatus = AlarmStatus.COMM;
            }
        }

        void Status_PrepareRecords(object sender, EventArgs e)
        {
            try
            {
                BitArray status = _chopper.GetStatusRegister(_chanNum);

                VetoRb.Value = status[5] ? 1 : 0;
                VetoRb.AlarmStatus = AlarmStatus.NO_ALARM;

                ReadyRb.Value = status[3] ? 1 : 0;
                ReadyRb.AlarmStatus = AlarmStatus.NO_ALARM;

                InsyncRb.Value = status[6] ? 1 : 0;
                InsyncRb.AlarmStatus = AlarmStatus.NO_ALARM;

                DirectionRb.Value = status[10] ? "CW" : "CCW";
                DirectionRb.AlarmStatus = AlarmStatus.NO_ALARM;
            }
            catch (Exception err)
            {
                Console.WriteLine("Error: could not get status register");
                Console.WriteLine(err.Message);
                VetoRb.AlarmStatus = AlarmStatus.COMM;
                ReadyRb.AlarmStatus = AlarmStatus.COMM;
                InsyncRb.AlarmStatus = AlarmStatus.COMM;
                DirectionRb.AlarmStatus = AlarmStatus.COMM;
            }
        }

        void DirectionSp_PropertySet(object sender, PropertyDelegateEventArgs e)
        {
            // The direction of the chopper may be fixed, so trying to change this may throw.
            try
            {
                if (e.NewValue.ToString().ToUpper().Trim() == "CW")
                {
                    _chopper.PutNominalDirection(_chanNum, true);
                }
                else if (e.NewValue.ToString().ToUpper().Trim() == "CCW")
                {
                    _chopper.PutNominalDirection(_chanNum, false);
                }
                else
                {
                    //Do nothing!
                }
            }
            catch (Exception err)
            {
                // No need to put into alarm state as it could be that the controller does not
                // accept direction changes
                Console.WriteLine("Error: could not set direction");
                Console.WriteLine(err.Message);
            }
        }

        void DirectionRb_PrepareRecords(object sender, EventArgs e)
        {
            try
            {
                bool cw = _chopper.GetNominalDirection(_chanNum);
                if (cw)
                {
                    DirectionSpRb.Value = "CW";
                }
                else
                {
                    DirectionSpRb.Value = "CCW";
                }

                DirectionSp.Value = DirectionSpRb.Value;
                DirectionSp.AlarmStatus = AlarmStatus.NO_ALARM;
            }
            catch (Exception err)
            {
                Console.WriteLine("Error: could not get nominal direction");
                Console.WriteLine(err.Message);
                DirectionSp.AlarmStatus = AlarmStatus.COMM;
            }

            // To get the actual direction we need to read the status register,
            // so this is done with the rest of the status register stuff.

            try
            {
                if (_chopper.GetChangeDirectionEnabled(_chanNum))
                {
                    DirectionEnabledRb.Value = 1;
                }
                else
                {
                    DirectionEnabledRb.Value = 0;
                }

                DirectionEnabledRb.AlarmStatus = AlarmStatus.NO_ALARM;
            }
            catch (Exception err)
            {
                Console.WriteLine("Error: could not get change direction enabled");
                Console.WriteLine(err.Message);
                DirectionEnabledRb.AlarmStatus = AlarmStatus.COMM;
            }
        }

        void PhaseErrSp_PropertySet(object sender, PropertyDelegateEventArgs e)
        {
            uint newvalue;
            if (UInt32.TryParse(e.NewValue.ToString(), out newvalue))
            {
                try
                {
                    _chopper.PutNominalPhaseErrorWindow(_chanNum, newvalue);
                    PhaseErrSp.AlarmStatus = AlarmStatus.NO_ALARM;
                }
                catch (Exception err)
                {
                    Console.WriteLine("Error: could not set phase error");
                    Console.WriteLine(err.Message);
                    PhaseErrSp.AlarmStatus = AlarmStatus.COMM;
                }
            }
        }

        void PhaseSp_PropertySet(object sender, PropertyDelegateEventArgs e)
        {

            uint newvalue;
            if (UInt32.TryParse(e.NewValue.ToString(), out newvalue))
            {
                try
                {
                    _chopper.PutNominalPhase(_chanNum, newvalue);
                    PhaseSp.AlarmStatus = AlarmStatus.NO_ALARM;
                }
                catch (Exception err)
                {
                    Console.WriteLine("Error: could not set phase");
                    Console.WriteLine(err.Message);
                    PhaseSp.AlarmStatus = AlarmStatus.COMM;
                }
            }
        }

        void Phase_PrepareRecords(object sender, EventArgs e)
        {
            // Update all Phase records in one go
            try
            {
                PhaseRb.Value = (int)_chopper.GetActualPhase(_chanNum);
                PhaseSpRb.Value = (int)_chopper.GetNominalPhase(_chanNum);

                PhaseErrRb.Value = _chopper.GetActualPhaseError(_chanNum);
                PhaseErrSpRb.Value = (int)_chopper.GetNominalPhaseError(_chanNum);

                PhaseRb.AlarmStatus = AlarmStatus.NO_ALARM;
                PhaseSpRb.AlarmStatus = AlarmStatus.NO_ALARM;
                PhaseErrRb.AlarmStatus = AlarmStatus.NO_ALARM;
                PhaseErrSpRb.AlarmStatus = AlarmStatus.NO_ALARM;
            }
            catch (Exception err)
            {
                Console.WriteLine("Error: could not get phase information");
                Console.WriteLine(err.Message);
                PhaseRb.AlarmStatus = AlarmStatus.COMM;
                PhaseSpRb.AlarmStatus = AlarmStatus.COMM;
                PhaseErrRb.AlarmStatus = AlarmStatus.COMM;
                PhaseErrSpRb.AlarmStatus = AlarmStatus.COMM;
            }
        }

        void FreqSp_PropertySet(object sender, PropertyDelegateEventArgs e)
        {
            double newvalue;
            if (Double.TryParse(e.NewValue.ToString(), out newvalue))
            {
                try
                {
                    _chopper.PutNominalFreq(_chanNum, newvalue);
                    FreqSp.AlarmStatus = AlarmStatus.NO_ALARM;
                }
                catch (Exception err)
                {
                    Console.WriteLine("Error: could not set frequency");
                    Console.WriteLine(err.Message);
                    FreqSp.AlarmStatus = AlarmStatus.COMM;
                }
            }
        }

        void Freq_PrepareRecords(object sender, EventArgs e)
        {
            // Update all Freq records in one go
            try
            {
                FreqRb.Value = _chopper.GetActualFreq(_chanNum);
                FreqSpRb.Value = _chopper.GetNominalFreq(_chanNum);
                //FreqSp.Value = FreqSpRb.Value;
            }
            catch (Exception err)
            {
                Console.WriteLine("Error: could not get frequency information");
                Console.WriteLine(err.Message);
                FreqRb.AlarmStatus = AlarmStatus.COMM;
                FreqSpRb.AlarmStatus = AlarmStatus.COMM;
            }

        }

        void ValidFreqs_PrepareRecord(object sender, EventArgs e)
        {
            try
            {
                double[] freqs = _chopper.GetAllowedFrequencies(_chanNum);

                String value = "";

                for (int i = 0; i < freqs.Length; ++i)
                {
                    value += freqs[i].ToString() + "|";
                }

                ValidFreqs.Value = value.Substring(0, value.Length - 1);
                ValidFreqs.AlarmStatus = AlarmStatus.NO_ALARM;
            }
            catch (Exception err)
            {
                Console.WriteLine("Error: could not get allowed frequencies");
                Console.WriteLine(err.Message);
                ValidFreqs.AlarmStatus = AlarmStatus.COMM;
            }
        }

    }
}
