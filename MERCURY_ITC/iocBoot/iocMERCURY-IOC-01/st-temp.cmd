## set TEMP_NUM before calling
## if TEMP_NUM = 1 then the entries for TEMP_NUM 1 in this IOC will be used for the setup

stringiftest("TEMP", "$(TEMP_$(TEMP_NUM)=)")

## Load our record instances
$(IFTEMP) dbLoadRecords("$(MERCURY_ITC)/db/MercuryTemp.db", "P=$(MYPVPREFIX)$(IOCNAME):$(TEMP_NUM):,PORT=L0,BOARD=$(TEMP_$(TEMP_NUM)),RECSIM=$(RECSIM),DISABLE=$(DISABLE)")
