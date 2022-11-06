## Load our record instances
dbLoadRecords("$(AEROFLEX)/db/aeroflex_2030.db", "PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),DEV_TYPE=2030")
