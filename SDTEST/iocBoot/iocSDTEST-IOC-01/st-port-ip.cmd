## set PN before calling
## if PN=1 the defines asyn port SD1 and uses macros such as PORT1, PORT1_PARITY to configure 

# this defines macros we can use for conditional loading later
stringiftest("PORT", "$(PORT$(PN)=)")

# create a real serial port, unless in simulation mode then crreate an unconnected asyn port 
$(IFPORT)$(IFSIM)       drvAsynIPPortConfigure("SD$(PN)", "127.0.0.1:80 UDP", 0, 1)
$(IFPORT)$(IFNOTSIM)    drvAsynIPPortConfigure("SD$(PN)","$(PORT$(PN)=)",0,0,0) 
#
$(IFPORT) < st-port-common.cmd
#
