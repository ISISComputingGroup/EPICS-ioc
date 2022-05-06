
## set PN before calling
## if PN=1 the defines asyn port SD1 and uses macros such as PORT1, PORT1_PARITY to configure 


## asyn serial port internal device name and motor name 

# PN is 1->8 so we can safely add a 0
epicsEnvSet("AMOTORPV", "MOT:MTR$(MTRCTRL)0$(PN)")

$(IFDEVSIM) drvAsynIPPortConfigure("Huber$(PN)", "localhost:$(EMULATOR_PORT=57677)")
asynOctetSetOutputEos("Huber$(PN)",0, "\r")
asynOctetSetInputEos("Huber$(PN)",0, "\r")
# (driver port, serial port, axis num, ms mov poll, ms idle poll, egu per step)
SMC9300CreateController("SMC$(PN)","Huber$(PN)",5, 100, 1000)

asynSetTraceMask("Huber$(PN)",-1,0x9) 
asynSetTraceIOMask("Huber$(PN)",-1,0x2)

## Load record instances

# Load asyn record 
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=$(AMOTORPV):ASYN,PORT=57677,ADDR=0,OMAX=256,IMAX=256") 
dbLoadRecords("$(TOP)/db/asyn_motor.db", "P=$(MYPVPREFIX),M=$(AMOTORPV),PORT=57677,ADDR=0") 
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)") 
dbLoadRecords("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS$(PN),mAXIS=$(AMOTORPV)") 

