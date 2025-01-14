epicsEnvSet "STREAM_PROTOCOL_PATH" "$(G3HALLPR)/data"
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
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=7)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=even)")
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

epicsEnvSet("P", "$(MYPVPREFIX)$(IOCNAME):")

## Load our record instances
dbLoadRecords("$(G3HALLPR)/db/group3hallprobe.db","PVPREFIX=$(MYPVPREFIX),P=$(P),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")

dbLoadRecords("$(G3HALLPR)/db/group3hallprobe_probe.db","P=$(P),SENSORID=0,ADDR=$(ADDR0=0),PORT=$(DEVICE),NAME=$(NAME0=probe0),SCALE=$(SCALE0=1),FIELD_SCAN_RATE=$(FIELD_SCAN_RATE=1 second),TEMP_SCAN_RATE=$(TEMP_SCAN_RATE=5 second),FLNK=$(FLNK0=)")
dbLoadRecords("$(G3HALLPR)/db/group3hallprobe_probe.db","P=$(P),SENSORID=1,ADDR=$(ADDR1=1),PORT=$(DEVICE),NAME=$(NAME1=probe1),SCALE=$(SCALE1=1),FIELD_SCAN_RATE=$(FIELD_SCAN_RATE=1 second),TEMP_SCAN_RATE=$(TEMP_SCAN_RATE=5 second),FLNK=$(FLNK1=)")
dbLoadRecords("$(G3HALLPR)/db/group3hallprobe_probe.db","P=$(P),SENSORID=2,ADDR=$(ADDR2=2),PORT=$(DEVICE),NAME=$(NAME2=probe2),SCALE=$(SCALE2=1),FIELD_SCAN_RATE=$(FIELD_SCAN_RATE=1 second),TEMP_SCAN_RATE=$(TEMP_SCAN_RATE=5 second),FLNK=$(FLNK2=)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

seq change_range, "P=$(P),SENSOR_ID=0"
seq change_range, "P=$(P),SENSOR_ID=1"
seq change_range, "P=$(P),SENSOR_ID=2"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
