epicsEnvSet("AMOTORNAME", "MTR$(MTRCTRL)0$(MN)")
epicsEnvSet("AMOTORPV", "MOT:$(AMOTORNAME)")

autosaveBuild("$(IOCNAME)_$(MN)_built_settings.req", "_settings.req", 1)
set_pass0_restoreFile("$(IOCNAME)_$(MN)_built_settings.sav")
set_pass1_restoreFile("$(IOCNAME)_$(MN)_built_settings.sav")


epicsEnvSet("MSTPI",$(MSTP$(MN)=200))
dcalc("MRESI", "1.0/$(MSTPI)", 1, 12)

epicsEnvSet("DHLMI",$(DHLM$(MN)=285))
epicsEnvSet("DLLMI",$(DLLM$(MN)=-0.25))

epicsEnvSet("NAMEI","$(NAME$(MN)=$(AMOTORNAME))")
epicsEnvSet("VELOI",$(VELO$(MN)=1))




asynSetTraceIOMask("$(AMOTOR)", 0, 2)

## Load record instances
calc("SN", "$(MN)-1", 2, 2)
# Load asyn record 
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=$(AMOTORPV):ASYN,PORT=$(AMOTOR),ADDR=$(SN),OMAX=256,IMAX=256") 
dbLoadRecords("$(TOP)/db/asyn_motor.db", "P=$(MYPVPREFIX),M=$(AMOTORPV),NAME=$(NAMEI),PORT=$(AMOTOR),ADDR=$(SN),VEL=$(VELOI),MRES=$(MRESI),DHLM=$(DHLMI),DLLM=$(DLLMI)") 
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)") 
dbLoadRecords("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS$(MN),mAXIS=$(AMOTORPV)") 

autosaveBuild("$(IOCNAME)_$(MN)_built_settings.req", "_settings.req", 0)

$(IFNOTSIM) < st-motor-init.cmd
