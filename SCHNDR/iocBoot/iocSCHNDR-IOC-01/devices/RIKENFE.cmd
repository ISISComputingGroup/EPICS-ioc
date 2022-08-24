# drvModbusAsynConfigure(portName, tcpPortName, slaveAddress, modbusFunction, modbusStartAddress, modbusLength, dataType, pollMsec, plcType)

# Sections refer to document "RIKEN PLC/IBEX Specification – Issue C"

# 2.4 Vacuum Pump Status
drvModbusAsynConfigure("$(PLC)vacuum_pump_status",      "$(PLC)", 255, 3, 4004093, 22, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4092

# 3.1 Klixon Interlock Status
drvModbusAsynConfigure("$(PLC)klixon_interlock_status", "$(PLC)", 255, 3, 4004146, 36, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4145

# 3.2 Water Interlock Status
drvModbusAsynConfigure("$(PLC)water_interlock_status",  "$(PLC)", 255, 3, 4004182, 38, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4181

# 3.3 Water Flow
drvModbusAsynConfigure("$(PLC)water_flow_rate",         "$(PLC)", 255, 3, 4004517, 78, 7, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4516

# 3.4 R-Box Interlock Status
drvModbusAsynConfigure("$(PLC)rbox_interlock_status",   "$(PLC)", 255, 3, 4004221, 56, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4220

# 3.5 MOL Status
drvModbusAsynConfigure("$(PLC)MOL_status",              "$(PLC)", 255, 3, 4004277,  9, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4276

## Load our record instances
dbLoadRecords("$(TOP)/db/RIKENFE.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(PLC)")
