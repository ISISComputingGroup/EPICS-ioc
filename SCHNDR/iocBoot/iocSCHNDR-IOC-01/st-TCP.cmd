
## for TCP
drvAsynIPPortConfigure("$(DEVICE)","$(IPADDR=130.246.48.127):$(IPPORT=502)",0,0,1)

## link type is 0 for tcp, 1 for RTU. 2 for ASCII
modbusInterposeConfig("$(DEVICE)",0,5000,0)
