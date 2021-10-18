epicsEnvSet("CDAQ","$(HOST=cDAQ9181-1B0C1FCMod1)")

## 3xAI inputs from a cDAQ 9181, one input per magnetometer channel
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQ)/$(X_DAQ_CHANNEL=ai0)", 0, "AI","MONSTER TerminalDiff N=1 F=1000") # X (horizontal transverse - parallel to the floor)
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQ)/$(Y_DAQ_CHANNEL=ai1)", 1, "AI","MONSTER TerminalDiff N=1 F=1000") # Y (vertical transverse - perpendicular to the floor)
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQ)/$(Z_DAQ_CHANNEL=ai2)", 2, "AI","MONSTER TerminalDiff N=1 F=1000") # Z (along the beam, in the direction of the beam)

$(IFNOTRECSIM) $(IFHAS_EXTRA_DAQ_CHANNEL) DAQmxConfig("R0", "$(CDAQ)/$(EXTRA_DAQ_CHANNEL=ai3)", 3, "AI","MONSTER TerminalDiff N=1 F=1000")
