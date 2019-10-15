-- ## Import lua utility functions


package.path = package.path .. ';' .. os.getenv("UTILITIES") .. '/lua/luaUtils.lua;'
local utils = require("luaUtils")
local getMacroValue = utils.getMacroValue
local setAsynOptions = utils.setAsynOptions
local setHardwareFlowControl = utils.setHardwareFlowControl
local setSoftwareFlowControl = utils.setSoftwareFlowControl


-- ## Get required macros and related vars
local oercone = getMacroValue{macro="OERCONE"}
local iocstartup = getMacroValue{macro="IOCSTARTUP"}
local emulator_port = getMacroValue{macro="EMULATOR_PORT", default="57677"}

-- ## Set EPICS environment vars
local device = "L0"

-- ##ISIS## Run IOC initialisation
iocsh.iocshLoad(string.format("%s/init.cmd", iocstartup))

-- Get macros required and related vars that required init.cmd to run
local recsim = getMacroValue{macro="RECSIM", default="0"}
local isRecsim = recsim == "1"
local isDevsim = getMacroValue{macro="DEVSIM", default="0"} == "1"
local pvprefix = string.format("%s", getMacroValue{macro="MYPVPREFIX"})
local disable = getMacroValue{macro="DISABLE", default="0"}
local iocname = getMacroValue{macro="IOCNAME"}

-- ## Device simulation mode IP configuration
if (isDevsim) then
    iocsh.drvAsynIPPortConfigure(device, string.format("localhost:%s", emulator_port))
end

-- ## For recsim:
if (isRecsim) then
    local port = getMacroValue{macro="PORT", default="NUL"}
    iocsh.drvAsynSerialPortConfigure(device, port, 0, 1 ,0 ,0)
end


-- ## For real device:
if (not isRecsim and not isDevsim) then
    local port = getMacroValue{macro="PORT", default="NO_PORT_MACRO"}
    local baud = getMacroValue{macro="BAUD", default="9600"}
    local bits = getMacroValue{macro="BITS", default="8"}
    local parity = getMacroValue{macro="PARITY", default="none"}
    local stop = getMacroValue{macro="STOP", default="1"}
    setAsynOptions(device, port, baud, bits, parity, stop)
    -- Hardware flow control off
    local flowControlOn = false
    setHardwareFlowControl(device, flowControlOn)
    -- Software flow control off
    setSoftwareFlowControl(device, flowControlOn)
end

-- ## Load record instances

-- ##ISIS## Load common DB records
iocsh.iocshLoad(string.format("%s/dbload.cmd", iocstartup))

-- ## Load our record instances
iocsh.dbLoadRecords(
    string.format("%s/db/oercone.db",oercone),
    string.format("PVPREFIX=%s,P=%s%s:,RECSIM=%s,DISABLE=%s,PORT=%s",
     pvprefix, pvprefix, iocname, recsim, disable, device)
)
iocsh.dbLoadRecords(
    string.format("%s/db/unit_setter.db", oercone),
    string.format("P=%s%s:", pvprefix, iocname)
)

-- ##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called
iocsh.iocshLoad(string.format("%s/preiocinit.cmd", iocstartup))

iocsh.iocInit()

-- ##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs
iocsh.iocshLoad(string.format("%s/postiocinit.cmd", iocstartup))
