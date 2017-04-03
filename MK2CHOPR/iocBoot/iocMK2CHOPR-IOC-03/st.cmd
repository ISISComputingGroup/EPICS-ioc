#!../../bin/windows-x64/MK2CHOPR-IOC-03

## You may have to change MK2CHOPR-IOC-03 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(MK2CHOPR)/data"
epicsEnvSet "DEVICE" "L0"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/MK2CHOPR-IOC-03.dbd"
MK2CHOPR_IOC_03_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd

## For emulator use:
$(IFDEVSIM) freeIPPort("FREEPORT")  
$(IFDEVSIM) epicsEnvShow("FREEPORT") 
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(FREEPORT=0)")

$(IFNOTDEVSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT)", 0, 0, 0, 0)
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=7)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=even)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")
$(IFNOTDEVSIM) asynOctetSetInputEos("$(DEVICE)", -1, "$(OEOS=\r)")
$(IFNOTDEVSIM) asynOctetSetOutputEos("$(DEVICE)", -1, "$(IEOS=\r)")

## Load record instances

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/MK2CHOPR.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=$(DEVICE)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs
< $(IOCSTARTUP)/postiocinit.cmd
