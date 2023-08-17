# MOXA E1242 DIs: function 2 (Read Discrete Inputs), address 0x0, length 0x8, data_type = UINT16 = 0, # pollMsec = for read func, waits XXX msecs
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_DI", "$(E12XX_ASYNPORT)", 0, 2, 0x0,   0x8, 0, 100, "ioLogik")

# MOXA E1242 AIs: function 4 (Read Input Registers), address 0x200, 0x4 words , data_type = UINT16 = 0, 
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_AI", "$(E12XX_ASYNPORT)", 0, 4, 0x200, 0x4, 0, 100, "ioLogik")

# MOXA E1242 Current mode status: function 4, address 0x240, 0x4 words , data_type = UINT16 = 0, 
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_AI_St", "$(E12XX_ASYNPORT)", 0, 4, 0x0240, 0x4, 0, 500, "ioLogik")

# MOXA E1242 Current mode settings read: function 3, address 0x220, 0x4 words , data_type = UINT16 = 0, 
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_AIMR", "$(E12XX_ASYNPORT)", 0, 3, 0x0220, 0x4, 0, 500, "ioLogik")

# MOXA E1242 Current mode settings write: function 6, address 0x220, 0x4 double words => 0x8, data_type = UINT16 = 0, 
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_AIMW", "$(E12XX_ASYNPORT)", 0, 6, 0x0220, 0x4, 0, 1, "ioLogik")

# MOXA E1242 Burn out value read (float - two words): function 3, address 0x230, 0x4 double words => 0x8, data_type = FLOAT32_LE = 7, 
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_BOR", "$(E12XX_ASYNPORT)", 0, 3, 0x0230, 0x8, 7, 500, "ioLogik")

# MOXA E1242 Burn out value write (float - two words): function 16 write multiple regs, address 0x230, 0x4 double words => 0x8 , data_type = FLOAT32_LE = 7, 
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_BOW", "$(E12XX_ASYNPORT)", 0, 16, 0x0230, 0x8, 7, 1, "ioLogik")


##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd


dbLoadRecords("$(MOXA12XX)/db/ioLogik_E1242.db","NAME=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT)")

dbLoadRecords("${TOP}/db/moxa_e1242_PVs.db","NAME=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT)")

iocshCmdList("< ${TOP}/iocBoot/iocMOXA12XX-IOC-01/st-aliases.cmd", "CHAN=\$(I), FNCTN=AI:RBV, CHANPREFIX=AI", "I", "0;1;2;3;", ";")
iocshCmdList("< ${TOP}/iocBoot/iocMOXA12XX-IOC-01/st-aliases.cmd", "CHAN=\$(I), FNCTN=DI, CHANPREFIX=DI", "I", "0;1;2;3;4;5;6;7", ";")
