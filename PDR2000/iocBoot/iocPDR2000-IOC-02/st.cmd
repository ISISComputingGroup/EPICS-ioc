#!../../bin/windows-x64/PDR2000-IOC-02

## You may have to change PDR2000-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(PDR2000)/data"
epicsEnvSet "DEVICE" "L0"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/PDR2000-IOC-02.dbd"
PDR2000_IOC_02_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

## For running emulator
#drvAsynIPPortConfigure("$(DEVICE)", "localhost:51891")

drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT)", 0, 0, 0, 0)
asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=9600)")
asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")
asynOctetSetInputEos("$(DEVICE)", -1, "$(OEOS=\n)")
## asynOctetSetOutputEos("$(DEVICE)", -1, "$(IEOS=\n)")

## Load record instances

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/PDR2000.db","P=$(MYPVPREFIX)$(IOCNAME):, port=$(DEVICE), RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")
#dbLoadRecords("db/xxx.db","user=iew83206Host")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=iew83206Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs
< $(IOCSTARTUP)/postiocinit.cmd
