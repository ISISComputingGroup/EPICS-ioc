cd ${TOP}

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

epicsEnvSet ("STREAM_PROTOCOL_PATH", "$(TOP)/data")

# Portname, port address
$(IFRECSIM) drvAsynSerialPortConfigure("ASTRIUM", "$(PORT=NUL)", 0, 1, 0, 0)
$(IFNOTRECSIM) astriumDriverConfigure("ASTRIUM", "$(IP_ADDR):$(IP_PORT)", $(DEVSIM=0))

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

dbLoadRecords("db/astrium_common.db","P=$(MYPVPREFIX)$(IOCNAME):, PORT=ASTRIUM, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")

## Load our record instances (conditionally!)
dbLoadRecordsLoop("db/astrium.db","P=$(MYPVPREFIX)$(IOCNAME):, Q=CH\$(I):, I=\$(I), PORT=ASTRIUM, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)", "I", 1, 2, 1)

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
