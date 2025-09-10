#!../../bin/windows-x64-debug/HVCAEN-IOC-01

## You may have to change HVCAEN-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/HVCAENSIM-IOC-01.dbd"
HVCAENSIM_IOC_01_registerRecordDeviceDriver pdbbase

calc("NCHANSUMMCHAR","$(NCHANSUMM=200)*40", 1, 2)

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

$(IFREADONLY= ) epicsEnvSet CAN_WRITE "#"

# use -D argument to turn on debugging

## arguments to CAENx527ConfigureCreate are: name, ip_address, username, password
## username, password are optional and the crate factory default is used if these are not specified
## we are in simulatiomn mode, so IP address is ignored
CAENx527ConfigureCreate "hv0", "127.0.0.1"
#CAENx527ConfigureCreate "hv1", "halldcaenhv1"

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
#dbLoadRecords("db/xxx.db","user=faa59Host")
$(CAN_WRITE= ) CAENx527DbLoadRecords("P=$(MYPVPREFIX)CAEN, ALARM_WHEN_ON=$(ALARM_WHEN_ON=NO_ALARM), ALARM_WHEN_RAMPING=$(ALARM_WHEN_RAMPING=NO_ALARM), ASG=READONLY", NCHANSUMM=$(NCHANSUMM=200), NCHANSUMMCHAR=$(NCHANSUMMCHAR)")
$(IFREADONLY= ) CAENx527DbLoadRecords("P=$(MYPVPREFIX)CAEN, ALARM_WHEN_ON=$(ALARM_WHEN_ON=NO_ALARM), ALARM_WHEN_RAMPING=$(ALARM_WHEN_RAMPING=NO_ALARM), ASG=DEFAULT", NCHANSUMM=$(NCHANSUMM=200), NCHANSUMMCHAR=$(NCHANSUMMCHAR)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

seq sncSummary, "P=$(MYPVPREFIX)CAEN"
