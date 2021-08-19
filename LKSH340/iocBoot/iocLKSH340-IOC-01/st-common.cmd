epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LKSH340)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device:
$(IFNOTDEVSIM) $(IFNOTRECSIM) epicsEnvSet("LUA_PATH", "${UTILITIES}/lua")
$(IFNOTDEVSIM) $(IFNOTRECSIM) epicsEnvSet("LUA_SCRIPT_PATH","${TOP}/iocBoot/${IOC}")
$(IFNOTDEVSIM) $(IFNOTRECSIM) luash("st-common.lua")


## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

stringiftest("USE_EXCITATION_FILE" "$(USE_EXCITATION_THRESHOLD_FILE=NO)" 5 "YES")

stringiftest("MODEL_350", "$(IS_MODEL_350=NO)" 5 "YES")

$(IFMODEL_350)dbLoadRecords("$(LKSH340)/db/Lakeshore350.db","P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
$(IFNOTMODEL_350)dbLoadRecords("$(LKSH340)/db/Lakeshore340.db","P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),IFUSE_EXCITATION_FILE=$(IFUSE_EXCITATION_FILE),IFNOTUSE_EXCITATION_FILE=$(IFNOTUSE_EXCITATION_FILE)")
dbLoadRecords("$(LKSH340)/db/Lakeshore3X0_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

$(IFUSE_EXCITATION_FILE) $(IFNOTDEVSIM) $(IFNOTRECSIM) epicsEnvSet "EXCITATION_THRESHOLD_DIR" "$(ICPCONFIGBASE)/$(INSTRUMENT)/configurations"
$(IFUSE_EXCITATION_FILE) $(IFRECSIM) epicsEnvSet "EXCITATION_THRESHOLD_DIR" "$(LKSH340)"
$(IFUSE_EXCITATION_FILE) $(IFDEVSIM) epicsEnvSet "EXCITATION_THRESHOLD_DIR" "$(LKSH340)"
$(IFUSE_EXCITATION_FILE) epicsEnvSet "EXCITATION_THRESHOLD_DIR_AND_FILE" "$(EXCITATION_THRESHOLD_DIR=)/excitation_thresholds/$(EXCITATION_THRESHOLD_FILE=)"

$(IFUSE_EXCITATION_FILE) dbpf "$(MYPVPREFIX)$(IOCNAME):THRESHOLDS:FILE" "$(EXCITATION_THRESHOLD_DIR_AND_FILE=)"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
