
##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

drvUSBQEProConfigure("qepro",100,1,$(DEVICE_ID))
asynSetTraceMask("qepro",0,0x11)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances

dbLoadRecords("$(QEPRO)/db/qepro.template","PREFIX=$(MYPVPREFIX)$(IOCNAME),PORT=qepro,ADDR=0,TIMEOUT=1,SIZE=1000,LASER=0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
