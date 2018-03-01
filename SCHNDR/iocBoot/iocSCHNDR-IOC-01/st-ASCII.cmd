
## ASCII, but use RTU if possible
drvAsynSerialPortConfigure("$(DEVICE)","$(PORT)",0,0,0)
asynSetOption("$(DEVICE)",0,"baud","2400")
asynSetOption("$(DEVICE)",0,"bits","7")
asynSetOption("$(DEVICE)",0,"parity","even")
asynSetOption("$(DEVICE)",0,"stop","1")
asynSetOption("$(DEVICE)",0,"clocal","N") # N enables DSR/DTR handshaking
asynSetOption("$(DEVICE)",0,"crtscts","N")
asynSetOption("$(DEVICE)",0,"ixon","Y")
asynSetOption("$(DEVICE)",0,"ixoff","Y")
asynOctetSetOutputEos("$(DEVICE)",0,"\r\n")
asynOctetSetInputEos("$(DEVICE)",0,"\r\n")

## link type is 0 for tcp, 1 for RTU. 2 for ASCII
modbusInterposeConfig("$(DEVICE)",2,3000,2)
