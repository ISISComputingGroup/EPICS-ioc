epicsEnvSet("AMOTORPV", "MOT:MTR$(MTRCTRL)0")

autosaveBuild("$(IOCNAME)_built_settings.req", "_settings.req", 1)
set_pass0_restoreFile("$(IOCNAME)_built_settings.sav")
set_pass1_restoreFile("$(IOCNAME)_built_settings.sav")

$(IFDEVSIM) drvAsynIPPortConfigure("Huber$(MTRCTRL)", "localhost:$(EMULATOR_PORT)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("Huber$(MTRCTRL)", "$(PORT)", 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("Huber$(MTRCTRL)", -1, "parity", "$(PARITY=None)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("Huber$(MTRCTRL)", -1, "baud", "$(BAUD=19200)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("Huber$(MTRCTRL)", -1, "bits", "$(BITS=8)")

$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("Huber$(MTRCTRL)", -1, "stop", "$(STOP=1)")
## Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("Huber$(MTRCTRL)", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("Huber$(MTRCTRL)",0,"crtscts","N")
## Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("Huber$(MTRCTRL)",0,"ixon","N")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("Huber$(MTRCTRL)",0,"ixoff","N")

asynOctetSetOutputEos("Huber$(MTRCTRL)",0, "\r")
asynOctetSetInputEos("Huber$(MTRCTRL)",0, "\r\n")

calc("AXISPLUS1","$(NUMBERAXES)+1", 1, 2)
# (driver port, port, axis num, ms mov poll, ms idle poll)
SMC9300CreateController("SMC$(MTRCTRL)","Huber$(MTRCTRL)", $(AXISPLUS1), 100, 1000)

#asynSetTraceMask("Huber$(MTRCTRL)",-1,0x9) 
#asynSetTraceIOMask("Huber$(MTRCTRL)",-1,0x2)

## Load record instances

# Load asyn record 
dbLoadRecordsLoop("$(TOP)/db/asyn_motor.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)\$(I),PORT=SMC$(MTRCTRL),ADDR=\$(I)", "I", 1, $(NUMBERAXES)
dbLoadRecordsLoop("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)\$(I)", "I", 1, $(NUMBERAXES))
dbLoadRecordsLoop("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS\$(I),mAXIS=$(AMOTORPV)\$(I)", "I", 1, $(NUMBERAXES)) 

autosaveBuild("$(IOCNAME)_built_settings.req", "_settings.req", 0)
