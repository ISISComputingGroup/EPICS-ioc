## Initialise the comms with the PSU
asynOctetConnect("DFKINIT","L0")
asynOctetWrite DFKINIT "ADR 000\r"

## Load our record instances
dbLoadRecords("$(TOP)/Db/DFKPS_8800_status.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, port=L0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
