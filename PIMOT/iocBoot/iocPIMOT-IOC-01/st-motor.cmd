epicsEnvSet("AMOTORPV", "MOT:MTR$(MTRCTRL)0$(AN)")

# The signal number is the axis-1
calc("SN", "$(AN)-1", 2, 2)

dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=$(AMOTORPV):ASYN,PORT=$(ASERIAL),ADDR=$(SN),OMAX=256,IMAX=256") 
dbLoadRecords("$(TOP)/db/asyn_motor.db", "P=$(MYPVPREFIX),M=$(AMOTORPV),PORT=$(AMOTOR),ADDR=$(SN)")
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)") 
dbLoadRecords("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS$(PN),mAXIS=$(AMOTORPV)") 