#!../../bin/windows-x64/ZFCNTRL-IOC-01

## You may have to change ZFCNTRL-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/ZFCNTRL-IOC-01.dbd"
ZFCNTRL_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
epicsEnvSet("P", "$(MYPVPREFIX)$(IOCNAME):")

dbLoadRecords("$(TOP)/db/zfcntrl.db", "P=$(P),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),MAGNETOMETER_X=$(MAGNETOMETER_X=not_set),MAGNETOMETER_Y=$(MAGNETOMETER_Y=not_set),MAGNETOMETER_Z=$(MAGNETOMETER_Z=not_set)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

seq zero_field, "MAGNETOMETER_X=$(P)MAGNETOMETER:X,MAGNETOMETER_Y=$(P)MAGNETOMETER:Y,MAGNETOMETER_Z=$(P)MAGNETOMETER:Z,STATE=$(P)STATEMACHINE,READINGS_READY=$(P)_READINGS_READY,TRIGGER_READ=$(P)TRIGGER_MAGNETOMETER_READ"
