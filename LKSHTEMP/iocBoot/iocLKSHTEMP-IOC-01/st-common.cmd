epicsEnvSet "STREAM_PROTOCOL_PATH" "$(LKSHTEMP)/data"
epicsEnvSet "DEVICE" "L0"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")
## Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"crtscts","N")
## Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixon","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixoff","N")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
stringiftest("LKSH332", "$(DEV_TYPE=LKSH332)", 5, "LKSH332")
stringiftest("LKSH336", "$(DEV_TYPE=LKSH336)", 5, "LKSH336")
stringiftest("LKSH350", "$(DEV_TYPE=LKSH350)", 5, "LKSH350")
stringiftest("LKSH340", "$(DEV_TYPE=LKSH340)", 5, "LKSH340")
stringiftest("LKSH372", "$(DEV_TYPE=LKSH372)", 5, "LKSH372")

$(IFLKSH332) dbLoadRecords("$(LKSH332)/lakeshore332.db", "P=$(MYPVPREFIX)$(IOCNAME), PORT=$(DEVICE), DEV_TYPE=$(DEV_TYPE=LKSH332) ADDR=0, TEMPSCAN=1, SCAN=2, TOLERANCE=1, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")
$(IFLKSH336) dbLoadRecords("$(LKSH336)/db/lakeshore336.db", "P=$(MYPVPREFIX)$(IOCNAME), PORT=$(DEVICE), DEV_TYPE=$(DEV_TYPE=LKSH336) ADDR=0, TEMPSCAN=1, SCAN=2, TOLERANCE=1, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")
$(IFLKSH350) dbLoadRecords("$(LKSH336)/db/lakeshore336.db", "P=$(MYPVPREFIX)$(IOCNAME), PORT=$(DEVICE), DEV_TYPE=$(DEV_TYPE=LKSH336) ADDR=0, TEMPSCAN=1, SCAN=2, TOLERANCE=1, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")
$(IFLKSH340) dbLoadRecords("$(LKSH340)/db/lakeshore340.db", "P=$(MYPVPREFIX)$(IOCNAME), PORT=$(DEVICE), DEV_TYPE=$(DEV_TYPE=LKSH340) ADDR=0, TEMPSCAN=1, SCAN=2, TOLERANCE=1, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")
$(IFLKSH372) dbLoadRecords("$(LKSH372)/db/lakeshore372.db", "P=$(MYPVPREFIX)$(IOCNAME), PORT=$(DEVICE), DEV_TYPE=$(DEV_TYPE=LKSH372) ADDR=0, TEMPSCAN=1, SCAN=2, TOLERANCE=1, RECSIM=$(RECSIM=0), DISABLE=$(DISABLE=0)")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=yyf77781"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
