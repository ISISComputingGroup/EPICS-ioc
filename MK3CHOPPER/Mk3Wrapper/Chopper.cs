using System;
using System.Runtime.Remoting;
using System.Collections;
using System.Collections.Generic;

namespace Mk3Wrapper
{
    public class Chopper : IChopper
    {
        string configFile = "";
        MK3ChopperSkeleton.IBeamLine _beamline = null;
        MK3ChopperSkeleton.RemotingHelper _helper;

        public Chopper(string configFile)
        {
            this.configFile = configFile;
        }

        public void Initialise()
        {
            RemotingConfiguration.Configure(configFile, false);

            _helper = new MK3ChopperSkeleton.RemotingHelper();
            _beamline = (MK3ChopperSkeleton.IBeamLine)MK3ChopperSkeleton.RemotingHelper.CreateProxy();
        }

        public int GetActualFreq(uint channel, ref double result)
        {
            try
            {
                if (_beamline == null) Initialise();


                MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleActualSpeed(channel);
                result = res.doubleResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetActualPhase(uint channel, ref uint result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleActualDelay(channel);
                result = res.uintResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetActualPhaseError(uint channel, ref int result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleActualErrorWindow(channel);
                result = res.intResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetAllowedFrequencies(uint channel, ref List<double> result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetAllowedDemandSpeeds(channel);
                result = new List<double>(res.doubleArray);
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetBeamlineName(ref string result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetBeamLineName();
                result = res.stringResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetChannelsCurrentSettings(ref string result)
        {
            try
            {
                MK3ChopperSkeleton.ResultContainer res = _beamline.GetChannelsCurrentSettings();
                result = res.stringResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetChopperName(uint channel, ref string result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetChopperName(channel);
                result = res.stringResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetChopperType(uint channel, ref string result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetChopperType(channel);
                result = res.stringResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetChangeDirectionEnabled(uint channel, ref bool result)
        {
            try
            {
                string chopperType = "";
                int err = GetChopperType(channel, ref chopperType);
                if (err != 0)
                {
                    return err;
                }

                if (chopperType == "MK3ChopperServer.TS2DiscChopper" || chopperType == "MK3ChopperServer.TS1DiscChopper")
                {
                    result = true;
                }
                else
                {

                    ////Other types are:
                    //"TS1DiscChopper"
                    //"TS1TZeroChopper"
                    //"TS2TZeroChopper"
                    result = false;
                }
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetComputerMode(ref bool result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetComputerMode();
                result = res.boolResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetFirmwareVersion(uint channel, ref int result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleFirmwareVersion(channel);
                result = res.intResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetMPPeriod(uint channel, ref int result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleMPPeriod(channel);
                result = res.intResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetNominalAngle(uint channel, ref double result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetStoredDemandDiscAngle(channel);
                result = res.doubleResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetNominalDirection(uint channel, ref bool result)
        {
            try
            {
                string chopperType = "";
                int err = GetChopperType(channel, ref chopperType);
                if (err != 0)
                {
                    return err;
                }

                if (chopperType == "MK3ChopperServer.TS2TZeroChopper" || chopperType == "MK3ChopperServer.TS1TZeroChopper")
                {
                    result = true;
                }
                else
                {
                    MK3ChopperSkeleton.ResultContainer res = _beamline.GetStoredDemandCWDirection(channel);
                    result = res.boolResult;
                }
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetNominalFreq(uint channel, ref double result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleDemandSpeed(channel);
                result = res.doubleResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetNominalPhaseError(uint channel, ref uint result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleDemandErrorWindow(channel);
                result = res.uintResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetNominalPhase(uint channel, ref uint result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleDemandDelay(channel);
                result = res.uintResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetNumberEnabledChannels(ref uint result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetNumberOfEnabledChannels();
                result = res.uintResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetSoftwareVersion(uint channel, ref int result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleSoftwareVersion(channel);
                result = res.intResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetStatusRegister(uint channel, ref List<bool> result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetModuleStatusRegister(channel);

                List<bool> ans = new List<bool>();

                foreach (bool b in res.statusReg)
                {
                    ans.Add(b);
                }

                result = new List<bool>(ans.ToArray());
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        public int GetNumberChannels(ref int result)
        {
            try
            {
                if (_beamline == null) Initialise();

                MK3ChopperSkeleton.ResultContainer res = _beamline.GetTotalNumberOfChannels();
                result = res.intResult;
            }
            catch (RemotingTimeoutException exception)
            {
                return -3;
            }
            catch
            {
                return -4;
            }

            return 0;
        }

        //public int PutNominalAngle(uint channel, double angle)
        //{
        //    MK3ChopperSkeleton.ResultContainer res = _beamline.SetStoredDemandDiscAngle(channel, angle);
        //    checkError(res);
        //    res = _beamline.SendStoredDemandDiscAngleToModule(channel);
        //    checkError(res);
        //    res = _beamline.SaveChopperSettings();
        //    checkError(res);

        //    return res.intResult;
        //}

        public int PutNominalDirection(uint channel, bool cw, ref int result)
        {
            string chopperType = "";
            int err = GetChopperType(channel, ref chopperType);

            if (err != 0)
            {
                return err;
            }

            if (chopperType == "MK3ChopperServer.TS2TZeroChopper" || chopperType == "MK3ChopperServer.TS1TZeroChopper")
            {
                return 0;
            }

            MK3ChopperSkeleton.ResultContainer res = _beamline.SetStoredDemandCWDirection(channel, cw);
            if (res.error)
            {
                return Convert.ToInt32(res.errorCode);
            }

            res = _beamline.SendStoredDemandCWDirectionToModule(channel);
            if (res.error)
            {
                return Convert.ToInt32(res.errorCode);
            }

            result = res.intResult;

            res = _beamline.SaveChopperSettings();
            if (res.error)
            {
                return Convert.ToInt32(res.errorCode);
            }

            return 0;
        }

        public int PutNominalFreq(uint channel, double speed, ref double result)
        {
            if (_beamline == null) Initialise();

            MK3ChopperSkeleton.ResultContainer res = _beamline.SetStoredDemandSpeed(channel, speed);
            if (res.error)
            {
                return Convert.ToInt32(res.errorCode);
            }

            res = _beamline.SendStoredDemandSpeedToModule(channel);
            if (res.error)
            {
                return Convert.ToInt32(res.errorCode);
            }

            result = res.doubleResult;

            double newVal = res.doubleResult;
            res = _beamline.SaveChopperSettings();
            if (res.error)
            {
                return Convert.ToInt32(res.errorCode);
            }

            return 0;
        }

        public int PutNominalPhaseErrorWindow(uint channel, uint error, ref uint result)
        {
            if (_beamline == null) Initialise();

            MK3ChopperSkeleton.ResultContainer res = _beamline.SetStoredDemandErrorWindow(channel, error);
            if (res.error)
            {
                return Convert.ToInt32(res.errorCode);
            }

            res = _beamline.SendStoredDemandErrorWindowToModule(channel);
            if (res.error)
            {
                return Convert.ToInt32(res.errorCode);
            }

            result = res.uintResult;

            res = _beamline.SaveChopperSettings();
            if (res.error)
            {
                return Convert.ToInt32(res.errorCode);
            }

            return 0;
        }

        public int PutNominalPhase(uint channel, uint phase, ref uint result)
        {
            if (_beamline == null) Initialise();

            MK3ChopperSkeleton.ResultContainer res = _beamline.SetStoredDemandDelay(channel, phase);
            if (res.error)
            {
                return Convert.ToInt32(res.errorCode);
            }

            res = _beamline.SendStoredDemandDelayToModule(channel);
            if (res.error)
            {
                return Convert.ToInt32(res.errorCode);
            }

            result = res.uintResult;

            res = _beamline.SaveChopperSettings();
            if (res.error)
            {
                return Convert.ToInt32(res.errorCode);
            }

            return 0;
        }

        public string ResolveErrorCode(int code)
        {
            string errorMsg = "";

            switch (code)
            {
                case 1:
                    errorMsg = "Channel Number Not In Range.";
                    break;
                case 2:
                    errorMsg = "Channel Not Enabled";
                    break;
                case 3:
                    errorMsg = "Set User Delay Too Large For Chopper";
                    break;
                case 4:
                    errorMsg = "Controller Module Did Not Echo Command and Data";
                    break;
                case 5:
                    errorMsg = "Communication To Module Error";
                    break;
                case 6:
                    errorMsg = "Chopper Type Not Recognized";
                    break;
                case 7:
                    errorMsg = "Returned CMD Error";
                    break;
                case 8:
                    errorMsg = "Returned Non - Numerical Data";
                    break;
                case 9:
                    errorMsg = "Returned Incorrect String Length";
                    break;
                case 10:
                    errorMsg = "Error Window Too Large";
                    break;
                case 11:
                    errorMsg = "Cannot Save To Chopper Settings File";
                    break;
                case 12:
                    errorMsg = "Chopper Settings File Does Not Exist";
                    break;
                case 13:
                    errorMsg = "Cannot Read Chopper Settings File";
                    break;
                case 14:
                    errorMsg = "Cannot Update Chopper Log File";
                    break;
                case 15:
                    errorMsg = "Chopper Log File Does Not Exist";
                    break;
                case 16:
                    errorMsg = "Cannot Read Chopper Log File";
                    break;
                case 17:
                    errorMsg = "Could Not Clear Chopper Log File";
                    break;
                case 18:
                    errorMsg = "Remote Access Never Allowed For This Method";
                    break;
                case 19:
                    errorMsg = "Tried To Set Angle On non Disk Chopper";
                    break;
                case 20:
                    errorMsg = "Tried To Set Out Of Range Angle";
                    break;
                case 21:
                    errorMsg = "Current User Demand Delay Too Large for Angle , Direction & Speed";
                    break;
                case 22:
                    errorMsg = "Incorrect Speed Request";
                    break;
                case 23:
                    errorMsg = "Tried to Set Same Value for TS1 Bit";
                    break;
                case 24:
                    errorMsg = "Number of Requested Channels to Enable Not in Range";
                    break;
                case 25:
                    errorMsg = "Cannot Accept Empty String";
                    break;
                case 26:
                    errorMsg = "Incorrect IP Format";
                    break;
                case 27:
                    errorMsg = "Tried To Set Direction On T0 CHopper";
                    break;
                case 28:
                    errorMsg = "Module Returned Incorrect Termination String";
                    break;
                case 29:
                    errorMsg = "Send Stored Demand Disc Angle To Module Via \"Send User Demand Delay\"";
                    break;
                case 30:
                    errorMsg = "Module Did Not Return \"0\" Or \"1\" Data";
                    break;
                case 31:
                    errorMsg = "Remote Access Not Allowed When System In Manual Mode";
                    break;
                case 32:
                    errorMsg = "Tried To Set From Test Mode To Normal Mode When PCB Jumper Set To Test Mode";
                    break;
                case 33:
                    errorMsg = "Channels Not Consequectively Enabled In \"ChopperSettings.xml\" File";
                    break;
                case 34:
                    errorMsg = "Channel 1 Not Enabled In \"ChopperSettings.xml\" File";
                    break;
                case 35:
                    errorMsg = "Second PC LAN Card Not Found";
                    break;
                case 36:
                    errorMsg = "Could Not Find Any Chopper Modules";
                    break;
                case 37:
                    errorMsg = "Too Many Connected Chopper Modules";
                    break;
                case 38:
                    errorMsg = "Server ChopperList Empty";
                    break;
                default:
                    errorMsg = "OK";
                    break;
            }

            return errorMsg;
        }

    }
}
