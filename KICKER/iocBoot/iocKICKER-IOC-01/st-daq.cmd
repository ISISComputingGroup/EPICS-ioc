## NI cDAQ-9185
epicsEnvSet("CDAQER","cDAQ9185-1D195CFMod2")
epicsEnvSet("CDAQAI","cDAQ9185-1D195CFMod3")
epicsEnvSet("CDAQAO","cDAQ9185-1D195CFMod4")

## input
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQAI)/ai0", 0, "AI","N=1000 F=1000") ## Kicker Volt
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQAI)/ai1", 1, "AI","N=1000 F=1000") ## Kicker Curr
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQAI)/ai2", 2, "AI","N=1000 F=1000") ## Separator Volt
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQAI)/ai3", 3, "AI","N=1000 F=1000") ## Separator Curr
