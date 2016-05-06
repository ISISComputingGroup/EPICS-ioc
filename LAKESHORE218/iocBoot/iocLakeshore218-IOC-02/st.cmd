#!../../bin/windows-x64/Lakeshore_218-02

## You may have to change Lakeshore_218-02 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(SUPPORT)/lakeshore218/1-0/Lakeshore218Sup"    
epicsEnvSet "TTY" "$(TTY=\\\\\\\\.\\\\COM5)"                                   

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/Lakeshore_218-02.dbd"
Lakeshore_218_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

drvAsynSerialPortConfigure("L0", "$(TTY)", 0, 0, 0, 0)                          
asynSetOption("L0", -1, "baud", "9600")                                         
asynSetOption("L0", -1, "bits", "7")                                            
asynSetOption("L0", -1, "parity", "odd")                                       
asynSetOption("L0", -1, "stop", "1")                                            
#asynOctetSetInputEos("L0", -1, "\r")                                            
#asynOctetSetOutputEos("L0", -1, "\r")                                           

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/Lakeshore_218.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=L0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=luj96656Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
