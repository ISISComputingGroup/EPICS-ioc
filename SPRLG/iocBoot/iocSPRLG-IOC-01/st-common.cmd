epicsEnvSet "STREAM_PROTOCOL_PATH" "$(SPRLG)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device use:
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

## Load our record instances
dbLoadRecords("${SPRLG}/db/superlogics.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),ADDR=$(ADDR=01)")
dbLoadRecords("${SPRLG}/db/superlogics_connected.db","P=$(MYPVPREFIX)$(IOCNAME):")

stringiftest("INP_0_CONNECTED", "$(INP_0_CONNECTED=YES)", 5, "YES")
stringiftest("INP_1_CONNECTED", "$(INP_1_CONNECTED=YES)", 5, "YES")
stringiftest("INP_2_CONNECTED", "$(INP_2_CONNECTED=YES)", 5, "YES")
stringiftest("INP_3_CONNECTED", "$(INP_3_CONNECTED=YES)", 5, "YES")
stringiftest("INP_4_CONNECTED", "$(INP_4_CONNECTED=YES)", 5, "YES")
stringiftest("INP_5_CONNECTED", "$(INP_5_CONNECTED=YES)", 5, "YES")
stringiftest("INP_6_CONNECTED", "$(INP_6_CONNECTED=YES)", 5, "YES")
stringiftest("INP_7_CONNECTED", "$(INP_7_CONNECTED=YES)", 5, "YES")

$(IFINP_0_CONNECTED) dbLoadRecords("${SPRLG}/db/superlogics_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),ADDR=$(ADDR=01),CHNL=0,UNITS=$(UNITS=C)")
$(IFINP_1_CONNECTED) dbLoadRecords("${SPRLG}/db/superlogics_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),ADDR=$(ADDR=01),CHNL=1,UNITS=$(UNITS=C)")
$(IFINP_2_CONNECTED) dbLoadRecords("${SPRLG}/db/superlogics_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),ADDR=$(ADDR=01),CHNL=2,UNITS=$(UNITS=C)")
$(IFINP_3_CONNECTED) dbLoadRecords("${SPRLG}/db/superlogics_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),ADDR=$(ADDR=01),CHNL=3,UNITS=$(UNITS=C)")
$(IFINP_4_CONNECTED) dbLoadRecords("${SPRLG}/db/superlogics_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),ADDR=$(ADDR=01),CHNL=4,UNITS=$(UNITS=C)")
$(IFINP_5_CONNECTED) dbLoadRecords("${SPRLG}/db/superlogics_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),ADDR=$(ADDR=01),CHNL=5,UNITS=$(UNITS=C)")
$(IFINP_6_CONNECTED) dbLoadRecords("${SPRLG}/db/superlogics_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),ADDR=$(ADDR=01),CHNL=6,UNITS=$(UNITS=C)")
$(IFINP_7_CONNECTED) dbLoadRecords("${SPRLG}/db/superlogics_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),ADDR=$(ADDR=01),CHNL=7,UNITS=$(UNITS=C)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

dbpf $(MYPVPREFIX)$(IOCNAME):ADDR $(ADDR=01)
dbpf $(MYPVPREFIX)$(IOCNAME):CHANNEL:0:CONNECTED $(INP_0_CONNECTED=YES)
dbpf $(MYPVPREFIX)$(IOCNAME):CHANNEL:1:CONNECTED $(INP_1_CONNECTED=YES)
dbpf $(MYPVPREFIX)$(IOCNAME):CHANNEL:2:CONNECTED $(INP_2_CONNECTED=YES)
dbpf $(MYPVPREFIX)$(IOCNAME):CHANNEL:3:CONNECTED $(INP_3_CONNECTED=YES)
dbpf $(MYPVPREFIX)$(IOCNAME):CHANNEL:4:CONNECTED $(INP_4_CONNECTED=YES)
dbpf $(MYPVPREFIX)$(IOCNAME):CHANNEL:5:CONNECTED $(INP_5_CONNECTED=YES)
dbpf $(MYPVPREFIX)$(IOCNAME):CHANNEL:6:CONNECTED $(INP_6_CONNECTED=YES)
dbpf $(MYPVPREFIX)$(IOCNAME):CHANNEL:7:CONNECTED $(INP_7_CONNECTED=YES)

## Start any sequence programs
#seq sncxxx,"user=hgv27692Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
