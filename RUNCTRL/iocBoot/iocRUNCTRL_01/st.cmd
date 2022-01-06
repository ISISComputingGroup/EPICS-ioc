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

# if you wish to debug autosave
#save_restoreSet_Debug(2)

## Load our record instances

dbLoadRecords("$(WEBGET)/db/sendAlert.db","P=$(MYPVPREFIX),Q=CS:AC:ALERTS:,INST=$(INSTRUMENT=Unknown),SOURCE=IBEX")
dbLoadRecords("$(TOP)/db/alertAction.db","P=$(MYPVPREFIX),Q=CS:AC:ALERTS:ACTION:OUT:,SOURCE=$(MYPVPREFIX)CS:AC:OUT:LIST,MESS=blocks out of range,ACTION=$(MYPVPREFIX)CS:AC:ALERTS:MESSAGE:SP")
dbLoadRecords("$(TOP)/db/alertAction.db","P=$(MYPVPREFIX),Q=CS:AC:ALERTS:ACTION:IN:,SOURCE=$(MYPVPREFIX)CS:AC:OUT:LIST,MESS=blocks now in range,ACTION=$(MYPVPREFIX)CS:AC:ALERTS:MESSAGE:SP")
## set out of range action for AC to dummy as we are using change action
dbLoadRecords("$(TOP)/db/runcontrolMgr.db","P=$(MYPVPREFIX),ALERT_OUT=$(MYPVPREFIX)CS:AC:DUMMYACT:OUT.PROC,ALERT_IN=$(MYPVPREFIX)CS:AC:ALERTS:ACTION:IN:DO.PROC,ALERT_CHANGE=$(MYPVPREFIX)CS:AC:ALERTS:ACTION:OUT:DO.PROC")

## load run control settings written by blockserver
iocshLoad "${ICPCONFIGROOT}/rc_settings.cmd", "RUNCONTROL=$(TOP)"

## load detector control, this closes the shutter if the detector count rate is exceeded
stringiftest("DETECT", "$(ICPCONFIGHOST)", 5, "NDXLOQ")
stringiftest("DETECT", "$(ICPCONFIGHOST)", 5, "NDXSANS2D")
stringiftest("SANS", "$(ICPCONFIGHOST)", 5, "NDXSANS2D")

# also load the records for tests
$(IFDEVSIM) epicsEnvSet("TESTENV", "TRUE")
$(IFRECSIM) epicsEnvSet("TESTENV", "TRUE")
$(IFNOTRECSIM) $(IFNOTDEVSIM) epicsEnvSet("TESTENV", "FALSE")
stringiftest("DETECT", "$(TESTENV)", 5, "TRUE")
stringiftest("SANS", "$(TESTENV)", 5, "TRUE")

$(IFDETECT) dbLoadRecords("$(TOP)/db/detector.db","P=$(MYPVPREFIX)")
$(IFDETECT) dbLoadRecords("$(WEBGET)/db/sendAlert.db","P=$(MYPVPREFIX),Q=CS:DC:ALERTS:,INST=$(INSTRUMENT=Unknown),SOURCE=IBEX")
$(IFDETECT) dbLoadRecords("$(RUNCONTROL)/db/gencontrolMgr.db","P=$(MYPVPREFIX),MODE=DC,OUT_ACTION=$(MYPVPREFIX)CS:OVERCOUNT:ALERT.PROC")
$(IFDETECT) dbLoadRecords("$(RUNCONTROL)/db/gencontrol.db","P=$(MYPVPREFIX),MODE=DC,PV=$(MYPVPREFIX)DAE:AD1:INTG:SPEC:RATE,NOALIAS=#")
$(IFSANS) dbLoadRecords("$(RUNCONTROL)/db/gencontrol.db","P=$(MYPVPREFIX),MODE=DC,PV=$(MYPVPREFIX)DAE:AD1:INTG:RATE,NOALIAS=#")
$(IFSANS) dbLoadRecords("$(RUNCONTROL)/db/gencontrol.db","P=$(MYPVPREFIX),MODE=DC,PV=$(MYPVPREFIX)DAE:AD2:INTG:SPEC:RATE,NOALIAS=#")
$(IFSANS) dbLoadRecords("$(RUNCONTROL)/db/gencontrol.db","P=$(MYPVPREFIX),MODE=DC,PV=$(MYPVPREFIX)DAE:AD2:INTG:RATE,NOALIAS=#")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

## set this to print out web POST contents
#epicsEnvSet("WEBGET_POST_DEBUG", 1)

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
