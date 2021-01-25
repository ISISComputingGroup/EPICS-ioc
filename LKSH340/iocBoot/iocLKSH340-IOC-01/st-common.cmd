epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LKSH340)/data"
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
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=odd)")
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

$(IFNOTDEVSIM) $(IFNOTRECSIM) epicsEnvSet "EXCITATION_THRESHOLD_DIR" "$(ICPCONFIGBASE)/common"
$(IFRECSIM) epicsEnvSet "EXCITATION_THRESHOLD_DIR" "$(LKSH340)"
$(IFDEVSIM) epicsEnvSet "EXCITATION_THRESHOLD_DIR" "$(LKSH340)"
epicsEnvSet "DEFAULT_EXCITATIONS_FILE" "None.txt"
epicsEnvSet "EXCITATION_THRESHOLD_DIR_AND_FILE" "$(EXCITATION_THRESHOLD_DIR)/excitation_thresholds/$(EXCITATION_THRESHOLD_FILE=$(DEFAULT_EXCITATIONS_FILE))"

## Load our record instances
dbLoadRecords("$(LKSH340)/db/Lakeshore340.db","P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(LKSH340)/db/Lakeshore340_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

dbpf "$(MYPVPREFIX)$(IOCNAME):THRESHOLDS:FILE" "$(EXCITATION_THRESHOLD_DIR_AND_FILE)"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
