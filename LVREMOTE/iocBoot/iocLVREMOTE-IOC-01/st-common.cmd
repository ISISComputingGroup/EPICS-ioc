epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LVREMOTE)/data"
epicsEnvSet "STRING_PORT" "L0"
epicsEnvSet "NUM_PORT" "L1"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

cd "${TOP}/iocBoot/${IOC}"
##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd


## create STRING_PORT (Required for String and Enum template)
drvAsynIPPortConfigure("$(STRING_PORT)", "$(IPADDR):64008 TCP")
asynOctetConnect("STRINGINIT","$(STRING_PORT)")
asynOctetWrite("STRINGINIT" "*IDN? ")

## create NUM_PORT (Requred for binary, enum and double template)
drvAsynIPPortConfigure("$(NUM_PORT)", "$(IPADDR):64009 TCP")
asynOctetConnect("NUMINIT","$(NUM_PORT)")
asynOctetWrite("NUMINIT" "*IDN? ")
# Wait for labview to initalise
epicsThreadSleep(5)

## Load our record instances
dbLoadRecords("$(LVREMOTE)/db/lvremotetest.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),STRING_PORT=$(STRING_PORT),NUM_PORT=$(NUM_PORT), IFNOTRECSIM=$(IFNOTRECSIM)")



##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

