# Sections refer to document "RIKEN PLC - IBEX Specification – Issue C"

# Function arguments shown for clarity - 
# drvModbusAsynConfigure(portName, tcpPortName, slaveAddress, modbusFunction, modbusStartAddress, modbusLength, dataType, pollMsec, plcType)


# 1.4   Separators
# =================

# 1.4.1 *_NOT_* TODO PSU Control (PSUs controlled via separate IOCs)

# 1.4.2 Separator Vacuum Interlock Status
drvModbusAsynConfigure("$(PLC)separator_status",             "$(PLC)", 255, 3, 4000,  3, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4000


# 1.5   Solenoid
# ===============

drvModbusAsynConfigure("$(PLC)solenoid_status",              "$(PLC)", 255, 3, 4003,  1, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4003


# 1.6   Kickers
# ==============

#       (1.6.a & 1.6.b additional sub-sections created for ease of programming and efficiency of reading PLC memory)

# 1.6.1 Kickers General Status
drvModbusAsynConfigure("$(PLC)kicker_status",                "$(PLC)", 255, 3, 4004,  4, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4004

# 1.6.a Kickers 1-4 Readback Status
drvModbusAsynConfigure("$(PLC)kickers_1-4_status"            "$(PLC)", 255, 3, 4007, 20, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4007

# 1.6.b Kickers 1-4 Output
drvModbusAsynConfigure("$(PLC)kickers_1-4_output"            "$(PLC)", 255, 3, 4500, 16, 7, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4500


# 2     Vacuum
# =============

# 2.1   Vacuum Status
drvModbusAsynConfigure("$(PLC)vacuum_status",                "$(PLC)", 255, 3, 4027, 44, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4027

# 2.2   Vacuum Valve Status
drvModbusAsynConfigure("$(PLC)vacuum_valve_status",          "$(PLC)", 255, 3, 4071, 21, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4071

# 2.3   Vacuum Valve Controls
drvModbusAsynConfigure("$(PLC)lv1_vacuum_valve_open",        "$(PLC)", 255, 5,  638,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0638
drvModbusAsynConfigure("$(PLC)lv2_vacuum_valve_open",        "$(PLC)", 255, 5,  639,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0639
drvModbusAsynConfigure("$(PLC)lv3_vacuum_valve_open",        "$(PLC)", 255, 5,  640,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0640
drvModbusAsynConfigure("$(PLC)lv4_vacuum_valve_open",        "$(PLC)", 255, 5,  643,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0643
drvModbusAsynConfigure("$(PLC)lv5_vacuum_valve_open",        "$(PLC)", 255, 5,  644,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0644
drvModbusAsynConfigure("$(PLC)lv6_vacuum_valve_open",        "$(PLC)", 255, 5,  645,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0645
drvModbusAsynConfigure("$(PLC)amgv_vacuum_valve_open",       "$(PLC)", 255, 5,  651,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0651
drvModbusAsynConfigure("$(PLC)fsov_vacuum_valve_open",       "$(PLC)", 255, 5,  652,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0652

# 2.4   Vacuum Pump Status
drvModbusAsynConfigure("$(PLC)vacuum_pump_status",           "$(PLC)", 255, 3, 4092, 22, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4092

# 2.4.1 Vacuum Pump Valve Interlocks (PIV - Pump Isolation Valve)
drvModbusAsynConfigure("$(PLC)piv_interlock_status",         "$(PLC)", 255, 3, 4114, 12, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4114



# ************************************************** FIXME: Needs Further Work **************************************************

# 2.4.2 TODO: LV Interlocks (LV - Line Valve)
drvModbusAsynConfigure("$(PLC)lv_interlock_status",          "$(PLC)", 255, 3, 4125,  7, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4125

# 2.4.3 TODO: Other Valve Interlocks
drvModbusAsynConfigure("$(PLC)other_valve_interlock_status", "$(PLC)", 255, 3, 4132,  3, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4132

# ************************************************** FIXME: Needs Further Work **************************************************



# 2.5   Beam Blocker Status
drvModbusAsynConfigure("$(PLC)beamblocker_status",           "$(PLC)", 255, 3, 4135,  5, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4135

# 2.6   Beam Blocker Information
drvModbusAsynConfigure("$(PLC)beamblocker_information",      "$(PLC)", 255, 3, 4140,  5, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4140


# 3     PSU Interlocks
# =====================

# 3.1   Klixon Interlock Status
drvModbusAsynConfigure("$(PLC)klixon_interlock_status",      "$(PLC)", 255, 3, 4145, 36, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4145

# 3.2   Water Interlock Status
drvModbusAsynConfigure("$(PLC)water_interlock_status",       "$(PLC)", 255, 3, 4181, 40, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4181
drvModbusAsynConfigure("$(PLC)water_interlock_status_extra", "$(PLC)", 255, 3, 4285,  1, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4285

# 3.3   Water Flow
drvModbusAsynConfigure("$(PLC)water_flow_rate",              "$(PLC)", 255, 3, 4516, 80, 7, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4516

# 3.4   R-Box Interlock Status (R-Box - Rectifier Box)
drvModbusAsynConfigure("$(PLC)rbox_interlock_status",        "$(PLC)", 255, 3, 4220, 56, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4220

# 3.5   MOL Status (MOL - Magnet Off Light)
drvModbusAsynConfigure("$(PLC)mol_status",                   "$(PLC)", 255, 3, 4276,  9, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4276

# 3.6   *_NOT_* TODO PSU Control / On  (PSUs controlled via separate IOCs)


## Load our record instances
dbLoadRecords("$(TOP)/db/RIKENFE.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(PLC)")
