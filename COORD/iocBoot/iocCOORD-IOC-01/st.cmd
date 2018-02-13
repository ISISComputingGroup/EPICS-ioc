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

# Riken port change
epicsEnvSet(PC_PSU_DISABLE,$(MYPVPREFIX)$(IOCNAME):PC:PSUS:DISABLE)
epicsEnvSet(PC_PSU_POWER,$(MYPVPREFIX)$(IOCNAME):PC:PSUS:POWER)
$(IFRIKEN=#) dbLoadRecords("$(TOP)/db/riken_changeover.db","P=$(MYPVPREFIX)$(IOCNAME):,PSU_DISABLE=$(PC_PSU_DISABLE),PSU_POWER=$(PC_PSU_POWER)")
$(IFRIKEN=#) dbLoadRecords("$(TOP)/db/riken_port_changeover_psus.db","PV_PREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,PSU_DISABLE=$(PC_PSU_DISABLE)")

# Riken RB2 mode change
epicsEnvSet(RB2C_PSU_DISABLE,$(MYPVPREFIX)$(IOCNAME):RB2C:PSUS:DISABLE)
epicsEnvSet(RB2C_PSU_POWER,$(MYPVPREFIX)$(IOCNAME):RB2C:PSUS:POWER)
$(IFRIKEN=#) dbLoadRecords("$(TOP)/db/riken_changeover.db","P=$(MYPVPREFIX)$(IOCNAME):,PSU_DISABLE=$(RB2C_PSU_DISABLE),PSU_POWER=$(RB2C_PSU_POWER)")
$(IFRIKEN=#) dbLoadRecords("$(TOP)/db/riken_rb2_mode_changeover_psus.db","PV_PREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,PSU_DISABLE=$(RB2C_PSU_DISABLE)")


##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

# Riken port change
$(IFRIKEN=#) seq riken_changeover, "OK_TO_RUN_PSUS=$(MYPVPREFIX)$(RIKEN_PC_IN),ALLOW_CHANGEOVER=$(MYPVPREFIX)$(RIKEN_PC_OUT),PSU_DISABLE=$(PC_PSU_DISABLE),PSU_POWER=$(PC_PSU_POWER)"

# Riken RB2 mode change
$(IFRIKEN=#) seq riken_changeover, "OK_TO_RUN_PSUS=$(MYPVPREFIX)$(RIKEN_RB2C_IN),ALLOW_CHANGEOVER=$(MYPVPREFIX)$(RIKEN_RB2C_OUT),PSU_DISABLE=$(RB2C_PSU_DISABLE),PSU_POWER=$(RB2C_PSU_POWER)"


##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
