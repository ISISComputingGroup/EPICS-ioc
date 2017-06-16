#!../../bin/windows-x64-debug/TEKAFG3XXX-IOC-02

## You may have to change TEKAFG3XXX-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TEKAFG3XXX)/data"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/TEKAFG3XXX-IOC-02.dbd"
TEKAFG3XXX_IOC_02_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

vxi11Configure("GPIB0", "130.246.49.179", 0, 0.0,"inst0", 0, 0)
#asynSetTraceIOMask("GPIB0",0,2)
#asynSetTraceMask("GPIB0",0,255)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/devAFG3XXX.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=GPIB0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=mjc23Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
