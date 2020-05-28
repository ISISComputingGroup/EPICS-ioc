#Init and connect
finsUDPInit("PLC", "$(PLCIP)", "TCP", 0, "$(PLCNODE=)")

## Load our record instances
dbLoadRecords("${TOP}/db/he-recovery.db","P=$(MYPVPREFIX),Q=$(IOCNAME):HE-RCVRY:")
