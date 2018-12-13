#!../../bin/windows-x64/IPS-IOC-01

## You may have to change IPS-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(IPS)/data"
epicsEnvSet "DEVICE" "L0"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/IPS-IOC-01.dbd"
IPS_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "baud", "9600")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "8")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "none")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "stop", "2")

# Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")

# Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

epicsEnvSet("P", "$(MYPVPREFIX)$(IOCNAME):")

## Load our record instances
dbLoadRecords("db/ips.db","PVPREFIX=$(MYPVPREFIX),P=$(P),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),MAX_FIELD=7.0,MAX_SWEEP_RATE=1.0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
seq cryomagnet, "FIELD=$(P)FIELD,FIELD_SETPOINT=$(P)FIELD:SP,FIELD_SETPOINT_ALARM=$(P)FIELD:SP.SEVR,FIELD_SETPOINT_READBACK=$(P)FIELD:SP:RBV,FIELD_SETPOINT_RAW=$(P)FIELD:SP:_RAW,PERSISTENT=$(P)PERSISTENT,MAGNET_FIELD=$(P)MAGNET:FIELD:PERSISTENT,HEATER_STATUS=$(P)HEATER:STATUS,HEATER_STATUS_SP=$(P)HEATER:STATUS:SP,HEATER_WAIT_TIME=$(P)HEATER:WAITTIME,ACTIVITY=$(P)ACTIVITY,ACTIVITY_SP=$(P)ACTIVITY:SP,SWEEPMODE=$(P)SWEEPMODE:PARAMS,SWEEPMODE_SP=$(P)SWEEPMODE:PARAMS:SP,SUPPLYVOLTAGE_STABLE=$(P)SUPPLY:VOLT:STABLE,SWEEP_ACTIVE=$(P)STS:SWEEPMODE:SWEEP,STATEMACHINE=$(P)STATEMACHINE"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
