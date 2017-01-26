epicsEnvSet "STREAM_PROTOCOL_PATH" "$(CCD100)/data"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

$(IFNOTDEVSIM) drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)                        
$(IFNOTDEVSIM) asynSetOption("L0", -1, "baud", "$(BAUD=57600)")                                   
$(IFNOTDEVSIM) asynSetOption("L0", -1, "bits", "$(BITS=8)")                                           
$(IFNOTDEVSIM) asynSetOption("L0", -1, "parity", "$(PARITY=none)")                                      
$(IFNOTDEVSIM) asynSetOption("L0", -1, "stop", "$(STOP=1)")                                            
$(IFNOTDEVSIM) asynOctetSetInputEos("L0", -1, "\r\n")                                         
$(IFNOTDEVSIM) asynOctetSetOutputEos("L0", -1, "\r\n") 

## For emulator use:
$(IFDEVSIM) freeIPPort("FREEPORT")  
$(IFDEVSIM) epicsEnvShow("FREEPORT") 
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(FREEPORT=0)")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("${TOP}/db/CCD100.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0")
dbLoadRecords("${TOP}/db/unit_setter.db","P=$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=ffv81422Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
