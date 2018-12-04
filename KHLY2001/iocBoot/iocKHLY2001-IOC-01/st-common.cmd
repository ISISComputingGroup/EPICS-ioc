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

# Need to set these for DEVSIM mode as lewis can't handle not having termination characters.
$(IFDEVSIM) asynOctetSetOutputEos("$(DEVICE)",0,"\r\n")


asynSetTraceMask("L0",-1,0x9)
asynSetTraceIOMask("L0",-1,0x2)

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(KHLY2001)/db/keithley_2001_misc.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(KHLY2001)/db/keithley_2001_error_handling.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(KHLY2001)/db/unit_setter.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE)")
dbLoadRecords("$(KHLY2001)/db/keithley_2001_init.db","PVPREFIX=$(MYPVPREFIX), P=$(MYPVPREFIX)$(IOCNAME):, PORT=$(DEVICE), RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(KHLY2001)/db/keithley_2001_buffer.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(KHLY2001)/db/keithley_2001_buffer_parsing.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")

dbLoadRecordsList("$(KHLY2001)/db/keithley_2001_channel.db", "PVPREFIX=$(MYPVPREFIX), P=$(MYPVPREFIX)$(IOCNAME):, PORT=$(DEVICE), RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0),PORT=$(DEVICE)", "CHANNEL", "01;02;03;04;05;06;07;08;09;10", ";")

dbLoadRecords("$(KHLY2001)/db/keithley_2001_channel_scanning.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),SCAN_DELAY=$(SCAN_DELAY=1)")

dbLoadRecords("$(KHLY2001)/db/alarm_readings_setter.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE)")
dbLoadRecords("$(KHLY2001)/db/alarm_units_setter.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

## Start Keithley 2001 sequence program
seq keithley_2001, "P=$(MYPVPREFIX)$(IOCNAME):"
