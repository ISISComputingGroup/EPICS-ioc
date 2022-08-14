
## ASCII, but use RTU if possible
drvAsynSerialPortConfigure("$(PLC)","$(PORT)",0,0,0)
asynSetOption("$(PLC)",0,"baud","2400")
asynSetOption("$(PLC)",0,"bits","7")
asynSetOption("$(PLC)",0,"parity","even")
asynSetOption("$(PLC)",0,"stop","1")
asynSetOption("$(PLC)",0,"clocal","N") # N enables DSR/DTR handshaking
asynSetOption("$(PLC)",0,"crtscts","N")
asynSetOption("$(PLC)",0,"ixon","Y")
asynSetOption("$(PLC)",0,"ixoff","Y")
asynOctetSetOutputEos("$(PLC)",0,"\r\n")
asynOctetSetInputEos("$(PLC)",0,"\r\n")

## link type is 0 for tcp, 1 for RTU. 2 for ASCII
modbusInterposeConfig("$(PLC)",2,3000,2)
