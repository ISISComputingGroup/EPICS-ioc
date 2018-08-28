## NI cDAQ-9185
epicsEnvSet("CDAQAI","cDAQ9185-1D195CFMod3")

## input
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQAI)/ai0", 0, "AI","N=1000 F=1000") ## Kicker Volt
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQAI)/ai1", 1, "AI","N=1000 F=1000") ## Kicker Curr
