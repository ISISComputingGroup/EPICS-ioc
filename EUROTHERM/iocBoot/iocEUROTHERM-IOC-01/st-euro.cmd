
########## EUROTHERM 

stringiftest("ACTIVE", "$(LADDR_$(EURO_NUM)=)")

## Load FileList
## A seperate instance must be created for each eurotherm
$(IFACTIVE) FileListConfigure("RAMPFILELIST$(EURO_NUM)", "$(CALIB_BASE_DIR)/$(RAMP_DIR)", $(RAMP_PAT)) 
$(IFACTIVE) FileListConfigure("SENSORFILELIST$(EURO_NUM)", "$(CALIB_BASE_DIR)/$(SENS_DIR)", "$(SENS_PAT)", 1) 

## Load ReadASCII
## A seperate instance must be created for each eurotherm
$(IFACTIVE) ReadASCIIConfigure("READASCII$(EURO_NUM)", "$(CALIB_BASE_DIR)/$(RAMP_DIR)")

## Load record instances
## GAD = Greater Eurtotherm address part
## LAD = Lesser Eurotherm address part
## For example: eurotherm address 1 => GAD = 0 and LAD = 1
## For example: eurotherm address 10 => GAD = 1 and LAD = 0
$(IFACTIVE) dbLoadRecords("$(TOP)/db/devEurotherm.db","P=$(MYPVPREFIX)${IOCPVPREFIX}:A0$(EURO_NUM):, Q=$(MYPVPREFIX)${IOCPVPREFIX}:, GAD=$(GADDR_$(EURO_NUM)=0), LAD=$(LADDR_$(EURO_NUM)=0), PORT=L0, CALIB_BASE_DIR= $(CALIB_BASE_DIR), SDIR=$(SENS_DIR), READ=READASCII$(EURO_NUM), RAMPLIST=RAMPFILELIST$(EURO_NUM), SENSORLIST=SENSORFILELIST$(EURO_NUM)")

dbLoadRecords("$(TOP)/db/isActiveEurotherm.db","P=$(MYPVPREFIX)${IOCPVPREFIX}:A0$(EURO_NUM):, IFACTIVE=$(IFACTIVE), IFNOTACTIVE=$(IFNOTACTIVE)")
