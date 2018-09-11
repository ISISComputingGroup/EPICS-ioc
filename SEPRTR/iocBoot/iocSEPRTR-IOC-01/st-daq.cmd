## NI cDAQ-9185
epicsEnvSet("CDAQAI","$(DAQ_AI_PORT_NAME=cDAQ9185-MUONFEMod3)")
epicsEnvSet("CDAQAO","$(DAQ_AO_PORT_NAME=cDAQ9185-MUONFEMod4)")

cDAQ9185-MUONFE-Mod4

## input
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQAI)/ai0", 0, "AI","N=1000 F=1000") ## Kicker Volt
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQAI)/ai1", 1, "AI","N=1000 F=1000") ## Kicker Curr
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQAI)/ai2", 2, "AI","N=$(VOLT_NELM=1000) F=$(VOLT_FREQ=1000)") ## Separator Volt
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQAI)/ai3", 3, "AI","N=$(CURR_NELM=1000) F=$(CURR_FREQ=1000)" ## Separator Curr

## output
$(IFNOTRECSIM) DAQmxConfig("W0", "$(CDAQAO)/ao0", 0, "AO","N=1 F=0") ## x
$(IFNOTRECSIM) DAQmxConfig("W0", "$(CDAQAO)/ao1", 1, "AO","N=1 F=0") ## x
$(IFNOTRECSIM) DAQmxConfig("W0", "$(CDAQAO)/ao2", 2, "AO","N=1 F=0") ## Separator Volt
$(IFNOTRECSIM) DAQmxConfig("W0", "$(CDAQAO)/ao3", 3, "AO","N=1 F=0") ## Separator Curr
