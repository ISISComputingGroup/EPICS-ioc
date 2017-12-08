
## set PN before calling
## if PN=1 the defines asyn port SD1 and uses macros such as PORT1, PORT1_PARITY to configure 


## asyn serial port internal device name and motor name 
epicsEnvSet("AMOTOR", "motor$(PN)")
# PN is 1->8 so we can safely add a 0
epicsEnvSet("AMOTORPV", "MOT:MTR$(MTRCTRL)0$(PN)")

autosaveBuild("$(IOCNAME)_$(PN)_built_settings.req", "_settings.req", 1)
set_pass0_restoreFile("$(IOCNAME)_$(PN)_built_settings.sav")
set_pass1_restoreFile("$(IOCNAME)_$(PN)_built_settings.sav")


asynSetTraceIOMask("$(AMOTOR)", 0, 2)

## Load record instances

# Load asyn record 
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=$(AMOTORPV):ASYN,PORT=$(ASERIAL),ADDR=0,OMAX=256,IMAX=256") 
dbLoadRecords("$(TOP)/db/asyn_motor.db", "P=$(MYPVPREFIX),M=$(AMOTORPV),PORT=$(AMOTOR),ADDR=0") 
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)") 
dbLoadRecords("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS$(PN),mAXIS=$(AMOTORPV)") 

autosaveBuild("$(IOCNAME)_$(PN)_built_settings.req", "_settings.req", 0)
