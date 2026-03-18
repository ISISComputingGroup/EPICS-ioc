
epicsEnvSet("DEVICE", "L0")
##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

$(IFNOTRECSIM) $(IFNOTDEVSIM) drvAsynIPPortConfigure("$(DEVICE)","$(IPADDR=127.0.0.1):$(IPPORT=502)",0,0,1)

$(IFNOTRECSIM) modbusInterposeConfig("$(DEVICE)",0,5000,0,0)

## Analog data: up to 200 acquisition data channels
## data channels are added in blocks of 20, so just do 20 channels for now (which is 40 16 bit words for 32bit float)
## modbus function code 4 for read input register
drvModbusAsynConfigure("ACQ1", "$(DEVICE)", 0, 4, 8, 40, 0, 1000, "DAS240")
$(IFACQ2=#) drvModbusAsynConfigure("ACQ2", "$(DEVICE)", 0, 4, 48, 40, 0, 1000, "DAS240")

## 4 logical function channels
## modbus function code 4 for read input register
drvModbusAsynConfigure("LOGF", "$(DEVICE)", 0, 4, 408, 8, 0, 1000, "DAS240")

# Logical data: modbus function code 2 for read discrete inputs, 12 channels
drvModbusAsynConfigure("LOGD", "$(DEVICE)", 0, 2, 8, 12, 0, 1000, "DAS240")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("db/DAS240.db","P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")
## load appropriate number of analogue cards, each has 20 channels, maximum 10 cards
dbLoadRecords("db/DAS240A.db","P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=ACQ1,C=1")
$(IFACQ2=#) dbLoadRecords("db/DAS240A.db","P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=ACQ2,C=2")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
