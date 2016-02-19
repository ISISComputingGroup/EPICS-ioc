#!../../bin/windows-x64-debug/DELFTBPMAG-IOC-01

## You may have to change DELFTBPMAG-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/DELFTBPMAG-IOC-01.dbd"
DELFTBPMAG_IOC_01_registerRecordDeviceDriver pdbbase

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TOP)/data"
epicsEnvSet "TTY" "$(TTY=COM17)"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

drvAsynSerialPortConfigure("L0", "$(TTY)", 0, 0, 0, 0)
asynSetOption("L0", -1, "baud", "9600")
asynSetOption("L0", -1, "bits", "8")
asynSetOption("L0", -1, "parity", "none")
asynSetOption("L0", -1, "stop", "1")
asynOctetSetInputEos("L0", -1, ";") 
asynOctetSetOutputEos("L0", -1, "*") 
#asynSetTraceIOMask("L0",-1,0x2) 
#asynSetTraceMask("L0",-1,0x9) 

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/DELFTBPMAG-IOC-01.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,PORT=L0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
