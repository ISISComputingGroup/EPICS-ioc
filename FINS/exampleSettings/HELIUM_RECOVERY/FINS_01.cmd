#Init and connect
$(IFDEVSIM) finsUDPInit("PLC", "$(PLCIP):$(EMULATOR_PORT=)", "TCPNOHEAD", 0, "$(PLCNODE=)")
$(IFRECSIM) finsUDPInit("PLC", "$(PLCIP):$(EMULATOR_PORT=)", "TCPNOHEAD", 1, "$(PLCNODE=)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) finsUDPInit("PLC", "$(PLCIP)", "TCP", 0, "$(PLCNODE=)")

## Load our record instances
dbLoadRecords("${TOP}/db/he-recovery.db","P=$(MYPVPREFIX),Q=$(IOCNAME):HE-RCVRY:,RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0)")
