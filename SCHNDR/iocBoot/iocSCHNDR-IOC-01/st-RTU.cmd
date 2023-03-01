
## RTU
drvAsynSerialPortConfigure("$(PLC)","$(PORT)",0,0,0)
asynSetOption("$(PLC)",0,"baud","9600")
asynSetOption("$(PLC)",0,"bits","8")
asynSetOption("$(PLC)",0,"parity","even")
asynSetOption("$(PLC)",0,"stop","1")
asynSetOption("$(PLC)",0,"clocal","N") # N enables DSR/DTR handshaking
asynSetOption("$(PLC)",0,"crtscts","N")
asynSetOption("$(PLC)",0,"ixon","Y")
asynSetOption("$(PLC)",0,"ixoff","Y")

## link type is 0 for tcp, 1 for RTU. 2 for ASCII
modbusInterposeConfig("$(PLC)",1,3000,2)
