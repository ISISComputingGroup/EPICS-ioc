epicsEnvSet("AMOTOR", "motor$(MN)")
epicsEnvSet("AMOTORNAME", "MTR$(MTRCTRL)0$(MN)")
epicsEnvSet("AMOTORPV", "MOT:$(AMOTORNAME)")

## Load record instances

# Set motor specific initial conditions
epicsEnvSet("EGUI",$(UNIT$(MN)="mm"))
epicsEnvSet("VELOI",$(VELO$(MN)=1))
epicsEnvSet("ACCLI",$(ACCL$(MN)=1))
epicsEnvSet("MSTPI",$(MSTP$(MN)=4000))
dcalc("MRESI", "1.0/$(MSTPI)", 1, 12)
dcalc("JVELCALC", "0.1*$(VELOI)",1,3)

epicsEnvSet("JVELI", "$(JVEL$(MN)=$(JVELCALC))")

# Need a non-zero encoder resolution for sim mode
$(IFSIM) epicsEnvSet("ERESI",1)
$(IFNOTSIM) epicsEnvSet("ERESI",0)
epicsEnvSet("DHLMI",$(DHLM$(MN)=200))
epicsEnvSet("DLLMI",$(DLLM$(MN)=-200))
epicsEnvSet("NAMEI","$(NAME$(MN)=$(AMOTORNAME))")
epicsEnvSet("OFSTI", "$(OFST$(MN)=0)")

# The signal number is the axis-1
calc("SN", "$(MN)-1", 2, 2)
$(IFSIM) motorSimConfigAxis("motorSim", $(SN), $(DHLMI), $(DLLMI),  $(DLLMI), 0)

# Load asyn record 
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=$(AMOTORPV):ASYN,PORT=$(ASERIAL),ADDR=0,OMAX=256,IMAX=256")
#Note that ERES is set to 0 because the driver does not support setting the encoder ratio. We do it only at startup
#
# S is the signal number (axis-1), C is the card number
#
# Set the VBAS, the base speed, to 0.0 as it has no effect (that I know of) on the McLennan except that the acceleration won't be set
# on an absolute move unless the speed and base speed are different
#

dbLoadRecords("$(TOP)/db/motor$(SIMSFX=).db", "P=$(MYPVPREFIX),M=$(AMOTORPV),VELO=$(VELOI),JVEL=$(JVELI),VBAS=0.0,ACCL=$(ACCLI),MRES=$(MRESI),ERES=$(ERESI),DHLM=$(DHLMI),DLLM=$(DLLMI),NAME=$(NAMEI),S=$(SN),C=0,UEIP=1,EGU=$(EGUI),OFF=$(OFSTI)")
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)") 
