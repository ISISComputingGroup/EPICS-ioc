# drvModbusAsynConfigure(portName,
#                        tcpPortName,
#                        slaveAddress,
#                        modbusFunction,
#                        modbusStartAddress,
#                        modbusLength,
#                        dataType,
#                        pollMsec,
#                        plcType);

# IBEX PLC Specification                         

# Section 2.4 Vacuum Pump Status
drvModbusAsynConfigure("$(PLC)vac_pump_stat", "$(PLC)", 255, 3, 4004093, 22, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4092

# Section 3.1 Klixon Interlock Status
drvModbusAsynConfigure("$(PLC)klixon_interlock_stat", "$(PLC)", 255, 3, 4004146, 35, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4145

# Section 3.2 Water Interlock Status
drvModbusAsynConfigure("$(PLC)water_interlock_stat", "$(PLC)", 255, 3, 4004182, 38, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4181

# Section 3.3 Water Flow
drvModbusAsynConfigure("$(PLC)water_flow", "$(PLC)", 255, 3, 4004517, 78, 7, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4516


## Load our record instances
dbLoadRecords("$(TOP)/db/RIKENFE.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(PLC)")
