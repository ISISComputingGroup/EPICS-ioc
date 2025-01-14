epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LVREMOTE)/data"
epicsEnvSet "DEVICE" "L0"
epicsEnvSet "NUM_PORT" "L1"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(NUM_PORT)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)
$(IFRECSIM) drvAsynSerialPortConfigure("$(NUM_PORT)", "$(PORT=NUL)", 0, 1, 0, 0)

## create NUM_PORT (Requred for binary, enum and double template)
$(IFNOTRECSIM) $(IFNOTDEVSIM) drvAsynIPPortConfigure("$(NUM_PORT)", "$(IPADDR):64009 TCP")

$(IFNOTRECSIM) asynOctetConnect("NUMINIT","$(NUM_PORT)")
$(IFNOTRECSIM) asynOctetWrite("NUMINIT" "*IDN? ")

# Wait for labview to initalise
$(IFNOTRECSIM) epicsThreadSleep(5)
#$(IFNOTRECSIM) asynSetTraceIOMask("$(NUM_PORT)", -1, 0x4)
#$(IFNOTRECSIM) asynSetTraceMask("$(NUM_PORT)", -1, 0x9)

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(LITRON)/db/litron.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),IFNOTRECSIM=$(IFNOTRECSIM),VI_PATH=$(VI_PATH=C:/labview modules/Instruments/HIFI/HIFI Laser/HIFI Laser - FrontPanel.vi),NUM_PORT=$(NUM_PORT),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=yyf77781"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
