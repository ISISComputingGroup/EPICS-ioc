
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(NEOCERA)/data"

< $(IOCSTARTUP)/init.cmd

$(IFNOTRECSIM) $(IFNOTDEVSIM) drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
$(IFNOTRECSIM) $(IFNOTDEVSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
$(IFNOTRECSIM) $(IFNOTDEVSIM) asynSetOption("L0", -1, "bits", "8")
$(IFNOTRECSIM) $(IFNOTDEVSIM) asynSetOption("L0", -1, "parity", "none")
$(IFNOTRECSIM) $(IFNOTDEVSIM) asynSetOption("L0", -1, "stop", "1")

# Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")

# Software flow control on
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","Y") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","Y")


$(IFNOTRECSIM) $(IFDEVSIM)  drvAsynIPPortConfigure("L0", "localhost:57677")

< $(IOCSTARTUP)/dbload.cmd

##
##
##
##
##
dbLoadRecords("$(TOP)/db/devNeocera.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=L0,DISABLE=$(DISABLE=0),RECSIM=$(RECSIM=0)")

dbLoadRecords("$(TOP)/db/unit_setter.db","P=$(MYPVPREFIX)$(IOCNAME):")

< $(IOCSTARTUP)/preiocinit.cmd

cd ${TOP}/iocBoot/${IOC}
iocInit

< $(IOCSTARTUP)/postiocinit.cmd

