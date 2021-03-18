##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TRITON)/data"
epicsEnvSet "DEVICE" "L0"

$(IFDEVSIM) epicsEnvSet "IPADDR" "localhost"
$(IFDEVSIM) epicsEnvSet "IPPORT" "$(EMULATOR_PORT=57677)"

$(IFNOTDEVSIM) $(IFNOTRECSIM) epicsEnvSet "IPADDR" "$(IPADDR=localhost)"
$(IFNOTDEVSIM) $(IFNOTRECSIM) epicsEnvSet "IPPORT" "$(IPPORT=33576)"

$(IFNOTRECSIM) drvAsynIPPortConfigure("$(DEVICE)", "$(IPADDR=NUL):$(IPPORT=NUL)")
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "NUL")

#
# Configure ReadASCII for PID lookup.
#
epicsEnvSet "CALIB_BASE_DIR" "C:/Instrument/Settings/config/common"
epicsEnvSet "RAMP_PAT" ".*"
$(IFNOTDEVSIM) epicsEnvSet "RAMP_DIR" "$(CALIB_BASE_DIR)/ramps"
$(IFDEVSIM) epicsEnvSet "RAMP_DIR" "$(READASCII)/example_settings"

epicsEnvSet "READASCII_NAME" "READASCII"
epicsEnvSet "FILELIST_NAME" "RAMPFILELIST"

FileListConfigure("$(FILELIST_NAME)", "$(RAMP_DIR)", "$(RAMP_PAT)") 
ReadASCIIConfigure("$(READASCII_NAME)", "$(RAMP_DIR)", 20)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

epicsEnvSet "POLL_RATE" "$(POLL_RATE=1 second)"
epicsEnvSet "CHANNEL_POLL_RATE" "$(CHANNEL_POLL_RATE=15 second)"

dbLoadRecords("../../db/TRITON.db", "P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),IPADDR=$(IPADDR=NUL),POLL_RATE=$(POLL_RATE),CHANNEL=POLL_RATE=$(CHANNEL_POLL_RATE)")
dbLoadRecords("../../db/TRITON_channels.db", "P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),POLL_RATE=$(POLL_RATE),CHANNEL=POLL_RATE=$(CHANNEL_POLL_RATE)")
dbLoadRecords("../../db/TRITON_pid.db", "P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),POLL_RATE=$(POLL_RATE),CHANNEL=POLL_RATE=$(CHANNEL_POLL_RATE)")
dbLoadRecords("../../db/TRITON_pid_lookup.db", "P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),READ=$(READASCII_NAME),RAMPLIST=$(FILELIST_NAME),RAMP_FILE_NAME=$(RAMP_FILE_NAME=Default.txt),USE_RAMP_FILE=$(USE_RAMP_FILE=0),POLL_RATE=$(POLL_RATE),CHANNEL=POLL_RATE=$(CHANNEL_POLL_RATE)")
dbLoadRecords("../../db/TRITON_temp_channels.db", "P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),POLL_RATE=$(POLL_RATE),CHANNEL=POLL_RATE=$(CHANNEL_POLL_RATE)")
dbLoadRecords("../../db/TRITON_pressure_channels.db", "P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),POLL_RATE=$(POLL_RATE),CHANNEL=POLL_RATE=$(CHANNEL_POLL_RATE)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
