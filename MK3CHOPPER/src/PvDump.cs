using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Security;

namespace Server
{
    public class PvDump
    {
        [SuppressUnmanagedCodeSecurity]
        [DllImport("pvdump.dll")]
        private static extern int pvdumpAddPV([MarshalAs(UnmanagedType.LPStr)]string pvName, [MarshalAs(UnmanagedType.LPStr)]string recordType, [MarshalAs(UnmanagedType.LPStr)]string desc);

        [SuppressUnmanagedCodeSecurity]
        [DllImport("pvdump.dll")]
        private static extern int pvdumpAddPVInfo([MarshalAs(UnmanagedType.LPStr)]string pvName, [MarshalAs(UnmanagedType.LPStr)]string infoName, [MarshalAs(UnmanagedType.LPStr)]string infoValue);

        [SuppressUnmanagedCodeSecurity]
        [DllImport("pvdump.dll")]
        private static extern int pvdumpWritePVs([MarshalAs(UnmanagedType.LPStr)]string iocname);

        public void DumpPVs(List<PVInfo> pvs, string ioc)
        {
            try
            {
                foreach (PVInfo pv in pvs)
                {

                    pvdumpAddPV(pv.Name, pv.Type, "");
                    pvdumpAddPVInfo(pv.Name, "INTEREST", pv.Interest);
                }

                //Write to db
                pvdumpWritePVs(ioc);
            }
            catch (Exception err)
            {
                Console.WriteLine("ERROR: Could not dump PVs: " + err.Message);
            }
        }
    }
}
