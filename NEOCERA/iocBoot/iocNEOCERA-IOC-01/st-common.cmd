
epicsEnvSet "STREAM_PROTOCOL_PATH" "$(NEOCERA)/data"

< $(IOCSTARTUP)/init.cmd

$(IFNOTRECSIM) $(IFNOTDEVSIM) drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
$(IFNOTRECSIM) $(IFNOTDEVSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
$(IFNOTRECSIM) $(IFNOTDEVSIM) asynSetOption("L0", -1, "bits", "8")
$(IFNOTRECSIM) $(IFNOTDEVSIM) asynSetOption("L0", -1, "parity", "none")
$(IFNOTRECSIM) $(IFNOTDEVSIM) asynSetOption("L0", -1, "stop", "1")

#asynSetTraceMask("L0",-1,0x9) 
#asynSetTraceIOMask("L0",-1,0x2)

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

