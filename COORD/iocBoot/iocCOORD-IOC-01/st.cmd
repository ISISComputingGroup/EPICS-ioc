#!../../bin/windows-x64/COORD-IOC-01

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/COORD-IOC-01.dbd"
COORD_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

# These PVs will make it so the inhibitor will only let one motor be non-zero at a time
epicsEnvSet(OK_TO_RUN_PSUS,$(MYPVPREFIX)PARS:USER:R0)
epicsEnvSet(ALLOW_PORT_CHANGEOVER,$(MYPVPREFIX)PARS:USER:R1)

## Start any sequence programs
seq riken_port_changeover, "OK_TO_RUN_PSUS=$(OK_TO_RUN_PSUS),ALLOW_PORT_CHANGEOVER=$(ALLOW_PORT_CHANGEOVER)"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
