
## set MN before calling
## if MN=1 the defines asyn port SD1 and uses macros such as PORT1, PORT1_PARITY to configure 


## asyn serial port internal device name and motor name 
epicsEnvSet("ASERIAL", "serial$(MN)")
epicsEnvSet("AMOTOR", "motor$(MN)")
# Make sure controller number is 2 digits long
calc("MTRCTRL", "$(MTRCTRL=11)", 2, 2)
epicsEnvSet("AMOTORNAME", "MTR$(MTRCTRL)0$(MN)")
epicsEnvSet("AMOTORPV", "MOT:$(AMOTORNAME)")

#autosaveBuild("$(IOCNAME)_$(MN)_built_settings.req", "_settings.req", 1)
#set_pass0_restoreFile("$(IOCNAME)_$(MN)_built_settings.sav")
#set_pass1_restoreFile("$(IOCNAME)_$(MN)_built_settings.sav")

## Create simulated motors: ( start card , start axis , low limit, high limit, home posn, # cards, # axes to setup)
#$(IFSIM) motorSimCreate( 0, 0, -32000, 32000, 0, 1, 1 )
## Setup the Asyn layer (portname, low-level driver drvet name, card, number of axes on card)
##$(IFSIM) drvAsynMotorConfigure("sim1", "motorSim", 0, 1)
$(IFSIM) motorSimCreateController("$(AMOTOR)", 1)
$(IFSIM) motorSimConfigAxis("$(AMOTOR)", 0, 20000, -20000,  500, 0)


$(IFSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "NUL", 0, 1)
$(IFSIM) epicsEnvSet("SIMSFX","Sim")
 
$(IFNOTSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "$(PORT=NUL)", 0, 0, 0)
$(IFNOTSIM) asynSetTraceIOMask("$(ASERIAL)", -1, 0xFF )
$(IFNOTSIM) asynOctetSetInputEos("$(ASERIAL)",0,"\r\n") 
$(IFNOTSIM) asynOctetSetOutputEos("$(ASERIAL)",0,"\r") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"baud","$(BAUD$(MN)=9600)") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"bits","$(BITS$(MN)=7)") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"stop","$(STOP$(MN)=1)") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"parity","$(PARITY$(MN)=even)") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"clocal","Y") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"crtscts","N") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"ixon","Y") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"ixoff","Y") 

## Check if open loop mode has been requested
$(IFNOTSIM) stringtest("IFCMOPEN","$(MODE$(MN)=)",4,"OPEN")
$(IFNOTSIM) $(IFCMOPEN) epicsEnvSet("MODE",CM11)

## Initialise control mode. Defaults to CM14, closed
$(IFNOTSIM) asynOctetConnect("MKINIT","$(ASERIAL)")
$(IFNOTSIM) asynOctetWrite("MKINIT","$(MN)$(MODE=CM14)")
$(IFNOTSIM) asynOctetWrite("MKINIT","$(MN)ER$(ERES$(MN)=400/4096)")

## Reset home mode. Currently will have no effect since driver uses CV command, not HD
# $(IFNOTSIM) asynOctetWrite("MKINIT","$(MN)$(MODE=DM00000000)")

# Test for Mclennan PM600 stepper motor controller
# Note that setup must be done in sim mode too or unconfigured card will crash at first caput
# PM304Setup(controller count, poll rate (1 to 60Hz))
$(IFNOTSIM) PM304Setup(1,5)

# PM304Config(card being configured, asyn port name,  number of axes)
$(IFNOTSIM) PM304Config(0, "$(ASERIAL)", "$(NAXES=1)")

asynSetTraceIOMask("$(ASERIAL)", 0, 2)

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
