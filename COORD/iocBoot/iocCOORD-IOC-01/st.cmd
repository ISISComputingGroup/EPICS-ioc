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

< ${TOP}/iocBoot/${IOC}/st_riken_port_changeover.cmd
< ${TOP}/iocBoot/${IOC}/st_riken_rb2_mode_changeover.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

seq riken_changeover, "OK_TO_RUN_PSUS=$(PC_OK_TO_RUN_PSUS),ALLOW_CHANGEOVER=$(PC_ALLOW_CHANGEOVER),PSU_DISABLE=$(PC_PSU_DISABLE),PSU_POWER=$(PC_PSU_POWER)"
seq riken_changeover, "OK_TO_RUN_PSUS=$(RB2C_OK_TO_RUN_PSUS),ALLOW_CHANGEOVER=$(RB2C_ALLOW_CHANGEOVER),PSU_DISABLE=$(RB2C_PSU_DISABLE),PSU_POWER=$(RB2C_PSU_POWER)"


##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
