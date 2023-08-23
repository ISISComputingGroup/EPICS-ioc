epicsEnvSet("CDAQ","$(HOST=PEARL_cDAQ_ChassisMod1)") # PEARL cDAQ chassis and module address (appended 'Mod1')

## 16 x temperature inputs from a cDAQ 9181 chassis with a 9213 thermocouple module

## DAQmxBaseConfig (portName, deviceName, Channelnr, acqType, options)
## portName - ASYN port name to create or to add to
## devicename - NI device name (e.g. dev1/ai0)
## Channelnr - Channelnr inside ASYN port (start with 0)
## acqType - “AI” ,”AO”, “BI”, “BO” or “COUNTER”
## options - see DAQmx Port Options

# TODO: add DAQ config lines for remaining channels
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai0",   0, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel  0
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai1",   1, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel  1
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai2",   2, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel  2
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai3",   3, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel  3
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai4",   4, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel  4
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai5",   5, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel  5
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai6",   6, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel  6
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai7",   7, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel  7
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai8",   8, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel  8
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai9",   9, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel  9
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai10", 10, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel 10
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai11", 11, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel 11
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai12", 12, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel 12
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai13", 13, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel 13
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai14", 14, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel 14
$(IFNOTRECSIM) DAQmxConfig("$(DEVICE)", "$(CDAQ)/ai15", 15, "AI","OneShot TerminalDef N=1 F=0 m=0 M=100")      # Channel 15
