# Sections refer to document "RIKEN PLC - IBEX Specification – Issue C"

# Function arguments shown for clarity - 
# drvModbusAsynConfigure(portName, tcpPortName, slaveAddress, modbusFunction, modbusStartAddress, modbusLength, dataType, pollMsec, plcType)


# 1.4   Separators
# =================

# 1.4.1 *_NOT_* TODO PSU Control (PSUs controlled via separate IOCs)

# 1.4.2 Separator Vacuum Interlock Status
drvModbusAsynConfigure("$(PLC)separator_status",             "$(PLC)", 255, 3, 4004001,  3, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4000


# 1.5   Solenoid
# ===============

drvModbusAsynConfigure("$(PLC)solenoid_status",              "$(PLC)", 255, 3, 4004004,  1, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4003


# 1.6   Kickers
# ==============

#       (1.6.a & 1.6.b additional sub-sections created for ease of programming and efficiency of reading PLC memory)

# 1.6.1 Kickers General Status
drvModbusAsynConfigure("$(PLC)kicker_status",                "$(PLC)", 255, 3, 4004005,  4, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4004

# 1.6.a Kickers 1-4 Readback Status
drvModbusAsynConfigure("$(PLC)kickers_1-4_status"            "$(PLC)", 255, 3, 4004008, 20, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4007

# 1.6.b Kickers 1-4 Output
drvModbusAsynConfigure("$(PLC)kickers_1-4_output"            "$(PLC)", 255, 3, 4004501, 16, 7, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4500


# 2     Vacuum
# =============

# 2.1   Vacuum Status
drvModbusAsynConfigure("$(PLC)vacuum_status",                "$(PLC)", 255, 3, 4004028, 44, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4027

# 2.2   Vacuum Valve Status
drvModbusAsynConfigure("$(PLC)vacuum_valve_status",          "$(PLC)", 255, 3, 4004072, 21, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4071

# 2.3   TODO: Vacuum Valve Controls


# 2.4   Vacuum Pump Status
drvModbusAsynConfigure("$(PLC)vacuum_pump_status",           "$(PLC)", 255, 3, 4004093, 22, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4092

# 2.4.1 Vacuum Pump Valve Interlocks (PIV - Pump Isolation Valve)
drvModbusAsynConfigure("$(PLC)piv_interlock_status",         "$(PLC)", 255, 3, 4004115, 12, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4114



# ************************************************** FIXME: Needs Further Work **************************************************

# 2.4.2 TODO: LV Interlocks (LV - Line Valve)
drvModbusAsynConfigure("$(PLC)lv_interlock_status",          "$(PLC)", 255, 3, 4004126,  7, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4125

# 2.4.3 TODO: Other Valve Interlocks
drvModbusAsynConfigure("$(PLC)other_valve_interlock_status", "$(PLC)", 255, 3, 4004133,  3, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4132

# ************************************************** FIXME: Needs Further Work **************************************************



# 2.5   Beam Blocker Status
drvModbusAsynConfigure("$(PLC)beamblocker_status",           "$(PLC)", 255, 3, 4004136,  5, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4135

# 2.6   Beam Blocker Information
drvModbusAsynConfigure("$(PLC)beamblocker_information",      "$(PLC)", 255, 3, 4004141,  5, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4140


# 3     PSU Interlocks
# =====================

# 3.1   Klixon Interlock Status
drvModbusAsynConfigure("$(PLC)klixon_interlock_status",      "$(PLC)", 255, 3, 4004146, 36, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4145

# 3.2   Water Interlock Status
drvModbusAsynConfigure("$(PLC)water_interlock_status",       "$(PLC)", 255, 3, 4004182, 38, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4181
drvModbusAsynConfigure("$(PLC)water_interlock_status_extra", "$(PLC)", 255, 3, 4004286,  1, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4285

# 3.3   Water Flow
drvModbusAsynConfigure("$(PLC)water_flow_rate",              "$(PLC)", 255, 3, 4004517, 80, 7, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4516

# 3.4   R-Box Interlock Status
drvModbusAsynConfigure("$(PLC)rbox_interlock_status",        "$(PLC)", 255, 3, 4004221, 56, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4220

# 3.5   MOL Status
drvModbusAsynConfigure("$(PLC)MOL_status",                   "$(PLC)", 255, 3, 4004277,  9, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4276

# 3.6   *_NOT_* TODO PSU Control / On  (PSUs controlled via separate IOCs)



## Load our record instances
dbLoadRecords("$(TOP)/db/RIKENFE.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(PLC)")
