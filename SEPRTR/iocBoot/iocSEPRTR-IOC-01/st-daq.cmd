## NI cDAQ-9185
epicsEnvSet("CDAQER","cDAQ9185-MUONFEMod2")
epicsEnvSet("CDAQAI","cDAQ9185-MUONFEMod3")
epicsEnvSet("CDAQAO","cDAQ9185-MUONFEMod4")

cDAQ9185-MUONFE-Mod4

## input
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQAI)/ai0", 0, "AI","N=$(NELM=1000) F=$(FREQ=1000)") ## Kicker Volt
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQAI)/ai1", 1, "AI","N=$(NELM=1000) F=$(FREQ=1000)") ## Kicker Curr
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQAI)/ai2", 2, "AI","N=$(NELM=1000) F=$(FREQ=1000)") ## Separator Volt
$(IFNOTDEVSIM) DAQmxConfig("R0", "$(CDAQAI)/ai3", 3, "AI","N=$(NELM=1000) F=$(FREQ=1000)") ## Separator Curr

## output
$(IFNOTDEVSIM) DAQmxConfig("W0", "$(CDAQAO)/ao0", 0, "AO","N=1 F=0") ## x
$(IFNOTDEVSIM) DAQmxConfig("W0", "$(CDAQAO)/ao1", 1, "AO","N=1 F=0") ## x
$(IFNOTDEVSIM) DAQmxConfig("W0", "$(CDAQAO)/ao2", 2, "AO","N=1 F=0") ## Separator Volt
$(IFNOTDEVSIM) DAQmxConfig("W0", "$(CDAQAO)/ao3", 3, "AO","N=1 F=0") ## Separator Curr
