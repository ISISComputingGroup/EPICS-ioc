#!../../bin/windows-x64/FERMCHOP-IOC-01

## You may have to change FERMCHOP-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(FERMCHOP)/data"
epicsEnvSet "DEVICE" "L0"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/FERMCHOP-IOC-01.dbd"
FERMCHOP_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## For unit testing:
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=)")

## For normal devsim:
# $(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:57677")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

epicsEnvSet "P" "$(MYPVPREFIX)$(IOCNAME):"

## Load our record instances
dbLoadRecords("db/fermchop.db","PVPREFIX=$(MYPVPREFIX),P=$(P),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),ASG=$(ASG=DEFAULT)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
seq keep_sp_and_rbv_in_sync, "SETPOINT=$(P)DELAY:SP,READBACK=$(P)DELAY:SP:RBV,TOLERANCE=$(P)DELAY:_SEQ_TOL,DELAY=$(P)DELAY:_SEQ_DELAY"
seq keep_sp_and_rbv_in_sync, "SETPOINT=$(P)GATEWIDTH:SP,READBACK=$(P)GATEWIDTH,TOLERANCE=$(P)GATEWIDTH:_SEQ_TOL,DELAY=$(P)GATEWIDTH:_SEQ_DELAY"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
