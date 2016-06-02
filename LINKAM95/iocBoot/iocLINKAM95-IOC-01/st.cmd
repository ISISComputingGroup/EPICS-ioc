#!../../bin/windows-x64/LINKAM95-IOC-01

## You may have to change LINKAM95-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LINKAM95)/linkam95Sup"
##epicsEnvSet "LINKAM_PORT" "$(TTY=\\\\\\\\.\\\\COM19)"
epicsEnvSet "DEVICE" "L0"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/LINKAM95-IOC-01.dbd"
LINKAM95_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT)", 0, 0, 0, 0)
asynSetOption("$(DEVICE)", -1, "baud", "19200")
asynSetOption("$(DEVICE)", -1, "bits", "8")
asynSetOption("$(DEVICE)", -1, "parity", "none")
asynSetOption("$(DEVICE)", -1, "stop", "1")
asynOctetSetInputEos("$(DEVICE)", -1, "\r")
asynOctetSetOutputEos("$(DEVICE)", -1, "\r")

## Load record instances

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/LINKAM95.db","P=T95:, port=$(DEVICE)")
#dbLoadRecords("db/xxx.db","user=iew83206Host")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=iew83206Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs
< $(IOCSTARTUP)/postiocinit.cmd
