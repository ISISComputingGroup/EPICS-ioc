function getMacroValue (options)
    --[[
        Gets the value of a macro from the environment, or returns the given default value

        Signature:
            getMacroValue{macro="macro_name", default="default_value"}

        Args:
            macro: String, the macro to look up in the environment
            default: String, the value to return if the macro if the macro is not set in the environment
        Raises:
            Error if the macro could not be found in the environment and no default is given
    ]]

    if type(options.macro) ~= "string" then
        error("No macro given")
    end
    macro = options.macro
    default = options.default

    macroFromEnvironment = os.getenv(macro)

    if (macroFromEnvironment~=nil) then
        -- Macro set to value from environment
        macroValue = macroFromEnvironment
        print(string.format("%s set from environment as %s", macro, macroFromEnvironment))
    elseif (type(default) == "string") then
        -- No macro environment variable set, use default
        macroValue = default
    else
        error(string.format("Macro %s not in enviroment with no default value", macro))
    end

    return macroValue
end

function setAsynOptions(device, port, baud, bits, parity, stop)
    --[[
        Sets the Asyn Options

        Args:
            device: String, the name of the asyn port
            port: String, the name of the physical port the device is connected to
            baud: Integer, The baud rate of the device
            bits: Integer, the number of data bits
            parity: String, the device parity
            stop: Integer, the number of stop bits.
    ]]
    iocsh.drvAsynSerialPortConfigure(device, port, 0, 0, 0, 0)
    iocsh.asynSetOption(device, -1, "baud", baud)
    iocsh.asynSetOption(device, -1, "bits", bits)
    iocsh.asynSetOption(device, -1, "parity", parity)
    iocsh.asynSetOption(device, -1, "stop", stop)
end

function setHardwareFlowControl(device, flowControlOn)
    --[[
        Sets hardware flow control

        Args:
            device: String, the name of the asyn port
            flowControlOn: Boolean, true if hardware flow control is on.
    ]]
    if (flowControlOn) then
        iocsh.asynSetOption(device, 0, "clocal", "N")
        iocsh.asynSetOption(device, 0, "crtscts", "Y")
    else
        iocsh.asynSetOption(device, 0, "clocal", "Y")
        iocsh.asynSetOption(device, 0, "crtscts", "N")
    end
end

function setSoftwareFlowControl(device, flowControlOn)
        --[[
        Sets software flow control

        Args:
            device: String, the name of the asyn port
            flowControlOn: Boolean, true if software flow control is on.
    ]]
    if (flowControlOn) then
        asyn.asynSetOption(device, 0, "ixon", "N")
        asyn.asynSetOption(device, 0, "ixoff", "N")
    else
        asyn.asynSetOption(device, 0, "ixon", "Y")
        asyn.asynSetOption(device, 0, "ixoff", "Y")
    end
end

emulator_port = getMacroValue{macro="EMULATOR_PORT", default="57677"}


port = getMacroValue{macro="PORT", default=""}

stream_protocol_path = string.format("%s%s", os.getenv("EDTIC"), "/data")

if(devsim) then
    iocsh.drvAsynIPPortConfigure(device, string.format("%s%s", "localhost:",emulator_port))
elseif(recsim) then
    iocsh.drvAsynSerialPortConfigure(device, port, 0, 1 ,0 ,0)
else
    -- Neither recsim nor devsim
    baud = getMacroValue{macro="BAUD", default="9600"}
    bits = getMacroValue{macro="BITS", default="8"}
    parity = getMacroValue{macro="PARITY", default="none"}
    stop = getMacroValue{macro="STOP", default="1"}

    asyn.setAsynOptions(device, port, baud, bits, parity, stop)

    setHardwareFlowControl(device, false)
    setSoftwareFlowControl(device, false)

end



-- ##ISIS## Run IOC initialisation
iocstartup = getMacroValue{macro="IOCSTARTUP"}
iocsh.iocshLoad(string.format("%s/init.cmd", iocstartup))

device = "L0"
pvprefix = string.format("%s", os.getenv("MYPVPREFIX"))
iocname = os.getenv("IOCNAME")
print(iocname)
p = string.format("%s%s", pvprefix, os.getenv("IOCNAME"))
EDTIC = os.getenv("EDTIC")

recsim = os.getenv("RECSIM") == "1"
devsim = os.getenv("DEVSIM") == "1"


port = getMacroValue{macro="PORT", default="DO_NO_COMMIT_THIS"}

stream_protocol_path = string.format("%s%s", os.getenv("EDTIC"), "/data")

if(devsim) then
    iocsh.drvAsynIPPortConfigure(device, string.format("%s%s", "localhost:",emulator_port))
elseif(recsim) then
    iocsh.drvAsynSerialPortConfigure(device, port, 0, 1 ,0 ,0)
else
    -- Neither recsim nor devsim
    iocsh.drvAsynSerialPortConfigure(device, port, 0, 0, 0, 0)
    iocsh.asynSetOption(device, -1, "baud", getMacroValue{macro="BAUD", default="9600"})
    iocsh.asynSetOption(device, -1, "bits", getMacroValue{macro="BITS", default="8"})
    iocsh.asynSetOption(device, -1, "parity", getMacroValue{macro="PARITY", default="none"})
    iocsh.asynSetOption(device, -1, "stop", getMacroValue{macro="STOP", default="1"})

    -- Hardware flow control off
    iocsh.asynSetOption(device, 0, "clocal", "Y")
    iocsh.asynSetOption(device, 0, "crtscts", "N")
    -- Software flow control off
    iocsh.asynSetOption(device, 0, "ixon", "N")
    iocsh.asynSetOption(device, 0, "ixoff", "N")

end

-- ##ISIS## Load common DB records
iocsh.iocshLoad(string.format("%s/dbload.cmd", iocstartup))


-- Load our record instances

edwardsTicBackingArgs=string.format("PVPREFIX=%s,P=%s:,RECSIM=%s,DISABLE=%s,PORT=%s",
        pvprefix, p, getMacroValue{macro="RECSIM", default="0"}, getMacroValue{macro="DISABLE", default="0"}, port)

iocsh.dbLoadRecords(string.format("%s%s", EDTIC, "/db/edwardsTicBacking.db"),edwardsTicBackingArgs)

print(string.format("Loaded db file %s with %s", "edwardsTicBacking.db", edwardsTicBackingArgs))

for gaugeNum=1, 3, 1 do
    print(gaugeNum)
    gaugeMacro = string.format("USEGAUGE%d", gaugeNum)
    if getMacroValue{macro=gaugeMacro, default="NO"} == "NO" then
        edwardsTicGaugeArgs=string.format("PVPREFIX=%s,P=%s:,GAUGE=%s,RECSIM=%s,DISABLE=%s,PORT=%s",
                                pvprefix, p, string.format("GAUGE%d", gaugeNum), getMacroValue{macro="RECSIM", default="0"}, getMacroValue{macro="DISABLE", default="0"}, port)

        iocsh.dbLoadRecords(string.format("%s%s", EDTIC, "/db/edwardsTicGauge.db"), edwardsTicGaugeArgs)

        print(string.format("Loaded db file %s with %s", "edwardsTicGauge.db", edwardsTicGaugeArgs))

    end
end

edwardsTicTurboArgs=string.format("PVPREFIX=%s,P=%s:,RECSIM=%s,DISABLE=%s,PORT=%s",
        pvprefix, p, getMacroValue{macro="RECSIM", default="0"}, getMacroValue{macro="DISABLE", default="0"}, port)

iocsh.dbLoadRecords(string.format("%s%s", EDTIC, "/db/edwardsTicTurbo.db"), edwardsTicTurboArgs)

print(string.format("Loaded db file %s with %s", "edwardsTicTurbo.db", edwardsTicTurboArgs))


-- ##ISIS## Load common DB records
iocsh.iocshLoad(string.format("%s/preiocinit.cmd", iocstartup))

os.execute(string.format("cd %s/iocboot/%s", getMacroValue{macro="TOP"}, getMacroValue{macro="IOC"} ))
iocsh.iocInit()


--##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
iocsh.iocshLoad(string.format("%s/postiocinit.cmd", iocstartup))
