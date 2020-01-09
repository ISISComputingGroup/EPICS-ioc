## set PS before calling
## if PS = 1 then the entries for PSU 1 in this IOC will be used for the setup


# this defines macros we can use for conditional loading later
stringiftest("PORT", "$(PORT$(PS)=)")


## For unit testing:
$(IFPORT) $(IFDEVSIM) drvAsynIPPortConfigure("L$(PS)", "localhost:$(EMULATOR_PORT=)")

## For recsim:
$(IFPORT) $(IFRECSIM) drvAsynSerialPortConfigure ("L$(PS)", "$(PORT=NUL)", 0, 1, 0, 0)

$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure ("L$(PS)", "$(PORT$(PS)=)")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption ("L$(PS)", 0, "baud", "$(BAUD$(PS)=9600)")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption ("L$(PS)", 0, "bits", "$(BITS$(PS)=8)")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption ("L$(PS)", 0, "parity", "$(PARITY$(PS)=none)")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption ("L$(PS)", 0, "stop", "$(STOP$(PS)=1)")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption ("L$(PS)", 0, "crtscts", "D")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption ("L$(PS)", 0, "clocal", "D")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption ("L$(PS)", 0, "ixon", "N")
$(IFPORT) $(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption ("L$(PS)", 0, "ixoff", "N")
$(IFPORT) $(IFNOTRECSIM) asynOctetSetInputEos("L$(PS)",0,"$(IEOS$(PS)=\\r)")
$(IFPORT) $(IFNOTRECSIM) asynOctetSetOutputEos("L$(PS)",0,"$(OEOS$(PS)=\\r)")

## Initialise the comms with the PSU
$(IFPORT) $(IFNOTRECSIM) asynOctetConnect("GENESYS_01$(PS)","L$(PS)")
$(IFPORT) $(IFNOTRECSIM) asynOctetWrite GENESYS_01$(PS) "ADR $(ADDR$(PS))"

stringiftest("FIELD_CONV_DEFINED", "$(AMPSTOGAUSS$(PS)=)")

# Need to set the conversion factor to something to avoid errors - doesn't matter what, as it won't be used. Choose 1 as this is a safe no-op.
$(IFNOTFIELD_CONV_DEFINED) epicsEnvSet("$(AMPSTOGAUSS$(PS)", "1")
$(IFNOTFIELD_CONV_DEFINED) epicsEnvSet("FIELD_CONV_DEFINED", "0")

$(IFFIELD_CONV_DEFINED) epicsEnvSet("FIELD_CONV_DEFINED", "1")

## Load record instances for connected psu
$(IFPORT)  dbLoadRecords("$(TOP)/db/TDK_LAMBDA_GENESYS.db", "P=$(MYPVPREFIX)$(IOCNAME):$(PS):,RECSIM=$(RECSIM=0), PORT=L$(PS), ADR=$(ADDR$(PS)), SP_PINI=$(SP_AT_STARTUP$(PS)=NO),AMPSTOGAUSS=$(AMPSTOGAUSS$(PS)),FIELD_CONV_DEFINED=$(FIELD_CONV_DEFINED)")
