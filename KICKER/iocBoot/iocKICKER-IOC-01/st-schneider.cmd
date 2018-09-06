## Modbus configuration
# drvModbusAsynConfigure("$(DEVICE)heartbeat", "$(DEVICE)", 1, 3, 649, 1, 0, 1000, "PLC")

## RTU

## For recsim:
$(IFRECSIM) drvAsynSerialPortConfigure("$(DEVICE):PLC", "$(PORT=NUL)", 0, 1, 0, 0)

## For real devices
$(IFNOTRECSIM) drvAsynSerialPortConfigure("$(DEVICE):PLC","$(PORT=NO_PORT_MACRO)",0,0,0) # change this
$(IFNOTRECSIM) asynSetOption("$(DEVICE):PLC",0,"baud","9600")
$(IFNOTRECSIM) asynSetOption("$(DEVICE):PLC",0,"bits","8")
$(IFNOTRECSIM) asynSetOption("$(DEVICE):PLC",0,"parity","even")
$(IFNOTRECSIM) asynSetOption("$(DEVICE):PLC",0,"stop","1")

# Hardware flow control
$(IFNOTRECSIM) asynSetOption("$(DEVICE):PLC",0,"clocal","N") # N enables DSR/DTR handshaking
$(IFNOTRECSIM) asynSetOption("$(DEVICE):PLC",0,"crtscts","N")

# Softawre flow control on
$(IFNOTRECSIM) asynSetOption("$(DEVICE):PLC",0,"ixon","Y")
$(IFNOTRECSIM) asynSetOption("$(DEVICE):PLC",0,"ixoff","Y")

## Add an asyn "interpose interface" driver.
#######################################################################
# modbusInterposeConfig(const char *portName,
#                      modbusLinkType linkType, .... Modbus link layer type: 0 = TCP/IP , 1 = RTU, 2 = ASCII
#                      int timeoutMsec, 
#                      int writeDelayMsec)
#######################################################################
$(IFNOTRECSIM) modbusInterposeConfig($(DEVICE):PLC, 0, 0, 0)

# Creates a modbus port driver
#######################################################################
# modbus port driver is created with the following command:
#drvModbusAsynConfigure(portName, 
#                        tcpPortName,
#                        slaveAddress, 
#                        modbusFunction, 
#                        modbusStartAddress, 
#                        modbusLength,
#                        dataType,
#                        pollMsec, 
#                        plcType);
# Modbus functions: 
# Read Holding Registers:    3
#######################################################################

$(IFNOTRECSIM) drvModbusAsynConfigure("$(DEVICE):POWER", "$(DEVICE):PLC", 1, 3, 0, 1, 0, 1000, "PLC")


# Load modbus record from template
dbLoadRecords("$(KICKER)/db/kicker_power.db","PVPREFIX=$(MYPVPREFIX),P=$(MYPVPREFIX)$(IOCNAME):,IFNOTRECSIM=$(IFNOTRECSIM),RECSIM=$(RECSIM=0),DISABLE=$(DISABLE=0),PORT=$(DEVICE)")
