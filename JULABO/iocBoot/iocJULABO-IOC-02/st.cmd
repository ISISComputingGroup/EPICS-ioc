#!../../bin/windows-x64-debug/JULABO-IOC-02

## You may have to change JULABO-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(SUPPORT)/julabo/julaboApp/protocol"
epicsEnvSet "TTY" "$(TTY=COM18)"

## Register all support components
dbLoadDatabase "dbd/JULABO-IOC-02.dbd"
JULABO_IOC_02_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

drvAsynSerialPortConfigure("L0", "$(TTY)", 0, 0, 0, 0)
asynSetOption("L0", -1, "baud", "4800")
asynSetOption("L0", -1, "bits", "7")
asynSetOption("L0", -1, "parity", "even")
asynSetOption("L0", -1, "stop", "1")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/FP50_MH.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=mjc23Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
