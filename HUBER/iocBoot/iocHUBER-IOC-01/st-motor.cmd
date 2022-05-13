epicsEnvSet("AMOTORPV", "MOT:MTR$(MTRCTRL)0")

$(IFDEVSIM) drvAsynIPPortConfigure("Huber$(MTRCTRL)", "localhost:$(EMULATOR_PORT=57677)")
asynOctetSetOutputEos("Huber$(MTRCTRL)",0, "\r")
asynOctetSetInputEos("Huber$(MTRCTRL)",0, "\r\n")
# (driver port, IP port, axis num, ms mov poll, ms idle poll)
SMC9300CreateController("SMC$(MTRCTRL)","Huber$(MTRCTRL)",5, 100, 1000)

#asynSetTraceMask("Huber$(MTRCTRL)",-1,0x9) 
#asynSetTraceIOMask("Huber$(MTRCTRL)",-1,0x2)

## Load record instances

# Load asyn record 
dbLoadRecordsLoop("$(TOP)/db/asyn_motor.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)\$(I),PORT=SMC$(MTRCTRL),ADDR=\$(I)", "I", 1, 4)
dbLoadRecordsLoop("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)\$(I)", "I", 1, 4)
dbLoadRecordsLoop("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS\$(I),mAXIS=$(AMOTORPV)\$(I)", "I", 1, 4) 
