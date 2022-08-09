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

modbusInterposeConfig("L0", 1, 2000, 0)

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
#

drvModbusAsynConfigure("MODBUS_RX","L0",2, 3, -1, 1, 0, 1000, "")
drvModbusAsynConfigure("MODBUS_TX","L0",2, 6, -1, 1, 0, 0, "")

asynSetTraceMask("L0", -1, 0x9)
asynSetTraceIOMask("L0", -1, 0x2)
