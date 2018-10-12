epicsEnvSet "STREAM_PROTOCOL_PATH" "$(KHLY2001)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## For unit testing:
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=)")

## For normal devsim:
# $(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:57677")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynVISAPortConfigure("$(DEVICE)","$(GPIBSTR=GPIB0::16::INSTR)",0, 0, 1, -1, "\n", 1)

# trace masks for debugging
asynSetTraceMask("$(DEVICE)",-1,0x9)
asynSetTraceIOMask("$(DEVICE)",-1,0x2)

# Need to set these for DEVSIM mode as lewis can't handle not having termination characters.
$(IFDEVSIM) asynOctetSetOutputEos("$(DEVICE)",0,"\r\n")

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(KHLY2001)/db/keithley_2001_misc.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(KHLY2001)/db/keithley_2001_init.db","PVPREFIX=$(MYPVPREFIX), P=$(MYPVPREFIX)$(IOCNAME):, PORT=$(DEVICE), RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(KHLY2001)/db/keithley_2001_buffer.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(KHLY2001)/db/keithley_2001_asub_buffer_parsing.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(KHLY2001)/db/keithley_2001_channels.db","PVPREFIX=$(MYPVPREFIX), P=$(MYPVPREFIX)$(IOCNAME):, PORT=$(DEVICE), RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(KHLY2001)/db/keithley_2001_channel_scanning.db","PVPREFIX=$(MYPVPREFIX), P=$(MYPVPREFIX)$(IOCNAME):, PORT=$(DEVICE), RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0),PORT=$(DEVICE), SCAN_SPEED = $(SCAN_SPEED = 0.5)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

## Start Keithley 2001 sequence program
seq keithley_2001, "P=$(MYPVPREFIX)$(IOCNAME):"
