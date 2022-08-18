
## for TCP
drvAsynIPPortConfigure("$(PLC)","$(IPADDR):$(IPPORT=502)",0,0,1)

## link type is 0 for tcp, 1 for RTU. 2 for ASCII
modbusInterposeConfig("$(PLC)",0,5000,0)
