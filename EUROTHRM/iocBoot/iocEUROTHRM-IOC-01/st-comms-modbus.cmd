# For dev sim devices
$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=)")

$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "$(BAUD=9600)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "8")  # Must be 8 bits for modbus mode, so ignore comms macro set in config
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "$(PARITY=even)")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "$(STOP=1)")

# Hardware flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")

# Software flow control off
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N") 
$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N")

modbusInterposeConfig("L0", 1, 2000, 4)

# Create modbus ports for all possible sensors, using modbus offset of 1024 each time.

# drvModbusAsynConfigure(portName, 
#                        tcpPortName,
#                        slaveAddress, 
#                        modbusFunction, 
#                        modbusStartAddress, 
#                        modbusLength,
#                        dataType,
#                        pollMsec, 
#                        plcType);

drvModbusAsynConfigure("MODBUS_RX_01","L0", 1, 3, -1, 1, 4, 1000, "")
drvModbusAsynConfigure("MODBUS_TX_01","L0", 1, 6, -1, 1, 4, 0, "")
										    
drvModbusAsynConfigure("MODBUS_RX_02","L0", 2, 3, -1, 1, 4, 1000, "")
drvModbusAsynConfigure("MODBUS_TX_02","L0", 2, 6, -1, 1, 4, 0, "")
										    
drvModbusAsynConfigure("MODBUS_RX_03","L0", 3, 3, -1, 1, 4, 1000, "")
drvModbusAsynConfigure("MODBUS_TX_03","L0", 3, 6, -1, 1, 4, 0, "")
										    
drvModbusAsynConfigure("MODBUS_RX_04","L0", 4, 3, -1, 1, 4, 1000, "")
drvModbusAsynConfigure("MODBUS_TX_04","L0", 4, 6, -1, 1, 4, 0, "")
										    
drvModbusAsynConfigure("MODBUS_RX_05","L0", 5, 3, -1, 1, 4, 1000, "")
drvModbusAsynConfigure("MODBUS_TX_05","L0", 5, 6, -1, 1, 4, 0, "")

drvModbusAsynConfigure("MODBUS_RX_06","L0", 6, 3, -1, 1, 4, 1000, "")
drvModbusAsynConfigure("MODBUS_TX_06","L0", 6, 6, -1, 1, 4, 0, "")

drvModbusAsynConfigure("MODBUS_RX_07","L0", 7, 3, -1, 1, 4, 1000, "")
drvModbusAsynConfigure("MODBUS_TX_07","L0", 7, 6, -1, 1, 4, 0, "")

drvModbusAsynConfigure("MODBUS_RX_08","L0", 8, 3, -1, 1, 4, 1000, "")
drvModbusAsynConfigure("MODBUS_TX_08","L0", 8, 6, -1, 1, 4, 0, "")

drvModbusAsynConfigure("MODBUS_RX_09","L0", 9, 3, -1, 1, 4, 1000, "")
drvModbusAsynConfigure("MODBUS_TX_09","L0", 9, 6, -1, 1, 4, 0, "")

drvModbusAsynConfigure("MODBUS_RX_10","L0", 10, 3, -1, 1, 4, 1000, "")
drvModbusAsynConfigure("MODBUS_TX_10","L0", 10, 6, -1, 1, 4, 0, "")

asynSetTraceMask("L0", -1, 0x9)
asynSetTraceIOMask("L0", -1, 0x2)
