
##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

## create an instance for each VME crate
## crate is the logical crate number we want to refer to it by, board_id is the crate number that the crate has been assigned
## by the USB. If a usb board in the VME crate was changed for example then it may appear with a different board_id but we are
## able here to map it back to our own crate number so the PVs remain the same.  
## CAENVMEConfigure(const char *portName, int crate, int board_id, unsigned base_address, unsigned card_increment, bool simulate)

$(IFDEVSIM) CAENVMEConfigure("CRATE0", 0, 0, 0, 0x10000, 1)
$(IFRECSIM) CAENVMEConfigure("CRATE0", 0, 0, 0, 0x10000, 1)

stringiftest("CRATE0", "$(CARDS0=)")
stringiftest("CRATE1", "$(CARDS1=)")
stringiftest("CRATE2", "$(CARDS2=)")

$(IFNOTDEVSIM) $(IFNOTRECSIM) $(IFCRATE0) CAENVMEConfigure("CRATE0", $(MY_BOARD_NUMBER_0=0x1), $(CAEN_BOARD_NUMBER_0=0x0), $(BASE_ADDRESS_0=0x0), 0x10000, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) $(IFCRATE1) CAENVMEConfigure("CRATE1", $(MY_BOARD_NUMBER_1=0x2), $(CAEN_BOARD_NUMBER_1=0x1), $(BASE_ADDRESS_1=0x0), 0x10000, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) $(IFCRATE2) CAENVMEConfigure("CRATE2", $(MY_BOARD_NUMBER_2=0x3), $(CAEN_BOARD_NUMBER_2=0x2), $(BASE_ADDRESS_2=0x0), 0x10000, 0)

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

set_pass0_restoreFile("auto_settings.sav")
set_pass1_restoreFile("auto_settings.sav")

## Load our record instances


$(IFCRATE0) dbLoadRecords("$(CAENVME)/db/v895Crate.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=0,PORT=CRATE0,CARDS=$(CARDS0)")
$(IFCRATE0) dbLoadRecordsLoop("$(CAENVME)/db/v895Card.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=0,PORT=CRATE0,C=\$(CARD)", "CARD", 0, $(CARDS0))

$(IFCRATE1) dbLoadRecords("$(CAENVME)/db/v895Crate.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=1,PORT=CRATE1,CARDS=$(CARDS1)")
$(IFCRATE1) dbLoadRecordsLoop("$(CAENVME)/db/v895Card.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=1,PORT=CRATE1,C=\$(CARD)", "CARD", 0, $(CARDS1))

$(IFCRATE2) dbLoadRecords("$(CAENVME)/db/v895Crate.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=2,PORT=CRATE2,CARDS=$(CARDS2)")
$(IFCRATE2) dbLoadRecordsLoop("$(CAENVME)/db/v895Card.db","P=$(MYPVPREFIX),Q=$(IOCNAME):,CRATE=2,PORT=CRATE2,C=\$(CARD)", "CARD", 0, $(CARDS2))

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
