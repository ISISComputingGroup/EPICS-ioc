#!../../bin/windows-x64/MERCURY-IOC-01
## You may have to change MERCURY-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

epicsEnvSet(IOC_NUM,1)
## Register all support components
dbLoadDatabase "dbd/MERCURY-IOC-01.dbd"
MERCURY_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

epicsEnvSet(TEMP_NUM,1)
< $(MERCURY_ITC)/iocBoot/iocMercuryiTC/st-temp.cmd

epicsEnvSet(TEMP_NUM,2)
< $(MERCURY_ITC)/iocBoot/iocMercuryiTC/st-temp.cmd

epicsEnvSet(TEMP_NUM,3)
< $(MERCURY_ITC)/iocBoot/iocMercuryiTC/st-temp.cmd

epicsEnvSet(TEMP_NUM,4)
< $(MERCURY_ITC)/iocBoot/iocMercuryiTC/st-temp.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=hgv27692Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
