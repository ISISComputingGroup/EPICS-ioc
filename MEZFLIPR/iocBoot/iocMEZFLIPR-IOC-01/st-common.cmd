#!../../bin/windows-x64/MEZFLIPR-IOC-01

# Increase this if you get <<TRUNCATED>> or discarded messages warnings in your errlog output
errlogInit2(65536, 256)

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(MEZFLIPR)/data"
epicsEnvSet "DEVICE" "L0"

cd "${TOP}"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration:
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

# For real device:
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynIPPortConfigure("$(DEVICE)", "$(HOST)")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

stringiftest("USES_V1_PROTOCOL", "$(PROTOCOL_VERSION=2)", 5, "1")
stringiftest("USES_V2_PROTOCOL", "$(PROTOCOL_VERSION=2)", 5, "2")

## Load our record instances
$(IFUSES_V2_PROTOCOL) dbLoadRecords("$(MEZFLIPR)/db/mezflipr_common_v2.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")
$(IFUSES_V2_PROTOCOL) dbLoadRecords("$(MEZFLIPR)/db/mezflipr_single_v2.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE),NAME=FLIPPER")

$(IFUSES_V1_PROTOCOL) stringiftest("POLARISERPRESENT", "$(POLARISERPRESENT=)",5,"yes")
$(IFUSES_V1_PROTOCOL) stringiftest("ANALYSERPRESENT", "$(ANALYSERPRESENT=)",5,"yes")
$(IFUSES_V1_PROTOCOL) 
$(IFUSES_V1_PROTOCOL) ## Load our record instances
$(IFUSES_V1_PROTOCOL) dbLoadRecords("$(MEZFLIPR)/db/mezflipr_common_v1.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),IFANALYSERPRESENT=$(IFANALYSERPRESENT),IFPOLARISERPRESENT=$(IFPOLARISERPRESENT),IFNOTANALYSERPRESENT=$(IFNOTANALYSERPRESENT),IFNOTPOLARISERPRESENT=$(IFNOTPOLARISERPRESENT)")
$(IFUSES_V1_PROTOCOL) 
$(IFUSES_V1_PROTOCOL) $(IFANALYSERPRESENT) dbLoadRecords("$(MEZFLIPR)/db/mezflipr_single_v1.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),NAME=ANALYSER,CODE=a")
$(IFUSES_V1_PROTOCOL) $(IFPOLARISERPRESENT) dbLoadRecords("$(MEZFLIPR)/db/mezflipr_single_v1.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),NAME=POLARISER,CODE=p")


##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"

iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
