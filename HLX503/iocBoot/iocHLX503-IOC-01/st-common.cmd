epicsEnvSet "STREAM_PROTOCOL_PATH" "$(ITC503)/data"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Ramp for read ascii
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(ITC503)/data"
epicsEnvSet "READASCII_NAME" "READASCII"
epicsEnvSet "FILELIST_NAME" "FILELIST"
$(IFNOTDEVSIM) epicsEnvSet "CALIB_BASE_DIR" "$(ICPCONFIGBASE)/$(INSTRUMENT)"
$(IFDEVSIM) epicsEnvSet "CALIB_BASE_DIR" "$(HLX503)"
epicsEnvSet "TPAR_DIR" "configurations/hlx503"
epicsEnvSet "TPAR_PAT" ".*"
FileListConfigure("$(FILELIST_NAME)", "$(CALIB_BASE_DIR)/$(TPAR_DIR)", "$(TPAR_PAT)", 0) 
ReadASCIIConfigure("$(READASCII_NAME)", "$(CALIB_BASE_DIR)/$(TPAR_DIR)", 20)


epicsEnvSet "DEVICE" "L0"

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=2)")
## Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"crtscts","N")
## Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixon","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixoff","N")

epicsEnvSet "CTRLCHANNEL$(SORB_CHANNEL)_NAME" "SORB"
epicsEnvSet "CTRLCHANNEL$(HE3POTHI_CHANNEL)_NAME" "HE3POTHI"
epicsEnvSet "CTRLCHANNEL$(1KPOTHE3POTLO_CHANNEL)_NAME" "1KPOTHE3POTLO"

epicsEnvSet "SENSOR$(SORB_SENSOR)_NAME" "SORB"
epicsEnvSet "SENSOR$(HE3POTHI_SENSOR)_NAME" "HE3POTHI"
epicsEnvSet "SENSOR$(1KPOTHE3POTLO_SENSOR)_NAME" "1KPOTHE3POTLO"

# asynSetTraceIOMask("L0", -1, 0x2)
# asynSetTraceMask("L0", -1, 0x9)

## Load DB Records
dbLoadRecords("$(ITC503)/db/ITC503.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=$(DEVICE), RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0), READ=$(READASCII_NAME), CTRLCHANNEL1_NAME=$(CTRLCHANNEL1_NAME), CTRLCHANNEL2_NAME=$(CTRLCHANNEL2_NAME), CTRLCHANNEL3_NAME=$(CTRLCHANNEL3_NAME), SENSOR1_NAME=$(SENSOR1_NAME), SENSOR2_NAME=$(SENSOR2_NAME), SENSOR3_NAME=$(SENSOR3_NAME), IFNOTHLX503=#")
dbLoadRecords("$(HLX503)/db/hlx503.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),MAX_TEMP_FOR_HE3_COOLING=$(MAX_TEMP_FOR_HE3_COOLING),MAX_OPERATING_TEMP_FOR_HELIOX=$(MAX_OPERATING_TEMP_FOR_HELIOX),SORB_CHANNEL=$(SORB_CHANNEL),HE3POTHI_CHANNEL=$(HE3POTHI_CHANNEL),1KPOTHE3POTLO_CHANNEL=$(1KPOTHE3POTLO_CHANNEL),SORB_SENSOR=$(SORB_SENSOR),HE3POTHI_SENSOR=$(HE3POTHI_SENSOR),1KPOTHE3POTLO_SENSOR=$(1KPOTHE3POTLO_SENSOR),READ=$(READASCII_NAME),FILELIST=$(FILELIST_NAME)")

# dbLoadRecords("$(FILELIST)/db/calibration.db", "P=$(MYPVPREFIX)$(IOCNAME):, CALIB_BASE_DIR=$(CALIB_BASE_DIR), SDIR=$(SENS_DIR), CALIBLIST=SENSORFILELISTHE3POT, CONV_TO_PV=TEMP, CONV_FROM_PV=, CONV_TO_DESC=Temperature, CONV_TO_EGU=K, SP_PV=RAMP:_OUT_SP")
# dbLoadRecords("$(FILELIST)/db/calibration.db", "P=$(MYPVPREFIX)$(IOCNAME):, CALIB_BASE_DIR=$(CALIB_BASE_DIR), SDIR=$(SENS_DIR), CALIBLIST=SENSORFILELISTSORB, CONV_TO_PV=TEMP, CONV_FROM_PV=, CONV_TO_DESC=Temperature, CONV_TO_EGU=K, SP_PV=RAMP:_OUT_SP")


##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=ltu34219"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
