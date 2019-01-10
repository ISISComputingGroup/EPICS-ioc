# MOXA E1210 DIs (if NOT counter mode) : function 2 (Read Discrete Inputs), address 0x0, length 16, data_type = UINT16 = 0, # pollMsec = for read func, waits XXX msecs
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_DI",             "$(E12XX_ASYNPORT)", 0, 2, 0x0,   0x10, 0, 100, "ioLogik")

# MOXA E1210 DIs (if counter mode: start/stop counter) : function 5 (Write Single Coil), address 0x0100, length 16, data_type = UINT16 = 0, # pollMsec = for read func, waits XXX msecs
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_DICNT_S",        "$(E12XX_ASYNPORT)", 0, 5, 0x0100,   0x10, 0, 1, "ioLogik")

# MOXA E1210 DIs (if counter mode: start/stop counter) : function 1 (Read Coils), address 0x0100, length 16, data_type = UINT16 = 0, # pollMsec = for read func, waits XXX msecs
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_DICNT_S_RBV",    "$(E12XX_ASYNPORT)", 0, 1, 0x0100,   0x10, 0, 500, "ioLogik")

# MOXA E1210 DIs (if counter mode: clear counter) : function 5 (Write Single Coil), address 0x0110, length 16, data_type = UINT16 = 0, # pollMsec = for read func, waits XXX msecs
# (RBV is always 0)
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_DICNT_CLR",      "$(E12XX_ASYNPORT)", 0, 5, 0x0110,   0x10, 0, 1, "ioLogik")

# MOXA E1210 DIs (if counter mode: counter value) : function 4 (Read Input Registers), address 0x0010, 0x10 double words => length 0x20, data_type = INT32_BE = 6, # pollMsec = for read func, waits XXX msecs
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_DICNT",          "$(E12XX_ASYNPORT)", 0, 4, 0x0010,   0x22, 6, 500, "ioLogik")

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd


dbLoadRecords("$(MOXA1210)/db/ioLogik_E1210.db","NAME=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT)")

dbLoadRecords("${TOP}/db/IBEX_PVs.db","NAME=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT)")

# Load the user-given aliases of the channels

iocshCmdList("< ${TOP}/iocBoot/iocMOXA1210-IOC-01/st-aliases.cmd", "CHAN=\$(I)", "I", "00;01;02;03;04;05;06;07;08;09;10;11;12;13;14;15", ";")
