#!../../bin/windows-x64/KYNCTM3K-IOC-01

## You may have to change KYNCTM3K-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

#< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(KYNCTM3K)/data"
epicsEnvSet "DEVICE" "L0"

#cd "${TOP}"

## Register all support components
#dbLoadDatabase "dbd/KYNCTM3K-IOC-01.dbd"
#KYNCTM3K_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(KYNCTM3K)/db/KYNCTM3K.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),MEAS_UNITS=$(MEAS_UNITS=mm)")
dbLoadRecords("$(KYNCTM3K)/db/KYNCTM3K_out_channels.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),MEAS_UNITS=$(MEAS_UNITS=mm),DISCHAN01=$(DISCHAN01=),DISCHAN02=$(DISCHAN02=),DISCHAN03=$(DISCHAN03=),DISCHAN04=$(DISCHAN04=),DISCHAN05=$(DISCHAN05=),DISCHAN06=$(DISCHAN06=),DISCHAN07=$(DISCHAN07=),DISCHAN08=$(DISCHAN08=),DISCHAN09=$(DISCHAN09=),DISCHAN10=$(DISCHAN10=),DISCHAN11=$(DISCHAN11=),DISCHAN12=$(DISCHAN12=),DISCHAN13=$(DISCHAN13=),DISCHAN14=$(DISCHAN14=),DISCHAN15=$(DISCHAN15=),DISCHAN16=$(DISCHAN16=)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=mcga"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
