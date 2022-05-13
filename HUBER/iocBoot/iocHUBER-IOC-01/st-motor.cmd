
## set PN before calling
## if PN=1 the defines asyn port SD1 and uses macros such as PORT1, PORT1_PARITY to configure 



epicsEnvSet("AMOTORPV", "MOT:MTR$(MTRCTRL)0")

$(IFDEVSIM) drvAsynIPPortConfigure("Huber1", "localhost:$(EMULATOR_PORT=57677)")
asynOctetSetOutputEos("Huber1",0, "\r")
asynOctetSetInputEos("Huber1",0, "\r\n")
# (driver port, IP port, axis num, ms mov poll, ms idle poll)
SMC9300CreateController("SMC1","Huber1",2, 1000, 10000)

asynSetTraceMask("Huber1",-1,0x9) 
asynSetTraceIOMask("Huber1",-1,0x2)

## Load record instances

# Load asyn record 
dbLoadRecordsLoop("$(TOP)/db/asyn_motor.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)\$(I),PORT=SMC1,ADDR=\$(I)", "I", 1, 1)
dbLoadRecordsLoop("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)\$(I)", "I", 1, 1)
dbLoadRecordsLoop("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS\$(I),mAXIS=$(AMOTORPV)\$(I)", "I", 1, 1) 
