#!../../bin/windows-x64/INSTRON-IOC-01

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(INSTRON)\db"
epicsEnvSet "DEVICE" "L0"

## You may have to change INSTRON-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)



cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/INSTRON-IOC-01.dbd"
INSTRON_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# $(IFNOTRECSIM) $(IFDEVSIM) freeIPPort("FREEPORT")  
# $(IFNOTRECSIM) $(IFDEVSIM) epicsEnvShow("FREEPORT") 
# $(IFNOTRECSIM) $(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(FREEPORT=0)")
$(IFNOTRECSIM) $(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:57677")

$(IFNOTDEVSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=$(FREEPORT=0))", 0, 0, 0, 0)
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")
$(IFNOTDEVSIM) asynOctetSetInputEos("$(DEVICE)", -1, "$(OEOS=\r\n)")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/controls.db", "P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
