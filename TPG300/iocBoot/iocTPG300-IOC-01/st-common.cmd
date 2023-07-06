##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TPG)/data"

stringiftest("USEIP", "$(IPADDR=)", 3)

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NUL)", 0, 1, 0, 0)

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=57677)")

## For real device use:
$(IFNOTUSEIP) $(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NOTSPECIFIED)", 0, 0, 0, 0)
$(IFNOTUSEIP) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "9600")
$(IFNOTUSEIP) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "8")
$(IFNOTUSEIP) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "none")
$(IFNOTUSEIP) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "1")

# Hardware flow control off
$(IFNOTUSEIP) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTUSEIP) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")

# Software flow control off
$(IFNOTUSEIP) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N") 
$(IFNOTUSEIP) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N")

$(IFUSEIP) drvAsynIPPortConfigure("L0", "$(IPADDR=NOTSPECIFIED):8000")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

#####################
## Load record instances
stringiftest("300", $(MODEL="300"), 5, "300")

stringiftest("PRESSURA1", $(PRESA1ON="Y"), 5, "Y")
stringiftest("PRESSURA2", $(PRESA2ON="Y"), 5, "Y")
stringiftest("PRESSURB1", $(PRESB1ON="Y"), 5, "Y")
stringiftest("PRESSURB2", $(PRESB2ON="Y"), 5, "Y")

dbLoadRecords("$(TPG)/db/devTPGx00.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),IF300=$(IF300),IFNOT300=$(IFNOT300)")
$(IF300) dbLoadRecords("$(TPG)/db/devTPG300.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")
$(IFNOT300) dbLoadRecords("$(TPG)/db/devTPG500.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")
dbLoadRecords("$(TPG)/db/TPG300_channels.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0), IFPRESSURA1=$(IFPRESSURA1),IFPRESSURA2=$(IFPRESSURA2),IFPRESSURB1=$(IFPRESSURB1),IFPRESSURB2=$(IFPRESSURB2),IF300=$(IF300),IFNOT300=$(IFNOT300)")
dbLoadRecords("$(TPG)/db/unit_setter.db","P=$(MYPVPREFIX)$(IOCNAME):")
dbLoadRecords("$(TPG)/db/TPG300_switching_functions_rb.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),IF300=$(IF300),IFNOT300=$(IFNOT300)")
$(IF300) dbLoadRecords("$(TPG)/db/TPG300_switching_functions_rb_AB.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),IF300=$(IF300),IFNOT300=$(IFNOT300)")
dbLoadRecords("$(TPG)/db/TPG300_switching_functions.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),IF300=$(IF300),IFNOT300=$(IFNOT300)")
dbLoadRecords("$(TPG)/db/TPG300_function_statuses.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),IF300=$(IF300),IFNOT300=$(IFNOT300)")
dbLoadRecords("$(TPG)/db/TPG300_switching_functions_rb_error_setter.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")
dbLoadRecords("$(TPG)/db/TPG300_function_statuses_error_setter.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")

## Finished loading record instances
#########################

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=mjc23Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
