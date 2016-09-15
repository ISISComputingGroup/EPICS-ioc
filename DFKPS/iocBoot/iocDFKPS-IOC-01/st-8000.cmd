## set positions of interlock and power flags in status string
epicsEnvSet "POWER_FLAG_POSITION" "0"
epicsEnvSet "INTERLOCK_FLAG_POSITION" "9"

## Initialise the comms with the PSU
asynOctetConnect("DFKINIT","L0")
asynOctetWrite DFKINIT "UNLOCK\r"

## Load our record instances
dbLoadRecords("$(TOP)/Db/DFKPS_8000_status.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, port=L0, powpos=$(POWER_FLAG_POSITION), ilkpos=$(INTERLOCK_FLAG_POSITION), SP_PINI=$(SP_PINI), FRI=$(FACTOR_READ_I=1)")
