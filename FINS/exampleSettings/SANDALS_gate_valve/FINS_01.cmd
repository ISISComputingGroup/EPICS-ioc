#Init and connect
finsUDPInit("PLC", "$(PLCIP)", "TCP", 1, "$(PLCNODE=)")

## Load our record instances
dbLoadRecords("${TOP}/db/sandals-gate-valve.db","P=$(MYPVPREFIX),Q=FINS_VAC:,RECSIM=$(RECSIM),TIMEOUT=5.0")
