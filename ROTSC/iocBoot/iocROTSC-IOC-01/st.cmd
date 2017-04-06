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

$(IFDEVSIM) freeIPPort("FREEPORT")  
$(IFDEVSIM) epicsEnvShow("FREEPORT") 
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:57677")

$(IFNOTDEVSIM) drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
$(IFNOTDEVSIM) asynSetOption("L0", -1, "baud", "$(BAUD=38400)")
$(IFNOTDEVSIM) asynSetOption("L0", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) asynSetOption("L0", -1, "parity", "$(PARITY=none)") 
$(IFNOTDEVSIM) asynSetOption("L0", -1, "stop", "$(STOP=1)")     
$(IFNOTDEVSIM) asynOctetSetInputEos("L0", -1, "\r")          
$(IFNOTDEVSIM) asynOctetSetOutputEos("L0", -1, "\r")         

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
epicsEnvSet "ERR" "ERR"
epicsEnvSet "CMD_ERR" "CMD_ERR"
dbLoadRecords("db/rotating_sample_changer.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, DISABLE=$(DISABLE=0), RECSIM=$(RECSIM=0), ERR=$(ERR), CMD_ERR=$(CMD_ERR)")
dbLoadRecords("db/error_calculator.db","P=$(MYPVPREFIX)$(IOCNAME):, ERR=$(ERR), DISABLE=$(DISABLE=0), RECSIM=$(RECSIM=0)")
dbLoadRecords("db/error_calculator.db","P=$(MYPVPREFIX)$(IOCNAME):, ERR=$(CMD_ERR), DISABLE=$(DISABLE=0), RECSIM=$(RECSIM=0)")
$(IS_HRPD=##) dbLoadRecords("db/HRPD_specific.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0, DISABLE=$(DISABLE=0), RECSIM=$(RECSIM=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=ffv81422Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
