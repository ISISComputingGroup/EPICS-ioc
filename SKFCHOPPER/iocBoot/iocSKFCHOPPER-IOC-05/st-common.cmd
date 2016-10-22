##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

# set name of chopper port for use later
epicsEnvSet("CHOP", "c5")

#drvAsynIPPortConfigure(const char *portName,
#                       const char *hostInfo,
#                       unsigned int priority,
#                       int noAutoConnect,
#                       int noProcessEos);

drvAsynIPPortConfigure("$(CHOP)","$(IPADDR):$(IPPORT=502)",0,0,1)

# link type is 0 for tcp, 1 for RTU. 2 for ASCII
#modbusInterposeConfig(const char *portName,
#                      modbusLinkType linkType,
#                      int timeoutMsec, 
#                      int writeDelayMsec)
modbusInterposeConfig("$(CHOP)",0,5000,0)

# load modbus definitions for use by SKFChopper.db, this used $(CHOP)
< $(SKFCHOPPER)/data/SKFChopper.cmd

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(SKFCHOPPER)/db/SKFChopper.db","P=$(MYPVPREFIX)$(IOCNAME):,CHOP=$(CHOP),NAME=$(NAME),OPEN=$(OPEN),CLOSED=$(CLOSED)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
