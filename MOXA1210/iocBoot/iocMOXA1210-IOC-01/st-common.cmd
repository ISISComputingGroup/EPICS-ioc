#!../../bin/linux-x86_64/MX_E12xx_ModbusIOC

## You may have to change MX_E12xx_ModbusIOC to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/MOXA1210-IOC-01.dbd"
MOXA1210_IOC_01_registerRecordDeviceDriver pdbbase

cd ${TOP}/iocBoot/${IOC}

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd


## Startup script
# ### E1240 (8AI) ###
epicsEnvSet("E1210_ASYNPORT","IP")

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("$(E1210_ASYNPORT)", "localhost:$(EMULATOR_PORT=)")

# drvAsynIPPortConfigure("$(E1210_ASYNPORT)", "$(IP_ADDRESS):502", 0, 0, 1)

$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynIPPortConfigure ("$(E1210_ASYNPORT)","$(IP_ADDRESS):502")

modbusInterposeConfig("$(E1210_ASYNPORT)", 0, 2000, 0)

# MOXA E1210 DIs (if NOT counter mode) : function 2 (Read Discrete Inputs), address 0x0, length 16, data_type = UINT16 = 0, # pollMsec = for read func, waits XXX msecs
drvModbusAsynConfigure("$(E1210_ASYNPORT)_DI",             "$(E1210_ASYNPORT)", 0, 2, 0x0,   0xF, 0, 100, "ioLogik")

# MOXA E1210 DIs (if counter mode: start/stop counter) : function 5 (Write Single Coil), address 0x0100, length 16, data_type = UINT16 = 0, # pollMsec = for read func, waits XXX msecs
drvModbusAsynConfigure("$(E1210_ASYNPORT)_DICNT_S",        "$(E1210_ASYNPORT)", 0, 5, 0x0100,   0xF, 0, 1, "ioLogik")

# MOXA E1210 DIs (if counter mode: start/stop counter) : function 1 (Read Coils), address 0x0100, length 16, data_type = UINT16 = 0, # pollMsec = for read func, waits XXX msecs
drvModbusAsynConfigure("$(E1210_ASYNPORT)_DICNT_S_RBV",    "$(E1210_ASYNPORT)", 0, 1, 0x0100,   0xF, 0, 500, "ioLogik")

# MOXA E1210 DIs (if counter mode: clear counter) : function 5 (Write Single Coil), address 0x0110, length 16, data_type = UINT16 = 0, # pollMsec = for read func, waits XXX msecs
# (RBV is always 0)
drvModbusAsynConfigure("$(E1210_ASYNPORT)_DICNT_CLR",      "$(E1210_ASYNPORT)", 0, 5, 0x0110,   0xF, 0, 1, "ioLogik")

# MOXA E1210 DIs (if counter mode: counter value) : function 4 (Read Input Registers), address 0x0010, 0x10 double words => length 0x20, data_type = INT32_BE = 6, # pollMsec = for read func, waits XXX msecs
drvModbusAsynConfigure("$(E1210_ASYNPORT)_DICNT",          "$(E1210_ASYNPORT)", 0, 4, 0x0010,   0x20, 6, 500, "ioLogik")

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd


dbLoadRecords("$(MOXA1210)/db/ioLogik_E1210.db","NAME=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E1210_ASYNPORT)")

asynSetTraceIOMask("$(E1210_ASYNPORT)_DI",-1,4)
asynSetTraceMask("$(E1210_ASYNPORT)_DI",-1,9)

asynSetTraceIOMask("$(E1210_ASYNPORT)_DICNT_S",-1,4)
asynSetTraceMask("$(E1210_ASYNPORT)_DICNT_S",-1,9)

asynSetTraceIOMask("$(E1210_ASYNPORT)_DICNT_S_RBV",-1,4)
asynSetTraceMask("$(E1210_ASYNPORT)_DICNT_S_RBV",-1,9)

asynSetTraceIOMask("$(E1210_ASYNPORT)_DICNT_CLR",-1,4)
asynSetTraceMask("$(E1210_ASYNPORT)_DICNT_CLR",-1,9)

asynSetTraceIOMask("$(E1210_ASYNPORT)_DICNT",-1,4)
asynSetTraceMask("$(E1210_ASYNPORT)_DICNT",-1,9)

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd


cd ${TOP}/iocBoot/${IOC}
iocInit()
#< startup.postscript

# has to wait for a second !
epicsThreadSleep 1

#
## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
