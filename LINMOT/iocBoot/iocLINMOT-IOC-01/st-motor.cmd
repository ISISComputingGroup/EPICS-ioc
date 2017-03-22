epicsEnvSet("AMOTOR", "motor$(MN)")
epicsEnvSet("AMOTORNAME", "MTR$(MTRCTRL)0$(MN)")
epicsEnvSet("AMOTORPV", "MOT:$(AMOTORNAME)")

## Load record instances

# Set motor specific initial conditions
epicsEnvSet("VELOI",$(VELO$(MN)=1))
epicsEnvSet("MRESI",$(MSTP$(MN)=0.01))
epicsEnvSet("OFSTI",$(OFST$(MN)=0))
$(IFSIM) epicsEnvSet("ERESI",1)
$(IFNOTSIM) epicsEnvSet("ERESI",0)
epicsEnvSet("DHLMI",$(DHLM$(MN)=100))
epicsEnvSet("DLLMI",$(DLLM$(MN)=0))
epicsEnvSet("ACCLI",$(ACCL$(MN)=1))

# The signal number is the axis-1
calc("SN", "$(MN)-1", 2, 2)
$(IFSIM) motorSimConfigAxis("motorSim", $(SN), $(DHLMI), $(DLLMI),  $(DLLMI), 0)

# Load asyn record 
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=$(AMOTORPV):ASYN,PORT=$(ASERIAL),ADDR=0,OMAX=256,IMAX=256")
#
# S is the signal number (axis-1), C is the card number
#
# Set the VBAS, the base speed, to 0.0 as it has no effect (that I know of) on the motor except that the acceleration won't be set
# on an absolute move unless the speed and base speed are different
#
dbLoadRecords("$(TOP)/db/motor$(SIMSFX=).db", "P=$(MYPVPREFIX),M=$(AMOTORPV),VELO=$(VELOI),VBAS=0.0,ACCL=$(ACCLI),MRES=$(MRESI),ERES=$(ERESI),DHLM=$(DHLMI),DLLM=$(DLLMI),NAME=$(AMOTORNAME),S=$(SN),C=0,UEIP=0") 
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)") 
dbLoadRecords("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS$(MN),mAXIS=$(AMOTORPV)") 
