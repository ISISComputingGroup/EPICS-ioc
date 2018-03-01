
## RTU
drvAsynSerialPortConfigure("$(DEVICE)","$(PORT)",0,0,0)
asynSetOption("$(DEVICE)",0,"baud","9600")
asynSetOption("$(DEVICE)",0,"bits","8")
asynSetOption("$(DEVICE)",0,"parity","even")
asynSetOption("$(DEVICE)",0,"stop","1")
asynSetOption("$(DEVICE)",0,"clocal","N") # N enables DSR/DTR handshaking
asynSetOption("$(DEVICE)",0,"crtscts","N")
asynSetOption("$(DEVICE)",0,"ixon","Y")
asynSetOption("$(DEVICE)",0,"ixoff","Y")

## link type is 0 for tcp, 1 for RTU. 2 for ASCII
modbusInterposeConfig("$(DEVICE)",1,3000,2)
