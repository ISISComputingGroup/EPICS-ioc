## Initialise the comms with the PSU
asynOctetConnect("DFKINIT","L0")
asynOctetWrite DFKINIT "UNLOCK\r"

## Load our record instances
#dbLoadRecords("db/xxx.db","user=faa59Host")
dbLoadRecords("$(TOP)/Db/DFKPS_hex.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME): port=L0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
