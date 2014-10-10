#!../../bin/windows-x64-debug/HAMEG8123-IOC-02

## You may have to change HAMEG8123-IOC-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(SUPPORT)/Hameg_8123/1-0/Hameg_8123Sup"    
epicsEnvSet "TTY" "$(TTY=\\\\\\\\.\\\\COM20)"  

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/HAMEG8123-IOC-02.dbd"
HAMEG8123_IOC_02_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

drvAsynSerialPortConfigure("L0", "$(TTY)", 0, 0, 0, 0)                          
asynSetOption("L0", -1, "baud", "9600")                                         
asynSetOption("L0", -1, "bits", "8")                                            
asynSetOption("L0", -1, "parity", "none")                                       
asynSetOption("L0", -1, "stop", "1")                                           
asynOctetSetInputEos("L0", -1, "\r")                                            
asynOctetSetOutputEos("L0", -1, "\r")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/devHameg_8123.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
