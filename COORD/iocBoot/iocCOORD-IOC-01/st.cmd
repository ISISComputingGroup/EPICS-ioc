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


epicsEnvSet(OK_TO_RUN_PSUS,$(MYPVPREFIX)SIMPLE:VALUE1)
epicsEnvSet(ALLOW_PORT_CHANGEOVER,$(MYPVPREFIX)SIMPLE:VALUE2)
epicsEnvSet(PSU_DISABLE,$(MYPVPREFIX)$(IOCNAME):PSUS:DISABLE:SP)
epicsEnvSet(PSU_POWER,$(MYPVPREFIX)$(IOCNAME):PSUS:POWER:ANY)


dbLoadRecords("$(TOP)/db/riken_port_changeover.db","PV_PREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,OK_TO_RUN_PSUS=$(OK_TO_RUN_PSUS),PSU_DISABLE=$(PSU_DISABLE),PSU_POWER=$(PSU_POWER)")
dbLoadRecords("$(TOP)/db/riken_port_changeover_psus.db","PV_PREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,OK_TO_RUN_PSUS=$(OK_TO_RUN_PSUS),PSU_DISABLE=$(PSU_DISABLE),PSU_POWER=$(PSU_POWER)")
dbLoadRecords("$(TOP)/db/riken_port_changeover_groups.db","PV_PREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,OK_TO_RUN_PSUS=$(OK_TO_RUN_PSUS),PSU_DISABLE=$(PSU_DISABLE),PSU_POWER=$(PSU_POWER)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

seq riken_port_changeover, "OK_TO_RUN_PSUS=$(OK_TO_RUN_PSUS),ALLOW_PORT_CHANGEOVER=$(ALLOW_PORT_CHANGEOVER),PSU_DISABLE=$(PSU_DISABLE),PSU_POWER=$(PSU_POWER)"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
