## set LEVEL_NUM before calling
## if LEVEL_NUM = 1 then the entries for LEVEL_NUM 1 in this IOC will be used for the setup

stringiftest("LEVEL", "$(LEVEL_$(LEVEL_NUM)=)")

## Load our record instances
$(IFLEVEL) dbLoadRecords("$(MERCURY_ITC)/db/MercuryLevel.db", "P=$(MYPVPREFIX)$(IOCNAME):LEVEL:$(LEVEL_NUM):,PORT=L0,BOARD=$(LEVEL_$(LEVEL_NUM)),RECSIM=$(RECSIM),DISABLE=$(DISABLE)")
