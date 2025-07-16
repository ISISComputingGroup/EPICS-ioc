##
## GEM gate valve
##
# Modbus function codes supported are:
#  Read holding registers             3 
#  Preset/write multiple registers   16 
# length always specified in number of 16 bit words,
# address here is 1 less PLC address plus 4xxxx prefix removed for code 3

## a readback of > 0 on a write (code 16) configure line below means it does a 
## single initial read of the value on IOC startup. code1
## 3rd arg is PLC slave address, check on PLC for this. Doesn't seem important for TCP,
## but is for RTU/ASCII
## subtract 40001 offset from 4x register addresses that are read by code 3
## addresss here are 41315 and 40650
drvModbusAsynConfigure("$(PLC)heartbeat", "$(PLC)", 1, 3, 649, 1, "UINT16", 1000, "PLC")
drvModbusAsynConfigure("$(PLC)gatevalve", "$(PLC)", 1, 3, 1314, 1, "UINT16", 1000, "PLC")

## Load our record instances
dbLoadRecords("$(TOP)/db/GEMGateValve.db","P=$(MYPVPREFIX)$(IOCNAME):,PORT=$(PLC),R=")

