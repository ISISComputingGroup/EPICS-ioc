#!../../bin/windows-x64/KICKER-IOC-01

## You may have to change KICKER-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/KICKER-IOC-01.dbd"
KICKER_IOC_01_registerRecordDeviceDriver pdbbase

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(KICKER)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

# Load up DB records for talking to the DAQ box
< iocBoot/iocKICKER-IOC-01/st-daq.cmd

# Load up record for talking to the Schneider M580 PLC 
< iocBoot/iocKICKER-IOC-01/st-schneider.cmd

## Load our record instances
dbLoadRecords("$(KICKER)/db/kicker.db","PVPREFIX=$(MYPVPREFIX), ,P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
dbLoadRecords("$(KICKER)/db/kicker_voltage.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),DAQMX=$(DAQMX = DAQ):,IFNOTRECSIM=$(IFNOTRECSIM),IFRECSIM=$(IFRECSIM),PSU_MAX_VOLT=$(PSU_MAX_VOLT=45),NELM=$(NELM=1000)")
dbLoadRecords("$(KICKER)/db/kicker_current.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),DAQMX=$(DAQMX = DAQ):,IFNOTRECSIM=$(IFNOTRECSIM),IFRECSIM=$(IFRECSIM),PSU_MAX_CURR=$(PSU_MAX_CURR=15),NELM=$(NELM=1000)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=olz75487"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
