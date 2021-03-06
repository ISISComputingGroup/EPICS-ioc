#!../../bin/windows-x64-debug/MK3CHOPR-IOC-01

## You may have to change MK3CHOPR-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/MK3CHOPR-IOC-01.dbd"
MK3CHOPR_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# Portname, path to config file, use mock (=1 for mock)
$(IFSIM) mk3DriverConfigure("MK3", "ignored_notneeded.config", 1) # RECSIM or DEVSIM
$(IFNOTSIM) mk3DriverConfigure("MK3", "C:/LabVIEW Modules/Drivers/ISIS MK3 Disc Chopper/MK3_Chopper.config", 0)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load common chopper properties
dbLoadRecords("db/mk3_common.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=MK3, CHANNEL=1, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")

## Translate from old macros for backwards compatibility
## The old macros are only used if the new one is not set
stringiftest("_NUM_SET", "$(NUM_CHANNELS=)")
$(IFNOT_NUM_SET) $(CHOPPER_1_PRESENT=#) epicsEnvSet NUM_CHANNELS 1
$(IFNOT_NUM_SET) $(CHOPPER_2_PRESENT=#) epicsEnvSet NUM_CHANNELS 2
$(IFNOT_NUM_SET) $(CHOPPER_3_PRESENT=#) epicsEnvSet NUM_CHANNELS 3
$(IFNOT_NUM_SET) $(CHOPPER_4_PRESENT=#) epicsEnvSet NUM_CHANNELS 4
$(IFNOT_NUM_SET) $(CHOPPER_5_PRESENT=#) epicsEnvSet NUM_CHANNELS 5

## Load our record instances (conditionally!) 
dbLoadRecordsLoop("db/mk3.db","PVPREFIX=$(MYPVPREFIX), P=$(MYPVPREFIX)$(IOCNAME):, Q=CH\$(I):, PORT=MK3, CHANNEL=\$(I), RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0), I=\$(I), ASG1=$(ASG1=DEFAULT), ASG2=$(ASG2=DEFAULT), ASG3=$(ASG3=DEFAULT), ASG4=$(ASG4=DEFAULT), ASG5=$(ASG5=DEFAULT)", "I", 1, $(NUM_CHANNELS=1), 1)

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
