
########## Eurothrm 

stringiftest("ACTIVE", "$(ADDR_$(EURO_NUM)=)")
calc("LAD", "$(ADDR_$(EURO_NUM)=0)%10",1,1)
calc("GAD", "$(ADDR_$(EURO_NUM)=0)/10%10",1,1)

## Load FileList
## A seperate instance must be created for each Eurothrm
$(IFACTIVE) FileListConfigure("RAMPFILELIST$(EURO_NUM)", "$(RAMP_DIR)", $(RAMP_PAT)) 
$(IFACTIVE) FileListConfigure("SENSORFILELIST$(EURO_NUM)", "$(CALIB_BASE_DIR)/$(SENS_DIR)", "$(SENS_PAT)", 1) 

## Load ReadASCII
## A seperate instance must be created for each Eurothrm
$(IFACTIVE) ReadASCIIConfigure("READASCII$(EURO_NUM)", "$(RAMP_DIR)")

epicsEnvSet("P","$(MYPVPREFIX)$(IOCNAME):A0$(EURO_NUM):")

## Load record instances
## The timing for record reads is controlled in st-timing.cmd
$(IFACTIVE) dbLoadRecords("$(TOP)/db/devEurothrm.db","P=$(P),Q=$(MYPVPREFIX)$(IOCNAME):, ADDR=$(ADDR_$(EURO_NUM)=0), GAD=$(GAD), LAD=$(LAD), PORT=L0, CALIB_BASE_DIR= $(CALIB_BASE_DIR), READ=READASCII$(EURO_NUM), RAMPLIST=RAMPFILELIST$(EURO_NUM), TREAD=$(TREAD=1.4), TDLY=$(TDLY=0.5)")

$(IFACTIVE) dbLoadRecords($(FILELIST)/db/calibration.db, "P=$(P), CALIB_BASE_DIR=$(CALIB_BASE_DIR), SDIR=$(SENS_DIR), CALIBLIST=SENSORFILELIST$(EURO_NUM), CONV_TO_PV=TEMP, CONV_FROM_PV=, CONV_TO_DESC=Temperature, CONV_TO_EGU=K, SP_PV=RAMP_SP")

# Readascii units
$(IFACTIVE) dbLoadRecords("$(ReadASCII)/db/get_metadata.db","DIR=$(P)TEMP,CAL=$(P)CAL:RBV,OUT=$(P)TEMP,OUTF=EGU,NAME=column1_units,DEFAULT=K")
$(IFACTIVE) dbLoadRecords("$(ReadASCII)/db/get_metadata.db","DIR=$(P)TEMP,CAL=$(P)CAL:RBV,OUT=$(P)TEMP:SP,OUTF=EGU,NAME=column1_units,DEFAULT=K")
$(IFACTIVE) dbLoadRecords("$(ReadASCII)/db/get_metadata.db","DIR=$(P)TEMP,CAL=$(P)CAL:RBV,OUT=$(P)TEMP:SP:RBV,OUTF=EGU,NAME=column1_units,DEFAULT=K")
$(IFACTIVE) dbLoadRecords("$(ReadASCII)/db/get_metadata.db","DIR=$(P)TEMP,CAL=$(P)CAL:RBV,OUT=$(P)RATE:UPDATE_EGU,OUTF=AA,NAME=column1_units,DEFAULT=K,OUTPP=PP")

# Load calibration range
$(IFACTIVE) dbLoadRecords("$(UTILITIES)/db/calibration_range.db","P=$(P), BDIR=TEMP.BDIR,TDIR=TEMP.TDIR,SPEC=TEMP.SPEC,HIGH_PV=TEMP:RANGE:OVER.B,LOW_PV=TEMP:RANGE:UNDER.B")

dbLoadRecords("$(TOP)/db/isActiveEurothrm.db","P=$(P), IFACTIVE=$(IFACTIVE), IFNOTACTIVE=$(IFNOTACTIVE)")
