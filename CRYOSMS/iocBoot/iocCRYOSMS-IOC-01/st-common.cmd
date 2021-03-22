##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd
## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NUL)", 0, 1, 0, 0)

# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=57677)")

## For real device use:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "$(BITS=7)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "$(PARITY=even)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "$(STOP=1)")
## Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")
## Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N")

CRYOSMSConfigure("ASYN_PORT", "$(MYPVPREFIX)$(IOCNAME):", "$(T_TO_A)","$(WRITE_UNIT)","$(DISPLAY_UNIT)","$(MAX_CURR)","$(MAX_VOLT)","$(ALLOW_PERSIST)","$(FAST_FILTER_VALUE)","$(FILTER_VALUE)","$(NPP)","$(FAST_PERSISTENT_SETTLETIME)","$(PERSISTENT_SETTLETIME)","$(FAST_RATE)","$(USE_SWITCH)","$(SWITCH_TEMP_PV)","$(SWITCH_HIGH)","$(SWITCH_LOW)","$(SWITCH_STABLE_NUMBER)","$(HEATER_TOLERANCE)","$(SWITCH_TIMEOUT)","$(HEATER_OUT)","$(USE_MAGNET_TEMP)","$(MAGNET_TEMP_PV)","$(MAX_MAGNET_TEMP)","$(MIN_MAGNET_TEMP)","$(COMP_OFF_ACT)","$(NO_OF_COMP)","$(MIN_NO_OF_COMP)","$(COMP_1_STAT_PV)","$(COMP_2_STAT_PV)","$(RAMP_FILE)")

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(CRYOSMS)/data"

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd
############################
## Load our record instances
############################

dbLoadRecords("$(CRYOSMS)/db/cryosms.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,ASYN_PORT=ASYN_PORT,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),WRITE_UNIT=$(WRITE_UNIT),DISPLAY_UNIT=$(DISPLAY_UNIT),T_TO_A=$(T_TO_A),SWITCH_HIGH=$(SWITCH_HIGH),SWITCH_LOW=$(SWITCH_LOW),SWITCH_STABLE_NUMBER=$(SWITCH_STABLE_NUMBER),SWITCH_TEMP_PV=$(SWITCH_TEMP_PV)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
