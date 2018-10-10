#!../../bin/windows-x64/SEPRTR-IOC-01

## You may have to change SEPRTR-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(SEPRTR)/data"
epicsEnvSet "DEVICE" "L0"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/SEPRTR-IOC-01.dbd"
SEPRTR_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

# Load up DB record for talking to the DAQ box
< iocBoot/iocSEPRTR-IOC-01/st-daq.cmd

## Load our record instances
dbLoadRecords("$(SEPRTR)/db/separator.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),IFNOTRECSIM=$(IFNOTRECSIM),IFRECSIM=$(IFRECSIM)")
dbLoadRecords("$(SEPRTR)/db/separator_voltage.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),IFNOTRECSIM=$(IFNOTRECSIM),IFRECSIM=$(IFRECSIM), PSU_MAX_VOLT=$(PSU_MAX_VOLT=200), NELM=$(NELM=100)")
dbLoadRecords("$(SEPRTR)/db/separator_current.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),IFNOTRECSIM=$(IFNOTRECSIM),IFRECSIM=$(IFRECSIM), PSU_MAX_CURR=$(PSU_MAX_CURR=2.5), NELM=$(NELM=100)")
dbLoadRecords("$(SEPRTR)/db/separator_power_status.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),IFNOTRECSIM=$(IFNOTRECSIM),IFRECSIM=$(IFRECSIM), POWER_MIN_VOLT = $(POWER_MIN_VOLT = 2)")
dbLoadRecords("$(SEPRTR)/db/separator_stability.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=$(DEVICE), DISABLE=$(DISABLE=0),RECSIM=$(RECSIM=0), NELM=$(NELM=100), FREQ=$(FREQ=1000), VUPPERLIM=$(VUPPERLIM), VLOWERLIM=$(VLOWERLIM), ISTEADY=$(ISTEADY), ILIMIT=$(ILIMIT), WINDOWSIZE=$(WINDOWSIZE=600), MAXUNSTBL=$(MAXUNSTBL=30)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=dzd77598"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
