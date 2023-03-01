#Init and connect
finsUDPInit("PLC", "$(PLCIP)", "TCP")

## Load our record instances
dbLoadRecords("${TOP}/db/zoom-vacuum.db","P=$(MYPVPREFIX),Q=VACUUM:, RECSIM=$(RECSIM), DISABLE=$(DISABLE=0)")
