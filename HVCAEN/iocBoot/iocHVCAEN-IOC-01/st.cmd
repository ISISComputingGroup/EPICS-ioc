#!../../bin/windows-x64-debug/HVCAEN-IOC-01

## You may have to change HVCAEN-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/HVCAEN-IOC-01.dbd"
HVCAEN_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# use -D argument to turn on debugging

## arguments to CAENx527ConfigureCreate are: name, ip_address, username, password
## username, password are optional and the crate factory default is used if these are not specified
CAENx527ConfigureCreate "hv0", "$(HVCAENIP0)"
CAENx527ConfigureCreate "hv1", "$(HVCAENIP1)"
CAENx527ConfigureCreate "hv2", "$(HVCAENIP2)"
CAENx527ConfigureCreate "hv3", "$(HVCAENIP3)"
CAENx527ConfigureCreate "hv4", "$(HVCAENIP4)"
CAENx527ConfigureCreate "hv5", "$(HVCAENIP5)"
CAENx527ConfigureCreate "hv6", "$(HVCAENIP6)"
CAENx527ConfigureCreate "hv7", "$(HVCAENIP7)"

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
#dbLoadRecords("db/xxx.db","user=faa59Host")
CAENx527DbLoadRecords("P=$(MYPVPREFIX)CAEN, ALARM_WHEN_ON=$(ALARM_WHEN_ON=NO_ALARM), ALARM_WHEN_RAMPING=$(ALARM_WHEN_RAMPING=NO_ALARM)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

seq sncSummary, "P=$(MYPVPREFIX)CAEN"
