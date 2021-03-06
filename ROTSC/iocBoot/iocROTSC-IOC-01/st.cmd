#!../../bin/windows-x64/ROTSC-IOC-01

## You may have to change ROTSC-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(ROTSC)/data"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/ROTSC-IOC-01.dbd"
ROTSC_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation
< $(IOCSTARTUP)/init.cmd
epicsEnvSet("DEVICE", "L0")

$(IFDEVSIM) freeIPPort("FREEPORT")
$(IFDEVSIM) epicsEnvShow("FREEPORT")
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

$(IFNOTDEVSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT)", 0, 0, 0, 0)
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=38400)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")
$(IFNOTDEVSIM) asynOctetSetInputEos("$(DEVICE)", -1, "\r")
$(IFNOTDEVSIM) asynOctetSetOutputEos("$(DEVICE)", -1, "\r")

## Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"crtscts","N")

## Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixon","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixoff","N")

## Load record instances

#asynSetTraceIOMask("$(DEVICE)",0,2)
#asynSetTraceMask("$(DEVICE)",0,255)

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd

stringiftest  "HRPD_VERSION"  "$(VERSION=0)"  5  "1"

## Load our record instances
epicsEnvSet "ERR" "ERR"
epicsEnvSet "CMD_ERR" "CMD_ERR"

dbLoadRecords("$(ROTSC)/db/rotating_sample_changer.db","P=$(MYPVPREFIX)$(IOCNAME):, VERSION=$(VERSION=0), PORT=$(DEVICE), DISABLE=$(DISABLE=0), RECSIM=$(RECSIM=0), ERR=$(ERR), CMD_ERR=$(CMD_ERR)")
dbLoadRecords("$(ROTSC)/db/error_calculator.db","P=$(MYPVPREFIX)$(IOCNAME):, ERR=$(ERR), DISABLE=$(DISABLE=0), RECSIM=$(RECSIM=0)")
$(IFHRPD_VERSION) dbLoadRecords("$(ROTSC)/db/error_calculator.db","P=$(MYPVPREFIX)$(IOCNAME):, ERR=$(CMD_ERR), DISABLE=$(DISABLE=0), RECSIM=$(RECSIM=0)")
$(IFHRPD_VERSION) dbLoadRecords("$(ROTSC)/db/HRPD_specific.db","P=$(MYPVPREFIX)$(IOCNAME):, CMD_ERR=$(CMD_ERR), PORT=$(DEVICE), DISABLE=$(DISABLE=0), RECSIM=$(RECSIM=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
seq rotsc,"P=$(MYPVPREFIX)$(IOCNAME):"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs
< $(IOCSTARTUP)/postiocinit.cmd
