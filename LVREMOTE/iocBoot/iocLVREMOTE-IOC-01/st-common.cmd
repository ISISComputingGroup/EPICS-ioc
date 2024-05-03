epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LVREMOTE)/data"
epicsEnvSet "STRING_PORT" "L0"
epicsEnvSet "NUM_PORT" "L1"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd


## For STRING_PORT:
drvAsynIPPortConfigure("$(STRING_PORT)", "LOCALHOST:64008 TCP")
asynOctetConnect("STRINGINIT","$(STRING_PORT)")
asynOctetWrite("STRINGINIT" "*IDN? ")
## For NUM_PORT:
drvAsynIPPortConfigure("$(NUM_PORT)", "LOCALHOST:64009 TCP")
asynOctetConnect("NUMINIT","$(NUM_PORT)")
asynOctetWrite("NUMINIT" "*IDN? ")
# Wait for labview to initalise
epicsThreadSleep(5)
## Load record instances
asynSetTraceIOMask("L1", -1, 0x2)
asynSetTraceMask("L1", -1, 0x9)
asynSetTraceIOTruncateSize("L1", -1, 1024)
##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd


## Load our record instances
dbLoadRecords("$(TOP)/db/lvremotetest.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),STRING_PORT=$(STRING_PORT),NUM_PORT=$(NUM_PORT)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit


##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

