using System;
using System.Collections.Generic;
using CaSharpServer;
using System.Net.Sockets;
using System.Diagnostics;
using System.ComponentModel;

namespace Server
{
    class Program
    {
        static bool runningFromVS()
        {
            bool isInDesignMode = LicenseManager.UsageMode == LicenseUsageMode.Designtime || Debugger.IsAttached == true;

            if (!isInDesignMode)
            {
                using (var process = Process.GetCurrentProcess())
                {
                    isInDesignMode = process.ProcessName.ToLowerInvariant().Contains("devenv");
                }
            }

            return isInDesignMode;
        }

        static void Main(string[] args)
        {
            if (runningFromVS())
            {
                //This deals with the st.cmd when running from VS
                args = new string[] { "..\\..\\iocBoot\\iocMk3Chopper\\st_simulate.cmd" };
            }

            if (args.Length != 1)
            {
                Console.WriteLine("Please supply a configuration file (e.g. st.cmd)");
                return;
            }

            //Read the st.cmd file
            Configuration config = new Configuration();
            config.ParseStartup(args[0]);

            CAServer server = null;

            try
            {
                //null = IP.Any
                server = new CAServer(config.ServerAddress, config.ConfiguredPort, 5064, 5065);
                Console.WriteLine("Connected to configured TCP port (" + config.ConfiguredPort + ")");
            }
            catch (SocketException e)
            {
                if (e.SocketErrorCode == SocketError.AddressAlreadyInUse)
                {
                    //the port is already in use, so ask the OS for a free port
                    server = new CAServer(config.ServerAddress, 0, 5064, 5065);
                    Console.WriteLine("Configured TCP port was unavailable.");
                    Console.WriteLine("Using dynamically assigned TCP port " + server.TcpPort);
                }
                else
                {
                    Console.WriteLine("Could not create CAServer: " + e.Message);
                }
            }

            Console.WriteLine("PV PREFIX: " + config.Prefix);

            List<CaWrapper> Choppers = new List<CaWrapper>();

            Mk3Wrapper.IChopper mk3chopper;

            int numChannels = 0;
            List<PVInfo> PVs = new List<PVInfo>();

            if (config.Simulation)
            {
                mk3chopper = new Mk3Simulator(server, config.Prefix);
                numChannels = config.NumSimulated;
            }
            else
            {
                mk3chopper = new Mk3Chopper(server, config.Prefix, config.ConfigFilePath);
                numChannels = (int)mk3chopper.GetNumberEnabledChannels();
            }

            IGetPvInfo pvinfo = mk3chopper as IGetPvInfo;

            if (pvinfo != null)
            {
                PVs.AddRange(pvinfo.GetPvInfo());
            }

            for (uint i = 0; i < numChannels; ++i)
            {
                Choppers.Add(new CaWrapper(server, config.Prefix, i + 1, mk3chopper));
                PVs.AddRange(Choppers[Choppers.Count - 1].PVs);
            }

            PvDump pvd = new PvDump();
            pvd.DumpPVs(PVs, "MK3CHOPPER");

            Console.WriteLine();

            while (true)
            {
                Console.Write(">>> ");
                string input = Console.ReadLine();

                if (input.ToUpper().Trim() == "QUIT" || input.ToUpper().Trim() == "EXIT")
                {
                    server.Dispose();
                    return;
                }
                else if (input.ToUpper().Trim() == "DBL")
                {
                    foreach (PVInfo pv in PVs)
                    {
                        Console.WriteLine(pv.Name);
                    }
                }
            }
        }
    }
}
