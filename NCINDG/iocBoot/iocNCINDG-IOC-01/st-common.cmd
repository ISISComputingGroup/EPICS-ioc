##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")
asynSetMinTimerPeriod(0.001)

nucInstDigConfigure("DIG0", "$(IP_ADDR_0)", $(INDEX_0))

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDig.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigTrace.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigDCSpec.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigTOFSpec.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")

iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/liveview.cmd", "LVDET=1,LVADDR=0"
iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/liveview.cmd", "LVDET=2,LVADDR=1"
iocshLoad "${TOP}/iocBoot/iocNCINDG-IOC-01/liveview.cmd", "LVDET=3,LVADDR=2"

< ${TOP}/iocBoot/iocNCINDG-IOC-01/digitiser-params.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
