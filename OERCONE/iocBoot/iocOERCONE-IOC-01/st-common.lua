-- ## Import lua utility functions

package.path = package.path .. ';' .. os.getenv("UTILITIES") .. '/lua/luaUtils.lua;'
ibex_utils = require "luaUtils"

function oercone_stcommon_main()
    -- ## Get required macros and related vars
    local oercone = ibex_utils.getMacroValue{macro="OERCONE"}
    local iocstartup = ibex_utils.getMacroValue{macro="IOCSTARTUP"}
    local emulator_port = ibex_utils.getMacroValue{macro="EMULATOR_PORT", default="57677"}

    -- ## Set EPICS environment vars
    iocsh.epicsEnvSet("STREAM_PROTOCOL_PATH", string.format("%s/data", oercone))
    local device = "L0"
    iocsh.epicsEnvSet("DEVICE", device)

    -- ##ISIS## Run IOC initialisation
    iocsh.iocshLoad(string.format("%s/init.cmd", iocstartup))

    -- Get macros required and related vars that required init.cmd to run
    local recsim = ibex_utils.getMacroValue{macro="RECSIM", default="0"}
    local isRecsim = recsim == "1"
    local isDevsim = ibex_utils.getMacroValue{macro="DEVSIM", default="0"} == "1"
    local disable = ibex_utils.getMacroValue{macro="DISABLE", default="0"}
    local iocname = ibex_utils.getMacroValue{macro="IOCNAME"}
    local pvprefix = ibex_utils.getMacroValue{macro="MYPVPREFIX"}

    -- ## Device simulation mode IP configuration
    if (isDevsim) then
        iocsh.drvAsynIPPortConfigure(device, string.format("localhost:%s", emulator_port))
    end

    -- ## For recsim:
    if (isRecsim) then
        local port = ibex_utils.getMacroValue{macro="PORT", default="NUL"}
        iocsh.drvAsynSerialPortConfigure(device, port, 0, 1 ,0 ,0)
    end

    -- ## For real device:
    if (not isRecsim and not isDevsim) then
        local port = ibex_utils.getMacroValue{macro="PORT", default="NO_PORT_MACRO"}
        local baud = ibex_utils.getMacroValue{macro="BAUD", default="9600"}
        local bits = ibex_utils.getMacroValue{macro="BITS", default="8"}
        local parity = ibex_utils.getMacroValue{macro="PARITY", default="none"}
        local stop = ibex_utils.getMacroValue{macro="STOP", default="1"}
        ibex_utils.setAsynOptions(device, port, baud, bits, parity, stop)
        -- Hardware flow control off
        local flowControlOn = false
        ibex_utils.setHardwareFlowControl(device, flowControlOn)
        -- Software flow control off
        ibex_utils.setSoftwareFlowControl(device, flowControlOn)
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
end

oercone_stcommon_main()
