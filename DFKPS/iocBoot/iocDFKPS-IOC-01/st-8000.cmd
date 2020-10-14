## set positions of interlock and power flags in status string

## Initialise the comms with the PSU
asynOctetConnect("DFKINIT","L0")
asynOctetWrite DFKINIT "UNLOCK\r"

## Load our record instances
dbLoadRecords("$(TOP)/Db/DFKPS_8000_status.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, port=L0, SP_PINI=$(SP_PINI), MIN_RAW_SETPOINT=$(MIN_RAW_SETPOINT), MAX_RAW_SETPOINT=$(MAX_RAW_SETPOINT)")
