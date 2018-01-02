epicsEnvSet("AMOTORNAME", "MTR$(MTRCTRL)0$(MN)")
epicsEnvSet("AMOTORPV", "MOT:$(AMOTORNAME)")

autosaveBuild("$(IOCNAME)_$(MN)_built_settings.req", "_settings.req", 1)
set_pass0_restoreFile("$(IOCNAME)_$(MN)_built_settings.sav")
set_pass1_restoreFile("$(IOCNAME)_$(MN)_built_settings.sav")


asynSetTraceIOMask("$(AMOTOR)", 0, 2)

## Load record instances
calc("SN", "$(MN)-1", 2, 2)
# Load asyn record 
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=$(AMOTORPV):ASYN,PORT=$(AMOTOR),ADDR=$(SN),OMAX=256,IMAX=256") 
dbLoadRecords("$(TOP)/db/asyn_motor.db", "P=$(MYPVPREFIX),M=$(AMOTORPV),PORT=$(AMOTOR),ADDR=$(SN)") 
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)") 
dbLoadRecords("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS$(MN),mAXIS=$(AMOTORPV)") 

autosaveBuild("$(IOCNAME)_$(MN)_built_settings.req", "_settings.req", 0)

$(IFNOTSIM) < st-motor-init.cmd
