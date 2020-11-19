epicsEnvSet("AMOTOR", "motor$(MN)")
epicsEnvSet("AMOTORNAME", "MTR$(MTRCTRL)0$(MN)")
epicsEnvSet("AMOTORPV", "MOT:$(AMOTORNAME)")

## Load record instances

epicsEnvSet("STEP_NUM", "1000")
# Assuming one axis per card
calc("CARD", "$(MN)-1", 2, 2)
$(IFNOTSIM) XPSConfigAxis($(CARD),0,"$(AXIS$(MN)_ID)",$(STEP_NUM))

dcalc("ERESI", "1.0/$(STEP_NUM)", 1, 12)
dcalc("MRESI", "1.0/$(STEP_NUM)", 1, 12)

# Set motor specific initial conditions
epicsEnvSet("EGUI",$(UNIT$(MN)="mm"))
epicsEnvSet("VELOI",$(VELO$(MN)=1))
epicsEnvSet("ACCLI",$(ACCL$(MN)=1))
dcalc("JVELCALC", "0.1*$(VELOI)",1,3)

epicsEnvSet("JVELI", "$(JVEL$(MN)=$(JVELCALC))")

epicsEnvSet("DHLMI",$(DHLM$(MN)=200))
epicsEnvSet("DLLMI",$(DLLM$(MN)=-200))
epicsEnvSet("NAMEI","$(NAME$(MN)=$(AMOTORNAME))")
epicsEnvSet("OFSTI", "$(OFST$(MN)=0)")

# The signal number is the axis-1
calc("SN", "$(MN)-1", 2, 2)
$(IFSIM) motorSimConfigAxis("motorSim", $(SN), $(DHLMI), $(DLLMI),  $(DLLMI), 0)

dbLoadRecords("$(TOP)/db/motor$(SIMSFX=).db", "P=$(MYPVPREFIX),M=$(AMOTORPV),DIR=Pos,XPS_PORT=$(XPS_PORT)")

#dbLoadRecords("$(TOP)/db/motor$(SIMSFX=).db", "P=$(MYPVPREFIX),M=$(AMOTORPV),VELO=$(VELOI),JVEL=$(JVELI),VBAS=0.0,ACCL=$(ACCLI),MRES=$(MRESI),ERES=$(ERESI),DHLM=$(DHLMI),DLLM=$(DLLMI),NAME=$(NAMEI),S=$(SN),C=0,UEIP=1,EGU=$(EGUI),OFF=$(OFSTI)")
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV)") 
