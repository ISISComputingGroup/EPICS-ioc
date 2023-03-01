epicsEnvSet("AMOTOR", "motor$(MN)")
epicsEnvSet("AMOTORNAME", "MTR$(MTRCTRL)0$(MN)")
epicsEnvSet("AMOTORPV", "MOT:$(AMOTORNAME)")

## Load record instances

epicsEnvSet("STEP_NUM", "1000")
# Assuming one axis per card
calc("CARD", "$(MN)-1", 2, 2)
$(IFNOTSIM) XPSConfigAxis($(CARD),0,"$(AXIS$(MN)_ID)",$(STEP_NUM))
$(IFSIM) motorSimConfigAxis("motorSim", $(CARD), 200, -200, -200, 0)

dcalc("ERES", "1.0/$(STEP_NUM)", 1, 12)
dcalc("MRES", "1.0/$(STEP_NUM)", 1, 12)

dbLoadRecords("$(TOP)/db/motor$(SIMSFX=).db", "P=$(MYPVPREFIX),M=$(AMOTORPV),XPS_PORT=$(XPS_PORT),MRES=$(MRES),ERES=$(ERES),CARD=$(CARD)")
dbLoadRecords("$(MOTOR)/db/motorStatus.db", "P=$(MYPVPREFIX),M=$(AMOTORPV),IOCNAME=$(IOCNAME)") 
