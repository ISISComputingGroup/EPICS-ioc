epicsEnvSet "STREAM_PROTOCOL_PATH" "$(ALDN1000)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")
## Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"crtscts","N")
## Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixon","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixoff","N")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances (default with ID switching)
# Load with default ID of 0
dbLoadRecords("$(ALDN1000)/db/aldn1000.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),ID=0")
dbLoadRecords("$(ALDN1000)/db/unit_setter.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")

# Check if macros' length > 0 (default operation)
stringiftest("ACTIVE1", "$(ID1=)")
stringiftest("ACTIVE2", "$(ID2=)")
stringiftest("ACTIVE3", "$(ID3=)")
stringiftest("ACTIVE4", "$(ID4=)")

# Load pv's that indicate whether sensor at index is active (i.e. ID set)
dbLoadRecords("$(ALDN1000)/db/isActiveAldn1000.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):1:,IFACTIVE=$(IFACTIVE1),IFNOTACTIVE=$(IFNOTACTIVE1)")
dbLoadRecords("$(ALDN1000)/db/isActiveAldn1000.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):2:,IFACTIVE=$(IFACTIVE2),IFNOTACTIVE=$(IFNOTACTIVE2)")
dbLoadRecords("$(ALDN1000)/db/isActiveAldn1000.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):3:,IFACTIVE=$(IFACTIVE3),IFNOTACTIVE=$(IFNOTACTIVE3)")
dbLoadRecords("$(ALDN1000)/db/isActiveAldn1000.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):4:,IFACTIVE=$(IFACTIVE4),IFNOTACTIVE=$(IFNOTACTIVE4)")

# Load the four sensor's records if needed
$(IFACTIVE1) dbLoadRecords("$(ALDN1000)/db/aldn1000.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):1:,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),ID=$(ID1)")
$(IFACTIVE1) dbLoadRecords("$(ALDN1000)/db/unit_setter.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):1:,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")

$(IFACTIVE2) dbLoadRecords("$(ALDN1000)/db/aldn1000.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):2:,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),ID=$(ID2)")
$(IFACTIVE2) dbLoadRecords("$(ALDN1000)/db/unit_setter.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):2:,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")

$(IFACTIVE3) dbLoadRecords("$(ALDN1000)/db/aldn1000.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):3:,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),ID=$(ID3)")
$(IFACTIVE3) dbLoadRecords("$(ALDN1000)/db/unit_setter.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):3:,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")

$(IFACTIVE4) dbLoadRecords("$(ALDN1000)/db/aldn1000.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):4:,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),ID=$(ID4)")
$(IFACTIVE4) dbLoadRecords("$(ALDN1000)/db/unit_setter.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):4:,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")


##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=znx23966"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
