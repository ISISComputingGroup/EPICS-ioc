epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TOP)/data"    
cd ${TOP}

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)                          
asynSetOption("L0", -1, "baud", "9600")                                         
asynSetOption("L0", -1, "bits", "7")                                            
asynSetOption("L0", -1, "parity", "odd")                                       
asynSetOption("L0", -1, "stop", "1")                                            
#asynOctetSetInputEos("L0", -1, "\r")                                            
#asynOctetSetOutputEos("L0", -1, "\r")                                           

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/Lakeshore218.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=luj96656Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
