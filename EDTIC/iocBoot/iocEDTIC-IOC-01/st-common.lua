device = "L0"
pvprefix = string.format("%s", os.getenv("MYPVPREFIX"))
p = string.format("%s%s", os.getenv("MYPVPREFIX"), os.getenv("IOCNAME"))
EDTIC = os.getenv("EDTIC")

recsim = os.getenv("RECSIM") == "1"
devsim = os.getenv("DEVSIM") == "1"

function getMacroValue (options)
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

emulator_port = getMacroValue{macro="EMULATOR_PORT", default="57677"}
iocstartup = getMacroValue{macro="IOCSTARTUP"}

port = getMacroValue{macro="PORT", default=""}

stream_protocol_path = string.format("%s%s", os.getenv("EDTIC"), "/data")

if(devsim) then
    iocsh.drvAsynIPPortConfigure(device, string.format("%s%s", "localhost:",emulator_port))
elseif(recsim) then
    iocsh.drvAsynSerialPortConfigure(device, port, 0, 1 ,0 ,0)
else 
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

-- Load our record instances

edwardsTicBackingArgs=string.format("PVPREFIX=%s,device=%s,RECSIM=%s,DISABLE=%s,PORT=%s",
        pvprefix, p, getMacroValue{macro="RECSIM", default="0"}, getMacroValue{macro="DISABLE", default="0"}, port)

iocsh.dbLoadRecords(string.format("%s%s", EDTIC, "/db/edwardsTicBacking.db"),edwardsTicBackingArgs)

print(string.format("Loaded db file %s with %s", "edwardsTicBacking.db", edwardsTicBackingArgs))

for gaugeNum=1, 3, 1 do
    print(gaugeNum)
    gaugeMacro = string.format("USEGAUGE%d", gaugeNum)
    if getMacroValue{macro=gaugeMacro, default="NO"} == "NO" then
        edwardsTicGaugeArgs=string.format("PVPREFIX=%s,device=%s,GAUGE=%s,RECSIM=%s,DISABLE=%s,PORT=%s",
                                pvprefix, p, string.format("GAUGE%d", gaugeNum), getMacroValue{macro="RECSIM", default="0"}, getMacroValue{macro="DISABLE", default="0"}, port)

        iocsh.dbLoadRecords(string.format("%s%s", EDTIC, "/db/edwardsTicGauge.db"), edwardsTicGaugeArgs)

        print(string.format("Loaded db file %s with %s", "edwardsTicGauge.db", edwardsTicGaugeArgs))

    end
end

edwardsTicTurboArgs=string.format("PVPREFIX=%s,device=%s,RECSIM=%s,DISABLE=%s,PORT=%s",
        pvprefix, p, getMacroValue{macro="RECSIM", default="0"}, getMacroValue{macro="DISABLE", default="0"}, port)

iocsh.dbLoadRecords(string.format("%s%s", EDTIC, "/db/edwardsTicTurbo.db"), edwardsTicTurboArgs)

-- iocsh.iocshLoad()

print(string.format("Loaded db file %s with %s", "edwardsTicTurbo.db", edwardsTicTurboArgs))
