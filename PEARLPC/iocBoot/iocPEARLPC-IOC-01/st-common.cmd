epicsEnvSet "STREAM_PROTOCOL_PATH" "$(PEARLPC)/data"
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

## Load our record instances
dbLoadRecords("$(PEARLPC)/db/devPearl.db","P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),USER_LIMIT=$(USER_LIMIT=1020),LIMITS_NEG_OFFSET=$(LIMITS_NEG_OFFSET=0),LIMITS_POS_OFFSET=$(LIMITS_POS_OFFSET=0),LIMITS_POS_CHANGE=$(LIMITS_POS_CHANGE=20),LIMITS_NEG_CHANGE=$(LIMITS_NEG_CHANGE=20)")

stringiftest("CHANGE_WHEN_RUNNING", "$(CHANGE_WHEN_RUNNING=no)", 5, "yes")

$(IFNOTCHANGE_WHEN_RUNNING) dbLoadRecords("$(UTILITIES)/db/disable_pv_puts.db", "INST=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):1:,PV1=$(MYPVPREFIX)$(IOCNAME):PRESSURE:SP,PV2=$(MYPVPREFIX)$(IOCNAME):SEND_PARAMETERS,PV3=$(MYPVPREFIX)$(IOCNAME):RESET:SP,PV4=$(MYPVPREFIX)$(IOCNAME):STOP:SP,PV5=$(MYPVPREFIX)$(IOCNAME):RUN:SP")
$(IFNOTCHANGE_WHEN_RUNNING) dbLoadRecords("$(UTILITIES)/db/disable_pv_puts.db", "INST=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):2:,PV1=$(MYPVPREFIX)$(IOCNAME):USER_LIMIT:SP,PV2=$(MYPVPREFIX)$(IOCNAME):LIMITS:POS_CHANGE:SP,PV3=$(MYPVPREFIX)$(IOCNAME):LIMITS:POS_OFFSET:SP,PV4=$(MYPVPREFIX)$(IOCNAME):LIMITS:NEG_CHANGE:SP,PV5=$(MYPVPREFIX)$(IOCNAME):LIMITS:NEG_OFFSET:SP,PV6=$(MYPVPREFIX)$(IOCNAME):PRESSURE_DIFF_THOLD:SP")

# For testing, load additional substitute PVs that would come from other IOCs
$(IFDEVSIM) dbLoadRecords("$(PEARLPC)/db/test_pvs.db", "INST=$(MYPVPREFIX)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=plf31717"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
