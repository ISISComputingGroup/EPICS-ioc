#!../../bin/windows-x64/IPS-IOC-01

## You may have to change IPS-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
#errlogInit2(65536, 256)
errlogInit2(65536, 1024)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(IPS)/data"
epicsEnvSet "DEVICE" "L0"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/IPS-IOC-01.dbd"
IPS_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "baud", "9600")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "8")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "none")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "stop", "2")

# Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")

# Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N")

# Uncomment these for StreamDevice debugging
#asynSetTraceMask("L0", -1, 0x9)
#asynSetTraceIOMask("L0", -1, 0x2)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

epicsEnvSet("P", "$(MYPVPREFIX)$(IOCNAME):")

## Useful for debugging - giving a pause to allow the user to attach a debugger
## msgBox "Hello"

# The STREAMPROTOCOL env var should be set to either "LEGACY" (default) or "SCPI"
# Set the database and protocol file names accordingly
stringiftest("STREAMPROTOCOL_SCPI", "$(STREAMPROTOCOL=)", 4, "SCPI")
$(IFNOTSTREAMPROTOCOL_SCPI) epicsEnvSet "DBFILE" "ips_legacy.db"
$(IFSTREAMPROTOCOL_SCPI) epicsEnvSet "DBFILE" "ips_scpi.db"
$(IFNOTSTREAMPROTOCOL_SCPI) epicsEnvSet "PROTOCOLFILE" "OxInstIPS.protocol"
$(IFSTREAMPROTOCOL_SCPI) epicsEnvSet "PROTOCOLFILE" "OxInstIPS_SCPI.protocol"

### IJG Diagnostics during development
#var streamError 1
#var streamDebug 1
#var streamDebugColored 1
#var streamErrorDeadTime 30
#var streamMsgTimeStamped 1
#streamSetLogfile("streamdevice_logfile.txt")
##################

## Load our record instances
dbLoadRecords("db/ips_common.db","PVPREFIX=$(MYPVPREFIX),P=$(P),PROTO=$(PROTOCOLFILE),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),MAX_FIELD=$(MAX_FIELD=7.0),MAX_SWEEP_RATE=$(MAX_SWEEP_RATE=1.0),STABILITY_VOLTAGE=$(STABILITY_VOLTAGE=0.1),HEATER_WAITTIME=$(HEATER_WAITTIME=60),MANAGER_ASG=$(MANAGER_ASG=MANAGER)")
dbLoadRecords("db/$(DBFILE)","PVPREFIX=$(MYPVPREFIX),P=$(P),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),MAX_FIELD=$(MAX_FIELD=7.0),MAX_SWEEP_RATE=$(MAX_SWEEP_RATE=1.0),STABILITY_VOLTAGE=$(STABILITY_VOLTAGE=0.1),HEATER_WAITTIME=$(HEATER_WAITTIME=60),MANAGER_ASG=$(MANAGER_ASG=MANAGER)")
$(IFSTREAMPROTOCOL_SCPI) dbLoadRecords("db/ips_scpi_levels.db","PVPREFIX=$(MYPVPREFIX),P=$(P),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),MIN_N2_FREQ=$(MIN_N2_FREQ=5000),MAX_N2_FREQ=$(MAX_N2_FREQ=65000),MANAGER_ASG=$(MANAGER_ASG=MANAGER)")
$(IFSTREAMPROTOCOL_SCPI) dbLoadRecords("db/scpi_system_alarms.db","PVPREFIX=$(MYPVPREFIX),P=$(P),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),BOARDID_MAG=$(BOARDID_MAG=MB1.T1),BOARDID_10TMAG=$(BOARDID_10TMAG=DB8.T1),BOARDID_PRESS=$(BOARDID_PRESS=DB5.P1),BOARDID_LEVEL=$(BOARDID_LEVEL=DB1.L1),MANAGER_ASG=$(MANAGER_ASG=MANAGER)")
$(IFSTREAMPROTOCOL_SCPI) dbLoadRecords("db/scpi_system_alarms_discrete.db","PVPREFIX=$(MYPVPREFIX),P=$(P),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),MANAGER_ASG=$(MANAGER_ASG=MANAGER)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
seq cryomagnet, "FIELD=$(P)FIELD,FIELD_SETPOINT=$(P)FIELD:SP,FIELD_SETPOINT_ALARM=$(P)FIELD:SP.SEVR,FIELD_SETPOINT_READBACK=$(P)FIELD:SP:RBV,FIELD_SETPOINT_RAW=$(P)FIELD:SP:_RAW,PERSISTENT=$(P)PERSISTENT,MAGNET_FIELD=$(P)MAGNET:FIELD:PERSISTENT,HEATER_STATUS=$(P)HEATER:STATUS,HEATER_STATUS_SP=$(P)HEATER:STATUS:SP,HEATER_WAIT_TIME=$(P)HEATER:WAITTIME,ACTIVITY=$(P)ACTIVITY,ACTIVITY_SP=$(P)ACTIVITY:SP,SWEEPMODE=$(P)SWEEPMODE:PARAMS,SWEEPMODE_SP=$(P)SWEEPMODE:PARAMS:SP,SUPPLYVOLTAGE_STABLE=$(P)SUPPLY:VOLT:STABLE,SWEEP_ACTIVE=$(P)STS:SWEEPMODE:SWEEP,STATEMACHINE=$(P)STATEMACHINE,HEATER_ONTIME_OK=$(P)HEATER:ONTIME_OK"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
