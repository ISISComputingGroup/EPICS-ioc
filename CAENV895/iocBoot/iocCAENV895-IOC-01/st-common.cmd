
##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## create an instance for each VME crate
## crate is the logical crate number we want to refer to it by, board_id is the crate number that the crate has been assigned
## by the USB. If a usb board in the VME crate was changed for example then it may appear with a different board_id but we are
## able here to map it back to our own crate number so the PVs remain the same.  
## CAENVMEConfigure(const char *portName, int crate, int board_id, unsigned base_address, unsigned card_increment, bool simulate)

$(IFDEVSIM) CAENVMEConfigure("CRATE0", 0, 0, 0, 0x10000, 1)
$(IFRECSIM) CAENVMEConfigure("CRATE0", 0, 0, 0, 0x10000, 1)
$(IFNOTDEVSIM) $(IFNOTRECSIM) CAENVMEConfigure("CRATE0", 0, 0, 0, 0x10000, 0)

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

set_pass0_restoreFile("auto_settings.sav")
set_pass1_restoreFile("auto_settings.sav")

## Load our record instances
dbLoadRecords("$(CAENVME)/db/v895Crate.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=0,PORT=CRATE0")
dbLoadRecords("$(CAENVME)/db/v895Card.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=0,PORT=CRATE0,C=0")
dbLoadRecords("$(CAENVME)/db/v895Card.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=0,PORT=CRATE0,C=1")
dbLoadRecords("$(CAENVME)/db/v895Card.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=0,PORT=CRATE0,C=2")
dbLoadRecords("$(CAENVME)/db/v895Card.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=0,PORT=CRATE0,C=3")
dbLoadRecords("$(CAENVME)/db/v895Card.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=0,PORT=CRATE0,C=4")
dbLoadRecords("$(CAENVME)/db/v895Card.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=0,PORT=CRATE0,C=5")
dbLoadRecords("$(CAENVME)/db/v895Card.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=0,PORT=CRATE0,C=6")

$(IFDEVSIM) dbLoadRecords("$(CAENVME)/db/v895SimTest.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=0,PORT=CRATE0,C=0")

## load autosave configMenu for managing sets of PVs
dbLoadRecords("$(AUTOSAVE)/db/configMenu.db","P=$(MYPVPREFIX)AS:$(IOCNAME):,CONFIG=vmeconfig")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd

makeAutosaveFileFromDbInfo("vmeconfig_settings.req", "vmeconfig")
create_manual_set("vmeconfigMenu.req","P=$(MYPVPREFIX)AS:$(IOCNAME):,CONFIG=vmeconfig,CONFIGMENU=1")

create_monitor_set("auto_settings.req", 30, "P=$(MYPVPREFIX)AS:$(IOCNAME):")

## choice: if you have loaded "defaults" config, make a change but do not save it back to defults, and restart ioc.
## what do you want to happen? 
## this would load last settings i.e. including your change, kept here in case we wish to swap back to it
#fdbrestore("vmeconfigMenu.sav")
## this loads the original "defaults" config, so discards any changes that have not been manually saved
## macro DEFAULTCFG is really for use by testing framework
dbpf("$(MYPVPREFIX)AS:$(IOCNAME):vmeconfigMenu:name", "$(DEFAULTCFG=defaults)")
