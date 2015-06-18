#!../../bin/windows-x64-debug/CONEXAGP-IOC-01

## You may have to change CONEXAGP-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/CONEXAGP-IOC-01.dbd"
CONEXAGP_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

$(IFSIM) motorSimCreateController("motor", 1) 
$(IFSIM) motorSimConfigAxis("motor", 0, 32000, -320000,  0, 0) 

$(IFNOTSIM) drvAsynSerialPortConfigure("serial1", "$(PORT=NL:)", 0, 0, 0)
$(IFNOTSIM) asynOctetSetInputEos("serial1",0,"\r\n") 
$(IFNOTSIM) asynOctetSetOutputEos("serial1",0,"\r\n") 
$(IFNOTSIM) asynSetOption("serial1",0,"baud","$(BAUD=9600)") 
$(IFNOTSIM) asynSetOption("serial1",0,"bits","8") 
$(IFNOTSIM) asynSetOption("serial1",0,"stop","1") 
$(IFNOTSIM) asynSetOption("serial1",0,"parity","none") 
$(IFNOTSIM) asynSetOption("serial1",0,"clocal","Y") 
$(IFNOTSIM) asynSetOption("serial1",0,"crtscts","N") 
$(IFNOTSIM) asynSetTraceIOMask("serial1", 0, 2)

# asyn_port, serial_port, controller_id, moving_poll_period(ms), idle_poll_period(ms)
$(IFNOTSIM) AG_CONEXCreateController("motor","serial1",1,50,500)

asynSetTraceIOMask("motor", 0, 2)

## Load record instances

# Load asyn record 
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=M1:ASYN,PORT=serial1, ADDR=0,OMAX=256,IMAX=256") 
dbLoadRecords("$(TOP)/db/motor.db", "P=$(MYPVPREFIX),M=M1") 

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
