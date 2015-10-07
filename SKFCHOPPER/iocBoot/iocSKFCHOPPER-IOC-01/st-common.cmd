##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

#drvAsynIPPortConfigure(const char *portName,
#                       const char *hostInfo,
#                       unsigned int priority,
#                       int noAutoConnect,
#                       int noProcessEos);

drvAsynIPPortConfigure("chop","$(IPADDR):$(IPPORT=502)",0,0,1)

# link type is 0 for tcp, 1 for RTU. 2 for ASCII
#modbusInterposeConfig(const char *portName,
#                      modbusLinkType linkType,
#                      int timeoutMsec, 
#                      int writeDelayMsec)
modbusInterposeConfig("chop",0,5000,0)

# Modbus function codes supported are:
#  Read holding registers      03 
#  Preset/write multiple registers   16 
# length always specified in number of 16 bit words,
# address here is 1 less than in chopper register doc with 40xxx prefix removed 
drvModbusAsynConfigure("ctime", "chop", 0, 3, 240, 5, 0, 1000, "SKF Chopper")
drvModbusAsynConfigure("rdir", "chop", 0, 3, 347, 1, 0, 1000, "SKF Chopper")
drvModbusAsynConfigure("rdirw", "chop", 0, 16, 347, 1, 0, 1, "SKF Chopper")
drvModbusAsynConfigure("freq", "chop", 0, 3, 353, 2, 8, 1000, "SKF Chopper")
drvModbusAsynConfigure("freqw", "chop", 0, 16, 345, 2, 8, 1, "SKF Chopper")
drvModbusAsynConfigure("phas", "chop", 0, 3, 362, 2, 8, 1000, "SKF Chopper")
drvModbusAsynConfigure("phasw", "chop", 0, 16, 362, 2, 8, 1, "SKF Chopper")
drvModbusAsynConfigure("phaserr", "chop", 0, 3, 360, 2, 0, 1000, "SKF Chopper")
drvModbusAsynConfigure("phaserrw", "chop", 0, 16, 360, 2, 0, 1, "SKF Chopper")
drvModbusAsynConfigure("veto", "chop", 0, 3, 375, 2, 8, 1000, "SKF Chopper")
drvModbusAsynConfigure("ready", "chop", 0, 3, 367, 2, 8, 1000, "SKF Chopper")
drvModbusAsynConfigure("insync", "chop", 0, 3, 371, 2, 8, 1000, "SKF Chopper")
drvModbusAsynConfigure("start", "chop", 0, 16, 388, 1, 8, 1, "SKF Chopper")
drvModbusAsynConfigure("stop", "chop", 0, 16, 389, 1, 8, 1, "SKF Chopper")
drvModbusAsynConfigure("state", "chop", 0, 3, 462, 1, 0, 1000, "SKF Chopper")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(SKFCHOPPER)/db/SKFChopper.db","P=$(MYPVPREFIX)$(IOCNAME):,TIME_L=ctime,DIR_L=rdir,FREQ_L=freq,PHAS_L=phas,PERR_L=phaserr,VETO_L=veto,READY_L=ready,INSYNC_L=insync,START_L=start,STOP_L=stop,STATE_L=state")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59Host"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
