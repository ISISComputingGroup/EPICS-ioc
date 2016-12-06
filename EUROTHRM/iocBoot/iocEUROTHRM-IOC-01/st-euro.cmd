
########## EUROTHRM 

stringiftest("ACTIVE", "$(ADDR_$(EURO_NUM)=)")
calc("LAD", "$(ADDR_$(EURO_NUM)=0)%10",1,1)
calc("GAD", "$(ADDR_$(EURO_NUM)=0)/10%10",1,1)

## Load FileList
## A seperate instance must be created for each EUROTHRM
$(IFACTIVE) FileListConfigure("RAMPFILELIST$(EURO_NUM)", "$(CALIB_BASE_DIR)/$(RAMP_DIR)", $(RAMP_PAT)) 
$(IFACTIVE) FileListConfigure("SENSORFILELIST$(EURO_NUM)", "$(CALIB_BASE_DIR)/$(SENS_DIR)", "$(SENS_PAT)", 1) 

## Load ReadASCII
## A seperate instance must be created for each EUROTHRM
$(IFACTIVE) ReadASCIIConfigure("READASCII$(EURO_NUM)", "$(CALIB_BASE_DIR)/$(RAMP_DIR)")

## Load record instances

$(IFACTIVE) dbLoadRecords("$(TOP)/db/devEUROTHRM.db","P=$(MYPVPREFIX)${IOCPVPREFIX}:A0$(EURO_NUM):, Q=$(MYPVPREFIX)${IOCPVPREFIX}:, ADDR=$(ADDR_$(EURO_NUM)=0), GAD=$(GAD), LAD=$(LAD), PORT=L0, CALIB_BASE_DIR= $(CALIB_BASE_DIR), SDIR=$(SENS_DIR), READ=READASCII$(EURO_NUM), RAMPLIST=RAMPFILELIST$(EURO_NUM), SENSORLIST=SENSORFILELIST$(EURO_NUM)")

dbLoadRecords("$(TOP)/db/isActiveEUROTHRM.db","P=$(MYPVPREFIX)${IOCPVPREFIX}:A0$(EURO_NUM):, IFACTIVE=$(IFACTIVE), IFNOTACTIVE=$(IFNOTACTIVE)")
