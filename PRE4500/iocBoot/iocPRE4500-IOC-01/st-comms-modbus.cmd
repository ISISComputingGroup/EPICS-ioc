## For dev sim devices
#$(IFDEVSIM) drvAsynIPPortConfigure("L0", "localhost:$(EMULATOR_PORT=)")
#
#$(IFNOTDEVSIM) $(IFNOTRECSIM) drvAsynSerialPortConfigure("L0", "$(PORT)", 0, 0, 0, 0)
#$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "baud", "$(BAUD=19200)")
#$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "bits", "8")  # Must be 8 bits for modbus mode, so ignore comms macro set in config
#$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "parity", "$(PARITY=even)")
#$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", -1, "stop", "$(STOP=1)")
#
## Hardware flow control off
#$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0", 0, "clocal", "Y")
#$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"crtscts","N")
#
## Software flow control off
#$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixon","N") 
#$(IFNOTDEVSIM) $(IFNOTRECSIM) asynSetOption("L0",0,"ixoff","N")

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

drvModbusAsynConfigure("L0MODBUS_RX_01","L0", 1, 3, 1001, 1, 4, 1000, "")
										    
drvModbusAsynConfigure("L0MODBUS_RX_02","L0", 2, 3, 1001, 1, 4, 1000, "")
										    
drvModbusAsynConfigure("L0MODBUS_RX_03","L0", 3, 3, 1001, 1, 4, 1000, "")
										    
drvModbusAsynConfigure("L0MODBUS_RX_04","L0", 4, 3, 1001, 1, 4, 1000, "")

asynSetTraceMask("L0", -1, 0x0)
asynSetTraceIOMask("L0", -1, 0x0)
