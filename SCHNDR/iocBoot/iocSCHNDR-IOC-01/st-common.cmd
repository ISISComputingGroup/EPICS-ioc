##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet("PLC", "PLC0")

## load appropriate setup file (TCP, RTU or ASCII)
< st-$(MODE).cmd

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

##ISIS## load device specific init and DB from devices directory
< devices/$(DEVCMD1=missing).cmd
## if useful later add reading  devices/$(DEVCMD2=nodevice).cmd  etc

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
