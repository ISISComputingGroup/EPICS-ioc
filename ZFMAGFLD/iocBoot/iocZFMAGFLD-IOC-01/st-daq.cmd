epicsEnvSet("CDAQ","$(HOST=cDAQ9181-1B0C1FCMod1)")

## 3xAI inputs from a cDAQ 9181, one input per magnetometer channel
## Read in 100 samples at a time at a frequency of 10Hz (so 1000 samples/s)
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQ)/$(X_DAQ_CHANNEL=ai0)", 0, "AI","MONSTER TerminalDiff N=100 F=10") # X (horizontal transverse - parallel to the floor)
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQ)/$(Y_DAQ_CHANNEL=ai1)", 1, "AI","MONSTER TerminalDiff N=100 F=10") # Y (vertical transverse - perpendicular to the floor)
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQ)/$(Z_DAQ_CHANNEL=ai2)", 2, "AI","MONSTER TerminalDiff N=100 F=10") # Z (along the beam, in the direction of the beam)

$(IFNOTRECSIM) $(IFHAS_EXTRA_DAQ_CHANNEL) DAQmxConfig("R0", "$(CDAQ)/$(EXTRA_DAQ_CHANNEL=ai3)", 3, "AI","MONSTER TerminalDiff N=1 F=1000")
