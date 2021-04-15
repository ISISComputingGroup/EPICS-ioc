#!../../bin/windows-x64-debug/TTIEX355P-IOC-01

## You may have to change TTIEX355P-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TTIEX355P)/ttiEX355PApp/protocol"
epicsEnvSet "DEVICE" "L0"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/TTIEX355P-IOC-01.dbd"
TTIEX355P_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd


## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "baud", "9600")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "8")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "none")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "stop", "1")

# Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"crtscts","N")

# Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixon","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixoff","N")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

# The field conversion is not defined if the macro is unset or set to the empty string.
stringiftest("FIELD_CONV_DEFINED", "$(AMPSTOGAUSS=)")

# Need to set the conversion factor to something to avoid errors - doesn't matter what, as it won't be used. Choose 1 as this is a safe no-op.
$(IFNOTFIELD_CONV_DEFINED) epicsEnvSet("AMPSTOGAUSS", "1")

$(IFNOTFIELD_CONV_DEFINED) epicsEnvSet("FIELD_CONV_DEFINED", "0")
$(IFFIELD_CONV_DEFINED) epicsEnvSet("FIELD_CONV_DEFINED", "1")

stringiftest("DOAUTOSAVESETPOINTS", "$(AUTOSAVESETPOINTS=NO)", 5, "YES")

## Load our record instances
dbLoadRecords("db/ttiEX355P.db","P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM),PORT=L0,AMPSTOGAUSS=$(AMPSTOGAUSS),FIELD_CONV_DEFINED=$(FIELD_CONV_DEFINED),MAX_FIELD=$(MAX_FIELD=1000000000),DISABLE_AUTOONOFF=$(DISABLE_AUTOONOFF=1),OFF_TOLERANCE=$(OFF_TOLERANCE=0.1),IFDOAUTOSAVESETPOINTS=$(IFDOAUTOSAVESETPOINTS)")

dbLoadRecords("$(UTILITIES)/db/check_stability.db", "P=$(MYPVPREFIX)$(IOCNAME):,INP_VAL=$(MYPVPREFIX)$(IOCNAME):FIELD,SP=$(MYPVPREFIX)$(IOCNAME):FIELD:SP:RBV,NSAMP=5,TOLERANCE=$(TOLERANCE=0.01)")


##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=mjc23Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
