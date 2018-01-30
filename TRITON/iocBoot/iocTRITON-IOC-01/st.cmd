#!../../bin/windows-x64/TRITON-IOC-01

## You may have to change TRITON-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TRITON)/data"
epicsEnvSet "DEVICE" "L0"

## Register all support components
dbLoadDatabase("../../dbd/TRITON-IOC-01.dbd",0,0)
TRITON_IOC_01_registerRecordDeviceDriver(pdbbase) 

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

$(IFDEVSIM) epicsEnvSet "IPADDR" "localhost"
$(IFDEVSIM) epicsEnvSet "IPPORT" "$(EMULATOR_PORT=57677)"

$(IFNOTDEVSIM) $(IFNOTRECSIM) epicsEnvSet "IPADDR" "oi-pc.isis.cclrc.ac.uk"
$(IFNOTDEVSIM) $(IFNOTRECSIM) epicsEnvSet "IPPORT" "$(IPPORT=33576)"

$(IFNOTRECSIM) drvAsynIPPortConfigure("$(DEVICE)", "$(IPADDR=NUL):$(IPPORT=NUL)")
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "NUL")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

dbLoadRecords("../../db/TRITON.db", "P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),IPADDR=$(IPADDR=NUL)")
dbLoadRecords("../../db/TRITON_valves.db", "P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE)")
dbLoadRecords("../../db/TRITON_channels.db", "P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE)")
dbLoadRecords("../../db/TRITON_pid.db", "P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE)")
dbLoadRecords("../../db/TRITON_temp_channels.db", "P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE)")
dbLoadRecords("../../db/TRITON_pressure_channels.db", "P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit()

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
