epicsEnvSet("AMOTOR", "motor$(MN)")
epicsEnvSet("AMOTORNAME", "MTR$(MTRCTRL)0$(MN)")
epicsEnvSet("AMOTORPV", "MOT:$(AMOTORNAME)")

$(IFSIM) motorSimCreateController("$(AMOTOR)", 1)
$(IFSIM) motorSimConfigAxis("$(AMOTOR)", 0, 20000, -20000,  500, 0)

## Check if open loop mode has been requested
$(IFNOTSIM) stringtest("IFCMOPEN","$(MODE$(MN)=)",4,"OPEN")
$(IFNOTSIM) $(IFCMOPEN) epicsEnvSet("MODE",CM11)

## Initialise control mode. Defaults to CM14, closed
$(IFNOTSIM) asynOctetConnect("MKINIT","$(ASERIAL)")
$(IFNOTSIM) asynOctetWrite("MKINIT","$(MN)$(MODE=CM14)")
$(IFNOTSIM) asynOctetWrite("MKINIT","$(MN)ER$(ERES$(MN)=400/4096)")

# If you want debug output
# asynSetTraceIOMask("$(ASERIAL)", 0, 2)

## Load record instances

# Set motor specific initial conditions
epicsEnvSet("VELOI",$(VELO$(MN)=1))
epicsEnvSet("ACCLI",$(ACCL$(MN)=1))
epicsEnvSet("MRESI",$(MRES$(MN)=0.0025))
$(IFSIM) epicsEnvSet("ERESI",$(ERES$(MN)=0.000244140625))
# Need a non-zero encoder resolution for sim mode
$(IFNOTSIM) epicsEnvSet("ERESI",$(ERES$(MN)=0.00025))
epicsEnvSet("DHLMI",$(DHLM$(MN)=200))
epicsEnvSet("DLLMI",$(DLLM$(MN)=-200))

# The signal number is the axis-1
calc("SN", "$(MN)-1", 2, 2)

# Load asyn record 
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=$(AMOTORPV):ASYN,PORT=$(ASERIAL),ADDR=0,OMAX=256,IMAX=256")
# Note that ERES is set to 0 because the driver does not support setting the encoder ratio. We do it only at startup
# S is the signal number (axis-1), C is the card number
dbLoadRecords("$(TOP)/db/motor$(SIMSFX=).db", "P=$(MYPVPREFIX),M=$(AMOTORPV),VELO=$(VELOI),VBAS=$(VELOI),ACCL=$(ACCLI),MRES=$(MRESI),ERES=$(ERESI),DHLM=$(DHLMI),DLLM=$(DLLMI),NAME=$(AMOTORNAME),S=$(SN),C=0,UEIP=1") 
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)") 
dbLoadRecords("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS$(MN),mAXIS=$(AMOTORPV)") 

#autosaveBuild("$(IOCNAME)_$(PN)_built_settings.req", "_settings.req", 0)

## Start homing sequencer
seq homing, "MOTPV=$(MYPVPREFIX)$(AMOTORPV),MODE='Constant_velocity'"
