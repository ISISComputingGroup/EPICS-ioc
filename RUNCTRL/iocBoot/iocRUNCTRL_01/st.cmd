#!../../bin/windows-x64/RUNCTRL_01

## You may have to change RUNCTRL_01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/RUNCTRL_01.dbd"
RUNCTRL_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances

dbLoadRecords("$(WEBGET)/db/sendAlert.db","P=$(MYPVPREFIX),Q=CS:AC:ALERTS:")
dbLoadRecords("$(TOP)/db/alertAction.db","P=$(MYPVPREFIX),Q=CS:AC:ALERTS:ACTION:,SOURCE=$(MYPVPREFIX)CS:AC:OUT:LIST,ACTION=$(MYPVPREFIX)CS:AC:ALERTS:MESSAGE:SP")
dbLoadRecords("$(TOP)/db/runcontrolMgr.db","P=$(MYPVPREFIX),ALERT_OUT=$(MYPVPREFIX)CS:AC:ALERTS:ACTION:DO.PROC,ALERT_IN=$(MYPVPREFIX)CS:AC:DUMMYACT:IN")

## load run control settings written by blockserver
iocshLoad "${ICPCONFIGROOT}/rc_settings.cmd", "RUNCONTROL=$(TOP)"

## load LOQ specific detector control, this puts in the aperture if the detctor count rate is exceeded
stringiftest("LOQ", "$(ICPCONFIGHOST)", 5, "NDXLOQ")
$(IFLOQ) dbLoadRecords("$(TOP)/db/LOQ_detector.db","P=$(MYPVPREFIX)")
$(IFLOQ) dbLoadRecords("$(WEBGET)/db/sendAlert.db","P=$(MYPVPREFIX),Q=CS:DC:ALERTS:")
$(IFLOQ) dbLoadRecords("$(RUNCONTROL)/db/gencontrolMgr.db","P=$(MYPVPREFIX),MODE=DC,OUT_ACTION=$(MYPVPREFIX)CS:OVERCOUNT:ALERT.PROC")
$(IFLOQ) dbLoadRecords("$(RUNCONTROL)/db/gencontrol.db","P=$(MYPVPREFIX),MODE=DC,PV=$(MYPVPREFIX)DAE:AD1:INTG:SPEC:RATE")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

dbpf "$(MYPVPREFIX)CS:AC:ALERTS:INST:SP", "$(INSTRUMENT)"

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
