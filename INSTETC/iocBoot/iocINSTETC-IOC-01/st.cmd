#!../../bin/windows-x64-debug/INSTETC-IOC-01

## @file 
## Configure INSTETC

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/INSTETC-IOC-01.dbd"
INSTETC_IOC_01_registerRecordDeviceDriver pdbbase

## so we don't get lots of messages about puts to the motor moving PV, this logs value changes only rather than all puts which is the default
epicsEnvSet("CAPUTLOGCONFIG","0")

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## configure IOC
instetcConfigure("consoleslog", "${ICPVARDIR}/logs/conserver/consoles-%Y%m%d.log", 100, 3.0)
instetcConfigure("daelog", "${ICPVARDIR}/logs/ioc/ISISDAE_01-%Y%m%d.log", 100, 3.0)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/INSTETC.db","P=$(MYPVPREFIX),IOC=$(IOCNAME)")
dbLoadRecords("db/svn-revision.db","P=$(MYPVPREFIX)")
dbLoadRecords("db/build-id.db","P=$(MYPVPREFIX)")
dbLoadRecords("db/inst_string_parameters.db","P=$(MYPVPREFIX)")
dbLoadRecords("db/inst_real_parameters.db","P=$(MYPVPREFIX)")
dbLoadRecords("db/user_parameters.db","P=$(MYPVPREFIX)")
dbLoadRecords("db/runcontrol.db","P=$(MYPVPREFIX)")
dbLoadRecords("db/experiment_data.db","P=$(MYPVPREFIX)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

# only log value changes
# this command does not seem to be implemented!
#$(IFISISINSTSTARTUP=#) caPutLogReconf 0
