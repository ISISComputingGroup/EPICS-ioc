epicsEnvSet "STREAM_PROTOCOL_PATH" "$(DG645)/data"
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
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"crtscts","Y")
## Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixon","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixoff","N")
asynOctetSetInputEos("$(DEVICE)",0,"\r\n")
asynOctetSetOutputEos("$(DEVICE)",0,"\n")
## drvAsynDG645(myport,ioport,ioaddr)
#       myport  - Interface asyn port name (i.e. "DG0")
#       ioport  - Comm asyn port name (i.e. "L2")
#       ioaddr  - Comm asyn port addr
#
drvAsynDG645("DG1","$(DEVICE)",-1);

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(DELAYGEN)/db/drvDG645.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX),R=$(IOCNAME): ,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DG1")
dbLoadRecords("$(DG645)/db/dg645.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX),R=$(IOCNAME): ,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DG1")
dbLoadRecordsList("$(DG645)/db/dg645_logic.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX),R=$(IOCNAME): ,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DG1", "Q", "T0;AB;CD;EF", ";")
dbLoadRecordsList("$(DG645)/db/dg645_delay.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX),R=$(IOCNAME): ,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DG1", "Q", "T0;T1;A;B;C;D;E;F;G;H", ";")
dbLoadRecordsList("$(DG645)/db/dg645_width.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX),R=$(IOCNAME): ,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=DG1", "Q", "TRG;AB;CD;EF", ";")

## load autosave configMenu for managing sets of PVs
dbLoadRecords("$(AUTOSAVE)/db/configMenu.db","P=$(MYPVPREFIX)AS:$(IOCNAME):,CONFIG=dgconfig")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=lvj36227"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

makeAutosaveFileFromDbInfo("dgconfig_settings.req", "dgconfig")
create_manual_set("dgconfigMenu.req","P=$(MYPVPREFIX)AS:$(IOCNAME):,CONFIG=dgconfig,CONFIGMENU=1")
create_monitor_set("auto_settings.req", 30, "P=$(MYPVPREFIX)AS:$(IOCNAME):")
dbpf("$(MYPVPREFIX)AS:$(IOCNAME):dgconfigMenu:name", "$(DEFAULTCFG=defaults)")