epicsEnvSet "DEVICE" "L0"
epicsEnvSet "ASYNPORT" "DG1"

##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## Device simulation mode IP configuration
$(IFDEVSIM) drvAsynIPPortConfigure("$(DEVICE)", "localhost:$(EMULATOR_PORT=57677)")

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NUL)", 0, 1, 0, 0)

## For real device:

stringiftest("SERIAL", "$(INTERFACE=SERIAL)", 5, "SERIAL")
stringiftest("ETHERNET", "$(INTERFACE=SERIAL)", 5, "ETHERNET")
stringiftest("LITRON", "$(APPLICATION=)", 5, "LITRON")

$(IFETHERNET) $(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynIPPortConfigure("$(DEVICE)", "$(ADDR=):5024")
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE)", "$(PORT=NO_PORT_MACRO)", 0, 0, 0, 0)

## Settings for Serial connections
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "baud", "$(BAUD=9600)")
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "bits", "$(BITS=8)")
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "parity", "$(PARITY=none)")
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", -1, "stop", "$(STOP=1)")

## Hardware flow control off
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)", 0, "clocal", "Y")
## note: above comment says hardware control is off, but it is actually turned on?
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"crtscts","Y")
## Software flow control off
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixon","N")
$(IFSERIAL) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("$(DEVICE)",0,"ixoff","N")

asynOctetSetInputEos("$(DEVICE)",0,"\r\n")
asynOctetSetOutputEos("$(DEVICE)",0,"\n")
## drvAsynDG645(myport,ioport,ioaddr)
#       myport  - Interface asyn port name (i.e. "DG0")
#       ioport  - Comm asyn port name (i.e. "L2")
#       ioaddr  - Comm asyn port addr
#
drvAsynDG645("$(ASYNPORT)","$(DEVICE)",-1);

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(DELAYGEN)/db/drvDG645.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX),R=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(ASYNPORT)")
dbLoadRecords("$(DG645)/db/dg645.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX),R=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(ASYNPORT)")
dbLoadRecordsList("$(DG645)/db/dg645_logic.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX),R=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(ASYNPORT)", "Q", "T0;AB;CD;EF;GH", ";")
dbLoadRecordsList("$(DG645)/db/dg645_delay.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX),R=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(ASYNPORT)", "Q", "T0;T1;A;B;C;D;E;F;G;H", ";")
dbLoadRecordsList("$(DG645)/db/dg645_width.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX),R=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(ASYNPORT)", "Q", "TRG;AB;CD;EF;GH", ";")
dbLoadRecordsList("$(DG645)/db/dg645_delay_width_shared.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX),R=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(ASYNPORT)", "Q", "T0;T1;A;B;C;D;E;F;G;H;TRG;AB;CD;EF;GH", ";")

$(IFLITRON) dbLoadRecords("$(DG645)/db/litron.db", "PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX),R=$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(ASYNPORT)")

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

set_requestfile_path("$(DELAYGEN)/delaygenApp/Db", "")
makeAutosaveFileFromDbInfo("dgconfig_settings.req", "dgconfig")
create_manual_set("dgconfigMenu.req","P=$(MYPVPREFIX)AS:$(IOCNAME):,CONFIG=dgconfig,CONFIGMENU=1")
create_monitor_set("auto_settings.req", 30, "P=$(MYPVPREFIX),R=$(IOCNAME):")

# if we want to apply defaults use this
#dbpf("$(MYPVPREFIX)AS:$(IOCNAME):dgconfigMenu:name", "$(DEFAULTCFG=defaults)")
