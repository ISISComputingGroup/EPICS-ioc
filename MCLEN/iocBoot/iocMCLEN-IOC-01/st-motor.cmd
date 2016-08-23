
## set PN before calling
## if PN=1 the defines asyn port SD1 and uses macros such as PORT1, PORT1_PARITY to configure 


## asyn serial port internal device name and motor name 
epicsEnvSet("ASERIAL", "serial$(PN)")
epicsEnvSet("AMOTOR", "motor$(PN)")
# Make sure controller number is 2 digits long
calc("MTRCTRL", "$(MTRCTRL=11)", 2, 2)
epicsEnvSet("AMOTORNAME", "MTR$(MTRCTRL)0$(PN)")
epicsEnvSet("AMOTORPV", "MOT:$(AMOTORNAME)")

autosaveBuild("$(IOCNAME)_$(PN)_built_settings.req", "_settings.req", 1)
set_pass0_restoreFile("$(IOCNAME)_$(PN)_built_settings.sav")
set_pass1_restoreFile("$(IOCNAME)_$(PN)_built_settings.sav")

$(IFSIM) motorSimCreateController("$(AMOTOR)", 1) 
$(IFSIM) motorSimConfigAxis("$(AMOTOR)", 0, 32000, -32000,  0, 0)
$(IFSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "NUL", 0, 1)

$(IFNOTSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "$(PORT$(PN)=NUL)", 0, 0, 0)
$(IFNOTSIM) asynSetTraceIOMask("$(ASERIAL)", -1, 0xFF )
$(IFNOTSIM) asynOctetSetInputEos("$(ASERIAL)",0,"\r\n") 
$(IFNOTSIM) asynOctetSetOutputEos("$(ASERIAL)",0,"\r") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"baud","$(BAUD$(PN)=9600)") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"bits","$(BITS$(PN)=7)") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"stop","$(STOP$(PN)=1") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"parity","$(PARITY$(PN)=even)") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"clocal","Y") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"crtscts","N") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"ixon","Y") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"ixoff","Y") 

## Check if open loop mode has been requested
stringtest("IFCMOPEN","$(MODE$(PN)=)",4,"OPEN")
$(IFCMOPEN) epicsEnvSet("MODE",CM11)

## Initialise control mode. Defaults to CM14, closed
$(IFNOTSIM) asynOctetConnect("MKINIT","$(ASERIAL)")
$(IFNOTSIM) asynOctetWrite("MKINIT","$(PN)$(MODE=CM14)")

## Set home mode
$(IFNOTSIM) asynOctetWrite("MKINIT","$(PN)$(MODE=DM00001000)")

# Test for Mclennan PM600 stepper motor controller
# PM304Setup(controller count, poll rate (1 to 60Hz))
PM304Setup(1,5)

# PM304Config(card being configured, asyn port name,  number of axes)
PM304Config(0, "$(ASERIAL)", 1)

asynSetTraceIOMask("$(AMOTOR)", 0, 2)

## Load record instances

# Set motor specific initial conditions
epicsEnvSet("VELI",$(VEL$(PN)=1))
epicsEnvSet("ACCI",$(ACC$(PN)=1))
epicsEnvSet("MRESI",$(MRES$(PN)=0.0025))
epicsEnvSet("ERESI",$(ERES$(PN)=0.000244140625))
epicsEnvSet("HLMI",$(HLM$(PN)=200))
epicsEnvSet("LLMI",$(LLM$(PN)=-200))

# Load asyn record 
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=$(AMOTORPV):ASYN,PORT=$(ASERIAL),ADDR=0,OMAX=256,IMAX=256")
dbLoadRecords("$(TOP)/db/motor.db", "P=$(MYPVPREFIX),M=$(AMOTORPV),VEL=$(VELI),ACC=$(ACCI),MRES=$(MRESI),ERES=$(ERESI),HLM=$(HLMI),LLM=$(LLMI),NAME=$(AMOTORNAME)") 
dbLoadRecords("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS$(PN),mAXIS=$(AMOTORPV)") 

autosaveBuild("$(IOCNAME)_$(PN)_built_settings.req", "_settings.req", 0)
