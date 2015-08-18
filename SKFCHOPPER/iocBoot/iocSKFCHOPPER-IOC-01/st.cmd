#!../../bin/windows-x64-debug/SKFCHOPPER-IOC-01

## You may have to change SKFCHOPPER-IOC-01 to something else
## everywhere it appears in this file

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/SKFCHOPPER-IOC-01.dbd"
SKFCHOPPER_IOC_01_registerRecordDeviceDriver pdbbase

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

#drvAsynIPPortConfigure(const char *portName,
#                       const char *hostInfo,
#                       unsigned int priority,
#                       int noAutoConnect,
#                       int noProcessEos);

drvAsynIPPortConfigure("chop1","130.246.54.103:502",0,0,1)
drvAsynIPPortConfigure("chop2","130.246.54.104:502",0,0,1)

# link type is 0 for tcp, 1 for RTU. 2 for ASCII
#modbusInterposeConfig(const char *portName,
#                      modbusLinkType linkType,
#                      int timeoutMsec, 
#                      int writeDelayMsec)
modbusInterposeConfig("chop1",0,5000,0)
modbusInterposeConfig("chop2",0,5000,0)

# Modbus function codes supported are:
#  Read holding registers      03 
#  Preset/write multiple registers   16 
# length always specified in number fo 16 bit words, 
drvModbusAsynConfigure("runspeed1", "chop1", 0, 3, 353, 2, 8, 1000, "SKF Chopper")
drvModbusAsynConfigure("time1", "chop1", 0, 3, 240, 5, 0, 1000, "SKF Chopper")
drvModbusAsynConfigure("time1w", "chop1", 0, 16, 242, 1, 0, 1, "SKF Chopper")
drvModbusAsynConfigure("rdir1", "chop1", 0, 3, 347, 1, 0, 1000, "SKF Chopper")
drvModbusAsynConfigure("rdir1w", "chop1", 0, 16, 347, 1, 0, 1, "SKF Chopper")

drvModbusAsynConfigure("runspeed2", "chop2", 0, 3, 353, 2, 8, 1000, "SKF Chopper")
drvModbusAsynConfigure("time2", "chop2", 0, 3, 240, 5, 0, 1000, "SKF Chopper")
drvModbusAsynConfigure("time2w", "chop2", 0, 16, 242, 1, 0, 1, "SKF Chopper")
drvModbusAsynConfigure("rdir2", "chop2", 0, 3, 347, 1, 0, 1000, "SKF Chopper")
drvModbusAsynConfigure("rdir2w", "chop2", 0, 16, 347, 1, 0, 1, "SKF Chopper")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(SKFCHOPPER)/db/SKFChopper.db","P=$(MYPVPREFIX)SKF1:,PORT1=runspeed1,PORT2=time1,PORT3=rdir1")
dbLoadRecords("$(SKFCHOPPER)/db/SKFChopper.db","P=$(MYPVPREFIX)SKF2:,PORT1=runspeed2,PORT2=time2,PORT3=rdir2")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
