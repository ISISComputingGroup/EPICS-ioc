#!../../bin/windows-x64-debug/ECLAB-IOC-01

## You may have to change ECLabTest to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/ECLAB-IOC-01.dbd"
ECLAB_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# pass "SIM" as ip address for simulation mode
$(IFSIM)    ECLabConfigure("port1", "SIM")
$(IFNOTSIM) ECLabConfigure("port1", "$(IPADDR=127.0.0.1)")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(ECLAB)/db/ECLab.db","P=$(MYPVPREFIX),Q=$(IOCNAME),PORT=port1,CHAN=0")
dbLoadRecords("$(ECLAB)/db/ECLabIntegerParams.db","P=$(MYPVPREFIX),Q=$(IOCNAME),PORT=port1,CHAN=0")
dbLoadRecords("$(ECLAB)/db/ECLabBooleanParams.db","P=$(MYPVPREFIX),Q=$(IOCNAME),PORT=port1,CHAN=0")
dbLoadRecords("$(ECLAB)/db/ECLabSingleParams.db","P=$(MYPVPREFIX),Q=$(IOCNAME),PORT=port1,CHAN=0")
dbLoadRecords("$(ECLAB)/db/ECLabIntegerArrayParams.db","P=$(MYPVPREFIX),Q=$(IOCNAME),PORT=port1,CHAN=0")
dbLoadRecords("$(ECLAB)/db/ECLabBooleanArrayParams.db","P=$(MYPVPREFIX),Q=$(IOCNAME),PORT=port1,CHAN=0")
dbLoadRecords("$(ECLAB)/db/ECLabSingleArrayParams.db","P=$(MYPVPREFIX),Q=$(IOCNAME),PORT=port1,CHAN=0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
