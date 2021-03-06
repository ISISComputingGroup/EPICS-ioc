#!../../bin/windows-x64/MUONJAWS-IOC-01
## You may have to change MUONJAWS-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

epicsEnvSet(IOC_NUM,1)
## Register all support components
dbLoadDatabase "dbd/MUONJAWS-IOC-01.dbd"
MUONJAWS_IOC_01_registerRecordDeviceDriver pdbbase

# Configure lvDCOM interface
lvDCOMConfigure("lvfp", "frontpanel", "${MUONJAWS}/data/lv_MuonJaws.xml", "$(LVDCOM_HOST="")", $(LVDCOM_OPTIONS=2))

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

dbLoadRecords("$(MUONJAWS)/db/MuonJaws.db", "P=$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
