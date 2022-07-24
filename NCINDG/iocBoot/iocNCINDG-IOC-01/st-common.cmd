epicsEnvSet "STREAM_PROTOCOL_PATH" "$(_SUPPORT_MACRO_)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

nucInstDigConfigure("DIG0", "172.16.105.186")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDig.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigTrace.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")
dbLoadRecords("$(NUCINSTDIG)/db/NucInstDigDCSpec.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DIG0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
