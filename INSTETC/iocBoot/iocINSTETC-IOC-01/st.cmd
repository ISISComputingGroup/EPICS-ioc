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

## Check for extra exclusive records
stringtest("IFEX1", "$(EXCLUSIVE1=)")
stringtest("IFEX2", "$(EXCLUSIVE2=)")
stringtest("IFEX3", "$(EXCLUSIVE3=)")
stringtest("IFEX4", "$(EXCLUSIVE4=)")

## Load our record instances
dbLoadRecords("db/INSTETC.db","P=$(MYPVPREFIX),IOC=$(IOCNAME)")
dbLoadRecords("db/svn-revision.db","P=$(MYPVPREFIX)")
dbLoadRecords("db/build-id.db","P=$(MYPVPREFIX)")
dbLoadRecords("db/inst_string_parameters.db","P=$(MYPVPREFIX)")
dbLoadRecords("db/inst_alias_string_parameters.db","P=$(MYPVPREFIX)")
dbLoadRecords("db/inst_real_parameters.db","P=$(MYPVPREFIX)")
dbLoadRecords("db/user_parameters.db","P=$(MYPVPREFIX)")
dbLoadRecords("db/experiment_data.db","P=$(MYPVPREFIX)")
$(IFEX1) dbLoadRecords("db/inst_exclusive.db","P=$(MYPVPREFIX),ID=$(EXCLUSIVE1=)")
$(IFEX2) dbLoadRecords("db/inst_exclusive.db","P=$(MYPVPREFIX),ID=$(EXCLUSIVE2=)")
$(IFEX3) dbLoadRecords("db/inst_exclusive.db","P=$(MYPVPREFIX),ID=$(EXCLUSIVE3=)")
$(IFEX4) dbLoadRecords("db/inst_exclusive.db","P=$(MYPVPREFIX),ID=$(EXCLUSIVE4=)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
sqlexec "$(IOCSTARTUP)/facility_pvs.sql"

# only log value changes
# this command does not seem to be implemented!
#$(IFISISINSTSTARTUP=#) caPutLogReconf 0
