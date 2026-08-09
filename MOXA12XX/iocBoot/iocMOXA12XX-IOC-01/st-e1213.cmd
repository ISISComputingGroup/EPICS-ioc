# MOXA E1213 DIs: function 2 (Read Discrete Inputs), address 0x0, length 0x8, data_type = 0, # pollMsec = for read func, waits XXX msecs
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_DI", "$(E12XX_ASYNPORT)", 0, 2, 0x0,   0x8, 0, 100, "ioLogik E1213")

# MOXA E1213 DOs read back: function 1 (Read from coils), address 0x0, length 0x8, data_type = 0, # pollMsec = for read func, waits XXX msecs
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_DO_RBV", "$(E12XX_ASYNPORT)", 0, 1, 0x0,   0x8, 0, 100, "ioLogik E1213")

# MOXA E1213 DOs: function 5 (Write to coils), address 0x0, length 0x8, data_type = 0, # pollMsec = No significance
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_DO", "$(E12XX_ASYNPORT)", 0, 5, 0x0,   0x8, 0, 100, "ioLogik E1213")

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd


dbLoadRecords("$(MOXA12XX)/db/ioLogik_E1213.db","NAME=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT)")

dbLoadRecords("${TOP}/db/moxa_e1213_PVs.db","NAME=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT)")

iocshCmdList("< ${TOP}/iocBoot/iocMOXA12XX-IOC-01/st-aliases.cmd", "CHAN=\$(I), FNCTN=DI, CHANPREFIX=DI", "I", "0;1;2;3;4;5;6;7", ";")
