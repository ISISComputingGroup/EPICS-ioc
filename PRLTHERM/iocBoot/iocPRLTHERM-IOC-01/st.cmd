#!../../bin/windows-x64/PRLTHERM-IOC-01

## You may have to change PRLTHERM-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(PRLTHERM)/data"
epicsEnvSet "DEVICE" "L0"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/PRLTHERM-IOC-01.dbd"
PRLTHERM_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## calling common command file in ioc 01 boot dir
# < ${TOP}/iocBoot/iocPRLTHERM-IOC-01/st-common.cmd

# Load DB record for talking to the cDAQ chassis
< iocBoot/iocPRLTHERM-IOC-01/st-daq.cmd

# ----------------------------------

## Load our record instances
dbLoadRecords("$(PRLTHERM)/db/prltherm.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),IFNOTRECSIM=$(IFNOTRECSIM),IFRECSIM=$(IFRECSIM)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=dzd77598"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

# DAQmxStart("L0")
DAQmxStart("$(DEVICE)")  # try to use pre-defined env variable
