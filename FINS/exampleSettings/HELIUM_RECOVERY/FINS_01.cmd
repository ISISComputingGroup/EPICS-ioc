#Init and connect
finsUDPInit("PLC", "$(PLCIP)", "UDP", 0, "$(PLCNODE=)")

## Load our record instances
dbLoadRecords("${TOP}/db/he-recovery.db","P=$(MYPVPREFIX),Q=$(IOCNAME):HE-RCVRY:")
