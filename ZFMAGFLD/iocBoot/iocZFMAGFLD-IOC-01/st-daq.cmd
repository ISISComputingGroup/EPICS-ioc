epicsEnvSet("CDAQ","$(HOST=cDAQ9181-1B0C1FCMod1)")

## 3xAI inputs from a cDAQ 9181, one input per magnetometer channel
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQ)/ai0", 0, "AI","OneShot TerminalDiff N=1 F=0") # X (L)
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQ)/ai1", 1, "AI","OneShot TerminalDiff N=1 F=0") # Y (T)
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQ)/ai2", 2, "AI","OneShot TerminalDiff N=1 F=0") # Z (V)
