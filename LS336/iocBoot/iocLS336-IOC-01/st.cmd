#!../../bin/windows-x64/LS336-IOC-01

## You may have to change LS336-IOC-01 to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

#Define protocol path
#epicsEnvSet("STREAM_PROTOCOL_PATH", "$(LAKESHORE336)/protocol/")
#epicsEnvSet("STREAM_PROTOCOL_PATH", "$(IP)/ipApp/Db/")

## Register all support components
dbLoadDatabase "dbd/LS336-IOC-01.dbd"
LS336_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

#drvAsynIPPortConfigure ("L0","192.168.200.154:7777",0,0,0)
## Load our record instances
#dbLoadRecords("db/LS336.db","P=$(MYPVPREFIX)")
#dbLoadRecords("$(IP)/ipApp/Db/LakeShore336.db","P=$(MYPVPREFIX),Q=LS01,PORT=L0,ADDR=0")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd


