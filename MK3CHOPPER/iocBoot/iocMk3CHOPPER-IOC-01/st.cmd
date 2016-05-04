#!../../bin/windows-x64-debug/MK3CHOPPER-IOC-01

## You may have to change MK3CHOPPER-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/MK3CHOPPER-IOC-01.dbd"
MK3CHOPPER_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# Portname, path to config file, use mock (=1 for mock)
mk3DriverConfigure("MK3", "C:/LabVIEW Modules/Drivers/ISIS MK3 Disc Chopper/MK3_Chopper.config", 0)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/mk3.db","P=$(MYPVPREFIX)$(IOCNAME):, Q=CH1:, PORT=MK3, CHANNEL=1")
#dbLoadRecords("db/mk3.db","P=$(MYPVPREFIX)$(IOCNAME):, Q=CH2:, PORT=MK3, CHANNEL=2")
#dbLoadRecords("db/mk3.db","P=$(MYPVPREFIX)$(IOCNAME):, Q=CH3:, PORT=MK3, CHANNEL=3")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
