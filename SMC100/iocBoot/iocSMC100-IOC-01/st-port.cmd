
## set PN before calling
## if PN=1 the defines asyn port SD1 and uses macros such as PORT1, PORT1_PARITY to configure 

# this defines macros we can use for conditional loading later
stringiftest("PORT", "$(PORT$(PN)=)")
$(IFPORT) < st-motor.cmd

stringiftest("PORT$(PN)", "$(PORT$(PN)=)")
