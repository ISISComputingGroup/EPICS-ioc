## set positions of interlock and power flags in status string

## Initialise the comms with the PSU
$(IFNOTRECSIM) asynOctetSetInputEos("L0", -1, "$(OEOS=\\r\\n)")
$(IFNOTRECSIM) asynOctetSetOutputEos("L0", -1, "$(IEOS=\\r\\n)")

asynOctetConnect("DFKINIT","L0")
asynOctetWrite DFKINIT "REM"

## Load our record instances
dbLoadRecords("$(TOP)/Db/DFKPS_8500_status.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, port=L0, SP_PINI=$(SP_PINI), ADDRESS=$(ADDRESS=0)")

asynSetTraceMask("L0", -1, 0x9)
asynSetTraceIOMask("L0", -1, 0x2)
