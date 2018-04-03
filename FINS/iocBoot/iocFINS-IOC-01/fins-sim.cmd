## Init and connect
## 1 as argument 4 enables simulation mode
finsUDPInit("PLC", "$(PLCIP)", "TCP", 1)

## Load our record instances
dbLoadRecords("${TOP}/db/larmor-air.db","P=$(MYPVPREFIX),Q=$(IOCNAME):BENCH:")
