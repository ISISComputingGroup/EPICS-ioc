#!../../bin/windows-x64/FINS-IOC-01

## You may have to change FINS-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/FINS-IOC-01.dbd"
FINS_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# this is larmor
#finsUDPInit("PLC", "130.246.36.139", "TCP")
# this is R78
#finsUDPInit("PLC", "130.246.55.167", "TCP")
finsUDPInit("PLC", "$(PLCIP)", "TCP")

# ASYN_TRACE_ERROR     0x0001
# ASYN_TRACEIO_DEVICE  0x0002
# ASYN_TRACEIO_FILTER  0x0004
# ASYN_TRACEIO_DRIVER  0x0008
# ASYN_TRACE_FLOW      0x0010

# ASYN_TRACEIO_NODATA  0x0000
# ASYN_TRACEIO_ASCII   0x0001
# ASYN_TRACEIO_ESCAPE  0x0002
# ASYN_TRACEIO_HEX     0x0004

# need to set trace mask per address
#asynSetTraceMask  ("PLC", 1, 0x01f)
#asynSetTraceIOMask("PLC", 1, 0x01)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/larmor-air.db","P=$(MYPVPREFIX),Q=BENCH:")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
