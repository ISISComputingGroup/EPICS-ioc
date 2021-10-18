## set PN before calling
## if PN=1 the defines asyn port SD1 and uses macros such as PORT1, PORT1_PARITY to configure 

## telnet RFC 2217 protocol to set serial port parameters

# this defines macros we can use for conditional loading later
stringiftest("PORT", "$(PORT$(PN)=)")

# create a real serial port, unless in simulation mode then create an unconnected asyn port 
$(IFPORT)$(IFSIM)       drvAsynIPPortConfigure("SD$(PN)", "127.0.0.1:80 UDP", 0, 1)
$(IFPORT)$(IFNOTSIM)    drvAsynIPPortConfigure("SD$(PN)","$(PORT$(PN)=) COM",0,0,0) 

# defaults should be reflected in config.xml
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "baud", "$(BAUD$(PN)=9600)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "bits", "$(BITS$(PN)=8)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "parity", "$(PARITY$(PN)=none)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "stop", "$(STOP$(PN)=1)")
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "clocal", "$(CLOCAL$(PN)=Y)") # if N, output flow control using DSR signal
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "crtscts", "$(CRTSCTS$(PN)=N)") # if Y, use hardware flow control (RTS/CTS)
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "ixon", "$(IXON$(PN)=N)") # if Y, use software flow control for output
$(IFPORT)$(IFNOTSIM) asynSetOption ("SD$(PN)", 0, "ixoff", "$(IXOFF$(PN)=N)") # if Y, use software flow control for input

$(IFPORT) < st-port-common.cmd
#
