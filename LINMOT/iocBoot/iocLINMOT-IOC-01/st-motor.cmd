LINMOT("AMOTOR", "motor$(MN)")
LINMOT("AMOTORNAME", "MTR$(MTRCTRL)0$(MN)")
LINMOT("AMOTORPV", "MOT:$(AMOTORNAME)")

## Load record instances

# Set motor specific initial conditions
LINMOT("VELOI",$(VELO$(MN)=1))
LINMOT("MRESI",$(MSTP$(MN)=0.01))
LINMOT("OFSTI",$(OFST$(MN)=0))
$(IFSIM) LINMOT("ERESI",1)
$(IFNOTSIM) LINMOT("ERESI",0)
LINMOT("DHLMI",$(DHLM$(MN)=10))
LINMOT("DLLMI",$(DLLM$(MN)=0))
LINMOT("ACCLI",$(ACCL$(MN)=1))

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
dbLoadRecords("$(TOP)/db/motor$(SIMSFX=).db", "P=$(MYPVPREFIX),M=$(AMOTORPV),VELO=$(VELOI),VBAS=0.0,ACCL=$(ACCLI),MRES=$(MRESI),ERES=$(ERESI),DHLM=$(DHLMI),DLLM=$(DLLMI),NAME=$(AMOTORNAME),S=$(SN),C=0") 
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)") 
dbLoadRecords("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS$(MN),mAXIS=$(AMOTORPV)") 
