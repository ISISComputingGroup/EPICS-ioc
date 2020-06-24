#!../../bin/linux-x86_64/RKNPS-IOC-01

## You may have to change RKNPS-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "IOCNAME" "RKNPS_01"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/RKNPS-IOC-01.dbd"
RKNPS_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(DANFYSIK8000)/danfysikMps8000App/protocol/RIKEN/"

# Load up DB records for communicating with PSUs
iocshCmdLoop("< iocBoot/iocRKNPS-IOC-01/st-psu-chain.cmd", "CHAIN=\$(CHAIN)", "CHAIN", 1, 4)

# Load up DB record for talking to the DAQ box
< iocBoot/iocRKNPS-IOC-01/st-daq.cmd

epicsEnvSet("RIKEN_PC_OUT","RKNPS_01:DAQ:W00:DATA.A")
epicsEnvSet("RIKEN_PC_IN","RKNPS_01:DAQ:R00:DATA")

# Riken port change
epicsEnvSet(PC_PSU_DISABLE,$(MYPVPREFIX)$(IOCNAME):PC:PSUS:DISABLE)
epicsEnvSet(PC_PSU_POWER,$(MYPVPREFIX)$(IOCNAME):PC:PSUS:POWER)

dbLoadRecords("$(TOP)/db/riken_changeover.db","P=$(MYPVPREFIX)$(IOCNAME):PC:,PSU_DISABLE=$(PC_PSU_DISABLE),PSU_POWER=$(PC_PSU_POWER)")
dbLoadRecords("$(TOP)/db/riken_port_changeover_psus.db","PV_PREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):PC:,PSU_DISABLE=$(PC_PSU_DISABLE)")

epicsEnvSet("RIKEN_RB2C_OUT","RKNPS_01:DAQ:W01:DATA.A")
epicsEnvSet("RIKEN_RB2C_IN","RKNPS_01:DAQ:R01:DATA")

# Riken RB2 mode change
epicsEnvSet(RB2C_PSU_DISABLE,$(MYPVPREFIX)$(IOCNAME):RB2C:PSUS:DISABLE)
epicsEnvSet(RB2C_PSU_POWER,$(MYPVPREFIX)$(IOCNAME):RB2C:PSUS:POWER)

dbLoadRecords("$(TOP)/db/riken_changeover.db","P=$(MYPVPREFIX)$(IOCNAME):RB2C:,PSU_DISABLE=$(RB2C_PSU_DISABLE),PSU_POWER=$(RB2C_PSU_POWER)")
dbLoadRecords("$(TOP)/db/riken_rb2_mode_changeover_psus.db","PV_PREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):RB2C:,PSU_DISABLE=$(RB2C_PSU_DISABLE)")

dbLoadRecords("$(TOP)/db/riken_psu_banner.db","P=$(MYPVPREFIX)$(IOCNAME):")

# Riken RB2 mode and port 3/4 monitoring
dbLoadRecords("$(TOP)/db/riken_port_monitor.db","P=$(MYPVPREFIX)$(IOCNAME):,DAQMX=$(MYPVPREFIX)$(IOCNAME):DAQ:,PORT=R0")

# Riken DaqMx connection monitoring
dbLoadRecords("$(TOP)/db/riken_daqmx.db","P=$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

# Riken port change
seq riken_changeover, "OK_TO_RUN_PSUS=$(MYPVPREFIX)$(RIKEN_PC_IN),ALLOW_CHANGEOVER=$(MYPVPREFIX)$(RIKEN_PC_OUT),PSU_DISABLE=$(PC_PSU_DISABLE),PSU_POWER=$(PC_PSU_POWER)"

# Riken RB2 mode change
seq riken_changeover, "OK_TO_RUN_PSUS=$(MYPVPREFIX)$(RIKEN_RB2C_IN),ALLOW_CHANGEOVER=$(MYPVPREFIX)$(RIKEN_RB2C_OUT),PSU_DISABLE=$(RB2C_PSU_DISABLE),PSU_POWER=$(RB2C_PSU_POWER)"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd


