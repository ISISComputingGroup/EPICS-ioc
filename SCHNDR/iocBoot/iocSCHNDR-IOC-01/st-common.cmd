##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# TCP
#drvAsynIPPortConfigure("$(DEVICE)","$(IPADDR=130.246.48.127):$(IPPORT=502)",0,0,1)
#modbusInterposeConfig("$(DEVICE)",0,5000,0)

# RTU
#drvAsynSerialPortConfigure("$(DEVICE)","COM1",0,0,0)
drvAsynSerialPortConfigure("$(DEVICE)","COM34",0,0,0)
asynSetOption("$(DEVICE)",0,"baud","9600")
#asynSetOption("$(DEVICE)",0,"baud","19200")
asynSetOption("$(DEVICE)",0,"bits","8")
asynSetOption("$(DEVICE)",0,"parity","even")
asynSetOption("$(DEVICE)",0,"stop","1")
asynSetOption("$(DEVICE)",0,"clocal","Y")
asynSetOption("$(DEVICE)",0,"crtscts","N")
asynSetOption("$(DEVICE)",0,"ixon","N")
asynSetOption("$(DEVICE)",0,"ixoff","N")
modbusInterposeConfig("$(DEVICE)",1,5000,2)

# for ASCII but not used - use RTU instead
#drvAsynSerialPortConfigure("$(DEVICE)","COM34",0,0,0)
#asynSetOption("$(DEVICE)",0,"baud","2400")
#asynSetOption("$(DEVICE)",0,"bits","7")
#asynSetOption("$(DEVICE)",0,"parity","even")
#asynSetOption("$(DEVICE)",0,"stop","1")
#asynSetOption("$(DEVICE)",0,"clocal","Y")
#asynSetOption("$(DEVICE)",0,"crtscts","N")
#asynSetOption("$(DEVICE)",0,"ixon","Y")
#asynSetOption("$(DEVICE)",0,"ixoff","Y")
#asynOctetSetOutputEos("$(DEVICE)",0,"\r\n")
#asynOctetSetInputEos("$(DEVICE)",0,"\r\n")
#modbusInterposeConfig("$(DEVICE)",2,5000,2)


# link type is 0 for tcp, 1 for RTU. 2 for ASCII
#modbusInterposeConfig(const char *portName,
#                      modbusLinkType linkType,
#                      int timeoutMsec, 
#                      int writeDelayMsec)

# Modbus function codes supported are:
#  Read holding registers             3 
#  Preset/write multiple registers   16 
# length always specified in number of 16 bit words,
# address here is 1 less than in chopper register doc with 40xxx prefix removed 

## a readback of > 0 on a write (code 16) configure line below means it does a 
## single initial read of the value on IOC startup. 
## 3rd arg is slave address, check on PLC for this. Deosn;rt seem inportant for TCP, but importanf for serial
drvModbusAsynConfigure("$(DEVICE)test", "$(DEVICE)", 1, 3, 2, 1, 0, 1000, "PLC") # or 4

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(TOP)/db/SCHNDR.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),R=faa")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
