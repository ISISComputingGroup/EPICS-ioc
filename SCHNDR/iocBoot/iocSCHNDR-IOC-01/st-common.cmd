##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## load appropriate setup file (TCP, RTU or ASCII)
< st-$(MODE).cmd

# Modbus function codes supported are:
#  Read holding registers             3 
#  Preset/write multiple registers   16 
# length always specified in number of 16 bit words,
# address here is 1 less than in chopper register doc with 40xxx prefix removed 

## a readback of > 0 on a write (code 16) configure line below means it does a 
## single initial read of the value on IOC startup. code1
## 3rd arg is PLC slave address, check on PLC for this. Doesn't seem important for TCP, but is for RTU/ASCII
## subtract 40001 from 40x register addresses that are read by code 3
drvModbusAsynConfigure("$(DEVICE)heartbeat", "$(DEVICE)", 1, 3, 649, 1, 0, 1000, "PLC")
drvModbusAsynConfigure("$(DEVICE)gatevalve", "$(DEVICE)", 1, 3, 1314, 1, 0, 1000, "PLC")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(TOP)/db/SCHNDR.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),R=")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
