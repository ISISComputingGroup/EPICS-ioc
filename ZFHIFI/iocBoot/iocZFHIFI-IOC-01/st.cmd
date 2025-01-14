#!../../bin/windows-x64/ZFHIFI-IOC-01

## You may have to change ZFHIFI-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/ZFHIFI-IOC-01.dbd"
ZFHIFI_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

stringiftest("SAVEFEEDBACKMODE" "$(SAVEFEEDBACKMODE=NO)" 5 "YES")
## Load our record instances
epicsEnvSet("P", "$(MYPVPREFIX)$(IOCNAME):")

dbLoadRecords("$(ZFHIFI)/db/zfhifi.db", "P=$(P),DISABLE=$(DISABLE=0),PSU_X=$(PSU_X=not_set),PSU_Y=$(PSU_Y=not_set),PSU_Z=$(PSU_Z=not_set),MAGNETOMETER_X1=$(MAGNETOMETER_X1=not_set),MAGNETOMETER_Y1=$(MAGNETOMETER_Y1=not_set),MAGNETOMETER_Z1=$(MAGNETOMETER_Z1=not_set),MAGNETOMETER_X2=$(MAGNETOMETER_X2=not_set),MAGNETOMETER_Y2=$(MAGNETOMETER_Y2=not_set),MAGNETOMETER_Z2=$(MAGNETOMETER_Z2=not_set),IFNOTSAVEFEEDBACKMODE=$(IFNOTSAVEFEEDBACKMODE),IFSAVEFEEDBACKMODE=$(IFSAVEFEEDBACKMODE)")

dbLoadRecords("$(ZFHIFI)/db/zfhifi_magnetometer_axis.db", "P=$(P),MAGNETOMETER_X1=$(MAGNETOMETER_X1=not_set),MAGNETOMETER_Y1=$(MAGNETOMETER_Y1=not_set),MAGNETOMETER_Z1=$(MAGNETOMETER_Z1=not_set),MAGNETOMETER_X2=$(MAGNETOMETER_X2=not_set),MAGNETOMETER_Y2=$(MAGNETOMETER_Y2=not_set),MAGNETOMETER_Z2=$(MAGNETOMETER_Z2=not_set)")
dbLoadRecords("$(ZFHIFI)/db/zfhifi_field_axis.db", "P=$(P),PSU_X=$(PSU_X=not_set),PSU_Y=$(PSU_Y=not_set),PSU_Z=$(PSU_Z=not_set),PSU_X_MIN=$(PSU_X_MIN=0),PSU_X_MAX=$(PSU_X_MAX=0),PSU_Y_MIN=$(PSU_Y_MIN=0),PSU_Y_MAX=$(PSU_Y_MAX=0),PSU_Z_MIN=$(PSU_Z_MIN=0),PSU_Z_MAX=$(PSU_Z_MAX=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

seq zero_field, "P=$(P)"
