epicsEnvSet "STREAM_PROTOCOL_PATH" "$(AEROFLEX)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

stringiftest("SERIAL", "$(PORT=)")
stringiftest("PROLOGIX", "$(PL_IPADDR=)")

## for real device using prologix gpib 
$(IFPROLOGIX) $(IFNOTDEVSIM) $(IFNOTRECSIM) prologixGPIBConfigure("$(DEVICE)", "$(PL_IPADDR=)")

## For real device on serial
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=9600)")
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")
## Hardware flow control off
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", 0, "clocal", "Y")
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"crtscts","N")
## Software flow control off
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixon","N")
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixoff","N")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
stringiftest("2023A", "$(DEV_TYPE=2023A)", 5, "2023A")
$(IF2023A) dbLoadRecords("$(AEROFLEX)/db/aeroflex_common.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),DEV_TYPE=$(DEV_TYPE=2023A),RF_PREC=6,ADDR=$(BUS_ADDR=0)")
$(IFNOT2023A) dbLoadRecords("$(AEROFLEX)/db/aeroflex_common.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),DEV_TYPE=$(DEV_TYPE=2030),RF_PREC=2,ADDR=$(BUS_ADDR=0)")
dbLoadRecords("$(AEROFLEX)/db/aeroflex_modulation.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),DEV_TYPE=$(DEV_TYPE=2030),ADDR=$(BUS_ADDR=0)")
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=$(IOCNAME):ASYN,PORT=$(DEVICE),ADDR=$(BUS_ADDR=0),OMAX=256,IMAX=256")
## Load device type specific st.cmd
< iocBoot/iocAEROFLEX-IOC-01/st-$(DEV_TYPE=2023A).cmd

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=nzc18866"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
