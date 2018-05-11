#!../../bin/windows-x64/INHIBITR-IOC-01

## You may have to change INHIBITR-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/INHIBITR-IOC-01.dbd"
INHIBITR_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
#dbLoadRecords("db/xxx.db","user=ynq66733Host")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

# These PVs will make it so the inhibitor will only let one motor be non-zero at a time

#epicsEnvSet(PVONE,$(MYPVPREFIX)MOT:MTR0407)
#epicsEnvSet(PVTWO,$(MYPVPREFIX)MOT:MTR0408)
#epicsEnvSet(PVONE_DISP,$(MYPVPREFIX)MOT:MTR0407.DISP)
#epicsEnvSet(PVTWO_DISP,$(MYPVPREFIX)MOT:MTR0408.DISP)

## Start any sequence programs
seq sncSummary, "PVONE=$(PVONE)"
