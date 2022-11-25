$(IFNOTRECSIM) # Sections refer to document "RIKEN PLC - IBEX Specification – Issue C"
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # Function arguments shown for clarity - 
$(IFNOTRECSIM) # drvModbusAsynConfigure(portName, tcpPortName, slaveAddress, modbusFunction, modbusStartAddress, modbusLength, dataType, pollMsec, plcType)
$(IFNOTRECSIM) 
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 1.4   Separators
$(IFNOTRECSIM) # =================
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 1.4.1 *_NOT_* TODO PSU Control (PSUs controlled via separate IOCs)
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 1.4.2 Separator Vacuum Interlock Status
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)separator_status",             "$(PLC)", 255, 3, 4000,  3, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4000
$(IFNOTRECSIM) 
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 1.5   Solenoid
$(IFNOTRECSIM) # ===============
$(IFNOTRECSIM) 
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)solenoid_status",              "$(PLC)", 255, 3, 4003,  1, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4003
$(IFNOTRECSIM) 
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 1.6   Kickers
$(IFNOTRECSIM) # ==============
$(IFNOTRECSIM) 
$(IFNOTRECSIM) #       (1.6.a & 1.6.b additional sub-sections created for ease of programming and efficiency of reading PLC memory in blocks)
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 1.6.1 Kickers General Status
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)kickers_status",                "$(PLC)", 255, 3, 4004,  4, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4004
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 1.6.a Kickers 1-4 Readback Status
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)kickers_1-4_status"            "$(PLC)", 255, 3, 4007, 20, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4007
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 1.6.b Kickers 1-4 Output
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)kickers_1-4_output"            "$(PLC)", 255, 3, 4500, 16, 7, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4500
$(IFNOTRECSIM) 
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 2     Vacuum
$(IFNOTRECSIM) # =============
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 2.1   Vacuum Status
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)vacuum_status",                "$(PLC)", 255, 3, 4027, 44, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4027
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 2.2   Vacuum Valve Status
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)vacuum_valve_status",          "$(PLC)", 255, 3, 4071, 21, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4071
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 2.3   Vacuum Valve Controls
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)lv1_vacuum_valve_open",        "$(PLC)", 255, 5,  638,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0638
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)lv2_vacuum_valve_open",        "$(PLC)", 255, 5,  639,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0639
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)lv3_vacuum_valve_open",        "$(PLC)", 255, 5,  640,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0640
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)lv4_vacuum_valve_open",        "$(PLC)", 255, 5,  643,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0643
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)lv5_vacuum_valve_open",        "$(PLC)", 255, 5,  644,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0644
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)lv6_vacuum_valve_open",        "$(PLC)", 255, 5,  645,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0645
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)lv7_vacuum_valve_open",        "$(PLC)", 255, 5,  702,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0702
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)amgv_vacuum_valve_open",       "$(PLC)", 255, 5,  651,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0651
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)fsov_vacuum_valve_open",       "$(PLC)", 255, 5,  652,  1, 0,    0, "Schneider M580 PLC")         # IEC61131 start address: %MW0652
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 2.4   Vacuum Pump Status
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)vacuum_pump_status",           "$(PLC)", 255, 3, 4092, 22, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4092
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 2.4.1 Vacuum Pump Valve Interlocks (PIV - Pump Isolation Valve)
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)piv_interlock_status",         "$(PLC)", 255, 3, 4114, 12, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4114
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 2.4.2 LV Interlocks (LV - Line Valve)
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)lv_interlock_status",          "$(PLC)", 255, 3, 4125,  7, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4125
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 2.4.3 Other Valve Interlocks
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)other_valve_interlock_status", "$(PLC)", 255, 3, 4132,  3, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4132
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 2.5   Beam Blocker Status
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)beamblocker_status",           "$(PLC)", 255, 3, 4135,  5, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4135
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 2.6   Beam Blocker Information
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)beamblocker_information",      "$(PLC)", 255, 3, 4140,  5, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4140
$(IFNOTRECSIM) 
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 3     PSU Interlocks
$(IFNOTRECSIM) # =====================
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 3.1   Klixon Interlock Status
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)klixon_interlock_status",      "$(PLC)", 255, 3, 4145, 36, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4145
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 3.2   Water Interlock Status
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)water_interlock_status",       "$(PLC)", 255, 3, 4181, 40, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4181
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)water_interlock_status_extra", "$(PLC)", 255, 3, 4285,  1, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4285
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 3.3   Water Flow
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)water_flow_rate",              "$(PLC)", 255, 3, 4516, 80, 7, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4516
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 3.4   R-Box Interlock Status (R-Box - Rectifier Box)
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)rbox_interlock_status",        "$(PLC)", 255, 3, 4220, 56, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4220
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 3.5   MOL Status (MOL - Magnet Off Light)
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)mol_status",                   "$(PLC)", 255, 3, 4276,  9, 0, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4276
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 3.6   *_NOT_* TODO PSU Control / On  (PSUs controlled via separate IOCs)
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 3.7   Water Temperature
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)water_temperature",            "$(PLC)", 255, 3, 4672, 66, 7, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4672
$(IFNOTRECSIM) 
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # 4     Temperature monitoring
$(IFNOTRECSIM) # ============================
$(IFNOTRECSIM) 
$(IFNOTRECSIM) drvModbusAsynConfigure("$(PLC)temperature_monitoring",       "$(PLC)", 255, 3, 4596, 75, 4, 1000, "Schneider M580 PLC")         # IEC61131 start address: %MW4596
$(IFNOTRECSIM) 
$(IFNOTRECSIM) 
$(IFNOTRECSIM) # ----------------------===========================------------------------ #


## Load record instances for general PLC interaction
dbLoadRecords("$(TOP)/db/RIKENFE.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(PLC),RECSIM=$(RECSIM),DISABLE=$(DISABLE)")

## Load record instances for Temperature Monitoring
dbLoadRecords("$(TOP)/db/RIKENFE_TEMPMON.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(PLC),RECSIM=$(RECSIM),DISABLE=$(DISABLE)")
