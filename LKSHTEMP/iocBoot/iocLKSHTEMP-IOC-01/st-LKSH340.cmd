# Load our record instances
dbLoadRecords("$(LKSH340)/Lakeshore340.db","P=$(MYPVPREFIX)$(IOCNAME):,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE),IFUSE_EXCITATION_FILE=$(IFUSE_EXCITATION_FILE),IFNOTUSE_EXCITATION_FILE=$(IFNOTUSE_EXCITATION_FILE)")
dbLoadRecords("$(LKSH340)/Lakeshore340_channel.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(DEVICE)")