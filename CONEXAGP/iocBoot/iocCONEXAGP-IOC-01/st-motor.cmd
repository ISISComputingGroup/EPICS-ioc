
## set PN before calling
## if PN=1 the defines asyn port SD1 and uses macros such as PORT1, PORT1_PARITY to configure 


## asyn serial port internal device name and motor name 
epicsEnvSet("ASERIAL", "serial$(PN)")
epicsEnvSet("AMOTOR", "motor$(PN)")
# PN is 1->8 so we can safely add a 0
epicsEnvSet("AMOTORPV", "MOT:MTR$(MTRCTRL)0$(PN)")

autosaveBuild("$(IOCNAME)_$(PN)_built_settings.req", "_settings.req", 1)
set_pass0_restoreFile("$(IOCNAME)_$(PN)_built_settings.sav")
set_pass1_restoreFile("$(IOCNAME)_$(PN)_built_settings.sav")

$(IFSIM) motorSimCreateController("$(AMOTOR)", 1) 
$(IFSIM) motorSimConfigAxis("$(AMOTOR)", 0, 32000, -32000,  0, 0) 
$(IFSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "NUL", 0, 1)

$(IFNOTSIM) drvAsynSerialPortConfigure("$(ASERIAL)", "$(PORT$(PN)=NUL)", 0, 0, 0)
$(IFNOTSIM) asynOctetSetInputEos("$(ASERIAL)",0,"\r\n") 
$(IFNOTSIM) asynOctetSetOutputEos("$(ASERIAL)",0,"\r\n") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"baud","$(BAUD$(PN)=57600)") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"bits","8") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"stop","1") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"parity","none") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"clocal","Y") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"crtscts","N") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"ixon","Y") 
$(IFNOTSIM) asynSetOption("$(ASERIAL)",0,"ixoff","Y") 
$(IFNOTSIM) asynSetTraceIOMask("$(ASERIAL)", 0, 2)

# asyn_port, serial_port, controller_id, moving_poll_period(ms), idle_poll_period(ms)
$(IFNOTSIM) AG_CONEXCreateController("$(AMOTOR)","$(ASERIAL)",1,50,500)

asynSetTraceIOMask("$(AMOTOR)", 0, 2)

## Load record instances

# Load asyn record 
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(MYPVPREFIX),R=$(AMOTORPV):ASYN,PORT=$(ASERIAL),ADDR=0,OMAX=256,IMAX=256") 
dbLoadRecords("$(TOP)/db/asyn_motor.db", "P=$(MYPVPREFIX),M=$(AMOTORPV),PORT=$(AMOTOR),ADDR=0") 
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV),IOCNAME=$(IOCNAME)") 
dbLoadRecords("$(AXIS)/db/axis.db", "P=$(MYPVPREFIX),AXIS=$(IOCNAME):AXIS$(PN),mAXIS=$(AMOTORPV)") 

autosaveBuild("$(IOCNAME)_$(PN)_built_settings.req", "_settings.req", 0)
