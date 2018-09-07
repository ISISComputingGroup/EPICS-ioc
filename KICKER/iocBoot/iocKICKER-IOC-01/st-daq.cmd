## NI cDAQ-9185
$(IFNOTRECSIM) epicsEnvSet("CDAQAI", "$(DAQ_AI_PORT_NAME = cDAQ9185-MuonFEMod3)")

## input
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQAI)/ai1", 1, "AI","N=$(NELM=1000), F=$(FREQ=1000)") ## Kicker Curr
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQAI)/ai0", 0, "AI","N=$(NELM=1000), F=$(FREQ=1000)") ## Kicker Volt
