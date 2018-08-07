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
epicsEnvSet("E1240_ASYNPORT","RIO252")
drvAsynIPPortConfigure("$(E1240_ASYNPORT)", "127.0.0.1:502", 0, 0, 1)

modbusInterposeConfig("$(E1240_ASYNPORT)", 0, 2000, 0)

# MOXA E1240 AIs: function 4, address 0x0, 0x8 words , data_type = UINT16 = 0, 
#drvModbusAsynConfigure("$(E1240_ASYNPORT)_AI", "$(E1240_ASYNPORT)", 0, 4, 0x000, 0x8, 0, 100, "ioLogik")

# MOXA E1240 Current mode status: function 4, address 0x3c, 0x8 words , data_type = UINT16 = 0, 
#drvModbusAsynConfigure("$(E1240_ASYNPORT)_AI_St", "$(E1240_ASYNPORT)", 0, 4, 0x3c, 0x8, 0, 500, "ioLogik")

# MOXA E1240 Current mode settings read: function 3, address 0x18, 0x8 words , data_type = UINT16 = 0, 
drvModbusAsynConfigure("$(E1240_ASYNPORT)_AIMR", "$(E1240_ASYNPORT)", 0, 3, 0x18, 0x8, 0, 500, "ioLogik")

# MOXA E1240 Current mode settings write: function 6, address 0x18, 0x8 words , data_type = UINT16 = 0, 
drvModbusAsynConfigure("$(E1240_ASYNPORT)_AIMW", "$(E1240_ASYNPORT)", 0, 6, 0x18, 0x8, 0, 1, "ioLogik")

# MOXA E1240 Burn out value read (float - two words): function 3, address 0x28, 0x8 double words => 0x10, data_type = FLOAT32_LE = 7, 
drvModbusAsynConfigure("$(E1240_ASYNPORT)_BOR", "$(E1240_ASYNPORT)", 0, 3, 0x0028, 0x10, 7, 500, "ioLogik")

# MOXA E1240 Burn out value write (float - two words): function 16 write multiple regs, address 0x28, 0x8 double words => 0x10 , data_type = FLOAT32_LE = 7, 
drvModbusAsynConfigure("$(E1240_ASYNPORT)_BOW", "$(E1240_ASYNPORT)", 0, 16, 0x0028, 0x10, 7, 1, "ioLogik")

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd


dbLoadRecords("$(MOXA1210)/db/ioLogik_E1240.db","NAME=$(MYPVPREFIX)$(IOCNAME):, ASYNPORT=$(E1240_ASYNPORT)")
dbLoadRecords("$(MOXA1210)/db/MX_E12xx_app_dep_addons.template","NAME=$(MYPVPREFIX)$(IOCNAME):, ASYNPORT=$(E1240_ASYNPORT)")

# Enable ASYN_TRACEIO_HEX on octet server
asynSetTraceIOMask("$(E1240_ASYNPORT)",-1,4)
# Enable ASYN_TRACE_ERROR and ASYN_TRACEIO_DRIVER on octet server
#asynSetTraceMask("$(E1240_ASYNPORT)",-1,9)

asynSetTraceIOMask("$(E1240_ASYNPORT)_AI",-1,4)
asynSetTraceMask("$(E1240_ASYNPORT)_AI",-1,9)
asynSetTraceIOMask("$(E1240_ASYNPORT)_AI_St",-1,4)
asynSetTraceMask("$(E1240_ASYNPORT)_AI_St",-1,9)
asynSetTraceIOMask("$(E1240_ASYNPORT)_AIMR",-1,4)
asynSetTraceMask("$(E1240_ASYNPORT)_AIMR",-1,9)
asynSetTraceIOMask("$(E1240_ASYNPORT)_AIMW",-1,4)
asynSetTraceMask("$(E1240_ASYNPORT)_AIMW",-1,9)
asynSetTraceIOMask("$(E1240_ASYNPORT)_BOR",-1,4)
asynSetTraceMask("$(E1240_ASYNPORT)_BOR",-1,9)
asynSetTraceIOMask("$(E1240_ASYNPORT)_BOW",-1,4)
asynSetTraceMask("$(E1240_ASYNPORT)_BOW",-1,9)

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
