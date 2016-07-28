epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LKSH336)/protocol"
epicsEnvSet "DEVICE" "L0"

cd ${TOP}

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

drvAsynIPPortConfigure ("$(DEVICE)", "$(ADDR):7777")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
#dbLoadRecords("db/xxx.db","user=iew83206Host")
dbLoadRecords("db/lakeshore336.db", "P=$(MYPVPREFIX)$(IOCNAME), PORT=$(DEVICE), ADDR=0, TEMPSCAN=1, SCAN=2, TOLERANCE=1")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=iew83206Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd



