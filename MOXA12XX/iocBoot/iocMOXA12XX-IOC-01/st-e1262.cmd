# MOXA E1262 AIs: function 4, address 0x810, 2 words => 0x10, data_type = FLOAT32_LE = 7,
drvModbusAsynConfigure("$(E12XX_ASYNPORT)_AI", "$(E12XX_ASYNPORT)", 0, 4, 0x810, 0x10, 7, 500, "ioLogik")

##ISIS## Load common DB records
< $(IOCSTARTUP)/dbload.cmd


dbLoadRecords("$(MOXA12XX)/db/ioLogik_E1262.db","NAME=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT)")

dbLoadRecords("${TOP}/db/moxa_e1262_PVs.db","NAME=$(MYPVPREFIX)$(IOCNAME), P=$(MYPVPREFIX)$(IOCNAME), ASYNPORT=$(E12XX_ASYNPORT)")

iocshCmdList("< ${TOP}/iocBoot/iocMOXA12XX-IOC-01/st-aliases.cmd", "CHAN=\$(I), FNCTN=TEMP:RBV", "I", "0;1;2;3;4;5;6;7", ";")
