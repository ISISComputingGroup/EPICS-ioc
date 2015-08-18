using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.Remoting;
using CaSharpServer;

namespace Server
{
    class Mk3Chopper : Mk3Wrapper.Chopper, IGetPvInfo
    {
        CAIntRecord NumEnabledChannelsRb;

        List<PVInfo> _PVs = new List<PVInfo>();

        public Mk3Chopper(CAServer server, string prefix, string config_file) : base(config_file)
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
            NumEnabledChannelsRb.Value = (int)this.GetNumberEnabledChannels();
        }
    }
}

