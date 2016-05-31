#!../../bin/windows-x64/LINKHAM95-IOC-01

## You may have to change LINKHAM95-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "TTY" "$(TTY=\\\\\\\\.\\\\COM19)"
epicsEnvSet "PORT" "L0"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/LINKHAM95-IOC-01.dbd"
LINKHAM95_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

drvAsynSerialPortConfigure("$(PORT)", "$(TTY)", 0, 0, 0, 0)
asynSetOption("$(PORT)", -1, "baud", "19200")
asynSetOption("$(PORT)", -1, "bits", "8")
asynSetOption("$(PORT)", -1, "parity", "none")
asynSetOption("$(PORT)", -1, "stop", "1")
# ASK: asynOctetSetInputEos("$(PORT)", -1, "\r")
# ASK: asynOctetSetOutputEos("$(PORT)", -1, "\r")


## Load record instances

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
#dbLoadRecords("db/xxx.db","user=iew83206Host")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=iew83206Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs
< $(IOCSTARTUP)/postiocinit.cmd
