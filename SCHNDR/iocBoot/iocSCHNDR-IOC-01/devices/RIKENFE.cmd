# drvModbusAsynConfigure(portName, tcpPortName, slaveAddress, modbusFunction, modbusStartAddress, modbusLength, dataType, pollMsec, plcType)

# Sections refer to document "RIKEN PLC/IBEX Specification – Issue C"


# 1.4   Separators

# 1.4.1 _NOT_ TODO PSU Control (PSUs controlled via separate IOCs)

# 1.4.2 TODO Vacuum Interlock Status


# 1.5   Solenoid


# 1.6   Kickers

# 1.6.1 General Status
drvModbusAsynConfigure("$(PLC)kicker_status",           "$(PLC)", 255, 3, 4004005,  4, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4004

#       (a,b additional sub-sections for ease of programming and efficiency of reading PLC memory)
# 1.6.a TODO Kickers 1-4 Readback Status
drvModbusAsynConfigure("$(PLC)kickers_1-4_status"       "$(PLC)", 255, 3, 4004008, 20, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4007

# 1.6.b TODO Kickers 1-4 Output
drvModbusAsynConfigure("$(PLC)kickers_1-4_output"       "$(PLC)", 255, 3, 4004501, 16, 7, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4500


# 2     Vacuum

# 2.1   Vacuum Status
drvModbusAsynConfigure("$(PLC)vacuum_status",           "$(PLC)", 255, 3, 4004028, 44, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4027

# 2.2   Vacuum Valve Status
drvModbusAsynConfigure("$(PLC)vacuum_valve_status",     "$(PLC)", 255, 3, 4004072, 21, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4071

# 2.3   TODO Vacuum Valve Controls

# 2.4   Vacuum Pump Status
drvModbusAsynConfigure("$(PLC)vacuum_pump_status",      "$(PLC)", 255, 3, 4004093, 22, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4092

# 2.4.1 Vacuum Pump Valve Interlocks (PIV - Pump Isolation Valve)
drvModbusAsynConfigure("$(PLC)piv_interlock_status",    "$(PLC)", 255, 3, 4004115, 12, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4114

# 2.4.2 TODO LV Interlocks (Line Valve)
drvModbusAsynConfigure("$(PLC)lv_interlock_status",     "$(PLC)", 255, 3, 4004126,  7, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4125

# 2.4.3 TODO Other Valve Interlocks
drvModbusAsynConfigure("$(PLC)other_valve_interlock_status", "$(PLC)", 255, 3, 4004133,  3, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4132

# 2.5   TODO Beam Blocker Status

# 2.6   TODO Beam Blocker Information


# 3     PSU Interlocks

# 3.1   Klixon Interlock Status
drvModbusAsynConfigure("$(PLC)klixon_interlock_status", "$(PLC)", 255, 3, 4004146, 36, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4145

# 3.2   Water Interlock Status
drvModbusAsynConfigure("$(PLC)water_interlock_status",  "$(PLC)", 255, 3, 4004182, 38, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4181

# 3.3   Water Flow
drvModbusAsynConfigure("$(PLC)water_flow_rate",         "$(PLC)", 255, 3, 4004517, 78, 7, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4516

# 3.4   R-Box Interlock Status
drvModbusAsynConfigure("$(PLC)rbox_interlock_status",   "$(PLC)", 255, 3, 4004221, 56, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4220

# 3.5   MOL Status
drvModbusAsynConfigure("$(PLC)MOL_status",              "$(PLC)", 255, 3, 4004277,  9, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4276

# 3.6   _NOT_ TODO PSU Control / On  (PSUs controlled via separate IOCs)



## Load our record instances
dbLoadRecords("$(TOP)/db/RIKENFE.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(PLC)")
