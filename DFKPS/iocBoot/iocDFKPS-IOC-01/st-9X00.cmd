# Cast PSU address as 3-digit number
calc("ADDRESS", "$(ADDRESS=0)", 2, 3)

# Send device initialisation commands
asynOctetConnect("DFKINIT","L0")
asynOctetWrite DFKINIT "ADR $(ADDRESS)\n\r"
asynOctetWrite DFKINIT "UNLOCK\n\r"	
asynOctetWrite DFKINIT "REM\n\r"

# Set polarity command
epicsEnvSet "POLCMD" "PO "

## Load our record instances
dbLoadRecords("$(TOP)/Db/DFKPS_9X00_status.db", "device=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME):, port=L0, SP_PINI=$(SP_PINI), ADDRESS=$(ADDRESS), POLCMD=$(POLCMD), MIN_RAW_SETPOINT=$(MIN_RAW_SETPOINT), MAX_RAW_SETPOINT=$(MAX_RAW_SETPOINT)")
