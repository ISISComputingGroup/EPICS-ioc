## $(ID) is 0 or 1 

CAENMCAConfigure("L$(ID)", "eth://$(IPADDR$(ID))")

## Load our record instances
dbLoadRecords("$(CAENMCA)/db/CAENMCA.db","P=$(MYPVPREFIX),Q=HEX$(ID):,PORT=L$(ID)")
dbLoadRecords("$(CAENMCA)/db/CAENMCAChan.db","P=$(MYPVPREFIX),Q=HEX$(ID):,PORT=L$(ID),CHAN=0")
dbLoadRecords("$(CAENMCA)/db/CAENMCAChan.db","P=$(MYPVPREFIX),Q=HEX$(ID):,PORT=L$(ID),CHAN=1")
dbLoadRecords("$(CAENMCA)/db/CAENMCAHVChan.db","P=$(MYPVPREFIX),Q=HEX$(ID):,PORT=L$(ID),CHAN=0")
dbLoadRecords("$(CAENMCA)/db/CAENMCAHVChan.db","P=$(MYPVPREFIX),Q=HEX$(ID):,PORT=L$(ID),CHAN=1")
