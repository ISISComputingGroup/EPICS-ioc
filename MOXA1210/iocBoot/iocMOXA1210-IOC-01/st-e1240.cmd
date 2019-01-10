# MOXA E1240 AIs: function 4, address 0x0, 0x8 words , data_type = UINT16 = 0,
#drvModbusAsynConfigure("$(E1240_ASYNPORT)_AI", "$(E1240_ASYNPORT)", 0, 4, 0x000, 0x8, 0, 100, "ioLogik")

# MOXA E1240 Current mode status: function 4, address 0x3c, 0x8 words , data_type = UINT16 = 0,
#drvModbusAsynConfigure("$(E1240_ASYNPORT)_AI_St", "$(E1240_ASYNPORT)", 0, 4, 0x3c, 0x8, 0, 500, "ioLogik")

# MOXA E1240 Current mode settings read: function 3, address 0x18, 0x8 words , data_type = UINT16 = 0,
#drvModbusAsynConfigure("$(E1240_ASYNPORT)_AIMR", "$(E1240_ASYNPORT)", 0, 3, 0x18, 0x8, 0, 500, "ioLogik")

# MOXA E1240 Current mode settings write: function 6, address 0x18, 0x8 words , data_type = UINT16 = 0,
#drvModbusAsynConfigure("$(E1240_ASYNPORT)_AIMW", "$(E1240_ASYNPORT)", 0, 6, 0x18, 0x8, 0, 1, "ioLogik")

# MOXA E1240 Burn out value read (float - two words): function 3, address 0x28, 0x8 double words => 0x10, data_type = FLOAT32_LE = 7,
#drvModbusAsynConfigure("$(E1240_ASYNPORT)_BOR", "$(E1240_ASYNPORT)", 0, 3, 0x0028, 0x10, 7, 500, "ioLogik")

# MOXA E1240 Burn out value write (float - two words): function 16 write multiple regs, address 0x28, 0x8 double words => 0x10 , data_type = FLOAT32_LE = 7,
#drvModbusAsynConfigure("$(E1240_ASYNPORT)_BOW", "$(E1240_ASYNPORT)", 0, 16, 0x0028, 0x10, 7, 1, "ioLogik")


##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd


dbLoadRecords("$(MOXA1210)/db/ioLogik_E1210.db","NAME=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT)")

dbLoadRecords("${TOP}/db/IBEX_PVs.db","NAME=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT)")

# Load the user-given aliases of the channels

iocshCmdList("< ${TOP}/iocBoot/iocMOXA1210-IOC-01/st-aliases.cmd", "CHAN=\$(I)", "I", "00;01;02;03;04;05;06;07;08;09;10;11;12;13;14;15", ";")
