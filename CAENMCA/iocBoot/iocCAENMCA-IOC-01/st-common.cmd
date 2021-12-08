
##ISIS## Run IOC initialisation 
< $(IOCSTARTUP)/init.cmd

CAENMCAConfigure("L1", "eth://130.246.55.0")
CAENMCAConfigure("L2", "eth://130.246.52.130")

## Load record instances

##ISIS## Load common DB records 
< $(IOCSTARTUP)/dbload.cmd

## Load our record instances
dbLoadRecords("$(CAENMCA)/db/CAENMCA.db","P=$(MYPVPREFIX),Q=HEX0:,PORT=L1")
dbLoadRecords("$(CAENMCA)/db/CAENMCAChan.db","P=$(MYPVPREFIX),Q=HEX0:,PORT=L1,CHAN=0")
dbLoadRecords("$(CAENMCA)/db/CAENMCAChan.db","P=$(MYPVPREFIX),Q=HEX0:,PORT=L1,CHAN=1")
dbLoadRecords("$(CAENMCA)/db/CAENMCAHVChan.db","P=$(MYPVPREFIX),Q=HEX0:,PORT=L1,CHAN=0")
dbLoadRecords("$(CAENMCA)/db/CAENMCAHVChan.db","P=$(MYPVPREFIX),Q=HEX0:,PORT=L1,CHAN=1")

dbLoadRecords("$(CAENMCA)/db/CAENMCA.db","P=$(MYPVPREFIX),Q=HEX1:,PORT=L2")
dbLoadRecords("$(CAENMCA)/db/CAENMCAChan.db","P=$(MYPVPREFIX),Q=HEX1:,PORT=L2,CHAN=0")
dbLoadRecords("$(CAENMCA)/db/CAENMCAChan.db","P=$(MYPVPREFIX),Q=HEX1:,PORT=L2,CHAN=1")
dbLoadRecords("$(CAENMCA)/db/CAENMCAHVChan.db","P=$(MYPVPREFIX),Q=HEX1:,PORT=L2,CHAN=0")
dbLoadRecords("$(CAENMCA)/db/CAENMCAHVChan.db","P=$(MYPVPREFIX),Q=HEX1:,PORT=L2,CHAN=1")

##ISIS## Stuff that needs to be done after all records are loaded but before iocInit is called 
< $(IOCSTARTUP)/preiocinit.cmd

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=faa59"

##ISIS## Stuff that needs to be done after iocInit is called e.g. sequence programs 
< $(IOCSTARTUP)/postiocinit.cmd
