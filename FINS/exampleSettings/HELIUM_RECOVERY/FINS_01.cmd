#Init and connect
$(IFDEVSIM) finsUDPInit("PLC", "$(PLC_IP):$(EMULATOR_PORT=)", "TCPNOHEAD", 0, "$(PLC_NODE=)")
$(IFRECSIM) finsUDPInit("PLC", "$(PLC_IP):$(EMULATOR_PORT=)", "TCPNOHEAD", 1, "$(PLC_NODE=)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) finsUDPInit("PLC", "$(PLC_IP)", "TCP", 0, "$(PLC_NODE=)")

## Load our record instances
dbLoadRecords("${TOP}/db/he-recovery.db","P=$(MYPVPREFIX),Q=HLM:,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),SCAN=1 second")
