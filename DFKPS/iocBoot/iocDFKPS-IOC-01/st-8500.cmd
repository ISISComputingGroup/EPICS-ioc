# Cast PSU address as 3-digit number
calc("ADDRESS", "$(ADDRESS)", 2, 3)

# Send device initialisation commands
asynOctetConnect("DFKINIT","L0")
asynOctetWrite DFKINIT "ADR $(ADDRESS)$(IEOS=\\n\\r)"
asynOctetWrite DFKINIT "UNLOCK$(IEOS=\\n\\r)"
asynOctetWrite DFKINIT "REM$(IEOS=\\n\\r)"

## Load our record instances
dbLoadRecords("$(TOP)/Db/DFKPS_8500_status.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, port=L0, SP_PINI=$(SP_PINI), ADDRESS=$(ADDRESS=0)")
