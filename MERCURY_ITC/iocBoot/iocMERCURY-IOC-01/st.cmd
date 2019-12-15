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


epicsEnvSet(SIM1, " ")
epicsEnvSet(SIM2, " ")
epicsEnvSet(SIM3, " ")
epicsEnvSet(SIM4, " ")
epicsEnvSet(SIM5, " ")
epicsEnvSet(SIM6, " ")
epicsEnvSet(DISABLE1, " ")
epicsEnvSet(DISABLE2, " ")
epicsEnvSet(DISABLE3, " ")
epicsEnvSet(DISABLE4, " ")
epicsEnvSet(DISABLE5, " ")
epicsEnvSet(DISABLE6, " ")
epicsEnvSet(DISABLE7, " ")
epicsEnvSet(DISABLE8, " ")

epicsEnvSet(TEMP_NUM,1)
< $(MERCURY_ITC)/iocBoot/iocMercuryiTC/st-temp.cmd

epicsEnvSet(TEMP_NUM,2)
< $(MERCURY_ITC)/iocBoot/iocMercuryiTC/st-temp.cmd

epicsEnvSet(TEMP_NUM,3)
< $(MERCURY_ITC)/iocBoot/iocMercuryiTC/st-temp.cmd

epicsEnvSet(TEMP_NUM,4)
< $(MERCURY_ITC)/iocBoot/iocMercuryiTC/st-temp.cmd

epicsEnvSet(LEVEL_NUM,1)
< $(MERCURY_ITC)/iocBoot/iocMercuryiTC/st-level.cmd

epicsEnvSet(LEVEL_NUM,2)
< $(MERCURY_ITC)/iocBoot/iocMercuryiTC/st-level.cmd

epicsEnvSet(PRESSURE_NUM,1)
< $(MERCURY_ITC)/iocBoot/iocMercuryiTC/st-pressure.cmd

epicsEnvSet(PRESSURE_NUM,2)
< $(MERCURY_ITC)/iocBoot/iocMercuryiTC/st-pressure.cmd


dbLoadRecords("db/MercuryGlobal.db", "P=$(MYPVPREFIX)$(IOCNAME):, SIM1=$(SIM1), SIM2=$(SIM2), SIM3=$(SIM3), SIM4=$(SIM4), SIM5=$(SIM5), SIM6=$(SIM6), DISABLE1=$(DISABLE1), DISABLE2=$(DISABLE2), DISABLE3=$(DISABLE3), DISABLE4=$(DISABLE4), DISABLE5=$(DISABLE5), DISABLE6=$(DISABLE6), DISABLE7=$(DISABLE7), DISABLE8=$(DISABLE8)")


##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=hgv27692Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
