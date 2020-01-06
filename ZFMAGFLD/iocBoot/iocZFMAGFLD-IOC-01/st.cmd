#!../../bin/windows-x64/ZFMAGFLD-IOC-01

## You may have to change ZFMAGFLD-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(ZFMAGFLD)/data"
epicsEnvSet "DEVICE" "L0"

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/ZFMAGFLD-IOC-01.dbd"
ZFMAGFLD_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

# Load up DB record for talking to the DAQ box
< iocBoot/iocZFMAGFLD-IOC-01/st-daq.cmd

## Load our record instances
dbLoadRecords("$(ZFMAGFLD)/db/zfmagfld_axes.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),IFNOTRECSIM=$(IFNOTRECSIM),IFRECSIM=$(IFRECSIM),OFFSETX=$(OFFSETX=0),OFFSETY=$(OFFSETY=0),OFFSETZ=$(OFFSETZ=0)")
dbLoadRecords("$(ZFMAGFLD)/db/zfmagfld_sensor_matrix.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RANGE=$(RANGE=1),MATRIX_11=$(MATRIX_1_1=0),MATRIX_12=$(MATRIX_1_2=0),MATRIX_13=$(MATRIX_1_3=0),MATRIX_21=$(MATRIX_2_1=0),MATRIX_22=$(MATRIX_2_2=0),MATRIX_23=$(MATRIX_2_3=0),MATRIX_31=$(MATRIX_3_1=0),MATRIX_32=$(MATRIX_3_2=0),MATRIX_33=$(MATRIX_3_3=0)")
dbLoadRecords("$(ZFMAGFLD)/db/zfmagfld.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),SQNCR=$(SQNCR=$(MYPVPREFIX)ZFCNTRL_01:INPUTS_UPDATED.PROC CA)")
dbLoadRecords("$(ZFMAGFLD)/db/zfmagfld_errors.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=dzd77598"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

DAQmxStart("R0")
