epicsEnvSet("CDAQ","$(HOST=cDAQ9181-1B0C1FCMod1)")

## 3xAI inputs from a cDAQ 9181, one input per magnetometer channel
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQ)/ai0", 0, "AI","MONSTER TerminalDiff N=1 F=1000") # X (L)
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQ)/ai1", 1, "AI","MONSTER TerminalDiff N=1 F=1000") # Y (T)
$(IFNOTRECSIM) DAQmxConfig("R0", "$(CDAQ)/ai2", 2, "AI","MONSTER TerminalDiff N=1 F=1000") # Z (V)
