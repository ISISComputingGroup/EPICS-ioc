### E1210 (16 DI) ###

# MOXA E1210 DIs (if NOT counter mode) : function 2 (Read Discrete Inputs), address 0x0, length 16, data_type = UINT16 = 0, # pollMsec = for read func, waits XXX msecs
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_DI",             "$(E12XX_ASYNPORT)", 0, 2, 0x0,   0x10, "UINT16", 100, "ioLogik")

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd


dbLoadRecords("$(MOXA12XX)/db/ioLogik_E1210.db","NAME=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT)")

dbLoadRecords("${TOP}/db/moxa_e1210_PVs.db","NAME=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT)")

# Load the user-given aliases of the channels

iocshCmdList("< ${TOP}/iocBoot/iocMOXA12XX-IOC-01/st-aliases.cmd", "CHAN=\$(I), FNCTN=DI", "I", "0;1;2;3;4;5;6;7;8;9;10;11;12;13;14;15", ";")
