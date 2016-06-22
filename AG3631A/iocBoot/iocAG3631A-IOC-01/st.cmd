#!../../bin/windows-x64-debug/AG3631A-IOC-01

## You may have to change AG3631A-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(AGILENT3631A)/agilent3631ASup"

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/AG3631A-IOC-01.dbd"
AG3631A_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

#Set up the GPIB access
#GpibBoardDriverConfig("GPIB0","1","0","3","0")
#asynOctetSetInputEos("GPIB0", 1, "\n")
#asynOctetSetOutputEos("GPIB0", 1, "\n")

#Set up serial port
drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
asynSetOption("L0", -1, "baud", "9600")
asynSetOption("L0", -1, "bits", "8")
asynSetOption("L0", -1, "parity", "none")
asynSetOption("L0", -1, "stop", "1")
asynOctetSetInputEos("L0", -1, "\r\n")
asynOctetSetOutputEos("L0", -1, "\r\n")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
#dbLoadRecords("db/devagilent3631A.db","P=$(MYPVPREFIX)$(IOCNAME):,R=:,PORT=GPIB0,A=1")  #GPIB
dbLoadRecords("db/devagilent3631A.db","P=$(MYPVPREFIX)$(IOCNAME):,R=:,PORT=L0,A=0")      #Serial

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=mjc23Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
