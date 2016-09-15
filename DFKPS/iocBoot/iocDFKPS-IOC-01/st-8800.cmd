## Initialise the comms with the PSU
asynOctetConnect("DFKINIT","L0")
asynOctetWrite DFKINIT "ADR 000\r"

## Load our record instances
dbLoadRecords("$(TOP)/Db/DFKPS_8800_status.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, port=L0, SP_PINI=$(SP_PINI), FRI=$(FACTOR_READ_I=1)")
